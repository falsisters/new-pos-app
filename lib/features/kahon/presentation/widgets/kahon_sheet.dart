// ignore_for_file: unused_local_variable

import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_handler_new.dart';
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
  const KahonSheet({super.key, required this.sheet});

  @override
  ConsumerState<KahonSheet> createState() => _KahonSheetState();
}

class _KahonSheetState extends ConsumerState<KahonSheet>
    with TickerProviderStateMixin {
  late KahonSheetDataSource _dataSource;
  final DataGridController _dataGridController = DataGridController();
  bool _isEditable = false;
  bool _isLoading = false;
  late FormulaHandler _formulaHandler;

  // Animation controllers
  late AnimationController _editModeController;
  late AnimationController _scaleController;
  late AnimationController _borderController;

  // Animations
  late Animation<double> _editModeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;

  // State management
  final Map<String, Set<String>> _formulaDependencies = {};
  final Map<String, CellChange> _pendingChanges = {};

  // Cell selection state
  int? _selectedRowIndex;
  int? _selectedColumnIndex;
  String? _selectedCellValue;
  String? _selectedCellColorHex;
  final TextEditingController _cellValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSheet();
  }

  void _initializeAnimations() {
    // Edit mode animation
    _editModeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _editModeAnimation = CurvedAnimation(
      parent: _editModeController,
      curve: Curves.easeInOutCubic,
    );

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Border color animation
    _borderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _borderColorAnimation = ColorTween(
      begin: AppColors.primaryLight.withOpacity(0.2),
      end: AppColors.primary.withOpacity(0.6),
    ).animate(CurvedAnimation(
      parent: _borderController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializeSheet() {
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
          _showModernSnackBar(
            'Failed to erase cell',
            icon: Icons.error,
            color: Colors.red,
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
    // Store the current cell value to preserve it
    String cellValue = value;

    // Find the current formula if it exists
    String? formula;
    final currentViewSheet = _dataSource.currentSheet;
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  AppColors.primary.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.palette_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Select Cell Color',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: CellColorHandler.colorPalette.length + 1,
                    itemBuilder: (context, index) {
                      // First option is to clear the color
                      if (index == 0) {
                        return InkWell(
                          onTap: () {
                            _handleCellSubmit(rowIndex, columnIndex,
                                formula ?? cellValue, null);
                            Navigator.of(context).pop();
                            setState(() {
                              _selectedCellColorHex = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(Icons.format_color_reset_rounded),
                            ),
                          ),
                        );
                      }

                      final colorEntry = CellColorHandler.colorPalette.entries
                          .elementAt(index - 1);

                      return InkWell(
                        onTap: () {
                          final colorHex = CellColorHandler.getHexFromColor(
                              colorEntry.value);
                          _handleCellSubmit(rowIndex, columnIndex,
                              formula ?? cellValue, colorHex);
                          Navigator.of(context).pop();
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildModernControlButton(
                      icon: Icons.close_rounded,
                      label: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleEditMode() {
    HapticFeedback.mediumImpact();

    setState(() {
      _isEditable = !_isEditable;
      _clearSelectedCell();
      _initializeDataSource();

      if (_isEditable) {
        _editModeController.forward();
        _scaleController.forward();
        _borderController.forward();
      } else {
        _editModeController.reverse();
        _scaleController.reverse();
        _borderController.reverse();
      }
    });

    _showModernSnackBar(
      _isEditable ? 'Edit mode enabled' : 'View mode enabled',
      icon: _isEditable ? Icons.edit : Icons.visibility,
      color: AppColors.primary,
    );
  }

  void _saveChanges() async {
    if (_pendingChanges.isEmpty) return;

    setState(() => _isLoading = true);
    HapticFeedback.selectionClick();

    try {
      await _applyPendingChanges();

      _showModernSnackBar(
        'Changes saved successfully!',
        icon: Icons.check_circle,
        color: Colors.green,
      );

      setState(() {
        _isEditable = false;
        _initializeDataSource();
        _editModeController.reverse();
        _scaleController.reverse();
        _borderController.reverse();
      });
    } catch (e) {
      _showModernSnackBar(
        'Failed to save changes',
        icon: Icons.error,
        color: Colors.red,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showModernSnackBar(String message,
      {required IconData icon, required Color color}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 8,
        duration: const Duration(seconds: 3),
      ),
    );
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

  // Update dependent formulas after cell value change
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

  // Helper method to update a cell in the sheet immutably
  SheetModel _updateCellInSheet(SheetModel sheet, String rowId, String cellId,
      String newValue, String? formula, String? color) {
    return sheet.copyWith(
      rows: sheet.rows.map((row) {
        if (row.id == rowId) {
          return row.copyWith(
            cells: row.cells.map((cell) {
              if (cell.id == cellId) {
                return cell.copyWith(
                  value: newValue,
                  formula: formula,
                  color: color,
                  isCalculated: true,
                  updatedAt: DateTime.now(),
                );
              }
              return cell;
            }).toList(),
            updatedAt: DateTime.now(),
          );
        }
        return row;
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }

  // Process dependent cells recursively
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

            // Update the working sheet using the helper method
            sheet = _updateCellInSheet(sheet, rowModel.id, cellModel.id,
                newValue, cellModel.formula, cellModel.color);

            print("Updated cell in working copy: $changeKey");

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
              ); // Create updated sheet with the new cell value
              updatedSheet = _updateCellInSheet(updatedSheet, row.id, cell.id,
                  newValue, cell.formula, cell.color);

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

  // Recalculate formulas
  Future<void> _recalculateFormulas() async {
    // Create a local copy of the pending changes
    final changesSnapshot = Map<String, CellChange>.from(_pendingChanges);

    // Rebuild the formula dependency map
    _buildFormulaDependencyMap();

    // Track recalculated cells to avoid redundant calculations
    final Set<String> recalculatedCells = {};

    // Process each pending change
    for (var change in changesSnapshot.values) {
      if (change.isUpdate) {
        // For updates, directly recalculate the formula if it exists
        final cellKey = '${change.rowId}_${change.columnIndex}';
        final namedCellKey =
            '${_getColumnLetter(change.columnIndex)}${change.rowId}';

        // Skip if already recalculated
        if (recalculatedCells.contains(cellKey) ||
            recalculatedCells.contains(namedCellKey)) {
          continue;
        }

        // Mark as recalculated
        recalculatedCells.add(cellKey);
        recalculatedCells.add(namedCellKey);

        // Find the row and cell to update
        final rowModel = widget.sheet.rows
            .firstWhereOrNull((r) => r.rowIndex == change.rowId);
        if (rowModel != null) {
          final cellModel = rowModel.cells
              .firstWhereOrNull((c) => c.columnIndex == change.columnIndex);
          if (cellModel != null &&
              cellModel.formula != null &&
              cellModel.formula!.startsWith('=')) {
            try {
              // Recalculate the formula
              String newValue = _formulaHandler.evaluateFormula(
                  cellModel.formula!, rowModel.rowIndex, change.columnIndex);

              // Update the pending change if the value has changed
              if (newValue != cellModel.value) {
                String changeKey = '${change.rowId}_${change.columnIndex}';
                _pendingChanges[changeKey] = CellChange(
                  isUpdate: true,
                  cellId: cellModel.id,
                  rowId: rowModel.id,
                  columnIndex: change.columnIndex,
                  displayValue: newValue,
                  formula: cellModel.formula,
                  color: cellModel.color,
                );

                print(
                    "Marked cell for formula update: ${changeKey} with value: ${newValue}");
              }
            } catch (e) {
              print("Error recalculating formula ${cellModel.formula}: $e");
            }
          }
        }
      }
    }

    // After applying all changes, we can safely recalculate all formulas
    print("Recalculating all formulas...");
    _recalculateAllFormulas(widget.sheet);
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

  // Show quick formulas menu
  void _showQuickFormulasMenu() {
    if (_selectedRowIndex == null || _selectedColumnIndex == null) return;

    final currentSheet = _dataSource.currentSheet;
    final rowIndex = _selectedRowIndex!;
    final columnIndex = _selectedColumnIndex!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  AppColors.primary.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.functions_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Quick Formulas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFormulaOption(
                        context,
                        'Add Vertical Cells',
                        Icons.add_rounded,
                        () {
                          if (rowIndex >= 2) {
                            final topCellRowIndex = rowIndex - 2;
                            final bottomCellRowIndex = rowIndex - 1;

                            bool topCellExists = currentSheet.rows
                                .any((r) => r.rowIndex == topCellRowIndex);
                            bool bottomCellExists = currentSheet.rows
                                .any((r) => r.rowIndex == bottomCellRowIndex);

                            if (topCellExists && bottomCellExists) {
                              String formula =
                                  '=${_getColumnLetter(columnIndex)}${topCellRowIndex} + ${_getColumnLetter(columnIndex)}${bottomCellRowIndex}';
                              _handleCellSubmit(rowIndex, columnIndex, formula,
                                  _selectedCellColorHex);
                              Navigator.of(context).pop();
                            } else {
                              _showModernSnackBar(
                                'Not enough valid rows above for this operation',
                                icon: Icons.warning,
                                color: Colors.orange,
                              );
                            }
                          } else {
                            _showModernSnackBar(
                              'Not enough rows above for this operation',
                              icon: Icons.warning,
                              color: Colors.orange,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildFormulaOption(
                        context,
                        'Subtract Vertical Cells',
                        Icons.remove_rounded,
                        () {
                          if (rowIndex >= 2) {
                            final topRowIndex = rowIndex - 2;
                            final bottomRowIndex = rowIndex - 1;

                            bool topRowExists = currentSheet.rows
                                .any((r) => r.rowIndex == topRowIndex);
                            bool bottomRowExists = currentSheet.rows
                                .any((r) => r.rowIndex == bottomRowIndex);

                            if (topRowExists && bottomRowExists) {
                              String formula =
                                  '=${_getColumnLetter(columnIndex)}${topRowIndex} - ${_getColumnLetter(columnIndex)}${bottomRowIndex}';
                              _handleCellSubmit(rowIndex, columnIndex, formula,
                                  _selectedCellColorHex);
                              Navigator.of(context).pop();
                            } else {
                              _showModernSnackBar(
                                'Not enough valid rows above for subtraction',
                                icon: Icons.warning,
                                color: Colors.orange,
                              );
                            }
                          } else {
                            _showModernSnackBar(
                              'Not enough rows above for subtraction',
                              icon: Icons.warning,
                              color: Colors.orange,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildFormulaOption(
                        context,
                        'Apply Multiply to All Rows',
                        Icons.close_rounded,
                        () {
                          if (columnIndex >= 2) {
                            // Get the two columns to the left
                            final firstColumnIndex = columnIndex - 2;
                            final secondColumnIndex = columnIndex - 1;

                            int formulasApplied = 0;

                            // Get all rows sorted by row index
                            final sortedRows = List<RowModel>.from(
                                currentSheet.rows)
                              ..sort(
                                  (a, b) => a.rowIndex.compareTo(b.rowIndex));

                            for (var row in sortedRows) {
                              // Check if cells exist in the two left columns for this row
                              final firstCell = row.cells.firstWhereOrNull(
                                  (c) => c.columnIndex == firstColumnIndex);
                              final secondCell = row.cells.firstWhereOrNull(
                                  (c) => c.columnIndex == secondColumnIndex);

                              // Only apply formula if both cells exist and have values
                              if (firstCell != null &&
                                  secondCell != null &&
                                  firstCell.value != null &&
                                  firstCell.value!.isNotEmpty &&
                                  secondCell.value != null &&
                                  secondCell.value!.isNotEmpty) {
                                try {
                                  // Check if both values are numeric
                                  double.parse(firstCell.value!);
                                  double.parse(secondCell.value!);

                                  // Create multiplication formula
                                  String formula =
                                      '=${_getColumnLetter(firstColumnIndex)}${row.rowIndex} * ${_getColumnLetter(secondColumnIndex)}${row.rowIndex}';

                                  // Apply the formula to this row in the selected column
                                  _handleCellSubmit(row.rowIndex, columnIndex,
                                      formula, _selectedCellColorHex);
                                  formulasApplied++;
                                } catch (_) {
                                  // Skip rows with non-numeric values
                                }
                              }
                            }

                            Navigator.of(context).pop();

                            if (formulasApplied > 0) {
                              _showModernSnackBar(
                                'Applied multiplication formula to $formulasApplied rows',
                                icon: Icons.check_circle,
                                color: Colors.green,
                              );
                            } else {
                              _showModernSnackBar(
                                'No valid numeric cells found in the two columns to the left',
                                icon: Icons.warning,
                                color: Colors.orange,
                              );
                            }
                          } else {
                            _showModernSnackBar(
                              'Need at least 2 columns to the left for multiplication',
                              icon: Icons.warning,
                              color: Colors.orange,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildFormulaOption(
                        context,
                        'Sum All Cells Above',
                        Icons.functions_rounded,
                        () {
                          List<String> terms = [];
                          final sortedRows = List<RowModel>.from(
                              currentSheet.rows)
                            ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

                          for (var rowIter in sortedRows) {
                            if (rowIter.rowIndex < rowIndex) {
                              final cellInColumn = rowIter.cells
                                  .firstWhereOrNull(
                                      (c) => c.columnIndex == columnIndex);

                              if (cellInColumn != null &&
                                  cellInColumn.value != null &&
                                  cellInColumn.value!.isNotEmpty) {
                                try {
                                  double.parse(cellInColumn.value!);
                                  terms.add(
                                      '${_getColumnLetter(columnIndex)}${rowIter.rowIndex}');
                                } catch (_) {
                                  // Skip non-numeric cells
                                }
                              }
                            }
                          }

                          if (terms.isNotEmpty) {
                            String formula = '=' + terms.join(' + ');
                            _handleCellSubmit(rowIndex, columnIndex, formula,
                                _selectedCellColorHex);
                            Navigator.of(context).pop();
                          } else {
                            _showModernSnackBar(
                              'No numeric cells found above this cell',
                              icon: Icons.warning,
                              color: Colors.orange,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildModernControlButton(
                      icon: Icons.close_rounded,
                      label: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormulaOption(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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

  // Handle cell tap for selection
  void _handleCellTap(DataGridCellTapDetails details) {
    if (details.rowColumnIndex.rowIndex > 0 && // Skip header
        details.column.columnName != 'itemName') {
      // Get the actual data grid row
      final rowData = _dataSource.rows.isNotEmpty &&
              details.rowColumnIndex.rowIndex - 1 < _dataSource.rows.length
          ? _dataSource.rows[details.rowColumnIndex.rowIndex - 1]
          : null;

      if (rowData != null) {
        // Extract row cell data from the first column
        final firstCell = rowData.getCells().first;
        if (firstCell.value is RowCellData) {
          final rowCellData = firstCell.value as RowCellData;
          final rowIndex = rowCellData.rowIndex;
          final columnIndex =
              int.parse(details.column.columnName.replaceAll('column', ''));

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
  }

  // Handle cell double tap for edit mode activation
  void _handleCellDoubleTap(DataGridCellDoubleTapDetails details) {
    if (!_isEditable) {
      _toggleEditMode();
    }
  }

  // Handle adding calculation rows
  void _handleAddCalculationRows() {
    // Get currently selected row index or default to last row
    int rowIndex = _dataGridController.selectedIndex != -1
        ? _dataGridController.selectedIndex
        : widget.sheet.rows.length - 1;

    // Find the actual row index from the model
    if (rowIndex >= 0 && rowIndex < widget.sheet.rows.length) {
      _addMultipleCalculationRows(widget.sheet.rows[rowIndex].rowIndex);
    } else {
      // Default to adding at the end
      _addMultipleCalculationRows(
          widget.sheet.rows.isNotEmpty ? widget.sheet.rows.last.rowIndex : 0);
    }
  }

  // Handle deleting selected row
  void _handleDeleteSelectedRow() {
    // Get currently selected row
    if (_dataGridController.selectedIndex != -1) {
      int selectedIndex = _dataGridController.selectedIndex;
      if (selectedIndex >= 0 && selectedIndex < widget.sheet.rows.length) {
        // Confirm before deleting
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 24),
                  const SizedBox(width: 8),
                  const Text('Confirm Delete'),
                ],
              ),
              content: const Text(
                'Are you sure you want to delete this row? This action cannot be undone.',
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.red.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    child: const Text('Delete',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      _deleteRow(widget.sheet.rows[selectedIndex].id);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text('Please select a row to delete'),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  // Build columns for the data grid
  List<GridColumn> _buildColumns() {
    final columns = <GridColumn>[
      GridColumn(
        columnName: 'itemName',
        label: _buildColumnHeader('Row Number'),
        width: 150,
      ),
    ];

    for (int i = 0; i < widget.sheet.columns; i++) {
      columns.add(
        GridColumn(
          columnName: 'column$i',
          width: 150,
          label: _buildColumnHeader(_getColumnLetter(i)),
        ),
      );
    }
    return columns;
  }

  Widget _buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 13,
          ),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _borderColorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _borderColorAnimation.value ??
                    AppColors.primaryLight.withValues(alpha: 0.2),
                width: _isEditable ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  spreadRadius: 0,
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                if (_isEditable)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    spreadRadius: 0,
                    blurRadius: 32,
                    offset: const Offset(0, 0),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernHeader(),
                _buildDivider(),
                Expanded(child: _buildDataGrid()),
                AnimatedBuilder(
                  animation: _editModeAnimation,
                  builder: (context, child) {
                    return SizeTransition(
                      sizeFactor: _editModeAnimation,
                      child: _buildModernEditControls(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.03),
            Colors.white.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.table_chart_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.sheet.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (!_isEditable)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.secondary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 14,
                          color: AppColors.secondary.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Double-tap to edit',
                          style: TextStyle(
                            color: AppColors.secondary.withOpacity(0.8),
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
          const SizedBox(width: 16),
          _buildModernActionButtons(),
        ],
      ),
    );
  }

  Widget _buildModernActionButtons() {
    return Row(
      children: [
        _buildModernActionButton(
          icon: Icons.refresh_rounded,
          tooltip: 'Refresh Data',
          onPressed: () {
            HapticFeedback.lightImpact();
            ref.read(sheetNotifierProvider.notifier).getSheetByDate(null, null);
          },
        ),
        const SizedBox(width: 8),
        _buildModernActionButton(
          icon: _isEditable ? Icons.visibility_rounded : Icons.edit_rounded,
          tooltip: _isEditable ? 'View Mode' : 'Edit Mode',
          onPressed: _toggleEditMode,
          isActive: _isEditable,
          gradient: _isEditable
              ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
              : null,
        ),
        if (_isEditable) ...[
          const SizedBox(width: 8),
          _buildModernActionButton(
            icon: Icons.add_circle_outline_rounded,
            tooltip: 'Add Calculation Rows',
            onPressed: () {
              HapticFeedback.lightImpact();
              _handleAddCalculationRows();
            },
          ),
          const SizedBox(width: 8),
          _buildModernActionButton(
            icon: Icons.help_outline_rounded,
            tooltip: 'Formula Help',
            onPressed: () {
              HapticFeedback.lightImpact();
              _showModernFormulaHelpDialog();
            },
          ),
          const SizedBox(width: 8),
          _buildModernActionButton(
            icon: Icons.delete_outline_rounded,
            tooltip: 'Delete Selected Row',
            onPressed: () {
              HapticFeedback.lightImpact();
              _handleDeleteSelectedRow();
            },
            gradient: [Colors.red.withOpacity(0.8), Colors.red],
          ),
        ],
      ],
    );
  }

  Widget _buildModernActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isActive = false,
    List<Color>? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient != null
            ? LinearGradient(colors: gradient)
            : LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gradient != null
              ? Colors.transparent
              : AppColors.primaryLight.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (gradient?.first ?? Colors.black).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: gradient != null ? Colors.white : AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primaryLight.withOpacity(0.3),
            AppColors.primaryLight.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildDataGrid() {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
          onCellDoubleTap: _handleCellDoubleTap,
          headerRowHeight: 56,
          rowHeight: 48,
        ),
      ),
    );
  }

  Widget _buildModernEditControls() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primary.withOpacity(0.02),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.primaryLight.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPendingChangesIndicator(),
              _buildModernControlButtons(),
            ],
          ),
          if (_selectedRowIndex != null && _selectedColumnIndex != null) ...[
            const SizedBox(height: 16),
            _buildSelectedCellInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildPendingChangesIndicator() {
    if (_pendingChanges.isEmpty) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.pending_actions_rounded,
              size: 16,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${_pendingChanges.length} unsaved change${_pendingChanges.length == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernControlButtons() {
    return Row(
      children: [
        if (_selectedRowIndex != null && _selectedColumnIndex != null) ...[
          _buildModernControlButton(
            icon: Icons.functions_rounded,
            label: 'Formulas',
            onPressed: _showQuickFormulasMenu,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          _buildModernControlButton(
            icon: Icons.clear_rounded,
            label: 'Clear',
            onPressed: _eraseSelectedCell,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          _buildModernControlButton(
            icon: Icons.palette_rounded,
            label: 'Color',
            onPressed: _showColorPickerForSelectedCell,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 20),
        ],
        _buildModernControlButton(
          icon: _isLoading ? Icons.hourglass_empty : Icons.save_rounded,
          label: _isLoading ? 'Saving...' : 'Save Changes',
          onPressed: _isLoading ? null : _saveChanges,
          color: AppColors.primary,
          isPrimary: true,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildModernControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
    bool isPrimary = false,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary && onPressed != null
            ? LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPrimary
            ? null
            : (onPressed != null
                ? color.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: onPressed != null
              ? (isPrimary ? Colors.transparent : color.withOpacity(0.3))
              : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: isPrimary && onPressed != null
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPrimary ? Colors.white : color,
                      ),
                    ),
                  )
                else
                  Icon(
                    icon,
                    size: 16,
                    color: onPressed != null
                        ? (isPrimary ? Colors.white : color)
                        : Colors.grey,
                  ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: onPressed != null
                        ? (isPrimary ? Colors.white : color)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCellInfo() {
    if (_selectedRowIndex == null || _selectedColumnIndex == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.edit_location_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Cell: ${_getColumnLetter(_selectedColumnIndex!)}${_selectedRowIndex!}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                if (_selectedCellValue?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Value: $_selectedCellValue',
                    style: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showModernFormulaHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  AppColors.primary.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.help_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Formula Help',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Cell References:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('• A3 - References cell in column A, row 3'),
                      Text(
                          '• Quantity5 - References cell in Quantity column, row 5'),
                      Text('• Name2 - References cell in Name column, row 2'),
                      SizedBox(height: 16),
                      Text('Range Functions:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('• SUM(A1:A10) - Adds values from A1 to A10'),
                      Text('• AVG(A1:A10) - Averages values from A1 to A10'),
                      Text(
                          '• COUNT(A1:A10) - Counts non-empty cells from A1 to A10'),
                      Text(
                          '• MAX(A1:A10) - Finds maximum value from A1 to A10'),
                      Text(
                          '• MIN(A1:A10) - Finds minimum value from A1 to A10'),
                      SizedBox(height: 16),
                      Text('Arithmetic Operations:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('• A1 + B1 - Addition'),
                      Text('• A1 - B1 - Subtraction'),
                      Text('• A1 * B1 - Multiplication'),
                      Text('• A1 / B1 - Division'),
                      Text('• A1 ^ 2 - Exponentiation'),
                      SizedBox(height: 16),
                      Text('Example:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('=SUM(Quantity1:Quantity5) + A6 * 2'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildModernControlButton(
                      icon: Icons.close_rounded,
                      label: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _editModeController.dispose();
    _scaleController.dispose();
    _borderController.dispose();
    _cellValueController.dispose();
    super.dispose();
  }
}
