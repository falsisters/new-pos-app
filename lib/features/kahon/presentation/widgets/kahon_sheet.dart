import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/providers/sheet_provider.dart';

class KahonSheet extends ConsumerStatefulWidget {
  final SheetModel sheet;
  const KahonSheet({
    super.key,
    required this.sheet,
  });

  @override
  ConsumerState<KahonSheet> createState() => _KahonSheetState();
}

class _KahonSheetState extends ConsumerState<KahonSheet> {
  late KahonSheetDataSource _dataSource;
  final DataGridController _dataGridController = DataGridController();
  bool _isEditable = false;
  late FormulaHandler _formulaHandler;

  // Store pending cell changes
  final Map<String, CellChange> _pendingChanges = {};

  @override
  void initState() {
    super.initState();
    _formulaHandler = FormulaHandler(sheet: widget.sheet);
    _initializeDataSource();
  }

  void _initializeDataSource() {
    _dataSource = KahonSheetDataSource(
      sheet: widget.sheet,
      kahonItems: const [], // Add an empty list for kahonItems or provide actual items
      isEditable: _isEditable,
      cellSubmitCallback: _handleCellSubmit,
      addCalculationRowCallback: _addCalculationRow,
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

      for (var change in _pendingChanges.values) {
        if (change.isUpdate) {
          cellsToUpdate.add({
            'id': change.cellId,
            'value': change.displayValue,
            'formula': change.formula,
          });
        } else {
          cellsToCreate.add({
            'rowId': change.rowId,
            'columnIndex': change.columnIndex,
            'value': change.displayValue,
            'formula': change.formula,
          });
        }
      }

      // Process updates in bulk if any
      if (cellsToUpdate.isNotEmpty) {
        await ref
            .read(sheetNotifierProvider.notifier)
            .updateCells(cellsToUpdate);
      }

      // Process creates in bulk if any
      if (cellsToCreate.isNotEmpty) {
        await ref
            .read(sheetNotifierProvider.notifier)
            .createCells(cellsToCreate);
      }

      // Clear pending changes
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
  void didUpdateWidget(KahonSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sheet != widget.sheet) {
      _formulaHandler = FormulaHandler(sheet: widget.sheet);
      _initializeDataSource();
    }
  }

  // Handle cell operations (create, update)
  // Update the _handleCellSubmit method
  Future<void> _handleCellSubmit(
      int rowIndex, int columnIndex, String value) async {
    print(
        "_handleCellSubmit called with: rowIndex=$rowIndex, columnIndex=$columnIndex, value=$value");
    try {
      // Use a local variable to store the current sheet state
      SheetModel currentSheet = widget.sheet;

      // If we already have a modified sheet in progress, use that instead
      if (_dataSource.sheet != widget.sheet) {
        currentSheet = _dataSource.sheet;
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
      // Make sure we're only using isUpdate=true for cells that have a real DB ID
      // (not temporary IDs that start with 'temp_')
      if (existingCell != null && !existingCell.id.startsWith('temp_')) {
        _pendingChanges[changeKey] = CellChange(
          isUpdate: true,
          cellId: existingCell.id,
          displayValue: displayValue,
          formula: formula,
        );
      } else {
        _pendingChanges[changeKey] = CellChange(
          isUpdate: false,
          rowId: rowModel.id,
          columnIndex: columnIndex,
          displayValue: displayValue,
          formula: formula,
        );
      }

      // Rest of the method remains the same...

      // Update UI immediately to show the change
      setState(() {
        // Create a mutable copy of the sheet for UI updates, starting from our current sheet
        SheetModel updatedSheet = SheetModel(
          id: currentSheet.id,
          name: currentSheet.name,
          columns: currentSheet.columns,
          kahonId: currentSheet.kahonId,
          createdAt: currentSheet.createdAt,
          updatedAt: currentSheet.updatedAt,
          rows: currentSheet.rows.map((row) {
            // If this is the row we're modifying
            if (row.id == rowModel.id) {
              // Create a mutable copy of cells
              List<CellModel> updatedCells = [...row.cells];

              if (existingCell != null) {
                // Update existing cell
                int cellIndex =
                    updatedCells.indexWhere((c) => c.id == existingCell.id);
                if (cellIndex != -1) {
                  updatedCells[cellIndex] = CellModel(
                    id: existingCell.id,
                    rowId: existingCell.rowId,
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
                updatedCells.add(CellModel(
                  id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
                  rowId: rowModel.id,
                  columnIndex: columnIndex,
                  value: displayValue,
                  formula: formula,
                  isCalculated: formula != null,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ));
              }

              // Return updated row with new cells list
              return RowModel(
                id: row.id,
                sheetId: row.sheetId,
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

        // Create a new FormulaHandler with updated sheet
        _formulaHandler = FormulaHandler(sheet: updatedSheet);

        // Re-initialize data source with updated sheet
        _dataSource = KahonSheetDataSource(
          sheet: updatedSheet,
          kahonItems: const [],
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
      await ref.read(sheetNotifierProvider.notifier).updateCells(cellsToUpdate);
    }
  }

  // Add calculation row
  Future<void> _addCalculationRow(int afterRowIndex) async {
    try {
      await ref
          .read(sheetNotifierProvider.notifier)
          .createCalculationRow(widget.sheet.id, afterRowIndex + 1);
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
      await ref.read(sheetNotifierProvider.notifier).deleteRow(rowId);
    } catch (e) {
      print('Error deleting row: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete row: ${e.toString()}')),
        );
      }
    }
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
                Text('• Quantity5 - References cell in Quantity column, row 5'),
                Text('• Name2 - References cell in Name column, row 2'),
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
                Text('=SUM(Quantity1:Quantity5) + A6 * 2'),
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
                            .read(sheetNotifierProvider.notifier)
                            .getSheetByDate(null, null);
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
                        tooltip: 'Add Calculation Row',
                        onPressed: () {
                          // Get currently selected row index or default to last row
                          int rowIndex = _dataGridController.selectedIndex != -1
                              ? _dataGridController.selectedIndex
                              : widget.sheet.rows.length - 1;

                          // Find the actual row index from the model
                          if (rowIndex >= 0 &&
                              rowIndex < widget.sheet.rows.length) {
                            _addCalculationRow(
                                widget.sheet.rows[rowIndex].rowIndex);
                          } else {
                            // Default to adding at the end
                            _addCalculationRow(widget.sheet.rows.isNotEmpty
                                ? widget.sheet.rows.last.rowIndex + 1
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
    // Custom labels for specific columns
    if (index == 0) return "Quantity";
    if (index == 1) return "Name";
    // For other columns, use Excel-like column letters (C, D, E, etc.)
    String columnLetter = '';
    int adjustedIndex =
        index - 2; // Adjust index to start from 0 after our custom columns
    while (adjustedIndex >= 0) {
      columnLetter =
          String.fromCharCode((adjustedIndex % 26) + 65) + columnLetter;
      adjustedIndex = (adjustedIndex ~/ 26) - 1;
    }
    return columnLetter;
  }
}
