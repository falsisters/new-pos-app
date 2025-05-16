// ignore_for_file: unused_field, unused_local_variable

import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/providers/inventory_provider.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_formula_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_color_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_sheet_data_source.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/row_cell_data.dart';
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

  // Track cells that depend on other cells for formula calculation
  final Map<String, Set<String>> _formulaDependencies = {};

  // Store pending cell changes
  final Map<String, CellChange> _pendingChanges = {};

  // Add variables to track currently selected cell
  int? _selectedRowIndex;
  int? _selectedColumnIndex;
  InventoryCellModel? _selectedCell;
  String? _selectedCellValue;
  String? _selectedCellColorHex;

  @override
  void initState() {
    super.initState();
    _formulaHandler = InventoryFormulaHandler(sheet: widget.sheet);
    _initializeDataSource();
    _buildFormulaDependencyMap();
  }

  // Build a map of formula dependencies
  void _buildFormulaDependencyMap() {
    _formulaDependencies.clear();
    for (var row in widget.sheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          // Get cell references from formula
          Set<String> dependencies =
              _formulaHandler.extractCellReferencesFromFormula(cell.formula!);

          // For each cell this formula depends on, add this cell as a dependent
          for (String dependency in dependencies) {
            if (!_formulaDependencies.containsKey(dependency)) {
              _formulaDependencies[dependency] = {};
            }
            _formulaDependencies[dependency]!
                .add('${row.rowIndex}_${cell.columnIndex}');
          }
        }
      }
    }
    print('Formula dependencies built: $_formulaDependencies');
  }

  void _initializeDataSource() {
    _dataSource = InventorySheetDataSource(
      sheet: widget.sheet,
      isEditable: _isEditable,
      cellSubmitCallback: _handleCellSubmit,
      addCalculationRowCallback: _addCalculationRow,
      deleteRowCallback: _deleteRow,
      formulaHandler: _formulaHandler,
      eraseCellCallback: _eraseCell,
      addMultipleCalculationRowsCallback: _addMultipleCalculationRows,
      onDoubleTabHandler: !_isEditable ? _toggleEditMode : null,
    );

    // Set the static context
    InventorySheetDataSource.currentContext = context;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InventorySheetDataSource.currentContext = context;
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
            'color': change.color, // Include color in update
          });
          print(
              "Update cell: id=${change.cellId}, value=${change.displayValue}, color=${change.color}");
        } else {
          cellsToCreate.add({
            'rowId': change.rowId,
            'columnIndex': change.columnIndex,
            'value': change.displayValue,
            'formula': change.formula,
            'color': change.color, // Include color in create
          });
          print(
              "Create cell: rowId=${change.rowId}, columnIndex=${change.columnIndex}, value=${change.displayValue}, color=${change.color}");
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
      _buildFormulaDependencyMap();
    }
  }

  // Update dependent formulas after cell value change
  void _updateDependentFormulas(
      int rowIndex, int columnIndex, InventorySheetModel currentSheet) {
    // Create cell key in format used by dependency map
    String cellKey = '${rowIndex}_${columnIndex}';
    String columnLetter = _getColumnLetter(columnIndex);

    // Also check for column name references (like "A1")
    String namedCellKey = '$columnLetter$rowIndex';

    // Process cells that depend on this cell
    Set<String> dependentCells = {};
    if (_formulaDependencies.containsKey(cellKey)) {
      dependentCells.addAll(_formulaDependencies[cellKey]!);
    }
    if (_formulaDependencies.containsKey(namedCellKey)) {
      dependentCells.addAll(_formulaDependencies[namedCellKey]!);
    }

    if (dependentCells.isEmpty) return;

    print(
        'Updating dependent formulas for cell $cellKey ($namedCellKey): $dependentCells');

    // Create a mutable copy of the sheet
    InventorySheetModel updatedSheet = InventorySheetModel(
      id: currentSheet.id,
      name: currentSheet.name,
      columns: currentSheet.columns,
      inventoryId: currentSheet.inventoryId,
      createdAt: currentSheet.createdAt,
      updatedAt: currentSheet.updatedAt,
      rows: [...currentSheet.rows],
    );

    // Track processed cells to avoid circular references
    Set<String> processedCells = {cellKey, namedCellKey};

    // Process all dependent cells and recursively update their dependents too
    _updateDependentCellsRecursively(
        dependentCells, processedCells, updatedSheet);

    // Update formula handler with our updated sheet
    _formulaHandler = InventoryFormulaHandler(sheet: updatedSheet);

    // Update data source
    setState(() {
      _dataSource = InventorySheetDataSource(
        sheet: updatedSheet,
        isEditable: _isEditable,
        cellSubmitCallback: _handleCellSubmit,
        addCalculationRowCallback: _addCalculationRow,
        deleteRowCallback: _deleteRow,
        formulaHandler: _formulaHandler,
        eraseCellCallback: _eraseCell,
        addMultipleCalculationRowsCallback: _addMultipleCalculationRows,
        onDoubleTabHandler: !_isEditable ? _toggleEditMode : null,
      );
    });
  }

  // Add recursive updating method - Fixed version
  void _updateDependentCellsRecursively(Set<String> cellsToUpdate,
      Set<String> processedCells, InventorySheetModel updatedSheet) {
    List<String> cellsToProcess = cellsToUpdate.toList();

    for (String cellKey in cellsToProcess) {
      // Skip already processed cells to prevent infinite recursion
      if (processedCells.contains(cellKey)) continue;
      processedCells.add(cellKey);

      List<String> parts = cellKey.split('_');
      if (parts.length == 2) {
        int depRowIndex = int.parse(parts[0]);
        int depColumnIndex = int.parse(parts[1]);

        // Find the cell
        var rowModel = updatedSheet.rows.firstWhereOrNull(
          (r) => r.rowIndex == depRowIndex,
        );

        if (rowModel != null) {
          var cellModel = rowModel.cells.firstWhereOrNull(
            (c) => c.columnIndex == depColumnIndex,
          );

          if (cellModel != null && cellModel.formula != null) {
            try {
              // Recalculate formula with updated data
              String newValue = _formulaHandler.evaluateFormula(
                  cellModel.formula!, depRowIndex, depColumnIndex);

              // Add to pending changes
              String changeKey = '${depRowIndex}_${depColumnIndex}';
              _pendingChanges[changeKey] = CellChange(
                isUpdate: true,
                cellId: cellModel.id,
                rowId: rowModel.id,
                columnIndex: depColumnIndex,
                displayValue: newValue,
                formula: cellModel.formula,
                color: cellModel.color,
              );

              // Find row index in the updated sheet
              int rowIdx =
                  updatedSheet.rows.indexWhere((r) => r.id == rowModel.id);
              if (rowIdx >= 0) {
                // Find cell index in the row
                int cellIdx = updatedSheet.rows[rowIdx].cells
                    .indexWhere((c) => c.id == cellModel.id);

                if (cellIdx >= 0) {
                  // Create updated cell
                  InventoryCellModel updatedCell = InventoryCellModel(
                    id: cellModel.id,
                    inventoryRowId: cellModel.inventoryRowId,
                    columnIndex: cellModel.columnIndex,
                    value: newValue,
                    formula: cellModel.formula,
                    color: cellModel.color,
                    isCalculated: true,
                    createdAt: cellModel.createdAt,
                    updatedAt: DateTime.now(),
                  );

                  // Update the cell in the sheet
                  List<InventoryCellModel> updatedCells =
                      List.from(updatedSheet.rows[rowIdx].cells);
                  updatedCells[cellIdx] = updatedCell;

                  // Update the row with new cells
                  updatedSheet.rows[rowIdx] = InventoryRowModel(
                    id: rowModel.id,
                    inventorySheetId: rowModel.inventorySheetId,
                    rowIndex: rowModel.rowIndex,
                    isItemRow: rowModel.isItemRow,
                    itemId: rowModel.itemId,
                    cells: updatedCells,
                    createdAt: rowModel.createdAt,
                    updatedAt: DateTime.now(),
                  );
                }
              }

              // Find cells that depend on this updated cell
              Set<String> nextDependents = new Set<String>();

              // Create keys for cell lookups
              String thisCellKey = '${depRowIndex}_${depColumnIndex}';
              String thisNamedKey =
                  '${_getColumnLetter(depColumnIndex)}${depRowIndex}';

              // Add any cells that depend on this cell
              if (_formulaDependencies.containsKey(thisCellKey)) {
                nextDependents.addAll(_formulaDependencies[thisCellKey]!);
              }

              if (_formulaDependencies.containsKey(thisNamedKey)) {
                nextDependents.addAll(_formulaDependencies[thisNamedKey]!);
              }

              // Filter out cells we've already processed
              nextDependents = nextDependents.difference(processedCells);

              // Recursively update dependent cells if there are any
              if (nextDependents.isNotEmpty) {
                _updateDependentCellsRecursively(
                    nextDependents, processedCells, updatedSheet);
              }
            } catch (e) {
              print('Error recalculating formula: $e');
            }
          }
        }
      }
    }
  }

  // Handle cell operations (create, update)
  Future<void> _handleCellSubmit(
      int rowIndex, int columnIndex, String value, String? color) async {
    print(
        "_handleCellSubmit called with: rowIndex=$rowIndex, columnIndex=$columnIndex, value=$value, color=$color");
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

      // Make sure we keep the existing formula if we're just changing color
      // and the passed value matches the current value (indicating a color-only change)
      if (existingCell != null &&
          color != null &&
          existingCell.formula != null &&
          ((existingCell.value == value) ||
              (value.isEmpty && existingCell.value == null))) {
        formula = existingCell.formula;
        displayValue = existingCell.value ?? '';
      }
      // Otherwise, check if the value is a formula
      else if (value.startsWith('=')) {
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
          color: color, // Include color in the change
        );
        print("Added update to pending changes: $changeKey");
      } else {
        _pendingChanges[changeKey] = CellChange(
          isUpdate: false,
          rowId: rowModel.id,
          columnIndex: columnIndex,
          displayValue: displayValue,
          formula: formula,
          color: color, // Include color in the change
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
                    color: color, // Include color in the model
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
                  color: color, // Include color in the model
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

        // Update the selected cell information
        if (_selectedRowIndex == rowIndex &&
            _selectedColumnIndex == columnIndex) {
          _selectedCellValue = value;
          _selectedCellColorHex = color;
        }

        // Re-initialize data source with updated sheet
        _dataSource = InventorySheetDataSource(
          sheet: updatedSheet,
          isEditable: _isEditable,
          cellSubmitCallback: _handleCellSubmit,
          addCalculationRowCallback: _addCalculationRow,
          deleteRowCallback: _deleteRow,
          formulaHandler: _formulaHandler,
          eraseCellCallback: _eraseCell,
          addMultipleCalculationRowsCallback: _addMultipleCalculationRows,
          onDoubleTabHandler: !_isEditable ? _toggleEditMode : null,
        );

        // Update formula dependency map
        _buildFormulaDependencyMap();

        // Update cells that depend on this one
        _updateDependentFormulas(rowIndex, columnIndex, updatedSheet);
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

  // Add new method to handle cell erasure
  void _eraseCell(int rowIndex, int columnIndex) async {
    try {
      // Find the corresponding row
      final rowModel = widget.sheet.rows.firstWhere(
        (r) => r.rowIndex == rowIndex,
        orElse: () => throw Exception('Row not found'),
      );

      // Check if the cell already exists
      final existingCell = rowModel.cells.firstWhereOrNull(
        (c) => c.columnIndex == columnIndex,
      );

      if (existingCell != null) {
        // Create a unique key for this cell change
        String changeKey = '${rowIndex}_${columnIndex}';

        // Store the change in pending changes with empty value and no formula
        _pendingChanges[changeKey] = CellChange(
          isUpdate: true,
          cellId: existingCell.id,
          rowId: rowModel.id,
          columnIndex: columnIndex,
          displayValue: '', // Empty value
          formula: null, // Clear formula
          color: null, // Clear color
        );

        print("Added cell erase to pending changes: $changeKey");

        // Update UI immediately to show the change
        setState(() {
          // Make sure we're working with the most current sheet state
          InventorySheetModel currentSheet = _dataSource.currentSheet;

          // Create a mutable copy of the sheet for UI updates
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

                // Update existing cell
                int cellIndex =
                    updatedCells.indexWhere((c) => c.id == existingCell.id);
                if (cellIndex != -1) {
                  updatedCells[cellIndex] = InventoryCellModel(
                    id: existingCell.id,
                    inventoryRowId: existingCell.inventoryRowId,
                    columnIndex: existingCell.columnIndex,
                    value: '', // Clear value
                    formula: null, // Clear formula
                    color: null, // Clear color
                    isCalculated: false, // No longer calculated
                    createdAt: existingCell.createdAt,
                    updatedAt: DateTime.now(),
                  );
                }

                // Return updated row with new cells list
                return InventoryRowModel(
                  id: row.id,
                  inventorySheetId: row.inventorySheetId,
                  rowIndex: row.rowIndex,
                  isItemRow: row.isItemRow,
                  itemId: row.itemId,
                  cells: updatedCells,
                  createdAt: row.createdAt,
                  updatedAt: row.updatedAt,
                );
              }
              return row; // Return unchanged row
            }).toList(),
          );

          // Update formula handler and data source
          _formulaHandler = InventoryFormulaHandler(sheet: updatedSheet);
          _dataSource = InventorySheetDataSource(
            sheet: updatedSheet,
            isEditable: _isEditable,
            cellSubmitCallback: _handleCellSubmit,
            addCalculationRowCallback: _addCalculationRow,
            deleteRowCallback: _deleteRow,
            formulaHandler: _formulaHandler,
            eraseCellCallback: _eraseCell,
            addMultipleCalculationRowsCallback: _addMultipleCalculationRows,
            onDoubleTabHandler: !_isEditable ? _toggleEditMode : null,
          );
        });
      }
    } catch (e) {
      print('Error erasing cell: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to erase cell: ${e.toString()}')),
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
    return GestureDetector(
      // Enable edit mode with double-click anywhere on the sheet
      onDoubleTap: !_isEditable ? _toggleEditMode : null,
      child: Container(
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
                      if (!_isEditable)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Double-click to edit',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      IconButton(
                        icon:
                            const Icon(Icons.refresh, color: AppColors.primary),
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
                      IconButton(
                        icon: const Icon(Icons.help_outline,
                            color: AppColors.primary),
                        tooltip: 'Formula Help',
                        onPressed: () {
                          _showFormulaHelpDialog();
                        },
                      ),
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
                onCellTap: (details) {
                  if (details.rowColumnIndex.rowIndex > 0 && // Skip header
                      details.column.columnName != 'itemName') {
                    // Get the actual data grid row - fixing the undefined getter error
                    final rowData = _dataSource.rows.isNotEmpty &&
                            details.rowColumnIndex.rowIndex - 1 <
                                _dataSource.rows.length
                        ? _dataSource.rows[details.rowColumnIndex.rowIndex - 1]
                        : null;

                    if (rowData != null) {
                      // Extract row cell data from the first column
                      final firstCell = rowData.getCells().first;
                      if (firstCell.value is RowCellData) {
                        final rowCellData = firstCell.value as RowCellData;
                        final rowIndex = rowCellData.rowIndex;
                        final columnIndex = int.parse(
                            details.column.columnName.replaceAll('column', ''));

                        // Find the cell in the data model
                        final rowModel = widget.sheet.rows.firstWhereOrNull(
                          (r) => r.rowIndex == rowIndex,
                        );

                        InventoryCellModel? cell;
                        if (rowModel != null) {
                          cell = rowModel.cells.firstWhereOrNull(
                            (c) => c.columnIndex == columnIndex,
                          );
                        }

                        setState(() {
                          _selectedRowIndex = rowIndex;
                          _selectedColumnIndex = columnIndex;
                          _selectedCell = cell;
                          _selectedCellValue = cell?.value ?? '';
                        });
                      }
                    }
                  }
                },
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
                    Expanded(child: Container()), // Spacer

                    // Add cell operation buttons
                    if (_selectedRowIndex != null &&
                        _selectedColumnIndex != null)
                      Row(
                        children: [
                          // Add Quick Formulas button
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.functions,
                              color: Colors.white,
                              size: 16,
                            ),
                            label: const Text('Quick Formulas',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onPressed: () {
                              _showQuickFormulasMenu();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 16,
                            ),
                            label: const Text('Erase Cell Value',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red)),
                            onPressed: () {
                              if (_selectedRowIndex != null &&
                                  _selectedColumnIndex != null) {
                                _eraseCell(
                                    _selectedRowIndex!, _selectedColumnIndex!);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Color picker button
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.color_lens,
                              color: Colors.white,
                              size: 16,
                            ),
                            label: const Text('Change Color',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onPressed: () {
                              _showColorPickerDialog(
                                  _selectedRowIndex!,
                                  _selectedColumnIndex!,
                                  _selectedCellValue ?? '');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
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
      ),
    );
  }

  // Add a new method to show quick formulas menu
  void _showQuickFormulasMenu() {
    if (_selectedRowIndex == null || _selectedColumnIndex == null) return;

    final currentSheet =
        _dataSource.currentSheet; // Use current sheet from data source
    final rowIndex = _selectedRowIndex!;
    final columnIndex = _selectedColumnIndex!;

    // Find the selected cell in the current sheet to get its properties
    final selectedRowModel =
        currentSheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
    final selectedCellModel = selectedRowModel?.cells
        .firstWhereOrNull((c) => c.columnIndex == columnIndex);

    final colorHex = selectedCellModel?.color ??
        _selectedCellColorHex; // Prioritize current model's color

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quick Formulas'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFormulaOption(
                  context,
                  'Subtract Vertical Cells',
                  Icons.remove,
                  () {
                    if (rowIndex >= 2) {
                      // Needs at least two cells above to subtract: (row-2) - (row-1)
                      // Ensure we are referencing valid row indices
                      final topRowIndex = rowIndex - 2;
                      final bottomRowIndex = rowIndex - 1;

                      // Check if these rows actually exist in the sheet
                      bool topRowExists = currentSheet.rows
                          .any((r) => r.rowIndex == topRowIndex);
                      bool bottomRowExists = currentSheet.rows
                          .any((r) => r.rowIndex == bottomRowIndex);

                      if (topRowExists && bottomRowExists) {
                        String formula =
                            '=${_getColumnLetter(columnIndex)}${topRowIndex} - ${_getColumnLetter(columnIndex)}${bottomRowIndex}';
                        _handleCellSubmit(
                            rowIndex, columnIndex, formula, colorHex);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Not enough valid rows above for subtraction.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Not enough rows above for subtraction.')),
                      );
                    }
                  },
                ),
                _buildFormulaOption(
                  context,
                  'Apply Multiply to All Rows',
                  Icons.clear,
                  () {
                    if (columnIndex < 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Select a cell in column C or higher to use this feature.')),
                      );
                      Navigator.of(context).pop(); // Close dialog
                      return;
                    }

                    String generateProductFormula(int rIdx, int cIdx) {
                      List<String> terms = [];
                      // Multiply columns from C (index 2) up to the column before the selected one
                      for (int colToMultiply = 2;
                          colToMultiply < cIdx;
                          colToMultiply++) {
                        terms.add("${_getColumnLetter(colToMultiply)}$rIdx");
                      }
                      if (terms.isEmpty) {
                        // If selected column is C, or no columns to multiply, result is 1
                        return "=1";
                      }
                      return "=" + terms.join(" * ");
                    }

                    final mainFormula =
                        generateProductFormula(rowIndex, columnIndex);
                    _handleCellSubmit(
                        rowIndex, columnIndex, mainFormula, colorHex);

                    // Apply to all other rows
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final sortedRows =
                          List<InventoryRowModel>.from(currentSheet.rows)
                            ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

                      for (var row in sortedRows) {
                        if (row.rowIndex == rowIndex)
                          continue; // Skip the already processed selected row

                        final otherFormula =
                            generateProductFormula(row.rowIndex, columnIndex);
                        // Submit with null color for other rows
                        _handleCellSubmit(
                            row.rowIndex, columnIndex, otherFormula, null);
                      }
                    });

                    Navigator.of(context).pop();
                  },
                ),
                _buildFormulaOption(
                  context,
                  'Add All Cells Above',
                  Icons.add,
                  () {
                    List<String> terms = [];

                    final sortedRows =
                        List<InventoryRowModel>.from(currentSheet.rows)
                          ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

                    for (var rowIter in sortedRows) {
                      if (rowIter.rowIndex < rowIndex) {
                        // Only cells strictly above
                        final cellInColumn = rowIter.cells.firstWhereOrNull(
                            (c) => c.columnIndex == columnIndex);

                        if (cellInColumn != null &&
                            cellInColumn.value != null &&
                            cellInColumn.value!.isNotEmpty) {
                          try {
                            // This check ensures we only include cells that currently hold a numeric value.
                            // The formula itself will use cell references.
                            double.parse(cellInColumn.value!);
                            terms.add(
                                '${_getColumnLetter(columnIndex)}${rowIter.rowIndex}');
                          } catch (_) {
                            // Value is not a plain number (e.g. text, #ERROR)
                            // Do not include in sum if it's not currently representing a number.
                          }
                        }
                      }
                    }

                    if (terms.isNotEmpty) {
                      String formula = '=' + terms.join(' + ');
                      _handleCellSubmit(
                          rowIndex, columnIndex, formula, colorHex);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'No numeric cells found above this cell in the column.')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build formula option items
  Widget _buildFormulaOption(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
    );
  }

  // Add a method to show color picker dialog for the selected cell
  void _showColorPickerDialog(int rowIndex, int columnIndex, String value) {
    final existingCell = _findCellInSheet(rowIndex, columnIndex);
    String? currentColorHex = existingCell?.color;

    // Preserve formula if it exists
    String valueToKeep = existingCell?.formula ?? value;
    // If we have a formula, use that, otherwise use the display value
    if (existingCell?.formula == null && existingCell?.value != null) {
      valueToKeep = existingCell!.value!;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Cell Color'),
          content: SizedBox(
            width: 300,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: CellColorHandler.colorPalette.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return InkWell(
                    onTap: () {
                      // Pass the preserved value instead of potentially empty value
                      _handleCellSubmit(
                          rowIndex, columnIndex, valueToKeep, null);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Icon(Icons.format_color_reset),
                      ),
                    ),
                  );
                }

                final colorEntry =
                    CellColorHandler.colorPalette.entries.elementAt(index - 1);

                return InkWell(
                  onTap: () {
                    final colorHex =
                        CellColorHandler.getHexFromColor(colorEntry.value);
                    // Pass the preserved value instead of potentially empty value
                    _handleCellSubmit(
                        rowIndex, columnIndex, valueToKeep, colorHex);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorEntry.value,
                      border: Border.all(
                        color: Colors.black,
                        width: currentColorHex != null &&
                                CellColorHandler.getHexFromColor(
                                        colorEntry.value) ==
                                    currentColorHex
                            ? 2
                            : 0.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to find a cell in the sheet
  InventoryCellModel? _findCellInSheet(int rowIndex, int columnIndex) {
    // Use _dataSource.currentSheet for consistency
    final rowModel = _dataSource.currentSheet.rows.firstWhereOrNull(
      (r) => r.rowIndex == rowIndex,
    );

    if (rowModel != null) {
      return rowModel.cells.firstWhereOrNull(
        (c) => c.columnIndex == columnIndex,
      );
    }

    return null;
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
            'Row Number',
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
