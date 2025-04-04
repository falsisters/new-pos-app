import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/row_cell_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/kahon_item_model.dart';

class KahonSheetDataSource extends DataGridSource {
  final SheetModel sheet;
  final List<KahonItemModel> kahonItems;
  final bool isEditable;
  final Function(int rowIndex, int columnIndex, String value)
      cellSubmitCallback;
  final Function(int afterRowIndex) addCalculationRowCallback;
  final Function(String rowId) deleteRowCallback;
  final FormulaHandler formulaHandler;

  SheetModel get currentSheet => sheet;

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

    // Extract column index from column name
    final columnIndex = int.parse(column.columnName.replaceAll('column', ''));

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

    // Create text editing controller for the field
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    // Create edit widget with keyboard listener
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) {
                  if (event is RawKeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter) {
                    cellSubmitCallback(rowIndex, columnIndex, controller.text);
                    submitCell();
                  }
                },
                child: TextField(
                  autofocus: true,
                  controller: controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          BorderSide(color: AppColors.primary.withOpacity(0.5)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24, // Extra padding to avoid text under icon
                    ),
                  ),
                  onSubmitted: (value) {
                    cellSubmitCallback(rowIndex, columnIndex, value);
                    submitCell();
                  },
                ),
              ),
              // Popup menu button as overlay
              Positioned(
                right: 2,
                child: PopupMenuButton<String>(
                  icon:
                      Icon(Icons.more_vert, color: AppColors.primary, size: 18),
                  padding: EdgeInsets.zero,
                  tooltip: 'Formula options',
                  splashRadius: 20,
                  onSelected: (value) {
                    String formula = '';

                    switch (value) {
                      case 'mult_left':
                        if (columnIndex >= 2) {
                          formula =
                              '=${_getColumnNameForIndex(columnIndex - 2)}$rowIndex * ${_getColumnNameForIndex(columnIndex - 1)}$rowIndex';
                        }
                        break;
                      case 'add_left':
                        if (columnIndex >= 2) {
                          formula =
                              '=${_getColumnNameForIndex(columnIndex - 2)}$rowIndex + ${_getColumnNameForIndex(columnIndex - 1)}$rowIndex';
                        }
                        break;
                      case 'add_vert':
                        if (rowIndex >= 2) {
                          formula =
                              '=${_getColumnNameForIndex(columnIndex)}${rowIndex - 2} + ${_getColumnNameForIndex(columnIndex)}${rowIndex - 1}';
                        }
                        break;
                      case 'sub_vert':
                        if (rowIndex >= 2) {
                          formula =
                              '=${_getColumnNameForIndex(columnIndex)}${rowIndex - 2} - ${_getColumnNameForIndex(columnIndex)}${rowIndex - 1}';
                        }
                        break;
                      case 'mult_vert':
                        if (rowIndex >= 2) {
                          formula =
                              '=${_getColumnNameForIndex(columnIndex)}${rowIndex - 2} * ${_getColumnNameForIndex(columnIndex)}${rowIndex - 1}';
                        }
                        break;
                      case 'mult_all':
                        if (columnIndex >= 2) {
                          // Apply multiply formula to this cell
                          formula =
                              '=${_getColumnNameForIndex(columnIndex - 2)}$rowIndex * ${_getColumnNameForIndex(columnIndex - 1)}$rowIndex';
                          controller.text = formula;

                          // Apply to current cell first
                          cellSubmitCallback(rowIndex, columnIndex, formula);

                          // Schedule the updates to other cells to happen after this edit is completed
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Find all rows with valid numerical values to apply formula
                            for (var row in sortedRows) {
                              if (row.rowIndex == rowIndex) {
                                continue; // Skip current row
                              }

                              // Check if cell already exists in this column for this row
                              final existingCell = row.cells
                                  .where((c) => c.columnIndex == columnIndex)
                                  .firstOrNull;

                              // Skip if the cell already has a value or is a calculated cell
                              if (existingCell != null &&
                                  (existingCell.value != null &&
                                          existingCell.value!.isNotEmpty ||
                                      existingCell.isCalculated)) {
                                continue; // Skip this row as it already has a value or formula
                              }

                              // Check if source cells have valid numerical values
                              final leftCell1 = row.cells
                                  .where(
                                      (c) => c.columnIndex == columnIndex - 2)
                                  .firstOrNull;
                              final leftCell2 = row.cells
                                  .where(
                                      (c) => c.columnIndex == columnIndex - 1)
                                  .firstOrNull;

                              if (leftCell1 != null && leftCell2 != null) {
                                try {
                                  // Verify both source cells have numerical values
                                  double.parse(leftCell1.value ?? '');
                                  double.parse(leftCell2.value ?? '');

                                  // Create formula for this row
                                  String targetFormula =
                                      '=${_getColumnNameForIndex(columnIndex - 2)}${row.rowIndex} * ${_getColumnNameForIndex(columnIndex - 1)}${row.rowIndex}';

                                  // Apply the formula to this cell
                                  cellSubmitCallback(
                                      row.rowIndex, columnIndex, targetFormula);
                                } catch (_) {
                                  // Skip if source cells don't have valid numerical values
                                }
                              }
                            }

                            // Refresh data source to show updated values
                            notifyListeners();
                          });

                          // Submit current cell edit
                          submitCell();
                        }
                        break;
                      case 'add_all_vert':
                        String formula = '=';
                        bool hasValues = false;

                        // Go through all rows in the sheet
                        for (var row in sortedRows) {
                          // Skip current row
                          if (row.rowIndex == rowIndex) {
                            continue;
                          }

                          // Find cell in the same column
                          final cellInColumn = row.cells
                              .where((c) => c.columnIndex == columnIndex)
                              .firstOrNull;

                          if (cellInColumn != null &&
                              cellInColumn.value != null &&
                              cellInColumn.value!.isNotEmpty) {
                            try {
                              // Try parsing to verify it's a valid number
                              double.parse(cellInColumn.value!);

                              // Add to formula
                              if (hasValues) {
                                formula += ' + ';
                              }
                              formula +=
                                  '${_getColumnNameForIndex(columnIndex)}${row.rowIndex}';
                              hasValues = true;
                            } catch (_) {
                              // Skip non-numeric values
                            }
                          }
                        }

                        if (hasValues) {
                          controller.text = formula;
                          cellSubmitCallback(rowIndex, columnIndex, formula);
                          submitCell();
                        }
                        break;
                    }

                    if (formula.isNotEmpty) {
                      controller.text = formula;
                      cellSubmitCallback(rowIndex, columnIndex, formula);
                      submitCell();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'mult_left',
                      child: Text('Multiply Left Cells'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'add_left',
                      child: Text('Add Left Cells'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'add_vert',
                      child: Text('Add Vertical Cells'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'sub_vert',
                      child: Text('Subtract Vertical Cells'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'mult_vert',
                      child: Text('Multiply Vertical Cells'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'mult_all',
                      child: Text('Apply Multiply to All Rows'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'add_all_vert',
                      child: Text('Add All Vertical Cells'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Helper method to convert column index to column name (A, B, C, etc.)
  String _getColumnNameForIndex(int index) {
    // Custom labels for specific columns
    if (index == 0) return "Quantity";
    if (index == 1) return "Name";

    // For other columns, use Excel-like column letters (C, D, E, etc.)
    String columnLetter = '';
    int adjustedIndex =
        index - 2; // Adjust index to start from 0 after custom columns
    while (adjustedIndex >= 0) {
      columnLetter =
          String.fromCharCode((adjustedIndex % 26) + 65) + columnLetter;
      adjustedIndex = (adjustedIndex ~/ 26) - 1;
    }
    return columnLetter;
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
