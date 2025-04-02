import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/kahon_item_model.dart';
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
    // Add functionality to save changes
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved!')),
    );

    // Optionally turn off edit mode after saving
    setState(() {
      _isEditable = false;
      _initializeDataSource();
    });
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
  Future<void> _handleCellSubmit(
      int rowIndex, int columnIndex, String value) async {
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

      if (existingCell != null) {
        // Update existing cell using the notifier
        await ref
            .read(sheetNotifierProvider.notifier)
            .updateCell(existingCell.id, displayValue, formula);
      } else {
        // Create new cell using the notifier
        await ref
            .read(sheetNotifierProvider.notifier)
            .createCell(rowModel.id, columnIndex, displayValue, formula);
      }

      // Recalculate all formulas in the sheet since this cell might be referenced
      await _recalculateFormulas();
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
    for (var row in widget.sheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          try {
            final newValue = _formulaHandler.evaluateFormula(
                cell.formula!, row.rowIndex, cell.columnIndex);

            await ref
                .read(sheetNotifierProvider.notifier)
                .updateCell(cell.id, newValue, cell.formula);
          } catch (e) {
            await ref
                .read(sheetNotifierProvider.notifier)
                .updateCell(cell.id, '#ERROR', cell.formula);
          }
        }
      }
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
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
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

// Formula Handler class to handle formula evaluation
class FormulaHandler {
  final SheetModel sheet;
  final Map<String, String> _columnMap = {};
  final Map<String, int> _columnIndexMap = {};

  FormulaHandler({required this.sheet}) {
    _initializeColumnMaps();
  }

  void _initializeColumnMaps() {
    // Initialize column mapping (letter to index and vice versa)
    for (int i = 0; i < sheet.columns; i++) {
      String columnLetter = _getColumnLetter(i);
      _columnMap[i.toString()] = columnLetter;
      _columnIndexMap[columnLetter.toUpperCase()] = i;
    }
  }

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

  // Main method to evaluate formulas
  String evaluateFormula(
      String formula, int currentRowIndex, int currentColumnIndex) {
    if (!formula.startsWith('=')) {
      return formula;
    }

    try {
      String processedFormula = formula.substring(1); // Remove the '=' sign

      // Process range functions first (SUM, AVG, etc.)
      processedFormula = _processRangeFunctions(processedFormula);

      // Process cell references (A1, B2, etc.)
      processedFormula =
          _processCellReferences(processedFormula, currentRowIndex);

      // Evaluate the processed formula using math_expressions
      Parser p = Parser();
      Expression exp = p.parse(processedFormula);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      // Format the result (remove decimal if it's a whole number)
      if (result == result.roundToDouble()) {
        return result.toInt().toString();
      } else {
        return result.toStringAsFixed(2);
      }
    } catch (e) {
      print('Formula evaluation error: $e');
      return '#ERROR';
    }
  }

  // Process range functions like SUM, AVG, COUNT, MAX, MIN
  String _processRangeFunctions(String formula) {
    // Pattern to match range functions: SUM(A1:A10), AVG(A1:A10), etc.
    RegExp rangePattern =
        RegExp(r'(SUM|AVG|COUNT|MAX|MIN)\(([A-Za-z0-9]+):([A-Za-z0-9]+)\)');

    return formula.replaceAllMapped(rangePattern, (match) {
      String function = match.group(1)!.toUpperCase();
      String startRef = match.group(2)!;
      String endRef = match.group(3)!;

      try {
        // Parse cell references
        CellReference startCell = _parseCellReference(startRef);
        CellReference endCell = _parseCellReference(endRef);

        // Ensure column indices match for ranges
        if (startCell.columnIndex != endCell.columnIndex) {
          throw Exception('Range must be in the same column');
        }

        // Get values in the range
        List<double> values = _getValuesInRange(
            startCell.columnIndex, startCell.rowIndex, endCell.rowIndex);

        // Apply the function to the values
        switch (function) {
          case 'SUM':
            return values.fold(0.0, (a, b) => a + b).toString();
          case 'AVG':
            if (values.isEmpty) return '0';
            return (values.fold(0.0, (a, b) => a + b) / values.length)
                .toString();
          case 'COUNT':
            return values.length.toString();
          case 'MAX':
            if (values.isEmpty) return '0';
            return values.reduce((a, b) => a > b ? a : b).toString();
          case 'MIN':
            if (values.isEmpty) return '0';
            return values.reduce((a, b) => a < b ? a : b).toString();
          default:
            return '0';
        }
      } catch (e) {
        print('Error processing range function: $e');
        return '0';
      }
    });
  }

  // Get values from cells in a specific range
  List<double> _getValuesInRange(
      int columnIndex, int startRowIndex, int endRowIndex) {
    List<double> values = [];

    // Ensure proper range ordering
    int start = startRowIndex < endRowIndex ? startRowIndex : endRowIndex;
    int end = startRowIndex > endRowIndex ? startRowIndex : endRowIndex;

    // Collect values from cells in the range
    for (int rowIndex = start; rowIndex <= end; rowIndex++) {
      try {
        // Find the row
        RowModel? row =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
        if (row == null) continue;

        // Find the cell
        CellModel? cell =
            row.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);
        if (cell == null || cell.value == null || cell.value!.isEmpty) continue;

        // Try to parse the value
        double? value = double.tryParse(cell.value!);
        if (value != null) {
          values.add(value);
        }
      } catch (e) {
        print('Error getting value from cell: $e');
      }
    }

    return values;
  }

  // Process individual cell references like A1, B2, etc.
  String _processCellReferences(String formula, int currentRowIndex) {
    // Pattern to match cell references: A1, B2, Quantity5, etc.
    RegExp cellPattern = RegExp(r'([A-Za-z]+)([0-9]+)');

    return formula.replaceAllMapped(cellPattern, (match) {
      String column = match.group(1)!;
      int rowIndex = int.parse(match.group(2)!);

      try {
        // Check if the column exists in our mapping
        if (!_columnIndexMap.containsKey(column.toUpperCase())) {
          throw Exception('Invalid column reference: $column');
        }

        int columnIndex = _columnIndexMap[column.toUpperCase()]!;

        // Find the row
        RowModel? row =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
        if (row == null) {
          return '0';
        }

        // Find the cell
        CellModel? cell =
            row.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);
        if (cell == null || cell.value == null || cell.value!.isEmpty) {
          return '0';
        }

        // Try to parse the value, return 0 if not a number
        double? value = double.tryParse(cell.value!);
        if (value == null) {
          return '0';
        }

        return value.toString();
      } catch (e) {
        print('Error processing cell reference: $e');
        return '0';
      }
    });
  }

  // Parse a cell reference (like A1) into column index and row index
  CellReference _parseCellReference(String reference) {
    RegExp cellPattern = RegExp(r'([A-Za-z]+)([0-9]+)');
    Match? match = cellPattern.firstMatch(reference);

    if (match == null) {
      throw Exception('Invalid cell reference: $reference');
    }

    String column = match.group(1)!;
    int rowIndex = int.parse(match.group(2)!);

    // Check if the column exists in our mapping
    if (!_columnIndexMap.containsKey(column.toUpperCase())) {
      throw Exception('Invalid column reference: $column');
    }

    int columnIndex = _columnIndexMap[column.toUpperCase()]!;

    return CellReference(columnIndex, rowIndex);
  }
}

// Helper class to represent a cell reference
class CellReference {
  final int columnIndex;
  final int rowIndex;

  CellReference(this.columnIndex, this.rowIndex);
}

class KahonSheetDataSource extends DataGridSource {
  final SheetModel sheet;
  final List<KahonItemModel> kahonItems;
  final bool isEditable;
  final Function(int rowIndex, int columnIndex, String value)
      cellSubmitCallback;
  final Function(int afterRowIndex) addCalculationRowCallback;
  final Function(String rowId) deleteRowCallback;
  final FormulaHandler formulaHandler;

  List<DataGridRow> _rows = [];

  KahonSheetDataSource({
    required this.sheet,
    required this.kahonItems,
    required this.isEditable,
    required this.cellSubmitCallback,
    required this.addCalculationRowCallback,
    required this.deleteRowCallback,
    required this.formulaHandler,
  }) {
    _rows = _generateRows();
  }

  @override
  List<DataGridRow> get rows => _rows;

  List<DataGridRow> _generateRows() {
    List<DataGridRow> dataRows = [];

    // Sort rows by rowIndex
    final sortedRows = List<RowModel>.from(sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    for (var row in sortedRows) {
      // Create a list for cells that match our columns
      List<DataGridCell> cells = [];

      // Add item name cell (first column)
      String itemNumber = '';
      if (row.isItemRow && row.itemId != null) {
        // Using the index+1 as the item number
        int itemIndex = sortedRows.indexOf(row);
        itemNumber = (itemIndex + 1).toString();
      } else if (!row.isItemRow) {
        // For non-item rows (headers, totals, etc.)
        // Using rowName or another existing property from RowModel
        itemNumber = row.rowIndex.toString();
      }

      cells.add(DataGridCell<RowCellData>(
        columnName: 'itemName',
        value: RowCellData(
          text: itemNumber,
          rowId: row.id,
          rowIndex: row.rowIndex,
          isItemRow: row.isItemRow,
        ),
      ));

      // Create a map for easy access to cell data by column index
      Map<int, CellModel> cellMap = {};
      for (var cell in row.cells) {
        cellMap[cell.columnIndex] = cell;
      }

      // Add cells for each column based on the sheet's column count
      for (int i = 0; i < sheet.columns; i++) {
        final CellModel? cellModel = cellMap[i];
        cells.add(DataGridCell<CellModel?>(
          columnName: 'column$i',
          value: cellModel,
        ));
      }

      // Create DataGridRow
      dataRows.add(DataGridRow(cells: cells));
    }

    return dataRows;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        // For item name column
        if (cell.columnName == 'itemName') {
          final rowData = cell.value as RowCellData;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            color: AppColors.secondary.withAlpha(13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rowData.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
                if (isEditable)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        size: 16, color: AppColors.secondary),
                    onSelected: (value) {
                      if (value == 'add_calculation') {
                        addCalculationRowCallback(rowData.rowIndex);
                      } else if (value == 'delete') {
                        deleteRowCallback(rowData.rowId);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'add_calculation',
                        child: Text('Add Calculation Row After'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete Row',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }
        // For cell model columns
        else if (cell.value is CellModel) {
          final cellModel = cell.value as CellModel;
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            color: cellModel.isCalculated
                ? AppColors.primaryLight.withAlpha(25)
                : null,
            child: Text(
              cellModel.value ?? '',
              style: TextStyle(
                color:
                    cellModel.isCalculated ? AppColors.primary : Colors.black87,
              ),
            ),
          );
        }
        // For empty cells or null values
        else {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: const Text(''),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget? buildEditWidget(DataGridRow row, RowColumnIndex rowColumnIndex,
      GridColumn column, CellSubmit submitCell) {
    // Only allow editing for cell values, not for headers or calculated cells
    if (column.columnName == 'itemName') {
      return null;
    }

    // Get the row data
    final rowCellData = row.getCells().first.value as RowCellData;
    final rowIndex = rowCellData.rowIndex;

    // Find the cell model
    final cell = row
        .getCells()
        .firstWhere(
          (cell) => cell.columnName == column.columnName,
          orElse: () =>
              DataGridCell<dynamic>(columnName: column.columnName, value: null),
        )
        .value as CellModel?;

    // Don't allow editing calculated cells
    if (cell != null && cell.isCalculated) {
      return null;
    }

    // Default value for the text field
    String initialValue = '';
    if (cell != null) {
      initialValue = cell.formula ?? cell.value ?? '';
    }

    // Create edit widget
    // In buildEditWidget method
    return Container(
      padding: const EdgeInsets.all(4),
      child: TextField(
        autofocus: true,
        controller: TextEditingController(text: initialValue),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
        onSubmitted: (value) {
          // Add debug print statements
          print("TextField onSubmitted called with value: $value");
          print("Column name: ${column.columnName}");

          // Extract column index from column name
          int columnIndex =
              int.parse(column.columnName.replaceAll('column', ''));
          print("Extracted column index: $columnIndex");

          // Call the callback to update the cell in the parent widget/state
          print(
              "Calling cellSubmitCallback with rowIndex: $rowIndex, columnIndex: $columnIndex, value: $value");
          cellSubmitCallback(rowIndex, columnIndex, value);

          // Submit the cell value to close the edit widget
          print("Calling submitCell()");
          submitCell();
        },
      ),
    );
  }

  // Get sorted rows for use in buildEditWidget
  List<RowModel> get sortedRows {
    return List<RowModel>.from(sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    return isEditable && column.columnName != 'itemName';
  }
}

// Helper class to store row data for the first column
class RowCellData {
  final String text;
  final String rowId;
  final int rowIndex;
  final bool isItemRow;

  RowCellData({
    required this.text,
    required this.rowId,
    required this.rowIndex,
    required this.isItemRow,
  });
}

// Extension method for firstWhereOrNull
extension FirstWhereOrNullExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
