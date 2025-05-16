// ignore_for_file: unused_local_variable

import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_data_source.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_color_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/row_cell_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Track cells that depend on other cells for formula calculation
  final Map<String, Set<String>> _formulaDependencies = {};

  // Track the currently selected cell
  int? _selectedRowIndex;
  int? _selectedColumnIndex;
  String? _selectedCellValue;
  String? _selectedCellColorHex;
  TextEditingController _cellValueController = TextEditingController();

  // Store pending cell changes
  final Map<String, CellChange> _pendingChanges = {};

  @override
  void initState() {
    super.initState();
    _formulaHandler = FormulaHandler(sheet: widget.sheet);
    _initializeDataSource();
    _buildFormulaDependencyMap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the current context in the data source
    KahonSheetDataSource.currentContext = context;
  }

  // Build a map of formula dependencies with improved debugging
  void _buildFormulaDependencyMap() {
    _formulaDependencies.clear();
    print("Rebuilding formula dependency map...");

    for (var row in widget.sheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          // Get cell references from formula
          Set<String> dependencies =
              _formulaHandler.extractCellReferencesFromFormula(cell.formula!);

          // Debug cells with no dependencies
          if (dependencies.isEmpty) {
            print("No dependencies found for formula: ${cell.formula}");
          }

          // For each cell this formula depends on, add this cell as a dependent
          for (String dependency in dependencies) {
            if (!_formulaDependencies.containsKey(dependency)) {
              _formulaDependencies[dependency] = {};
            }

            String cellKey = '${row.rowIndex}_${cell.columnIndex}';
            _formulaDependencies[dependency]!.add(cellKey);

            print(
                "Added dependency: $dependency -> $cellKey (formula: ${cell.formula})");
          }
        }
      }
    }

    print(
        'Formula dependencies built with ${_formulaDependencies.length} entries');
  }

  void _initializeDataSource() {
    _dataSource = KahonSheetDataSource(
      sheet: widget.sheet,
      kahonItems: const [],
      isEditable: _isEditable,
      cellSubmitCallback: _handleCellSubmit,
      addCalculationRowCallback: _addCalculationRow,
      deleteRowCallback: _deleteRow,
      formulaHandler: _formulaHandler,
      onCellSelected: _handleCellSelected,
    );

    // Make sure to set the context
    KahonSheetDataSource.currentContext = context;
  }

  // Handle cell selection
  void _handleCellSelected(
      int rowIndex, int columnIndex, String? value, String? colorHex) {
    setState(() {
      _selectedRowIndex = rowIndex;
      _selectedColumnIndex = columnIndex;
      _selectedCellValue = value;
      _selectedCellColorHex = colorHex;
      _cellValueController.text = value ?? '';
    });
  }

  // Clear selected cell
  void _clearSelectedCell() {
    setState(() {
      _selectedRowIndex = null;
      _selectedColumnIndex = null;
      _selectedCellValue = null;
      _selectedCellColorHex = null;
      _cellValueController.clear();
    });
  }

  // Erase selected cell
  void _eraseSelectedCell() {
    if (_selectedRowIndex != null && _selectedColumnIndex != null) {
      try {
        // Find the corresponding row in the current sheet
        final rowModel = widget.sheet.rows.firstWhereOrNull(
          (r) => r.rowIndex == _selectedRowIndex,
        );

        if (rowModel == null) {
          print('Row not found for index: $_selectedRowIndex');
          return;
        }

        // Check if the cell exists
        final existingCell = rowModel.cells.firstWhereOrNull(
          (c) => c.columnIndex == _selectedColumnIndex,
        );

        if (existingCell != null) {
          // Create a unique key for this cell change
          String changeKey = '${_selectedRowIndex}_${_selectedColumnIndex}';

          // Store the change in pending changes with empty value and no formula
          _pendingChanges[changeKey] = CellChange(
            isUpdate: true,
            cellId: existingCell.id,
            rowId: rowModel.id,
            columnIndex: _selectedColumnIndex!,
            displayValue: '', // Empty value
            formula: null, // Clear formula
            color: null, // Clear color
          );

          print("Added cell erase to pending changes: $changeKey");

          // Update UI immediately to show the change
          setState(() {
            // Make sure we're working with the most current sheet state
            SheetModel currentSheet = _dataSource.currentSheet;

            // Create a mutable copy of the sheet for UI updates
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

                  // Update existing cell
                  int cellIndex =
                      updatedCells.indexWhere((c) => c.id == existingCell.id);
                  if (cellIndex != -1) {
                    updatedCells[cellIndex] = CellModel(
                      id: existingCell.id,
                      rowId: existingCell.rowId,
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
                  return RowModel(
                    id: row.id,
                    sheetId: row.sheetId,
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
            _formulaHandler = FormulaHandler(sheet: updatedSheet);
            _dataSource = KahonSheetDataSource(
              sheet: updatedSheet,
              kahonItems: const [],
              isEditable: _isEditable,
              cellSubmitCallback: _handleCellSubmit,
              addCalculationRowCallback: _addCalculationRow,
              deleteRowCallback: _deleteRow,
              formulaHandler: _formulaHandler,
              onCellSelected: _handleCellSelected,
            );

            // Clear the selected cell data
            _selectedCellValue = '';
            _selectedCellColorHex = null;
            _cellValueController.clear();
          });
        } else {
          // If the cell doesn't exist yet, we can just clear the UI state
          _clearSelectedCell();
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
  }

  // Show color picker for selected cell
  void _showColorPickerForSelectedCell() {
    if (_selectedRowIndex != null && _selectedColumnIndex != null) {
      _showColorPicker(_selectedRowIndex!, _selectedColumnIndex!,
          _selectedCellValue ?? '', _selectedCellColorHex);
    }
  }

  // Method to show color picker popup
  void _showColorPicker(
      int rowIndex, int columnIndex, String value, String? currentColorHex) {
    // Use the provided context or the statically stored context
    BuildContext? context = this.context;

    // Store the current cell value to preserve it
    String cellValue = value;

    // Find the current formula if it exists
    String? formula;
    final currentViewSheet = _dataSource.currentSheet; // Use current sheet
    final rowModel = currentViewSheet.rows.firstWhereOrNull(
      (r) => r.rowIndex == rowIndex,
    );
    if (rowModel != null) {
      final cell = rowModel.cells.firstWhereOrNull(
        (c) => c.columnIndex == columnIndex,
      );
      formula = cell?.formula;
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
              itemCount: CellColorHandler.colorPalette.length +
                  1, // +1 for clear option
              itemBuilder: (context, index) {
                // First option is to clear the color
                if (index == 0) {
                  return InkWell(
                    onTap: () {
                      // Pass the original value/formula when clearing color
                      _handleCellSubmit(
                          rowIndex, columnIndex, formula ?? cellValue, null);
                      Navigator.of(context).pop();
                      // Update the selected cell color after clearing
                      setState(() {
                        _selectedCellColorHex = null;
                      });
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

                // Get color from palette (adjust index for the clear option)
                final colorEntry =
                    CellColorHandler.colorPalette.entries.elementAt(index - 1);

                return InkWell(
                  onTap: () {
                    final colorHex =
                        CellColorHandler.getHexFromColor(colorEntry.value);
                    // Pass the original value/formula when setting color
                    _handleCellSubmit(
                        rowIndex, columnIndex, formula ?? cellValue, colorHex);
                    Navigator.of(context).pop();
                    // Update the selected cell color after selecting
                    setState(() {
                      _selectedCellColorHex = colorHex;
                    });
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

  void _toggleEditMode() {
    setState(() {
      _isEditable = !_isEditable;
      _clearSelectedCell(); // Clear selected cell when toggling edit mode
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
            'color': change.color,
          });
          print(
              "Update cell: id=${change.cellId}, value=${change.displayValue}, color=${change.color}");
        } else {
          cellsToCreate.add({
            'rowId': change.rowId,
            'columnIndex': change.columnIndex,
            'value': change.displayValue,
            'formula': change.formula,
            'color': change.color,
          });
          print(
              "Create cell: rowId=${change.rowId}, columnIndex=${change.columnIndex}, value=${change.displayValue}, color=${change.color}");
        }
      }

      // Process updates in bulk if any
      if (cellsToUpdate.isNotEmpty) {
        print("Updating ${cellsToUpdate.length} cells");
        await ref
            .read(sheetNotifierProvider.notifier)
            .updateCells(cellsToUpdate);
      }

      // Process creates in bulk if any
      if (cellsToCreate.isNotEmpty) {
        print("Creating ${cellsToCreate.length} cells");
        await ref
            .read(sheetNotifierProvider.notifier)
            .createCells(cellsToCreate);
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
  void didUpdateWidget(KahonSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sheet != widget.sheet) {
      _formulaHandler = FormulaHandler(sheet: widget.sheet);
      _initializeDataSource();
      _buildFormulaDependencyMap();
    }
  }

  // Update dependent formulas after cell value change - Fixed version
  void _updateDependentFormulas(
      int rowIndex, int columnIndex, SheetModel currentSheet) {
    // Create cell key in format used by dependency map
    String cellKey = '${rowIndex}_${columnIndex}';
    String columnLetter = _getColumnLetter(columnIndex);

    // Also check for column name references (like "Quantity1")
    String namedCellKey = '$columnLetter$rowIndex';

    // Process cells that depend on this cell
    Set<String> dependentCells = {};
    if (_formulaDependencies.containsKey(cellKey)) {
      dependentCells.addAll(_formulaDependencies[cellKey]!);
    }
    if (_formulaDependencies.containsKey(namedCellKey)) {
      dependentCells.addAll(_formulaDependencies[namedCellKey]!);
    }

    if (dependentCells.isEmpty) {
      print("No dependent cells found for $cellKey or $namedCellKey");
      return;
    }

    print(
        'Updating dependent formulas for cell $cellKey ($namedCellKey): $dependentCells');

    // Create a new formula handler with the current sheet
    _formulaHandler = FormulaHandler(sheet: currentSheet);

    // Create a mutable copy of the sheet
    SheetModel updatedSheet = SheetModel(
      id: currentSheet.id,
      name: currentSheet.name,
      columns: currentSheet.columns,
      kahonId: currentSheet.kahonId,
      createdAt: currentSheet.createdAt,
      updatedAt: currentSheet.updatedAt,
      rows: [...currentSheet.rows],
    );

    // Track processed cells to avoid circular references
    Set<String> processedCells = {cellKey, namedCellKey};

    // Process all dependent cells recursively
    _processDependentCells(dependentCells, processedCells, updatedSheet);

    // Update data source with the modified sheet
    setState(() {
      _dataSource = KahonSheetDataSource(
        sheet: updatedSheet,
        kahonItems: const [],
        isEditable: _isEditable,
        cellSubmitCallback: _handleCellSubmit,
        addCalculationRowCallback: _addCalculationRow,
        deleteRowCallback: _deleteRow,
        formulaHandler: _formulaHandler,
        onCellSelected: _handleCellSelected,
      );
    });
  }

  // Process dependent cells recursively with clear debugging
  void _processDependentCells(
      Set<String> cellsToUpdate, Set<String> processedCells, SheetModel sheet) {
    List<String> cellsToProcess = cellsToUpdate.toList();

    for (String cellKey in cellsToProcess) {
      // Skip already processed cells to prevent infinite recursion
      if (processedCells.contains(cellKey)) {
        print("Skipping already processed cell: $cellKey");
        continue;
      }

      print("Processing dependent cell: $cellKey");
      processedCells.add(cellKey);

      // Parse the cell key to get row and column indices
      List<String> parts = cellKey.split('_');
      if (parts.length == 2) {
        int depRowIndex = int.parse(parts[0]);
        int depColumnIndex = int.parse(parts[1]);

        // Find the corresponding row
        var rowModel = sheet.rows.firstWhereOrNull(
          (r) => r.rowIndex == depRowIndex,
        );

        if (rowModel == null) {
          print("Row not found for index: $depRowIndex");
          continue;
        }

        // Find the cell that contains a formula
        var cellModel = rowModel.cells.firstWhereOrNull(
          (c) => c.columnIndex == depColumnIndex,
        );

        if (cellModel == null) {
          print(
              "Cell not found at column: $depColumnIndex in row: $depRowIndex");
          continue;
        }

        if (cellModel.formula == null || !cellModel.formula!.startsWith('=')) {
          print("Cell doesn't contain a formula: $cellKey");
          continue;
        }

        try {
          print(
              "Recalculating formula: ${cellModel.formula} for cell $cellKey");

          // Recalculate formula using updated cell values
          String newValue = _formulaHandler.evaluateFormula(
              cellModel.formula!, depRowIndex, depColumnIndex);

          print("Formula result: $newValue (old value: ${cellModel.value})");

          // Add to pending changes if the value has changed
          if (newValue != cellModel.value) {
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

            print("Added formula update to pending changes: $changeKey");

            // Find the row and cell index in our working sheet
            int rowIdx = sheet.rows.indexWhere((r) => r.id == rowModel.id);
            if (rowIdx >= 0) {
              int cellIdx = sheet.rows[rowIdx].cells
                  .indexWhere((c) => c.id == cellModel.id);

              if (cellIdx >= 0) {
                // Update the cell in our working copy
                sheet.rows[rowIdx].cells[cellIdx] = CellModel(
                  id: cellModel.id,
                  rowId: cellModel.rowId,
                  columnIndex: cellModel.columnIndex,
                  value: newValue,
                  formula: cellModel.formula,
                  color: cellModel.color,
                  isCalculated: true,
                  createdAt: cellModel.createdAt,
                  updatedAt: DateTime.now(),
                );

                print("Updated cell in working copy: $changeKey");
              }
            }

            // Now, we need to find cells that depend on this updated cell
            Set<String> nextLevelDependents = {};

            // Cell keys for dependency lookup
            String updatedCellKey = '${depRowIndex}_${depColumnIndex}';
            String updatedNamedKey =
                '${_getColumnLetter(depColumnIndex)}${depRowIndex}';

            // Find cells that depend on this cell
            if (_formulaDependencies.containsKey(updatedCellKey)) {
              nextLevelDependents.addAll(_formulaDependencies[updatedCellKey]!);
              print(
                  "Found ${_formulaDependencies[updatedCellKey]!.length} dependencies for $updatedCellKey");
            }

            if (_formulaDependencies.containsKey(updatedNamedKey)) {
              nextLevelDependents
                  .addAll(_formulaDependencies[updatedNamedKey]!);
              print(
                  "Found ${_formulaDependencies[updatedNamedKey]!.length} dependencies for $updatedNamedKey");
            }

            // Remove already processed cells to avoid circular references
            nextLevelDependents.removeAll(processedCells);

            // Process next level of dependencies
            if (nextLevelDependents.isNotEmpty) {
              print("Processing next level dependencies: $nextLevelDependents");
              _processDependentCells(
                  nextLevelDependents, processedCells, sheet);
            }
          }
        } catch (e) {
          print("Error recalculating formula: $e");
        }
      }
    }
  }

  // Recalculate all formula cells in the sheet
  void _recalculateAllFormulas(SheetModel currentSheet) {
    print("Starting full formula recalculation...");

    // Create a mutable copy of the sheet
    SheetModel updatedSheet = SheetModel(
      id: currentSheet.id,
      name: currentSheet.name,
      columns: currentSheet.columns,
      kahonId: currentSheet.kahonId,
      createdAt: currentSheet.createdAt,
      updatedAt: currentSheet.updatedAt,
      rows: [...currentSheet.rows],
    );

    // Process all cells with formulas
    int formulasProcessed = 0;
    for (var row in updatedSheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          try {
            String newValue = _formulaHandler.evaluateFormula(
                cell.formula!, row.rowIndex, cell.columnIndex);

            // Only update if value changed
            if (newValue != cell.value) {
              String changeKey = '${row.rowIndex}_${cell.columnIndex}';
              _pendingChanges[changeKey] = CellChange(
                isUpdate: true,
                cellId: cell.id,
                rowId: row.id,
                columnIndex: cell.columnIndex,
                displayValue: newValue,
                formula: cell.formula,
                color: cell.color,
              );

              // Find cell index and update in our working copy
              int rowIdx = updatedSheet.rows.indexWhere((r) => r.id == row.id);
              if (rowIdx >= 0) {
                int cellIdx = updatedSheet.rows[rowIdx].cells
                    .indexWhere((c) => c.id == cell.id);

                if (cellIdx >= 0) {
                  // Update the cell in our working copy
                  updatedSheet.rows[rowIdx].cells[cellIdx] = CellModel(
                    id: cell.id,
                    rowId: cell.rowId,
                    columnIndex: cell.columnIndex,
                    value: newValue,
                    formula: cell.formula,
                    color: cell.color,
                    isCalculated: true,
                    createdAt: cell.createdAt,
                    updatedAt: DateTime.now(),
                  );
                }
              }

              formulasProcessed++;
            }
          } catch (e) {
            print("Error recalculating formula ${cell.formula}: $e");
          }
        }
      }
    }

    print(
        "Formula recalculation complete. Updated $formulasProcessed formulas.");

    if (formulasProcessed > 0) {
      // Update the data source with our recalculated sheet
      setState(() {
        _formulaHandler = FormulaHandler(sheet: updatedSheet);
        _dataSource = KahonSheetDataSource(
          sheet: updatedSheet,
          kahonItems: const [],
          isEditable: _isEditable,
          cellSubmitCallback: _handleCellSubmit,
          addCalculationRowCallback: _addCalculationRow,
          deleteRowCallback: _deleteRow,
          formulaHandler: _formulaHandler,
          onCellSelected: _handleCellSelected,
        );
      });
    }
  }

  // Handle cell submission
  Future<void> _handleCellSubmit(
      int rowIndex, int columnIndex, String value, String? colorHex) async {
    print(
        "_handleCellSubmit called with: rowIndex=$rowIndex, columnIndex=$columnIndex, value=$value, color=$colorHex");

    // Skip submitting empty unchanged values
    if (_selectedRowIndex == rowIndex &&
        _selectedColumnIndex == columnIndex &&
        _selectedCellValue == value &&
        _selectedCellColorHex == colorHex) {
      return; // No changes, don't process
    }

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
      if (existingCell != null && !existingCell.id.startsWith('temp_')) {
        _pendingChanges[changeKey] = CellChange(
          isUpdate: true,
          cellId: existingCell.id,
          rowId: rowModel.id,
          columnIndex: columnIndex,
          displayValue: displayValue,
          formula: formula,
          color: colorHex,
        );
        print("Added update to pending changes: $changeKey");
      } else {
        _pendingChanges[changeKey] = CellChange(
          isUpdate: false,
          rowId: rowModel.id,
          columnIndex: columnIndex,
          displayValue: displayValue,
          formula: formula,
          color: colorHex,
        );
        print("Added create to pending changes: $changeKey");
      }

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
                    color: colorHex, // Set the color
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
                  color: colorHex, // Set the color
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

        // Update the selected cell values to match our changes
        _selectedCellValue = value;
        _selectedCellColorHex = colorHex;
        _cellValueController.text = value;

        // Re-initialize data source with updated sheet
        _dataSource = KahonSheetDataSource(
          sheet: updatedSheet,
          kahonItems: const [],
          isEditable: _isEditable,
          cellSubmitCallback: _handleCellSubmit,
          addCalculationRowCallback: _addCalculationRow,
          deleteRowCallback: _deleteRow,
          formulaHandler: _formulaHandler,
          onCellSelected: _handleCellSelected,
        );

        // Important - rebuild formula dependency map BEFORE updating dependents
        _buildFormulaDependencyMap();

        // If this is a formula cell or it depends on other cells, recalculate all formulas
        // This ensures that complex interdependencies are maintained
        if (value.startsWith('=')) {
          // First update direct dependencies
          _updateDependentFormulas(rowIndex, columnIndex, updatedSheet);

          // Then trigger a complete recalculation to handle complex dependencies
          _recalculateAllFormulas(updatedSheet);
        } else if (existingCell != null && existingCell.value != displayValue) {
          // If just a value changed, update direct dependencies
          _updateDependentFormulas(rowIndex, columnIndex, updatedSheet);
        }
      });
    } catch (e) {
      print('Error handling cell submission: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update cell: ${e.toString()}')),
        );
      }
    }
  }

  // Recalculate all formulas in the sheet
  Future<void> _recalculateFormulas() async {
    try {
      // First get the current sheet state
      SheetModel currentSheet = widget.sheet;

      // If we already have a modified sheet in progress, use that instead
      if (_dataSource.sheet != widget.sheet) {
        currentSheet = _dataSource.sheet;
      }

      // Use our comprehensive formula recalculation
      _recalculateAllFormulas(currentSheet);

      // Apply all pending changes
      if (_pendingChanges.isNotEmpty) {
        List<Map<String, dynamic>> cellsToUpdate = [];

        for (var change in _pendingChanges.values) {
          if (change.isUpdate) {
            cellsToUpdate.add({
              'id': change.cellId,
              'value': change.displayValue,
              'formula': change.formula,
              'color': change.color,
            });
          }
        }

        if (cellsToUpdate.isNotEmpty) {
          print("Saving ${cellsToUpdate.length} recalculated cells");
          await ref
              .read(sheetNotifierProvider.notifier)
              .updateCells(cellsToUpdate);
        }

        _pendingChanges.clear();
      }
    } catch (e) {
      print('Error during formula recalculation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error recalculating formulas: ${e.toString()}')),
        );
      }
    }
  }

  // Add calculation row
  Future<void> _addCalculationRow(int afterRowIdx) async {
    try {
      // First save any pending changes
      if (_pendingChanges.isNotEmpty) {
        await _applyPendingChanges();
      }

      // Add the calculation row
      await ref
          .read(sheetNotifierProvider.notifier)
          .createCalculationRow(widget.sheet.id, afterRowIdx + 1);

      // Ensure we stay in edit mode
      if (!_isEditable) {
        setState(() {
          _isEditable = true;
          _initializeDataSource();
          _buildFormulaDependencyMap();
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

  // Add multiple calculation rows
  Future<void> _addMultipleCalculationRows(int afterRowIndex) async {
    int? numberOfRows = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller =
            TextEditingController(text: '1');
        return AlertDialog(
          title: const Text('Add Calculation Rows'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How many calculation rows do you want to add?'),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Rows',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                int? value = int.tryParse(controller.text);
                if (value != null && value > 0) {
                  Navigator.of(context).pop(value);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid number')),
                  );
                }
              },
            ),
          ],
        );
      },
    );

    if (numberOfRows != null && numberOfRows > 0) {
      try {
        // First save any pending changes
        if (_pendingChanges.isNotEmpty) {
          await _applyPendingChanges();
        }

        // Create a list of row indexes to add
        List<int> rowIndexes = [];
        int currentIndex = afterRowIndex + 1;
        for (int i = 0; i < numberOfRows; i++) {
          rowIndexes.add(currentIndex + i);
        }

        await ref
            .read(sheetNotifierProvider.notifier)
            .createCalculationRows(widget.sheet.id, rowIndexes);

        // Ensure we stay in edit mode
        if (!_isEditable) {
          setState(() {
            _isEditable = true;
            _initializeDataSource();
            _buildFormulaDependencyMap();
          });
        }
      } catch (e) {
        print('Error adding calculation rows: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to add calculation rows: ${e.toString()}')),
          );
        }
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
                  'Add Vertical Cells',
                  Icons.add,
                  () {
                    if (rowIndex >= 2) {
                      // Needs at least two cells above: (row-2) + (row-1)
                      // This formula adds the cell two rows above and one row above.
                      // For sum of all cells above, see 'Add All Cells Above'.
                      final topCellRowIndex =
                          rowIndex - 2; // Cell two rows above
                      final bottomCellRowIndex =
                          rowIndex - 1; // Cell one row above

                      bool topCellExists = currentSheet.rows
                          .any((r) => r.rowIndex == topCellRowIndex);
                      bool bottomCellExists = currentSheet.rows
                          .any((r) => r.rowIndex == bottomCellRowIndex);

                      if (topCellExists && bottomCellExists) {
                        String formula =
                            '=${_getColumnLetter(columnIndex)}${topCellRowIndex} + ${_getColumnLetter(columnIndex)}${bottomCellRowIndex}';
                        _handleCellSubmit(
                            rowIndex, columnIndex, formula, colorHex);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Not enough valid rows above for this operation.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Not enough rows above for this operation.')),
                      );
                    }
                  },
                ),
                _buildFormulaOption(
                  context,
                  'Subtract Vertical Cells',
                  Icons.remove,
                  () {
                    if (rowIndex >= 2) {
                      // Needs at least two cells above: (row-2) - (row-1)
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
                      // Custom columns Quantity (0) and Name (1)
                      // Column C equivalent is index 2
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Select a cell in column C (or its equivalent "A") or higher.')),
                      );
                      Navigator.of(context).pop(); // Close dialog
                      return;
                    }

                    String generateProductFormula(int rIdx, int cIdx) {
                      List<String> terms = [];
                      // Multiply columns from index 2 (e.g., "C" or its custom equivalent "A")
                      // up to the column before the selected one.
                      for (int colToMultiply = 2;
                          colToMultiply < cIdx;
                          colToMultiply++) {
                        terms.add("${_getColumnLetter(colToMultiply)}$rIdx");
                      }
                      if (terms.isEmpty) {
                        return "=1"; // Product of no terms is 1
                      }
                      return "=" + terms.join(" * ");
                    }

                    final mainFormula =
                        generateProductFormula(rowIndex, columnIndex);
                    _handleCellSubmit(
                        rowIndex, columnIndex, mainFormula, colorHex);

                    // Apply to all other rows
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final sortedRows = List<RowModel>.from(currentSheet.rows)
                        ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

                      for (var row in sortedRows) {
                        if (row.rowIndex == rowIndex) continue;

                        final otherFormula =
                            generateProductFormula(row.rowIndex, columnIndex);
                        _handleCellSubmit(
                            row.rowIndex, columnIndex, otherFormula, null);
                      }
                    });

                    Navigator.of(context).pop();
                  },
                ),
                _buildFormulaOption(
                  context,
                  'Add All Cells Above', // Renamed for clarity
                  Icons.add,
                  () {
                    List<String> terms = [];

                    final sortedRows = List<RowModel>.from(currentSheet.rows)
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
                          tooltip: 'Add Calculation Rows',
                          onPressed: () {
                            // Get currently selected row index or default to last row
                            int rowIndex =
                                _dataGridController.selectedIndex != -1
                                    ? _dataGridController.selectedIndex
                                    : widget.sheet.rows.length - 1;

                            // Find the actual row index from the model
                            if (rowIndex >= 0 &&
                                rowIndex < widget.sheet.rows.length) {
                              _addMultipleCalculationRows(
                                  widget.sheet.rows[rowIndex].rowIndex);
                            } else {
                              // Default to adding at the end
                              _addMultipleCalculationRows(
                                  widget.sheet.rows.isNotEmpty
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
                // Add onCellTap callback to track cell selection
                onCellTap: (details) {
                  if (details.rowColumnIndex.rowIndex > 0 && // Skip header
                      details.column.columnName != 'itemName') {
                    // Get the actual data grid row
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

                        CellModel? cell;
                        if (rowModel != null) {
                          cell = rowModel.cells.firstWhereOrNull(
                            (c) => c.columnIndex == columnIndex,
                          );
                        }

                        setState(() {
                          _selectedRowIndex = rowIndex;
                          _selectedColumnIndex = columnIndex;
                          _selectedCellValue = cell?.value ?? '';
                          _selectedCellColorHex = cell?.color;
                          _cellValueController.text = cell?.value ?? '';
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
                    Row(
                      children: [
                        if (_pendingChanges.isNotEmpty)
                          Text(
                            '${_pendingChanges.length} unsaved changes',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        // Show cell manipulation buttons only when a cell is selected
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
                                onPressed: _showQuickFormulasMenu,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Erase button with eraser icon instead of trash
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                label: const Text('Erase Cell Value',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.red)),
                                onPressed: _eraseSelectedCell,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              // Color selector button with label
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.color_lens,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text('Change Color',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onPressed: _showColorPickerForSelectedCell,
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
                  ],
                ),
              ),
          ],
        ),
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
