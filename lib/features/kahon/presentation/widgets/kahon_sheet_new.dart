import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/providers/sheet_provider.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_state.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_formula_manager.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_data_manager.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_ui_builder.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_data_source.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/row_cell_data.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';

// Define RowReorderOperation class
class RowReorderOperation {
  final String sheetId;
  final List<Map<String, dynamic>> rowMappings;
  final List<Map<String, dynamic>> formulaUpdates;

  RowReorderOperation({
    required this.sheetId,
    required this.rowMappings,
    required this.formulaUpdates,
  });
}

class KahonSheetNew extends ConsumerStatefulWidget {
  final SheetModel sheet;
  const KahonSheetNew({super.key, required this.sheet});

  @override
  ConsumerState<KahonSheetNew> createState() => _KahonSheetNewState();
}

class _KahonSheetNewState extends ConsumerState<KahonSheetNew>
    with TickerProviderStateMixin {
  // Core components
  late KahonSheetState _state;
  late KahonSheetFormulaManager _formulaManager;
  late KahonSheetDataManager _dataManager;
  late KahonSheetUIBuilder _uiBuilder;
  late KahonSheetDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _initializeSheet();
  }

  void _initializeComponents() {
    _state = KahonSheetState();
    _formulaManager = KahonSheetFormulaManager(sheet: widget.sheet);
    _dataManager = KahonSheetDataManager(ref: ref, sheet: widget.sheet);

    _uiBuilder = KahonSheetUIBuilder(
      context: context,
      onRefresh: _handleRefresh,
      onToggleEditMode: _toggleEditMode,
      onAddCalculationRows: _handleAddCalculationRows,
      onShowFormulaHelp: _showModernFormulaHelpDialog,
      onDeleteSelectedRow: _handleDeleteSelectedRow,
      onSaveChanges: _saveChanges,
      onShowQuickFormulas: _showQuickFormulasMenu,
      onEraseSelectedCell: _eraseSelectedCell,
      onShowColorPicker: _showColorPickerForSelectedCell,
      onCellTap: _handleCellTap,
      onCellDoubleTap: _handleCellDoubleTap,
    );

    _state.initializeAnimations(this);
  }

  void _initializeSheet() {
    _initializeDataSource();
    _buildFormulaDependencyMap();
    _recalculateAllFormulasOnLoad();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    KahonSheetDataSource.currentContext = context;
  }

  @override
  void didUpdateWidget(KahonSheetNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sheet != widget.sheet) {
      print("KahonSheet didUpdateWidget: Sheet has changed. Re-initializing.");
      _formulaManager.updateSheet(widget.sheet);
      _dataManager.updateSheet(widget.sheet);
      _initializeDataSource();
      _buildFormulaDependencyMap();
      _recalculateAllFormulasOnLoad();
    }
  }

  // Core initialization methods
  void _buildFormulaDependencyMap() {
    final dependencies = _formulaManager.buildFormulaDependencyMap();
    _state.clearFormulaDependencies();
    dependencies.forEach((key, value) {
      value.forEach((cellKey) => _state.addFormulaDependency(key, cellKey));
    });
  }

  void _recalculateAllFormulasOnLoad() {
    final result = _formulaManager.recalculateAllFormulasOnLoad();

    if (result.pendingChanges.isNotEmpty) {
      result.pendingChanges.forEach((key, change) {
        _state.addPendingChange(key, change);
      });

      if (mounted) {
        setState(() {
          _dataManager.updateSheet(result.updatedSheet);
          _formulaManager.updateSheet(result.updatedSheet);
          _initializeDataSource();
        });
      }
    }
  }

  void _initializeDataSource() {
    _dataSource = KahonSheetDataSource(
      sheet: _dataManager.currentSheet,
      kahonItems: const [],
      isEditable: _state.isEditable,
      cellSubmitCallback: _handleCellSubmit,
      addCalculationRowCallback: _addCalculationRow,
      deleteRowCallback: _deleteRow,
      formulaHandler: _formulaManager.formulaHandler,
      onCellSelected: _handleCellSelected,
      onRowReorder: _state.isEditable ? _handleRowReorder : null,
    );
    KahonSheetDataSource.currentContext = context;
  }

  // Event handlers
  void _handleRefresh() {
    ref.read(sheetNotifierProvider.notifier).getSheetByDate(null, null);
  }

  void _toggleEditMode() {
    HapticFeedback.mediumImpact();

    if (_state.isEditable && _state.hasPendingChanges) {
      _saveChanges();
      return;
    }

    setState(() {
      _state.setEditable(!_state.isEditable);
      _state.clearSelectedCell();
      _initializeDataSource();

      if (_state.isEditable) {
        _state.startEditModeAnimations();
      } else {
        _state.stopEditModeAnimations();
      }
    });

    _uiBuilder.showModernSnackBar(
      message: _state.isEditable ? 'Edit mode enabled' : 'View mode enabled',
      icon: _state.isEditable ? Icons.edit : Icons.visibility,
      color: AppColors.primary,
    );
  }

  Future<void> _saveChanges() async {
    if (!_state.hasPendingChanges) {
      _uiBuilder.showModernSnackBar(
        message: 'No changes to save.',
        icon: Icons.info_outline,
        color: AppColors.secondary,
      );
      return;
    }

    if (mounted) {
      setState(() => _state.setLoading(true));
    }
    HapticFeedback.selectionClick();

    try {
      // Apply row reorder operations first
      bool rowReorderSuccess = await _dataManager
          .applyRowReorderOperations(_state.pendingRowReorderOperations);
      if (!rowReorderSuccess) {
        throw Exception("Failed to save row reorder operations.");
      }

      // Apply cell changes
      bool cellChangesSuccess =
          await _dataManager.applyPendingChanges(_state.pendingChanges);
      if (!cellChangesSuccess) {
        throw Exception("Failed to save cell changes.");
      }

      if (mounted) {
        _uiBuilder.showModernSnackBar(
          message: 'Changes saved successfully!',
          icon: Icons.check_circle,
          color: Colors.green,
        );

        setState(() {
          _state.clearPendingChanges();
          _state.setEditable(false);
          _state.stopEditModeAnimations();
        });
      }
    } catch (e) {
      if (mounted) {
        _uiBuilder.showModernSnackBar(
          message: 'Failed to save changes: ${e.toString()}',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _state.setLoading(false));
      }
    }
  }

  // Cell handling methods
  void _handleCellSelected(
      int rowIndex, int columnIndex, String? value, String? colorHex) {
    setState(() {
      _state.setSelectedCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        value: value,
        colorHex: colorHex,
      );
    });
  }

  Future<void> _handleCellSubmit(
      int rowIndex, int columnIndex, String value, String? colorHex,
      {bool isCalculatedResult = false}) async {
    print(
        "_handleCellSubmit called with: rowIndex=$rowIndex, columnIndex=$columnIndex, value=$value, color=$colorHex, isCalculated=$isCalculatedResult");

    // Skip submitting empty unchanged values
    if (_state.selectedRowIndex == rowIndex &&
        _state.selectedColumnIndex == columnIndex &&
        _state.selectedCellValue == value &&
        _state.selectedCellColorHex == colorHex) {
      return;
    }

    try {
      final result = _dataManager.handleCellSubmit(
        rowIndex,
        columnIndex,
        value,
        colorHex,
        _state.selectedCellValue,
        _state.selectedCellColorHex,
        isCalculatedResult: isCalculatedResult,
      );

      if (result.pendingChange != null) {
        String changeKey = '${rowIndex}_${columnIndex}';
        _state.addPendingChange(changeKey, result.pendingChange!);
      }

      // Update UI immediately
      setState(() {
        _dataManager.updateSheet(result.updatedSheet);
        _formulaManager.updateSheet(result.updatedSheet);
        _state.setSelectedCell(
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            value: value,
            colorHex: colorHex);
        _initializeDataSource();
        _buildFormulaDependencyMap();

        // Update dependent formulas if needed (but not for calculated results from quick formulas)
        if (value.startsWith('=') ||
            (result.pendingChange != null && !isCalculatedResult)) {
          _updateDependentFormulas(rowIndex, columnIndex);
        }
      });
    } catch (e) {
      print('Error handling cell submission: $e');
      if (mounted) {
        _uiBuilder.showModernSnackBar(
          message: 'Failed to update cell: ${e.toString()}',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    }
  }

  void _updateDependentFormulas(int rowIndex, int columnIndex) {
    final result = _formulaManager.updateDependentFormulas(
      rowIndex,
      columnIndex,
      _dataManager.currentSheet,
      _state.formulaDependencies,
    );

    if (result.newPendingChanges.isNotEmpty) {
      result.newPendingChanges.forEach((key, change) {
        _state.addPendingChange(key, change);
      });

      setState(() {
        _dataManager.updateSheet(result.updatedSheet);
        _formulaManager.updateSheet(result.updatedSheet);
        _initializeDataSource();
      });
    }
  }

  void _eraseSelectedCell() {
    if (_state.selectedRowIndex != null && _state.selectedColumnIndex != null) {
      _handleCellSubmit(
          _state.selectedRowIndex!, _state.selectedColumnIndex!, '', null);
    }
  }

  void _showColorPickerForSelectedCell() {
    if (_state.selectedRowIndex != null && _state.selectedColumnIndex != null) {
      // Find current formula if it exists
      String? formula;
      final currentSheet = _dataManager.currentSheet;
      final rowModel = currentSheet.rows
          .firstWhereOrNull((r) => r.rowIndex == _state.selectedRowIndex);
      if (rowModel != null) {
        final cell = rowModel.cells.firstWhereOrNull(
            (c) => c.columnIndex == _state.selectedColumnIndex);
        formula = cell?.formula;
      }

      _uiBuilder.showColorPicker(
        rowIndex: _state.selectedRowIndex!,
        columnIndex: _state.selectedColumnIndex!,
        value: _state.selectedCellValue ?? '',
        currentColorHex: _state.selectedCellColorHex,
        onColorSelected: (rowIndex, columnIndex, value, colorHex) {
          _handleCellSubmit(rowIndex, columnIndex, formula ?? value, colorHex);
          setState(() {
            _state.setSelectedCell(colorHex: colorHex);
          });
        },
      );
    }
  }

  // Row handling methods
  Future<void> _handleRowReorder(
      String movedRowId, int oldDisplayIndex, int newDisplayIndex) async {
    print(
        "Handling row reorder: $movedRowId from $oldDisplayIndex to $newDisplayIndex");
    HapticFeedback.mediumImpact();

    final operation = await _dataManager.handleRowReorder(
        movedRowId, oldDisplayIndex, newDisplayIndex);

    if (operation != null) {
      setState(() {
        _state.addPendingRowReorderOperation(operation);
        _formulaManager.updateSheet(_dataManager.currentSheet);
        _initializeDataSource();
        _buildFormulaDependencyMap();
      });

      _uiBuilder.showModernSnackBar(
        message: 'Row reorder queued. Save changes to apply.',
        icon: Icons.pending_actions_rounded,
        color: Colors.orange,
      );
    }
  }

  Future<void> _addCalculationRow(int afterRowIdx) async {
    try {
      if (_state.hasPendingChanges) {
        _saveChanges();
      }

      bool success = await _dataManager.addCalculationRow(afterRowIdx);

      if (success && !_state.isEditable) {
        setState(() {
          _state.setEditable(true);
          _initializeDataSource();
          _buildFormulaDependencyMap();
        });
      }
    } catch (e) {
      print('Error adding calculation row: $e');
      if (mounted) {
        _uiBuilder.showModernSnackBar(
          message: 'Failed to add calculation row: ${e.toString()}',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    }
  }

  Future<void> _deleteRow(String rowId) async {
    try {
      await _dataManager.deleteRow(rowId);
    } catch (e) {
      print('Error deleting row: $e');
      if (mounted) {
        _uiBuilder.showModernSnackBar(
          message: 'Failed to delete row: ${e.toString()}',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    }
  }

  void _handleAddCalculationRows() {
    int rowIndex = _state.dataGridController.selectedIndex != -1
        ? _state.dataGridController.selectedIndex
        : widget.sheet.rows.length - 1;

    if (rowIndex >= 0 && rowIndex < widget.sheet.rows.length) {
      _addMultipleCalculationRows(widget.sheet.rows[rowIndex].rowIndex);
    } else {
      _addMultipleCalculationRows(
          widget.sheet.rows.isNotEmpty ? widget.sheet.rows.last.rowIndex : 0);
    }
  }

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
                decoration: const InputDecoration(labelText: 'Number of Rows'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  _uiBuilder.showModernSnackBar(
                    message: 'Please enter a valid number',
                    icon: Icons.error,
                    color: Colors.red,
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
        if (_state.hasPendingChanges) {
          _saveChanges();
        }

        List<int> rowIndexes = [];
        int currentIndex = afterRowIndex + 1;
        for (int i = 0; i < numberOfRows; i++) {
          rowIndexes.add(currentIndex + i);
        }

        bool success =
            await _dataManager.addMultipleCalculationRows(rowIndexes);

        if (success && !_state.isEditable) {
          setState(() {
            _state.setEditable(true);
            _initializeDataSource();
            _buildFormulaDependencyMap();
          });
        }
      } catch (e) {
        print('Error adding calculation rows: $e');
        if (mounted) {
          _uiBuilder.showModernSnackBar(
            message: 'Failed to add calculation rows: ${e.toString()}',
            icon: Icons.error,
            color: Colors.red,
          );
        }
      }
    }
  }

  void _handleDeleteSelectedRow() {
    if (_state.dataGridController.selectedIndex != -1) {
      int selectedIndex = _state.dataGridController.selectedIndex;
      if (selectedIndex >= 0 && selectedIndex < widget.sheet.rows.length) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
      _uiBuilder.showModernSnackBar(
        message: 'Please select a row to delete',
        icon: Icons.info_outline,
        color: AppColors.primary,
      );
    }
  }

  // UI event handlers
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

          final rowModel =
              widget.sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
          CellModel? cell;
          if (rowModel != null) {
            cell = rowModel.cells
                .firstWhereOrNull((c) => c.columnIndex == columnIndex);
          }

          setState(() {
            _state.setSelectedCell(
              rowIndex: rowIndex,
              columnIndex: columnIndex,
              value: cell?.value ?? '',
              colorHex: cell?.color,
            );
          });
        }
      }
    }
  }

  void _handleCellDoubleTap(DataGridCellDoubleTapDetails details) {
    if (!_state.isEditable) {
      _toggleEditMode();
    }
  }

  void _showQuickFormulasMenu() {
    if (_state.selectedRowIndex == null || _state.selectedColumnIndex == null)
      return;

    final currentSheet = _dataSource.currentSheet;
    final rowIndex = _state.selectedRowIndex!;
    final columnIndex = _state.selectedColumnIndex!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Colors.white, AppColors.primary.withOpacity(0.02)],
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
                      child: const Icon(Icons.functions_rounded,
                          color: Colors.white, size: 20),
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
                          String formula =
                              _formulaManager.generateAddVerticalFormula(
                                  rowIndex, columnIndex);
                          if (formula.isNotEmpty) {
                            String result =
                                _formulaManager.evaluateQuickFormula(
                                    formula, rowIndex, columnIndex);
                            if (result.isNotEmpty &&
                                !result.startsWith('#ERROR')) {
                              // Submit the result but mark it as a calculated result with the formula
                              _handleCellSubmitWithFormula(
                                  rowIndex,
                                  columnIndex,
                                  result,
                                  formula,
                                  _state.selectedCellColorHex);
                              Navigator.of(context).pop();
                            } else {
                              _uiBuilder.showModernSnackBar(
                                message:
                                    'Unable to calculate result for this operation',
                                icon: Icons.warning,
                                color: Colors.orange,
                              );
                            }
                          } else {
                            _uiBuilder.showModernSnackBar(
                              message:
                                  'Not enough valid rows above for this operation',
                              icon: Icons.warning,
                              color: Colors.orange,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildFormulaOption(
                        context,
                        'Add All Vertical Cells',
                        Icons.add_circle_outline_rounded,
                        () {
                          String formula =
                              _formulaManager.generateSumAllAboveFormula(
                                  rowIndex, columnIndex);
                          if (formula.isNotEmpty) {
                            String result =
                                _formulaManager.evaluateQuickFormula(
                                    formula, rowIndex, columnIndex);
                            if (result.isNotEmpty &&
                                !result.startsWith('#ERROR')) {
                              // Submit the result but mark it as a calculated result with the formula
                              _handleCellSubmitWithFormula(
                                  rowIndex,
                                  columnIndex,
                                  result,
                                  formula,
                                  _state.selectedCellColorHex);
                              Navigator.of(context).pop();
                            } else {
                              _uiBuilder.showModernSnackBar(
                                message:
                                    'Unable to calculate sum of cells above',
                                icon: Icons.warning,
                                color: Colors.orange,
                              );
                            }
                          } else {
                            _uiBuilder.showModernSnackBar(
                              message: 'No rows above to sum',
                              icon: Icons.warning,
                              color: Colors.orange,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildFormulaOption(
                        context,
                        'Subtract Vertical Cells',
                        Icons.remove_rounded,
                        () {
                          String formula =
                              _formulaManager.generateSubtractVerticalFormula(
                                  rowIndex, columnIndex);
                          if (formula.isNotEmpty) {
                            String result =
                                _formulaManager.evaluateQuickFormula(
                                    formula, rowIndex, columnIndex);
                            if (result.isNotEmpty &&
                                !result.startsWith('#ERROR')) {
                              // Submit the result but mark it as a calculated result with the formula
                              _handleCellSubmitWithFormula(
                                  rowIndex,
                                  columnIndex,
                                  result,
                                  formula,
                                  _state.selectedCellColorHex);
                              Navigator.of(context).pop();
                            } else {
                              _uiBuilder.showModernSnackBar(
                                message:
                                    'Unable to calculate result for this operation',
                                icon: Icons.warning,
                                color: Colors.orange,
                              );
                            }
                          } else {
                            _uiBuilder.showModernSnackBar(
                              message:
                                  'Not enough valid rows above for this operation',
                              icon: Icons.warning,
                              color: Colors.orange,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildFormulaOption(
                        context,
                        'Apply Multiply to All Rows',
                        Icons.close_rounded,
                        () async {
                          if (columnIndex >= 2) {
                            // Validate that we have at least one row with valid values in both required columns
                            int validRowsCount = 0;
                            for (var row in currentSheet.rows) {
                              if (_isMultiplyValidForRow(row, columnIndex)) {
                                validRowsCount++;
                              }
                            }

                            if (validRowsCount == 0) {
                              _uiBuilder.showModernSnackBar(
                                message:
                                    'No rows found with valid numeric values in both ${_getColumnLetter(columnIndex - 2)} and ${_getColumnLetter(columnIndex - 1)} columns',
                                icon: Icons.warning,
                                color: Colors.orange,
                              );
                              return;
                            }

                            // Show confirmation dialog
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded,
                                          color: Colors.orange, size: 24),
                                      const SizedBox(width: 8),
                                      const Text('Confirm Bulk Operation'),
                                    ],
                                  ),
                                  content: Text(
                                    'This will calculate and insert the result of (${_getColumnLetter(columnIndex - 2)} * ${_getColumnLetter(columnIndex - 1)}) for $validRowsCount rows with valid values. Continue?',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primary.withOpacity(0.8)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        child: const Text('Apply',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              Navigator.of(context)
                                  .pop(); // Close the formula menu first

                              int appliedCount = 0;

                              // Apply calculation to all valid rows
                              for (var row in currentSheet.rows) {
                                if (_isMultiplyValidForRow(row, columnIndex)) {
                                  String formula =
                                      _formulaManager.generateMultiplyFormula(
                                          row.rowIndex, columnIndex);
                                  if (formula.isNotEmpty) {
                                    String result =
                                        _formulaManager.evaluateQuickFormula(
                                            formula, row.rowIndex, columnIndex);
                                    if (result.isNotEmpty &&
                                        !result.startsWith('#ERROR')) {
                                      // Submit the result but mark it as a calculated result with the formula
                                      await _handleCellSubmitWithFormula(
                                          row.rowIndex,
                                          columnIndex,
                                          result,
                                          formula,
                                          null);
                                      appliedCount++;
                                    }
                                  }
                                }
                              }

                              _uiBuilder.showModernSnackBar(
                                message:
                                    'Applied calculation to $appliedCount rows',
                                icon: Icons.check_circle,
                                color: Colors.green,
                              );
                            }
                          } else {
                            _uiBuilder.showModernSnackBar(
                              message:
                                  'Need at least 2 columns to the left for multiplication',
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

  // Helper method to handle cell submission with both result and formula
  Future<void> _handleCellSubmitWithFormula(int rowIndex, int columnIndex,
      String result, String formula, String? colorHex) async {
    print(
        "_handleCellSubmitWithFormula called with: rowIndex=$rowIndex, columnIndex=$columnIndex, result=$result, formula=$formula, color=$colorHex");

    try {
      final rowModel = _dataManager.currentSheet.rows.firstWhere(
        (r) => r.rowIndex == rowIndex,
        orElse: () => throw Exception('Row not found'),
      );

      final existingCell = rowModel.cells.firstWhereOrNull(
        (c) => c.columnIndex == columnIndex,
      );

      // Create a special handling for formula + result combination
      final pendingChange = CellChange(
        isUpdate: existingCell != null && !existingCell.id.startsWith('temp_'),
        cellId: existingCell?.id,
        rowId: rowModel.id,
        columnIndex: columnIndex,
        displayValue: result, // Display the calculated result
        formula: formula, // But save the formula
        color: colorHex,
        isCalculated: true, // Mark as calculated
      );

      String changeKey = '${rowIndex}_${columnIndex}';
      _state.addPendingChange(changeKey, pendingChange);

      // Update the sheet with the result but keep the formula
      final updatedSheet = _dataManager.createUpdatedSheetWithCell(
        _dataManager.currentSheet,
        rowModel,
        existingCell,
        columnIndex,
        result, // Show result in UI
        formula, // But keep formula for future calculations
        colorHex,
        true, // isCalculated
      );

      setState(() {
        _dataManager.updateSheet(updatedSheet);
        _formulaManager.updateSheet(updatedSheet);
        _state.setSelectedCell(
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            value: result,
            colorHex: colorHex);
        _initializeDataSource();
        _buildFormulaDependencyMap();
      });
    } catch (e) {
      print('Error handling cell submission with formula: $e');
      if (mounted) {
        _uiBuilder.showModernSnackBar(
          message: 'Failed to update cell: ${e.toString()}',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    }
  }

  // Helper method to check if a row has valid values for multiplication
  bool _isMultiplyValidForRow(dynamic row, int columnIndex) {
    if (columnIndex < 2) return false;

    int leftColumnIndex = columnIndex - 2;
    int rightColumnIndex = columnIndex - 1;

    // Convert cells to a regular iterable to ensure firstWhereOrNull works
    final cells = row.cells as Iterable<dynamic>;

    // Find the cells in the required columns
    dynamic leftCell;
    dynamic rightCell;

    try {
      leftCell =
          cells.firstWhereOrNull((c) => c.columnIndex == leftColumnIndex);
      rightCell =
          cells.firstWhereOrNull((c) => c.columnIndex == rightColumnIndex);
    } catch (e) {
      print('Error finding cells for multiplication validation: $e');
      return false;
    }

    // Check if both cells exist and have valid numeric values
    if (leftCell == null || rightCell == null) return false;

    String leftValue = leftCell.value?.toString().trim() ?? '';
    String rightValue = rightCell.value?.toString().trim() ?? '';

    if (leftValue.isEmpty || rightValue.isEmpty) return false;

    // Try to parse as numbers
    double? leftNum = double.tryParse(leftValue);
    double? rightNum = double.tryParse(rightValue);

    return leftNum != null && rightNum != null;
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
                  Icon(icon, color: isPrimary ? Colors.white : color, size: 20),
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

  void _showModernFormulaHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Colors.white, AppColors.primary.withOpacity(0.02)],
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
                      child: const Icon(Icons.help_rounded,
                          color: Colors.white, size: 20),
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
                const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

  // Utility methods
  String _getColumnLetter(int index) {
    if (index == 0) return "Quantity";
    if (index == 1) return "Name";
    String columnLetter = '';
    int adjustedIndex = index - 2;
    while (adjustedIndex >= 0) {
      columnLetter =
          String.fromCharCode((adjustedIndex % 26) + 65) + columnLetter;
      adjustedIndex = (adjustedIndex ~/ 26) - 1;
    }
    return columnLetter;
  }

  @override
  Widget build(BuildContext context) {
    return _uiBuilder.buildMainContainer(
      sheetName: widget.sheet.name,
      isEditable: _state.isEditable,
      isLoading: _state.isLoading,
      scaleAnimation: _state.scaleAnimation,
      borderColorAnimation: _state.borderColorAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _uiBuilder.buildModernHeader(
            sheetName: widget.sheet.name,
            isEditable: _state.isEditable,
          ),
          _uiBuilder.buildDivider(),
          Expanded(
            child: _uiBuilder.buildDataGrid(
              dataSource: _dataSource,
              controller: _state.dataGridController,
              columns: _uiBuilder.buildColumns(
                columnCount: widget.sheet.columns,
                getColumnLetter: _getColumnLetter,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _state.editModeAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _state.editModeAnimation,
                child: Column(
                  children: [
                    _uiBuilder.buildModernEditControls(
                      hasPendingChanges: _state.hasPendingChanges,
                      pendingChangesCount: _state.totalPendingChangesCount,
                      isLoading: _state.isLoading,
                      hasSelectedCell: _state.selectedRowIndex != null &&
                          _state.selectedColumnIndex != null,
                    ),
                    if (_state.selectedRowIndex != null &&
                        _state.selectedColumnIndex != null)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16, left: 24, right: 24, bottom: 8),
                        child: _uiBuilder.buildSelectedCellInfo(
                          cellAddress:
                              '${_getColumnLetter(_state.selectedColumnIndex!)}${_state.selectedRowIndex!}',
                          cellValue: _state.selectedCellValue,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }
}
