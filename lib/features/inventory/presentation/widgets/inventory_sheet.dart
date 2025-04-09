import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/providers/inventory_provider.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_formula_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_sheet_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter/services.dart';

class InventorySheet extends ConsumerStatefulWidget {
  final InventorySheetModel sheet;
  const InventorySheet({
    super.key,
    required this.sheet,
  });

  @override
  ConsumerState<InventorySheet> createState() => _InventorySheetState();
}

class _InventorySheetState extends ConsumerState<InventorySheet> {
  late InventorySheetDataSource _dataSource;
  final DataGridController _dataGridController = DataGridController();
  bool _isEditable = false;
  late InventoryFormulaHandler _formulaHandler;

  // Store pending cell changes
  final Map<String, CellChange> _pendingChanges = {};

  @override
  void initState() {
    super.initState();
    _formulaHandler = InventoryFormulaHandler(sheet: widget.sheet);
    _initializeDataSource();
  }

  void _initializeDataSource() {
    _dataSource = InventorySheetDataSource(
      sheet: widget.sheet,
      isEditable: _isEditable,
      cellSubmitCallback: _handleCellSubmit,
      addCalculationRowCallback:
          _addCalculationRow, // This still uses the single row method
      deleteRowCallback: _deleteRow,
      formulaHandler: _formulaHandler,
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditable = !_isEditable;
      _initializeDataSource(); // Refresh data source with new editable state
    });
  }

  void _saveChanges() {
    // Apply all pending changes
    _applyPendingChanges().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved!')),
      );

      // Optionally turn off edit mode after saving
      setState(() {
        _isEditable = false;
        _initializeDataSource();
      });
    });
  }

  // Apply all pending changes to the database
  Future<void> _applyPendingChanges() async {
    if (_pendingChanges.isEmpty) return;

    try {
      // Separate changes into updates and creates
      List<Map<String, dynamic>> cellsToUpdate = [];
      List<Map<String, dynamic>> cellsToCreate = [];

      print("Processing ${_pendingChanges.length} pending changes");

      for (var change in _pendingChanges.values) {
        if (change.isUpdate) {
          cellsToUpdate.add({
            'id': change.cellId,
            'value': change.displayValue,
            'formula': change.formula,
          });
          print(
              "Update cell: id=${change.cellId}, value=${change.displayValue}");
        } else {
          cellsToCreate.add({
            'rowId': change.rowId,
            'columnIndex': change.columnIndex,
            'value': change.displayValue,
            'formula': change.formula,
          });
          print(
              "Create cell: rowId=${change.rowId}, columnIndex=${change.columnIndex}, value=${change.displayValue}");
        }
      }

      // Process updates in bulk if any
      if (cellsToUpdate.isNotEmpty) {
        print("Updating ${cellsToUpdate.length} cells");
        await ref.read(inventoryProvider.notifier).updateCells(cellsToUpdate);
      }

      // Process creates in bulk if any
      if (cellsToCreate.isNotEmpty) {
        print("Creating ${cellsToCreate.length} cells");
        await ref.read(inventoryProvider.notifier).createCells(cellsToCreate);
      }

      // Clear pending changes only after successful update
      _pendingChanges.clear();

      // Recalculate formulas after all changes are applied
      await _recalculateFormulas();
    } catch (e) {
      print('Error applying pending changes: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save changes: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void didUpdateWidget(InventorySheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sheet != widget.sheet) {
      _formulaHandler = InventoryFormulaHandler(sheet: widget.sheet);
      _initializeDataSource();
    }
  }

  // Handle cell operations (create, update)
  Future<void> _handleCellSubmit(
      int rowIndex, int columnIndex, String value) async {
    print(
        "_handleCellSubmit called with: rowIndex=$rowIndex, columnIndex=$columnIndex, value=$value");
    try {
      // Use a local variable to store the current sheet state
      InventorySheetModel currentSheet = widget.sheet;

      // If we already have a modified sheet in progress, use that instead
      if (_dataSource.currentSheet != widget.sheet) {
        currentSheet = _dataSource.currentSheet;
      }

      // Find the corresponding row
      final rowModel = currentSheet.rows.firstWhere(
        (r) => r.rowIndex == rowIndex,
        orElse: () => throw Exception('Row not found'),
      );
      print("Found row with id: ${rowModel.id}");

      // Check if the cell already exists
      final existingCell = rowModel.cells.firstWhereOrNull(
        (c) => c.columnIndex == columnIndex,
      );

      String? formula;
      String displayValue = value;

      // Check if the value is a formula
      if (value.startsWith('=')) {
        formula = value;
        try {
          displayValue =
              _formulaHandler.evaluateFormula(value, rowIndex, columnIndex);
        } catch (e) {
          displayValue = '#ERROR';
          print('Formula evaluation error: $e');
        }
      }

      // Create a unique key for this cell change
      String changeKey = '${rowIndex}_${columnIndex}';

      // Store the change in pending changes
      if (existingCell != null && !existingCell.id.startsWith('temp_')) {
        _pendingChanges[changeKey] = CellChange(
          isUpdate: true,
          cellId: existingCell.id,
          rowId: rowModel.id, // Add rowId for clearer tracking
          columnIndex: columnIndex, // Add columnIndex for clearer tracking
          displayValue: displayValue,
          formula: formula,
        );
        print("Added update to pending changes: $changeKey");
      } else {
        _pendingChanges[changeKey] = CellChange(
          isUpdate: false,
          rowId: rowModel.id,
          columnIndex: columnIndex,
          displayValue: displayValue,
          formula: formula,
        );
        print("Added create to pending changes: $changeKey");
      }

      // Update UI immediately to show the change
      setState(() {
        // Create a mutable copy of the sheet for UI updates, starting from our current sheet
        InventorySheetModel updatedSheet = InventorySheetModel(
          id: currentSheet.id,
          name: currentSheet.name,
          columns: currentSheet.columns,
          inventoryId: currentSheet.inventoryId,
          createdAt: currentSheet.createdAt,
          updatedAt: currentSheet.updatedAt,
          rows: currentSheet.rows.map((row) {
            // If this is the row we're modifying
            if (row.id == rowModel.id) {
              // Create a mutable copy of cells
              List<InventoryCellModel> updatedCells = [...row.cells];

              if (existingCell != null) {
                // Update existing cell
                int cellIndex =
                    updatedCells.indexWhere((c) => c.id == existingCell.id);
                if (cellIndex != -1) {
                  updatedCells[cellIndex] = InventoryCellModel(
                    id: existingCell.id,
                    inventoryRowId: existingCell.inventoryRowId,
                    columnIndex: existingCell.columnIndex,
                    value: displayValue,
                    formula: formula,
                    isCalculated: formula != null,
                    createdAt: existingCell.createdAt,
                    updatedAt: DateTime.now(),
                  );
                }
              } else {
                // Add new cell
                updatedCells.add(InventoryCellModel(
                  id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
                  inventoryRowId: rowModel.id,
                  columnIndex: columnIndex,
                  value: displayValue,
                  formula: formula,
                  isCalculated: formula != null,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ));
              }

              // Return updated row with new cells list
              return InventoryRowModel(
                id: row.id,
                inventorySheetId: row.inventorySheetId,
                rowIndex: row.rowIndex,
                isItemRow: row.isItemRow,
                itemId: row.itemId,
                cells: updatedCells, // Using our updated cells list
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              );
            }
            return row; // Return unchanged row
          }).toList(),
        );

        // Create a new InventoryFormulaHandler with updated sheet
        _formulaHandler = InventoryFormulaHandler(sheet: updatedSheet);

        // Re-initialize data source with updated sheet
        _dataSource = InventorySheetDataSource(
          sheet: updatedSheet,
          isEditable: _isEditable,
          cellSubmitCallback: _handleCellSubmit,
          addCalculationRowCallback: _addCalculationRow,
          deleteRowCallback: _deleteRow,
          formulaHandler: _formulaHandler,
        );
      });
    } catch (e) {
      print('Error handling cell submission: $e');
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update cell: ${e.toString()}')),
        );
      }
    }
  }

  // Recalculate all formulas in the sheet
  Future<void> _recalculateFormulas() async {
    List<Map<String, dynamic>> cellsToUpdate = [];

    for (var row in widget.sheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          try {
            final newValue = _formulaHandler.evaluateFormula(
                cell.formula!, row.rowIndex, cell.columnIndex);

            cellsToUpdate.add({
              'id': cell.id,
              'value': newValue,
              'formula': cell.formula,
            });
          } catch (e) {
            cellsToUpdate.add({
              'id': cell.id,
              'value': '#ERROR',
              'formula': cell.formula,
            });
          }
        }
      }
    }

    if (cellsToUpdate.isNotEmpty) {
      await ref.read(inventoryProvider.notifier).updateCells(cellsToUpdate);
    }
  }

  // Add calculation row
  Future<void> _addCalculationRow(int afterRowIndex) async {
    try {
      // Save changes first if there are any
      if (_pendingChanges.isNotEmpty) {
        await _applyPendingChanges();
      }

      // Add the row
      await ref
          .read(inventoryProvider.notifier)
          .createInventoryRow(widget.sheet.id, afterRowIndex + 1);

      // Ensure we stay in edit mode
      if (!_isEditable) {
        setState(() {
          _isEditable = true;
          _initializeDataSource();
        });
      }
    } catch (e) {
      print('Error adding calculation row: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add calculation row: ${e.toString()}')),
        );
      }
    }
  }

  // Delete row
  Future<void> _deleteRow(String rowId) async {
    try {
      await ref.read(inventoryProvider.notifier).deleteRow(rowId);
    } catch (e) {
      print('Error deleting row: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete row: ${e.toString()}')),
        );
      }
    }
  }

  // Add multiple calculation rows
  Future<void> _addMultipleCalculationRows(
      int afterRowIndex, int rowCount) async {
    try {
      // Save changes first if there are any
      if (_pendingChanges.isNotEmpty) {
        await _applyPendingChanges();
      }

      // Calculate row indexes for all new rows
      List<int> rowIndexes =
          List.generate(rowCount, (index) => afterRowIndex + 1 + index);

      await ref
          .read(inventoryProvider.notifier)
          .createInventoryRows(widget.sheet.id, rowIndexes);

      // Ensure we stay in edit mode
      if (!_isEditable) {
        setState(() {
          _isEditable = true;
          _initializeDataSource();
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $rowCount new rows')),
      );
    } catch (e) {
      print('Error adding calculation rows: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add calculation rows: ${e.toString()}')),
        );
      }
    }
  }

  // Show dialog to add multiple rows
  void _showAddRowsDialog(int afterRowIndex) {
    final TextEditingController controller = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    // Save changes before showing the dialog if needed
    if (_pendingChanges.isNotEmpty) {
      _applyPendingChanges().then((_) {
        _actuallyShowAddRowsDialog(afterRowIndex, controller, formKey);
      });
    } else {
      _actuallyShowAddRowsDialog(afterRowIndex, controller, formKey);
    }
  }

  // Extracted actual dialog showing logic
  void _actuallyShowAddRowsDialog(int afterRowIndex,
      TextEditingController controller, GlobalKey<FormState> formKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Calculation Rows'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How many rows would you like to add?'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of rows',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }
                    final number = int.tryParse(value);
                    if (number == null || number <= 0) {
                      return 'Please enter a valid positive number';
                    }
                    if (number > 100) {
                      return 'Maximum 100 rows at once';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Add Rows'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final rowCount = int.parse(controller.text);
                  Navigator.of(context).pop();
                  _addMultipleCalculationRows(afterRowIndex, rowCount);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showFormulaHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Formula Help'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Cell References:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• A3 - References cell in column A, row 3'),
                Text('• SKU5 - References cell in SKU column, row 5'),
                Text('• Name2 - References cell in Name column, row 2'),
                Text('• Quantity3 - References cell in Quantity column, row 3'),
                SizedBox(height: 12),
                Text('Range Functions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• SUM(A1:A10) - Adds values from A1 to A10'),
                Text('• AVG(A1:A10) - Averages values from A1 to A10'),
                Text('• COUNT(A1:A10) - Counts non-empty cells from A1 to A10'),
                Text('• MAX(A1:A10) - Finds maximum value from A1 to A10'),
                Text('• MIN(A1:A10) - Finds minimum value from A1 to A10'),
                SizedBox(height: 12),
                Text('Arithmetic Operations:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• A1 + B1 - Addition'),
                Text('• A1 - B1 - Subtraction'),
                Text('• A1 * B1 - Multiplication'),
                Text('• A1 / B1 - Division'),
                Text('• A1 ^ 2 - Exponentiation'),
                SizedBox(height: 12),
                Text('Example:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('=SUM(Quantity1:Quantity5) + SKU6 * 2'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.sheet.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                      tooltip: 'Refresh Data',
                      onPressed: () {
                        ref
                            .read(inventoryProvider.notifier)
                            .getInventoryByDate(null, null);
                      },
                    ),
                    IconButton(
                      icon: Icon(_isEditable ? Icons.lock : Icons.edit),
                      onPressed: _toggleEditMode,
                      tooltip: _isEditable ? 'View Mode' : 'Edit Mode',
                      color: AppColors.primary,
                    ),
                    if (_isEditable)
                      IconButton(
                        icon: const Icon(Icons.add, color: AppColors.primary),
                        tooltip: 'Add Calculation Rows',
                        onPressed: () {
                          // Get currently selected row index or default to last row
                          int rowIndex = _dataGridController.selectedIndex != -1
                              ? _dataGridController.selectedIndex
                              : widget.sheet.rows.length - 1;

                          // Find the actual row index from the model
                          if (rowIndex >= 0 &&
                              rowIndex < widget.sheet.rows.length) {
                            _showAddRowsDialog(
                                widget.sheet.rows[rowIndex].rowIndex);
                          } else {
                            // Default to adding at the end
                            _showAddRowsDialog(widget.sheet.rows.isNotEmpty
                                ? widget.sheet.rows.last.rowIndex
                                : 0);
                          }
                        },
                      ),
                    if (_isEditable)
                      IconButton(
                        icon: const Icon(Icons.help_outline,
                            color: AppColors.primary),
                        tooltip: 'Formula Help',
                        onPressed: () {
                          _showFormulaHelpDialog();
                        },
                      ),
                    if (_isEditable)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete Selected Row',
                        onPressed: () {
                          // Get currently selected row
                          if (_dataGridController.selectedIndex != -1) {
                            int selectedIndex =
                                _dataGridController.selectedIndex;
                            if (selectedIndex >= 0 &&
                                selectedIndex < widget.sheet.rows.length) {
                              // Confirm before deleting
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: const Text(
                                        'Are you sure you want to delete this row? This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      TextButton(
                                        child: const Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          _deleteRow(widget
                                              .sheet.rows[selectedIndex].id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please select a row to delete')),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.primaryLight),
          Expanded(
            child: SfDataGrid(
              source: _dataSource,
              controller: _dataGridController,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columnWidthMode: ColumnWidthMode.auto,
              allowEditing: _isEditable,
              selectionMode: SelectionMode.multiple,
              navigationMode: GridNavigationMode.cell,
              frozenColumnsCount: 1, // Freeze the first column (item names)
              columns: _buildColumns(),
            ),
          ),
          // Add save button at the bottom when in edit mode
          if (_isEditable)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_pendingChanges.isNotEmpty)
                    Text(
                      '${_pendingChanges.length} unsaved changes',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: _saveChanges,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<GridColumn> _buildColumns() {
    // Use the columns property from SheetModel to determine column count
    int columnCount = widget.sheet.columns;
    // Create columns
    List<GridColumn> columns = [];
    // Add item name column
    columns.add(
      GridColumn(
        columnName: 'itemName',
        label: Container(
          padding: const EdgeInsets.all(8),
          color: AppColors.primary.withAlpha(25),
          alignment: Alignment.center,
          child: const Text(
            'Items',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        width: 150,
      ),
    );
    // Add data columns based on the sheet's column count
    for (int i = 0; i < columnCount; i++) {
      columns.add(
        GridColumn(
          columnName: 'column$i',
          width: 150,
          label: Container(
            padding: const EdgeInsets.all(8),
            color: AppColors.primary.withOpacity(0.1),
            alignment: Alignment.center,
            child: Text(
              _getColumnLetter(i),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      );
    }
    return columns;
  }

  // Convert column index to Excel-like column letters (A, B, C, ... Z, AA, AB, etc.)
  String _getColumnLetter(int index) {
    // Use Excel-like column letters (A, B, C, etc.)
    String columnLetter = '';
    int tempIndex = index;

    while (tempIndex >= 0) {
      columnLetter = String.fromCharCode((tempIndex % 26) + 65) + columnLetter;
      tempIndex = (tempIndex ~/ 26) - 1;
    }
    return columnLetter;
  }
}
