import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/services.dart';

import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/providers/inventory_provider.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/state/inventory_sheet_state.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/managers/inventory_formula_manager.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/managers/inventory_data_manager.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/builders/inventory_sheet_ui_builder.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_sheet_data_source.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/enhanced_row_reorder_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/row_cell_data.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/row_reorder_change.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_color_handler.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';

class InventorySheetNew extends ConsumerStatefulWidget {
  final InventorySheetModel sheet;

  const InventorySheetNew({
    super.key,
    required this.sheet,
  });

  @override
  ConsumerState<InventorySheetNew> createState() => _InventorySheetNewState();
}

class _InventorySheetNewState extends ConsumerState<InventorySheetNew>
    with TickerProviderStateMixin {
  // State Management
  late InventorySheetState _state;

  // Business Logic Managers
  late InventoryFormulaManager _formulaManager;
  late InventoryDataManager _dataManager;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _setupDataSource();

    // Recalculate formulas on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recalculateAllFormulasOnLoad();
    });
  }

  void _initializeComponents() {
    _state = InventorySheetState(
      sheet: widget.sheet,
      tickerProvider: this,
    );

    _formulaManager = InventoryFormulaManager(sheet: widget.sheet);
    _dataManager = InventoryDataManager(ref: ref);

    // Listen to state changes
    _state.addListener(_onStateChanged);
  }

  void _setupDataSource() {
    final dataSource = InventorySheetDataSource(
      sheet: widget.sheet,
      isEditable: _state.isEditable,
      cellSubmitCallback: _handleCellSubmit,
      addCalculationRowCallback: _addCalculationRow,
      deleteRowCallback: _deleteRow,
      formulaHandler: _formulaManager.formulaHandler,
      eraseCellCallback: _eraseCell,
      addMultipleCalculationRowsCallback: _addMultipleCalculationRows,
      onDoubleTabHandler: !_state.isEditable ? _toggleEditMode : null,
      onRowReorder: _handleRowReorder,
    );

    _state.setDataSource(dataSource);
    InventorySheetDataSource.currentContext = context;
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {}); // Trigger rebuild when state changes
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InventorySheetDataSource.currentContext = context;
  }

  @override
  void didUpdateWidget(InventorySheetNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sheet != widget.sheet) {
      _formulaManager.updateSheet(widget.sheet);
      _setupDataSource();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recalculateAllFormulasOnLoad();
      });
    }
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    super.dispose();
  }

  // Event Handlers
  void _toggleEditMode() {
    _state.toggleEditMode();
    _setupDataSource();
    HapticFeedback.mediumImpact();
  }

  Future<void> _saveChanges() async {
    if (_state.isLoading) return;

    _state.setLoading(true);

    try {
      await _dataManager.applyPendingChanges(
        _state.pendingChanges,
        _state.pendingRowReorders,
      );

      _showSnackBar('Changes saved successfully!');
      _state.setEditMode(false);
      _state.clearAllPendingChanges();
      _setupDataSource();
    } catch (e) {
      _showSnackBar('Failed to save changes: ${e.toString()}', isError: true);
    } finally {
      _state.setLoading(false);
    }
  }

  Future<void> _handleRowReorder(
      String rowId, int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    try {
      final mappings = EnhancedRowReorderHandler.calculateSequentialMappings(
        widget.sheet.rows,
        rowId,
        oldIndex,
        newIndex,
      );

      if (mappings.isEmpty) return;

      final validation = EnhancedRowReorderHandler.validateRowMappings(
        mappings,
        widget.sheet.rows,
      );

      if (!validation.isValid) {
        _showSnackBar(
          'Cannot reorder rows: ${validation.errors.join(", ")}',
          isError: true,
        );
        return;
      }

      final formulaUpdates = EnhancedRowReorderHandler.calculateFormulaUpdates(
        widget.sheet,
        mappings,
      );

      _state.setLoading(true);
      await _dataManager.applyEnhancedRowReorder(mappings, formulaUpdates);
      _showSnackBar('Rows reordered successfully!');
    } catch (e) {
      _showSnackBar('Failed to reorder rows: ${e.toString()}', isError: true);
    } finally {
      _state.setLoading(false);
    }
  }

  Future<void> _handleCellSubmit(
      int rowIndex, int columnIndex, String value, String? color) async {
    try {
      // Use current sheet from data source for latest state
      InventorySheetModel currentSheet =
          _state.dataSource?.currentSheet ?? widget.sheet;

      final rowModel = currentSheet.rows.firstWhere(
        (r) => r.rowIndex == rowIndex,
        orElse: () => throw Exception('Row not found'),
      );

      final existingCell = rowModel.cells.firstWhereOrNull(
        (c) => c.columnIndex == columnIndex,
      );

      String? formula;
      String displayValue = value;

      // Handle formula and color logic
      if (existingCell != null &&
          color != null &&
          existingCell.formula != null &&
          ((existingCell.value == value) ||
              (value.isEmpty && existingCell.value == null))) {
        formula = existingCell.formula;
        displayValue = existingCell.value ?? '';
      } else if (value.startsWith('=')) {
        formula = value;
        try {
          displayValue = _formulaManager.formulaHandler
              .evaluateFormula(value, rowIndex, columnIndex);
        } catch (e) {
          displayValue = '#ERROR';
        }
      }

      // Create pending change
      String changeKey = '${rowIndex}_${columnIndex}';

      if (existingCell != null && !existingCell.id.startsWith('temp_')) {
        _state.addPendingCellChange(
            changeKey,
            CellChange(
              isUpdate: true,
              cellId: existingCell.id,
              rowId: rowModel.id,
              columnIndex: columnIndex,
              displayValue: displayValue,
              formula: formula,
              color: color,
            ));
      } else {
        _state.addPendingCellChange(
            changeKey,
            CellChange(
              isUpdate: false,
              rowId: rowModel.id,
              columnIndex: columnIndex,
              displayValue: displayValue,
              formula: formula,
              color: color,
            ));
      }

      // Update UI immediately
      final updatedSheet = _dataManager.updateCellInSheet(
        currentSheet,
        rowModel.id,
        columnIndex,
        displayValue,
        formula,
        color,
        existingCellId: existingCell?.id,
      );

      _formulaManager.updateSheet(updatedSheet);
      _state.updateSelectedCell(
        rowIndex: rowIndex,
        columnIndex: columnIndex,
        value: value,
        colorHex: color,
      );

      _setupDataSourceWithSheet(updatedSheet);
      _updateDependentFormulas(rowIndex, columnIndex, updatedSheet);
    } catch (e) {
      _showSnackBar('Failed to update cell: ${e.toString()}', isError: true);
    }
  }

  void _setupDataSourceWithSheet(InventorySheetModel sheet) {
    final dataSource = InventorySheetDataSource(
      sheet: sheet,
      isEditable: _state.isEditable,
      cellSubmitCallback: _handleCellSubmit,
      addCalculationRowCallback: _addCalculationRow,
      deleteRowCallback: _deleteRow,
      formulaHandler: _formulaManager.formulaHandler,
      eraseCellCallback: _eraseCell,
      addMultipleCalculationRowsCallback: _addMultipleCalculationRows,
      onDoubleTabHandler: !_state.isEditable ? _toggleEditMode : null,
      onRowReorder: _handleRowReorder,
    );

    _state.setDataSource(dataSource);
  }

  void _updateDependentFormulas(
      int rowIndex, int columnIndex, InventorySheetModel currentSheet) {
    final dependentCells =
        _formulaManager.getDependentCells(rowIndex, columnIndex);
    if (dependentCells.isEmpty) return;

    InventorySheetModel updatedSheet = currentSheet;
    Set<String> processedCells = {};

    _updateDependentCellsRecursively(
        dependentCells, processedCells, updatedSheet);

    _formulaManager.updateSheet(updatedSheet);
    _setupDataSourceWithSheet(updatedSheet);
  }

  void _updateDependentCellsRecursively(Set<String> cellsToUpdate,
      Set<String> processedCells, InventorySheetModel updatedSheet) {
    // Implementation similar to original but cleaner
    for (String cellKey in cellsToUpdate.toList()) {
      if (processedCells.contains(cellKey)) continue;
      processedCells.add(cellKey);

      List<String> parts = cellKey.split('_');
      if (parts.length == 2) {
        int depRowIndex = int.parse(parts[0]);
        int depColumnIndex = int.parse(parts[1]);

        var rowModel = updatedSheet.rows.firstWhereOrNull(
          (r) => r.rowIndex == depRowIndex,
        );

        if (rowModel != null) {
          var cellModel = rowModel.cells.firstWhereOrNull(
            (c) => c.columnIndex == depColumnIndex,
          );

          if (cellModel != null && cellModel.formula != null) {
            try {
              String newValue = _formulaManager.formulaHandler.evaluateFormula(
                  cellModel.formula!, depRowIndex, depColumnIndex);

              String changeKey = '${depRowIndex}_${depColumnIndex}';
              _state.addPendingCellChange(
                  changeKey,
                  CellChange(
                    isUpdate: true,
                    cellId: cellModel.id,
                    rowId: rowModel.id,
                    columnIndex: depColumnIndex,
                    displayValue: newValue,
                    formula: cellModel.formula,
                    color: cellModel.color,
                  ));

              // Update the sheet model for continued calculations
              updatedSheet = _dataManager.updateCellInSheet(
                updatedSheet,
                rowModel.id,
                depColumnIndex,
                newValue,
                cellModel.formula,
                cellModel.color,
                existingCellId: cellModel.id,
              );

              // Find next dependent cells
              final nextDependents = _formulaManager
                  .getDependentCells(depRowIndex, depColumnIndex)
                  .difference(processedCells);

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

  void _eraseCell(int rowIndex, int columnIndex) async {
    try {
      final rowModel = widget.sheet.rows.firstWhere(
        (r) => r.rowIndex == rowIndex,
        orElse: () => throw Exception('Row not found'),
      );

      final existingCell = rowModel.cells.firstWhereOrNull(
        (c) => c.columnIndex == columnIndex,
      );

      if (existingCell != null) {
        String changeKey = '${rowIndex}_${columnIndex}';

        _state.addPendingCellChange(
            changeKey,
            CellChange(
              isUpdate: true,
              cellId: existingCell.id,
              rowId: rowModel.id,
              columnIndex: columnIndex,
              displayValue: '',
              formula: null,
              color: null,
            ));

        // Update UI immediately
        final currentSheet = _state.dataSource?.currentSheet ?? widget.sheet;
        final updatedSheet = _dataManager.updateCellInSheet(
          currentSheet,
          rowModel.id,
          columnIndex,
          '',
          null,
          null,
          existingCellId: existingCell.id,
        );

        _formulaManager.updateSheet(updatedSheet);
        _setupDataSourceWithSheet(updatedSheet);
      }
    } catch (e) {
      _showSnackBar('Failed to erase cell: ${e.toString()}', isError: true);
    }
  }

  Future<void> _recalculateAllFormulasOnLoad() async {
    try {
      final cellsToUpdate = _formulaManager.recalculateAllFormulas();

      if (cellsToUpdate.isNotEmpty) {
        await _dataManager.autoSaveRecalculatedFormulas(cellsToUpdate);
      }
    } catch (e) {
      print('Error during formula recalculation on load: $e');
    }
  }

  // Row Management
  Future<void> _addCalculationRow(int afterRowIndex) async {
    try {
      if (_state.totalPendingChanges > 0) {
        await _dataManager.applyPendingChanges(
          _state.pendingChanges,
          _state.pendingRowReorders,
        );
        _state.clearAllPendingChanges();
      }

      await _dataManager.addCalculationRow(
          widget.sheet.inventoryId, afterRowIndex);

      if (!_state.isEditable) {
        _state.setEditMode(true);
        _setupDataSource();
      }
    } catch (e) {
      _showSnackBar('Failed to add calculation row: ${e.toString()}',
          isError: true);
    }
  }

  Future<void> _deleteRow(String rowId) async {
    try {
      await _dataManager.deleteRow(rowId);
    } catch (e) {
      _showSnackBar('Failed to delete row: ${e.toString()}', isError: true);
    }
  }

  Future<void> _addMultipleCalculationRows(
      int afterRowIndex, int rowCount) async {
    try {
      if (_state.totalPendingChanges > 0) {
        await _dataManager.applyPendingChanges(
          _state.pendingChanges,
          _state.pendingRowReorders,
        );
        _state.clearAllPendingChanges();
      }

      await _dataManager.addMultipleCalculationRows(
        widget.sheet.inventoryId,
        afterRowIndex,
        rowCount,
      );

      if (!_state.isEditable) {
        _state.setEditMode(true);
        _setupDataSource();
      }

      _showSnackBar('Added $rowCount new rows');
    } catch (e) {
      _showSnackBar('Failed to add calculation rows: ${e.toString()}',
          isError: true);
    }
  }

  // UI Event Handlers
  void _handleCellTap(DataGridCellTapDetails details) {
    if (details.rowColumnIndex.rowIndex > 0 &&
        details.column.columnName != 'itemName') {
      final rowData = _state.dataSource?.rows.isNotEmpty == true &&
              details.rowColumnIndex.rowIndex - 1 <
                  _state.dataSource!.rows.length
          ? _state.dataSource!.rows[details.rowColumnIndex.rowIndex - 1]
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

          _state.updateSelectedCell(
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            cell: cell,
            value: cell?.value ?? '',
            colorHex: cell?.color,
          );
        }
      }
    }
  }

  void _handleAddRows() {
    int rowIndex = _state.dataGridController.selectedIndex != -1
        ? _state.dataGridController.selectedIndex
        : widget.sheet.rows.length - 1;

    if (rowIndex >= 0 && rowIndex < widget.sheet.rows.length) {
      _showAddRowsDialog(widget.sheet.rows[rowIndex].rowIndex);
    } else {
      _showAddRowsDialog(
          widget.sheet.rows.isNotEmpty ? widget.sheet.rows.last.rowIndex : 0);
    }
  }

  void _handleDeleteRow() {
    if (_state.dataGridController.selectedIndex != -1) {
      int selectedIndex = _state.dataGridController.selectedIndex;
      if (selectedIndex >= 0 && selectedIndex < widget.sheet.rows.length) {
        _showDeleteConfirmationDialog(selectedIndex);
      }
    } else {
      _showSnackBar('Please select a row to delete', isError: true);
    }
  }

  void _handleRefresh() {
    ref.read(inventoryProvider.notifier).getInventoryByDate(null, null);
  }

  // Dialogs and UI Components
  void _showAddRowsDialog(int afterRowIndex) {
    final TextEditingController controller = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    if (_state.totalPendingChanges > 0) {
      _dataManager
          .applyPendingChanges(
        _state.pendingChanges,
        _state.pendingRowReorders,
      )
          .then((_) {
        _state.clearAllPendingChanges();
        _actuallyShowAddRowsDialog(afterRowIndex, controller, formKey);
      });
    } else {
      _actuallyShowAddRowsDialog(afterRowIndex, controller, formKey);
    }
  }

  void _actuallyShowAddRowsDialog(int afterRowIndex,
      TextEditingController controller, GlobalKey<FormState> formKey) {
    // ...existing dialog code...
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
                SizedBox(height: 12),
                Text('Range Functions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• SUM(A1:A10) - Adds values from A1 to A10'),
                Text('• AVG(A1:A10) - Averages values from A1 to A10'),
                SizedBox(height: 12),
                Text('Arithmetic Operations:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('• A1 + B1 - Addition'),
                Text('• A1 - B1 - Subtraction'),
                Text('• A1 * B1 - Multiplication'),
                Text('• A1 / B1 - Division'),
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
    if (_state.selectedRowIndex == null || _state.selectedColumnIndex == null)
      return;

    final currentSheet = _state.dataSource?.currentSheet ?? widget.sheet;
    final rowIndex = _state.selectedRowIndex!;
    final columnIndex = _state.selectedColumnIndex!;

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
                _buildFormulaOption(
                  'Subtract Vertical Cells',
                  Icons.remove,
                  'Subtract the cell above from the one two rows above',
                  Colors.orange,
                  () => _applySubtractVerticalFormula(rowIndex, columnIndex),
                ),
                const SizedBox(height: 8),
                _buildFormulaOption(
                  'Apply Multiply to All Rows',
                  Icons.clear,
                  'Multiply all values in previous columns for each row',
                  Colors.blue,
                  () => _applyMultiplyToAllRows(
                      rowIndex, columnIndex, currentSheet),
                ),
                const SizedBox(height: 8),
                _buildFormulaOption(
                  'Add All Cells Above',
                  Icons.add,
                  'Sum all numeric cells above in this column',
                  Colors.green,
                  () => _applyAddAllCellsAbove(
                      rowIndex, columnIndex, currentSheet),
                ),
                const SizedBox(height: 8),
                _buildFormulaOption(
                  'Apply Addition to All Rows',
                  Icons.add_circle_outline,
                  'Add all values in previous columns for each row',
                  Colors.purple,
                  () => _applyAdditionToAllRows(
                      rowIndex, columnIndex, currentSheet),
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

  // Formula Application Methods
  void _applySubtractVerticalFormula(int rowIndex, int columnIndex) {
    final formula =
        _formulaManager.generateSubtractVerticalFormula(rowIndex, columnIndex);
    if (formula.isNotEmpty) {
      _handleCellSubmit(
          rowIndex, columnIndex, formula, _state.selectedCellColorHex);
    } else {
      _showSnackBar('Not enough valid rows above for subtraction.',
          isError: true);
    }
  }

  void _applyMultiplyToAllRows(
      int rowIndex, int columnIndex, InventorySheetModel currentSheet) {
    if (columnIndex < 2) {
      _showSnackBar('Select a cell in column C or higher to use this feature.',
          isError: true);
      return;
    }

    final selectedRowModel =
        currentSheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
    if (selectedRowModel == null) return;

    final mainFormula = _formulaManager.generateProductFormula(
        rowIndex, columnIndex, selectedRowModel);
    if (mainFormula.isNotEmpty) {
      _handleCellSubmit(
          rowIndex, columnIndex, mainFormula, _state.selectedCellColorHex);

      // Apply to all other rows
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final sortedRows = List.from(currentSheet.rows)
          ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

        for (var row in sortedRows) {
          if (row.rowIndex == rowIndex) continue;

          final otherFormula = _formulaManager.generateProductFormula(
              row.rowIndex, columnIndex, row);
          if (otherFormula.isNotEmpty) {
            _handleCellSubmit(row.rowIndex, columnIndex, otherFormula, null);
          }
        }
      });
    } else {
      _showSnackBar(
          'The two cells to the left must contain valid numeric values.',
          isError: true);
    }
  }

  void _applyAddAllCellsAbove(
      int rowIndex, int columnIndex, InventorySheetModel currentSheet) {
    final formula =
        _formulaManager.generateSumAllAboveFormula(rowIndex, columnIndex);
    if (formula.isNotEmpty) {
      _handleCellSubmit(
          rowIndex, columnIndex, formula, _state.selectedCellColorHex);
    } else {
      _showSnackBar('No numeric cells found above this cell in the column.',
          isError: true);
    }
  }

  void _applyAdditionToAllRows(
      int rowIndex, int columnIndex, InventorySheetModel currentSheet) {
    if (columnIndex <= 1) {
      _showSnackBar('Select a cell in column C or higher to use this feature.',
          isError: true);
      return;
    }

    final selectedRowModel =
        currentSheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
    if (selectedRowModel == null) return;

    final mainFormula = _formulaManager.generateSumFormula(
        rowIndex, columnIndex, selectedRowModel);
    if (mainFormula.isNotEmpty) {
      _handleCellSubmit(
          rowIndex, columnIndex, mainFormula, _state.selectedCellColorHex);

      // Apply to all other rows
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final sortedRows = List.from(currentSheet.rows)
          ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

        for (var row in sortedRows) {
          if (row.rowIndex == rowIndex) continue;

          final otherFormula = _formulaManager.generateSumFormula(
              row.rowIndex, columnIndex, row);
          if (otherFormula.isNotEmpty) {
            _handleCellSubmit(row.rowIndex, columnIndex, otherFormula, null);
          }
        }
      });
    }
  }

  void _showColorPickerDialog() {
    if (_state.selectedRowIndex == null || _state.selectedColumnIndex == null)
      return;

    final existingCell =
        _findCellInSheet(_state.selectedRowIndex!, _state.selectedColumnIndex!);
    String valueToKeep =
        existingCell?.formula ?? _state.selectedCellValue ?? '';

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
          content: InventorySheetUIBuilder.buildColorPickerDialog(
            currentColorHex: _state.selectedCellColorHex,
            onRemoveColor: () {
              _handleCellSubmit(_state.selectedRowIndex!,
                  _state.selectedColumnIndex!, valueToKeep, null);
              Navigator.of(context).pop();
            },
            onSelectColor: (colorHex) {
              _handleCellSubmit(_state.selectedRowIndex!,
                  _state.selectedColumnIndex!, valueToKeep, colorHex);
              Navigator.of(context).pop();
            },
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

  InventoryCellModel? _findCellInSheet(int rowIndex, int columnIndex) {
    final currentSheet = _state.dataSource?.currentSheet ?? widget.sheet;
    final rowModel =
        currentSheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
    return rowModel?.cells
        .firstWhereOrNull((c) => c.columnIndex == columnIndex);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: !_state.isEditable ? _toggleEditMode : null,
      child: AnimatedBuilder(
        animation: _state.editModeAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _state.editModeScaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _state.editModeBorderColorAnimation.value ??
                      AppColors.primary.withOpacity(0.3),
                  width: _state.isEditable ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _state.isEditable
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    spreadRadius: _state.isEditable ? 3 : 1,
                    blurRadius: _state.isEditable ? 12 : 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InventorySheetUIBuilder.buildModernHeader(
                    sheetName: widget.sheet.name,
                    isEditable: _state.isEditable,
                    onToggleEditMode: _toggleEditMode,
                    onRefresh: _handleRefresh,
                    onAddRows: _handleAddRows,
                    onShowHelp: _showFormulaHelpDialog,
                    onDeleteRow: _state.isEditable ? _handleDeleteRow : null,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: _state.dataSource != null
                          ? SfDataGrid(
                              source: _state.dataSource!,
                              controller: _state.dataGridController,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              columnWidthMode: ColumnWidthMode.auto,
                              allowEditing: _state.isEditable,
                              selectionMode: SelectionMode.multiple,
                              navigationMode: GridNavigationMode.cell,
                              frozenColumnsCount: 1,
                              columns: InventorySheetUIBuilder.buildColumns(
                                  widget.sheet),
                              onCellTap: _handleCellTap,
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  InventorySheetUIBuilder.buildEditControlsPanel(
                    isEditable: _state.isEditable,
                    totalPendingChanges: _state.totalPendingChanges,
                    pendingRowReorders: _state.pendingRowReorders.length,
                    isLoading: _state.isLoading,
                    hasSelectedCell: _state.selectedRowIndex != null &&
                        _state.selectedColumnIndex != null,
                    onSaveChanges: _saveChanges,
                    onShowQuickFormulas: _state.selectedRowIndex != null &&
                            _state.selectedColumnIndex != null
                        ? _showQuickFormulasMenu
                        : null,
                    onEraseCell: _state.selectedRowIndex != null &&
                            _state.selectedColumnIndex != null
                        ? () => _eraseCell(_state.selectedRowIndex!,
                            _state.selectedColumnIndex!)
                        : null,
                    onShowColorPicker: _state.selectedRowIndex != null &&
                            _state.selectedColumnIndex != null
                        ? _showColorPickerDialog
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
