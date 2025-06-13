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
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/row_reorder_change.dart';
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

class _InventorySheetState extends ConsumerState<InventorySheet>
    with TickerProviderStateMixin {
  late InventorySheetDataSource _dataSource;
  final DataGridController _dataGridController = DataGridController();
  bool _isEditable = false;
  bool _isLoading = false;
  late InventoryFormulaHandler _formulaHandler;

  // Animation controllers for modern UI transitions
  late AnimationController _editModeAnimationController;
  late Animation<double> _editModeScaleAnimation;
  late Animation<Color?> _editModeBorderColorAnimation;

  // Track cells that depend on other cells for formula calculation
  final Map<String, Set<String>> _formulaDependencies = {};

  // Store pending cell changes
  final Map<String, CellChange> _pendingChanges = {};

  // Store pending row reorder changes
  final Map<String, RowReorderChange> _pendingRowReorders = {};

  // Track currently selected cell
  int? _selectedRowIndex;
  int? _selectedColumnIndex;
  InventoryCellModel? _selectedCell;
  String? _selectedCellValue;
  String? _selectedCellColorHex;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _formulaHandler = InventoryFormulaHandler(sheet: widget.sheet);
    _initializeDataSource();
    _buildFormulaDependencyMap();

    // Add this line to recalculate formulas on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recalculateAllFormulasOnLoad();
    });
  }

  void _initializeAnimations() {
    _editModeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _editModeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _editModeAnimationController,
      curve: Curves.easeInOut,
    ));

    _editModeBorderColorAnimation = ColorTween(
      begin: AppColors.primary.withOpacity(0.3),
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _editModeAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _editModeAnimationController.dispose();
    super.dispose();
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
      onRowReorder: _handleRowReorder, // Add row reorder callback
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
      _initializeDataSource();

      if (_isEditable) {
        _editModeAnimationController.forward();
      } else {
        _editModeAnimationController.reverse();
      }
    });

    // Provide haptic feedback
    HapticFeedback.mediumImpact();
  }

  Future<void> _saveChanges() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await _applyPendingChanges();
      _showSnackBar('Changes saved successfully!');

      setState(() {
        _isEditable = false;
        _initializeDataSource();
        _editModeAnimationController.reverse();
      });
    } catch (e) {
      _showSnackBar('Failed to save changes: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Handle row reordering
  void _handleRowReorder(String rowId, int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;

    print("Row reorder requested: $rowId from $oldIndex to $newIndex");

    // Add to pending row reorders
    _pendingRowReorders[rowId] = RowReorderChange(
      rowId: rowId,
      oldRowIndex: oldIndex,
      newRowIndex: newIndex,
    );

    // Update UI immediately with temporary reordering
    setState(() {
      _updateRowOrderInUI(oldIndex, newIndex);
    });

    _showSnackBar('Row position updated (pending save)');
  }

  // Update row order in UI temporarily
  void _updateRowOrderInUI(int oldIndex, int newIndex) {
    // Create a working copy of the sheet with reordered rows
    final currentSheet = _dataSource.currentSheet;
    final sortedRows = List<InventoryRowModel>.from(currentSheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    if (oldIndex >= 0 &&
        oldIndex < sortedRows.length &&
        newIndex >= 0 &&
        newIndex < sortedRows.length) {
      // Remove the row from old position
      final movedRow = sortedRows.removeAt(oldIndex);

      // Insert at new position
      sortedRows.insert(newIndex, movedRow);

      // Update all row indexes based on new positions
      final updatedRows = <InventoryRowModel>[];
      for (int i = 0; i < sortedRows.length; i++) {
        final row = sortedRows[i];
        updatedRows.add(InventoryRowModel(
          id: row.id,
          inventorySheetId: row.inventorySheetId,
          rowIndex: i, // New index based on position
          isItemRow: row.isItemRow,
          itemId: row.itemId,
          cells: row.cells,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        ));
      }

      // Create updated sheet
      final updatedSheet = InventorySheetModel(
        id: currentSheet.id,
        name: currentSheet.name,
        columns: currentSheet.columns,
        inventoryId: currentSheet.inventoryId,
        createdAt: currentSheet.createdAt,
        updatedAt: currentSheet.updatedAt,
        rows: updatedRows,
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
        onRowReorder: _handleRowReorder,
      );

      // Rebuild formula dependencies after reordering
      _buildFormulaDependencyMap();
    }
  }

  // Apply all pending changes including row reorders
  Future<void> _applyPendingChanges() async {
    if (_pendingChanges.isEmpty && _pendingRowReorders.isEmpty) return;

    try {
      // First, apply row reordering if any
      if (_pendingRowReorders.isNotEmpty) {
        print("Applying ${_pendingRowReorders.length} row reorder changes");

        List<Map<String, dynamic>> rowUpdates = _pendingRowReorders.values
            .map((change) => {
                  'rowId': change.rowId,
                  'newRowIndex': change.newRowIndex,
                })
            .toList();

        await ref
            .read(inventoryProvider.notifier)
            .updateRowPositions(rowUpdates);

        _pendingRowReorders.clear();
        print("Row reorder changes applied successfully");
      }

      // Then apply cell changes as before
      if (_pendingChanges.isNotEmpty) {
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
              'color': change.color,
            });
          } else {
            cellsToCreate.add({
              'rowId': change.rowId,
              'columnIndex': change.columnIndex,
              'value': change.displayValue,
              'formula': change.formula,
              'color': change.color,
            });
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
      }
    } catch (e) {
      print('Error applying pending changes: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save changes: ${e.toString()}')),
        );
      }
      rethrow;
    }
  }

  @override
  void didUpdateWidget(InventorySheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sheet != widget.sheet) {
      _formulaHandler = InventoryFormulaHandler(sheet: widget.sheet);
      _initializeDataSource();
      _buildFormulaDependencyMap();

      // Add this line to recalculate formulas when sheet data changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recalculateAllFormulasOnLoad();
      });
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

  // Recalculate all formulas when sheet is loaded
  Future<void> _recalculateAllFormulasOnLoad() async {
    try {
      print('Starting formula recalculation on load...');

      // Get all cells with formulas
      List<Map<String, dynamic>> formulaCells = _getAllFormulaCells();

      if (formulaCells.isEmpty) {
        print('No formula cells found');
        return;
      }

      print('Found ${formulaCells.length} formula cells to recalculate');

      // Multi-pass formula resolution to handle dependencies
      int maxPasses = 5;
      bool hasChanges = true;
      List<Map<String, dynamic>> cellsToUpdate = [];

      for (int pass = 0; pass < maxPasses && hasChanges; pass++) {
        print('Formula recalculation pass ${pass + 1}');
        hasChanges = false;

        for (var cellData in formulaCells) {
          try {
            String formula = cellData['formula'] as String;
            int rowIndex = cellData['rowIndex'] as int;
            int columnIndex = cellData['columnIndex'] as int;
            String cellId = cellData['cellId'] as String;
            String? currentValue = cellData['currentValue'] as String?;

            // Recalculate the formula
            String newValue =
                _formulaHandler.evaluateFormula(formula, rowIndex, columnIndex);

            // Check if value changed
            if (newValue != currentValue) {
              hasChanges = true;

              // Update in our local data
              cellData['currentValue'] = newValue;

              // Add to cells to update
              cellsToUpdate.removeWhere((cell) => cell['id'] == cellId);
              cellsToUpdate.add({
                'id': cellId,
                'value': newValue,
                'formula': formula,
              });

              print(
                  'Updated cell ${_getColumnLetter(columnIndex)}$rowIndex: $currentValue -> $newValue');
            }
          } catch (e) {
            print('Error recalculating formula for cell: $e');
            // Add error value to updates
            String cellId = cellData['cellId'] as String;
            cellsToUpdate.removeWhere((cell) => cell['id'] == cellId);
            cellsToUpdate.add({
              'id': cellId,
              'value': '#ERROR',
              'formula': cellData['formula'],
            });
          }
        }
      }

      // Auto-save the recalculated values
      if (cellsToUpdate.isNotEmpty) {
        print(
            'Auto-saving ${cellsToUpdate.length} recalculated formula values');
        await _autoSaveRecalculatedFormulas(cellsToUpdate);
      }

      print('Formula recalculation completed');
    } catch (e) {
      print('Error during formula recalculation on load: $e');
    }
  }

  // Get all cells with formulas
  List<Map<String, dynamic>> _getAllFormulaCells() {
    List<Map<String, dynamic>> formulaCells = [];

    // Sort rows by index for consistent processing
    final sortedRows = List<InventoryRowModel>.from(widget.sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    for (var row in sortedRows) {
      // Sort cells by column index for consistent processing
      final sortedCells = List<InventoryCellModel>.from(row.cells)
        ..sort((a, b) => a.columnIndex.compareTo(b.columnIndex));

      for (var cell in sortedCells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          formulaCells.add({
            'cellId': cell.id,
            'rowIndex': row.rowIndex,
            'columnIndex': cell.columnIndex,
            'formula': cell.formula!,
            'currentValue': cell.value,
          });
        }
      }
    }

    return formulaCells;
  }

  // Auto-save recalculated formula values in background
  Future<void> _autoSaveRecalculatedFormulas(
      List<Map<String, dynamic>> cellsToUpdate) async {
    try {
      // Save to database without showing loading indicators
      await ref.read(inventoryProvider.notifier).updateCells(cellsToUpdate);

      print(
          'Successfully auto-saved ${cellsToUpdate.length} recalculated formulas');
    } catch (e) {
      print('Error auto-saving recalculated formulas: $e');
      // Don't show error to user since this is a background operation
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
      onDoubleTap: !_isEditable ? _toggleEditMode : null,
      child: AnimatedBuilder(
        animation: _editModeAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _editModeScaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _editModeBorderColorAnimation.value ??
                      AppColors.primary.withOpacity(0.3),
                  width: _isEditable ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isEditable
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    spreadRadius: _isEditable ? 3 : 1,
                    blurRadius: _isEditable ? 12 : 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModernHeader(),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: SfDataGrid(
                        source: _dataSource,
                        controller: _dataGridController,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        columnWidthMode: ColumnWidthMode.auto,
                        allowEditing: _isEditable,
                        selectionMode: SelectionMode.multiple,
                        navigationMode: GridNavigationMode.cell,
                        frozenColumnsCount: 1,
                        columns: _buildColumns(),
                        onCellTap: _handleCellTap,
                      ),
                    ),
                  ),
                  _buildEditControlsPanel(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleCellTap(DataGridCellTapDetails details) {
    if (details.rowColumnIndex.rowIndex > 0 &&
        details.column.columnName != 'itemName') {
      final rowData = _dataSource.rows.isNotEmpty &&
              details.rowColumnIndex.rowIndex - 1 < _dataSource.rows.length
          ? _dataSource.rows[details.rowColumnIndex.rowIndex - 1]
          : null;

      if (rowData != null) {
        final firstCell = rowData.getCells().first;
        if (firstCell.value is RowCellData) {
          final rowCellData = firstCell.value as RowCellData;
          final rowIndex = rowCellData.rowIndex;
          final columnIndex =
              int.parse(details.column.columnName.replaceAll('column', ''));

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
            _selectedCellColorHex = cell?.color;
          });
        }
      }
    }
  }

  Widget _buildModernHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sheet.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!_isEditable)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 16,
                              color: AppColors.primary.withOpacity(0.8),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Double-click to edit',
                              style: TextStyle(
                                color: AppColors.primary.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildModernActionButton(
          icon: Icons.refresh,
          label: 'Refresh',
          onPressed: () {
            ref.read(inventoryProvider.notifier).getInventoryByDate(null, null);
          },
          color: AppColors.secondary,
        ),
        _buildModernActionButton(
          icon: _isEditable ? Icons.visibility : Icons.edit,
          label: _isEditable ? 'View Mode' : 'Edit Mode',
          onPressed: _toggleEditMode,
          color: _isEditable ? Colors.orange : AppColors.primary,
          isPrimary: true,
        ),
        _buildModernActionButton(
          icon: Icons.add,
          label: 'Add Rows',
          onPressed: _handleAddRows,
          color: Colors.green,
        ),
        _buildModernActionButton(
          icon: Icons.help_outline,
          label: 'Help',
          onPressed: _showFormulaHelpDialog,
          color: Colors.blue,
        ),
        if (_isEditable)
          _buildModernActionButton(
            icon: Icons.delete,
            label: 'Delete',
            onPressed: _handleDeleteRow,
            color: Colors.red,
          ),
      ],
    );
  }

  Widget _buildModernActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isPrimary = false,
  }) {
    return Material(
      elevation: isPrimary ? 6 : 3,
      shadowColor: color.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddRows() {
    int rowIndex = _dataGridController.selectedIndex != -1
        ? _dataGridController.selectedIndex
        : widget.sheet.rows.length - 1;

    if (rowIndex >= 0 && rowIndex < widget.sheet.rows.length) {
      _showAddRowsDialog(widget.sheet.rows[rowIndex].rowIndex);
    } else {
      _showAddRowsDialog(
          widget.sheet.rows.isNotEmpty ? widget.sheet.rows.last.rowIndex : 0);
    }
  }

  void _handleDeleteRow() {
    if (_dataGridController.selectedIndex != -1) {
      int selectedIndex = _dataGridController.selectedIndex;
      if (selectedIndex >= 0 && selectedIndex < widget.sheet.rows.length) {
        _showDeleteConfirmationDialog(selectedIndex);
      }
    } else {
      _showSnackBar('Please select a row to delete', isError: true);
    }
  }

  void _showDeleteConfirmationDialog(int selectedIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Delete'),
          content: const Text(
            'Are you sure you want to delete this row? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
              onPressed: () {
                _deleteRow(widget.sheet.rows[selectedIndex].id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditControlsPanel() {
    if (!_isEditable) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.02),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildPendingChangesIndicator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_selectedRowIndex != null && _selectedColumnIndex != null)
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildEditActionButton(
                        icon: Icons.functions,
                        label: 'Quick Formulas',
                        onPressed: _showQuickFormulasMenu,
                        color: Colors.blue,
                      ),
                      _buildEditActionButton(
                        icon: Icons.clear,
                        label: 'Erase Cell',
                        onPressed: () => _eraseCell(
                            _selectedRowIndex!, _selectedColumnIndex!),
                        color: Colors.red,
                      ),
                      _buildEditActionButton(
                        icon: Icons.color_lens,
                        label: 'Change Color',
                        onPressed: () => _showColorPickerDialog(
                            _selectedRowIndex!,
                            _selectedColumnIndex!,
                            _selectedCellValue ?? ''),
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 16),
              _buildSaveButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingChangesIndicator() {
    final totalPendingChanges =
        _pendingChanges.length + _pendingRowReorders.length;
    if (totalPendingChanges == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pending_actions, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$totalPendingChanges unsaved change${totalPendingChanges == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_pendingRowReorders.isNotEmpty)
                Text(
                  '${_pendingRowReorders.length} row position${_pendingRowReorders.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: Colors.orange.shade600,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Material(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Material(
      elevation: 6,
      shadowColor: AppColors.primary.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : _saveChanges,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                const Icon(Icons.save, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                _isLoading ? 'Saving...' : 'Save Changes',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Add the missing _showQuickFormulasMenu method
  void _showQuickFormulasMenu() {
    if (_selectedRowIndex == null || _selectedColumnIndex == null) return;

    final currentSheet = _dataSource.currentSheet;
    final rowIndex = _selectedRowIndex!;
    final columnIndex = _selectedColumnIndex!;

    // Find the selected cell in the current sheet to get its properties
    final selectedRowModel =
        currentSheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
    final selectedCellModel = selectedRowModel?.cells
        .firstWhereOrNull((c) => c.columnIndex == columnIndex);

    final colorHex = selectedCellModel?.color ?? _selectedCellColorHex;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.functions, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              const Text('Quick Formulas'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModernFormulaOption(
                  context,
                  'Subtract Vertical Cells',
                  Icons.remove,
                  'Subtract the cell above from the one two rows above',
                  Colors.orange,
                  () => _applySubtractVerticalFormula(
                      rowIndex, columnIndex, colorHex),
                ),
                const SizedBox(height: 8),
                _buildModernFormulaOption(
                  context,
                  'Apply Multiply to All Rows',
                  Icons.clear,
                  'Multiply all values in previous columns for each row',
                  Colors.blue,
                  () => _applyMultiplyToAllRows(
                      rowIndex, columnIndex, colorHex, currentSheet),
                ),
                const SizedBox(height: 8),
                _buildModernFormulaOption(
                  context,
                  'Add All Cells Above',
                  Icons.add,
                  'Sum all numeric cells above in this column',
                  Colors.green,
                  () => _applyAddAllCellsAbove(
                      rowIndex, columnIndex, colorHex, currentSheet),
                ),
                const SizedBox(height: 8),
                _buildModernFormulaOption(
                  context,
                  'Apply Addition to All Rows',
                  Icons.add_circle_outline,
                  'Add all values in previous columns for each row',
                  Colors.purple,
                  () => _applyAdditionToAllRows(
                      rowIndex, columnIndex, colorHex, currentSheet),
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

  Widget _buildModernFormulaOption(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.05),
                color.withOpacity(0.02),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _applySubtractVerticalFormula(
      int rowIndex, int columnIndex, String? colorHex) {
    if (rowIndex >= 2) {
      final topRowIndex = rowIndex - 2;
      final bottomRowIndex = rowIndex - 1;

      // Check if these rows exist
      final currentSheet = _dataSource.currentSheet;
      bool topRowExists =
          currentSheet.rows.any((r) => r.rowIndex == topRowIndex);
      bool bottomRowExists =
          currentSheet.rows.any((r) => r.rowIndex == bottomRowIndex);

      if (topRowExists && bottomRowExists) {
        String formula =
            '=${_getColumnLetter(columnIndex)}${topRowIndex} - ${_getColumnLetter(columnIndex)}${bottomRowIndex}';
        _handleCellSubmit(rowIndex, columnIndex, formula, colorHex);
      } else {
        _showSnackBar('Not enough valid rows above for subtraction.',
            isError: true);
      }
    } else {
      _showSnackBar('Not enough rows above for subtraction.', isError: true);
    }
  }

  void _applyMultiplyToAllRows(int rowIndex, int columnIndex, String? colorHex,
      InventorySheetModel currentSheet) {
    if (columnIndex < 2) {
      _showSnackBar('Select a cell in column C or higher to use this feature.',
          isError: true);
      return;
    }

    String generateProductFormula(
        int rIdx, int cIdx, InventoryRowModel rowModel) {
      // Only multiply the first 2 cells to the left of the selected column
      int firstColumnIndex = cIdx - 2;
      int secondColumnIndex = cIdx - 1;

      final firstCell = rowModel.cells
          .firstWhereOrNull((c) => c.columnIndex == firstColumnIndex);
      final secondCell = rowModel.cells
          .firstWhereOrNull((c) => c.columnIndex == secondColumnIndex);

      // Check if both cells have valid values
      bool firstCellValid = false;
      bool secondCellValid = false;

      if (firstCell != null &&
          firstCell.value != null &&
          firstCell.value!.isNotEmpty &&
          firstCell.value != '0') {
        try {
          double.parse(firstCell.value!);
          firstCellValid = true;
        } catch (_) {
          if (firstCell.formula != null && firstCell.formula!.startsWith('=')) {
            firstCellValid = true;
          }
        }
      }

      if (secondCell != null &&
          secondCell.value != null &&
          secondCell.value!.isNotEmpty &&
          secondCell.value != '0') {
        try {
          double.parse(secondCell.value!);
          secondCellValid = true;
        } catch (_) {
          if (secondCell.formula != null &&
              secondCell.formula!.startsWith('=')) {
            secondCellValid = true;
          }
        }
      }

      // Both cells must be valid for multiplication
      if (!firstCellValid || !secondCellValid) {
        return "";
      }

      return "=${_getColumnLetter(firstColumnIndex)}$rIdx * ${_getColumnLetter(secondColumnIndex)}$rIdx";
    }

    final selectedRowModel =
        currentSheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
    if (selectedRowModel == null) return;

    final mainFormula =
        generateProductFormula(rowIndex, columnIndex, selectedRowModel);
    if (mainFormula.isNotEmpty) {
      _handleCellSubmit(rowIndex, columnIndex, mainFormula, colorHex);
    } else {
      _showSnackBar(
          'The two cells to the left must contain valid numeric values.',
          isError: true);
      return;
    }

    // Apply to all other rows
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sortedRows = List<InventoryRowModel>.from(currentSheet.rows)
        ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

      for (var row in sortedRows) {
        if (row.rowIndex == rowIndex) continue;

        final otherFormula =
            generateProductFormula(row.rowIndex, columnIndex, row);
        if (otherFormula.isNotEmpty) {
          _handleCellSubmit(row.rowIndex, columnIndex, otherFormula, null);
        }
      }
    });
  }

  void _applyAddAllCellsAbove(int rowIndex, int columnIndex, String? colorHex,
      InventorySheetModel currentSheet) {
    List<String> terms = [];

    final sortedRows = List<InventoryRowModel>.from(currentSheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    for (var rowIter in sortedRows) {
      if (rowIter.rowIndex < rowIndex) {
        final cellInColumn =
            rowIter.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);

        if (cellInColumn != null &&
            cellInColumn.value != null &&
            cellInColumn.value!.isNotEmpty) {
          try {
            double.parse(cellInColumn.value!);
            terms.add('${_getColumnLetter(columnIndex)}${rowIter.rowIndex}');
          } catch (_) {
            // Skip non-numeric values
          }
        }
      }
    }

    if (terms.isNotEmpty) {
      String formula = '=' + terms.join(' + ');
      _handleCellSubmit(rowIndex, columnIndex, formula, colorHex);
    } else {
      _showSnackBar('No numeric cells found above this cell in the column.',
          isError: true);
    }
  }

  void _applyAdditionToAllRows(int rowIndex, int columnIndex, String? colorHex,
      InventorySheetModel currentSheet) {
    if (columnIndex <= 1) {
      _showSnackBar('Select a cell in column C or higher to use this feature.',
          isError: true);
      return;
    }

    String generateSumFormula(int rIdx, int cIdx, InventoryRowModel rowModel) {
      List<String> terms = [];
      bool hasValidValues = false;

      for (int colToSum = 1; colToSum < cIdx; colToSum++) {
        final cell =
            rowModel.cells.firstWhereOrNull((c) => c.columnIndex == colToSum);

        if (cell != null &&
            cell.value != null &&
            cell.value!.isNotEmpty &&
            cell.value != '0') {
          try {
            double.parse(cell.value!);
            terms.add("${_getColumnLetter(colToSum)}$rIdx");
            hasValidValues = true;
          } catch (_) {
            if (cell.formula != null && cell.formula!.startsWith('=')) {
              terms.add("${_getColumnLetter(colToSum)}$rIdx");
              hasValidValues = true;
            }
          }
        }
      }

      if (!hasValidValues || terms.isEmpty) {
        return "";
      }

      return "=" + terms.join(" + ");
    }

    final selectedRowModel =
        currentSheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
    if (selectedRowModel == null) return;

    final mainFormula =
        generateSumFormula(rowIndex, columnIndex, selectedRowModel);
    if (mainFormula.isNotEmpty) {
      _handleCellSubmit(rowIndex, columnIndex, mainFormula, colorHex);
    }

    // Apply to all other rows
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sortedRows = List<InventoryRowModel>.from(currentSheet.rows)
        ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

      for (var row in sortedRows) {
        if (row.rowIndex == rowIndex) continue;

        final otherFormula = generateSumFormula(row.rowIndex, columnIndex, row);
        if (otherFormula.isNotEmpty) {
          _handleCellSubmit(row.rowIndex, columnIndex, otherFormula, null);
        }
      }
    });
  }

  // Add the missing color picker dialog method
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.color_lens, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              const Text('Select Cell Color'),
            ],
          ),
          content: Container(
            width: 320,
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose a color for this cell',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: CellColorHandler.colorPalette.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildColorOption(
                        null,
                        'Remove Color',
                        Icons.format_color_reset,
                        currentColorHex == null,
                        () {
                          _handleCellSubmit(
                              rowIndex, columnIndex, valueToKeep, null);
                          Navigator.of(context).pop();
                        },
                      );
                    }

                    final colorEntry = CellColorHandler.colorPalette.entries
                        .elementAt(index - 1);
                    final colorHex =
                        CellColorHandler.getHexFromColor(colorEntry.value);
                    final isSelected = currentColorHex == colorHex;

                    return _buildColorOption(
                      colorEntry.value,
                      colorEntry.key,
                      null,
                      isSelected,
                      () {
                        _handleCellSubmit(
                            rowIndex, columnIndex, valueToKeep, colorHex);
                        Navigator.of(context).pop();
                      },
                    );
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

  Widget _buildColorOption(
    Color? color,
    String label,
    IconData? icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      elevation: isSelected ? 4 : 2,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
              width: isSelected ? 3 : 1,
            ),
          ),
          child: Center(
            child: icon != null
                ? Icon(
                    icon,
                    color: Colors.grey[600],
                    size: 20,
                  )
                : Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
          ),
        ),
      ),
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
