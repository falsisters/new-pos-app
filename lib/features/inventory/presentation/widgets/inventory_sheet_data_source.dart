import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_formula_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/row_cell_data.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_color_handler.dart';

class InventorySheetDataSource extends DataGridSource {
  final InventorySheetModel sheet;
  final bool isEditable;
  final Function(int rowIndex, int columnIndex, String value, String? color)
      cellSubmitCallback;
  final Function(int afterRowIndex) addCalculationRowCallback;
  final Function(int afterRowIndex, int rowCount)?
      addMultipleCalculationRowsCallback;
  final Function(String rowId) deleteRowCallback;
  final InventoryFormulaHandler formulaHandler;
  final Function(int rowIndex, int columnIndex)? eraseCellCallback;
  final Function()? onDoubleTabHandler;

  // Static context for accessing from static methods
  static BuildContext? currentContext;

  InventorySheetModel get currentSheet => sheet;

  List<DataGridRow> _rows = [];

  InventorySheetDataSource({
    required this.sheet,
    required this.isEditable,
    required this.cellSubmitCallback,
    required this.addCalculationRowCallback,
    required this.deleteRowCallback,
    required this.formulaHandler,
    this.eraseCellCallback,
    this.addMultipleCalculationRowsCallback,
    this.onDoubleTabHandler,
  }) {
    _rows = _generateRows();
  }

  @override
  List<DataGridRow> get rows => _rows;

  List<DataGridRow> _generateRows() {
    List<DataGridRow> dataRows = [];

    final sortedRows = List<InventoryRowModel>.from(sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    for (var row in sortedRows) {
      List<DataGridCell> cells = [];

      String itemNumber = '';
      if (row.isItemRow && row.itemId != null) {
        int itemIndex = sortedRows.indexOf(row);
        itemNumber = (itemIndex + 1).toString();
      } else if (!row.isItemRow) {
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

      Map<int, InventoryCellModel> cellMap = {};
      for (var cell in row.cells) {
        cellMap[cell.columnIndex] = cell;
      }

      for (int i = 0; i < sheet.columns; i++) {
        final InventoryCellModel? cellModel = cellMap[i];
        cells.add(DataGridCell<InventoryCellModel?>(
          columnName: 'column$i',
          value: cellModel,
        ));
      }

      dataRows.add(DataGridRow(cells: cells));
    }

    return dataRows;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
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
                        if (addMultipleCalculationRowsCallback != null) {
                          _showAddRowsDialog(rowData.rowIndex);
                        } else {
                          addCalculationRowCallback(rowData.rowIndex);
                        }
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
        } else if (cell.value is InventoryCellModel) {
          final cellModel = cell.value as InventoryCellModel;

          Color? backgroundColor;
          if (cellModel.color != null && cellModel.color!.isNotEmpty) {
            backgroundColor = CellColorHandler.getColorFromHex(cellModel.color);
          } else if (cellModel.isCalculated) {
            backgroundColor = AppColors.primaryLight.withAlpha(25);
          }

          return GestureDetector(
            // Add double-tap handler for cells to toggle edit mode
            onDoubleTap: isEditable
                ? null
                : () {
                    if (onDoubleTabHandler != null) {
                      onDoubleTabHandler!();
                    }
                  },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              color: backgroundColor,
              child: Text(
                cellModel.value ?? '',
                style: TextStyle(
                  color: cellModel.isCalculated
                      ? AppColors.primary
                      : Colors.black87,
                ),
              ),
            ),
          );
        } else {
          return GestureDetector(
            // Add double-tap handler for empty cells too
            onDoubleTap: isEditable
                ? null
                : () {
                    if (onDoubleTabHandler != null) {
                      onDoubleTabHandler!();
                    }
                  },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: const Text(''),
            ),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget? buildEditWidget(DataGridRow row, RowColumnIndex rowColumnIndex,
      GridColumn column, CellSubmit submitCell) {
    if (column.columnName == 'itemName') {
      return null;
    }

    final rowCellData = row.getCells().first.value as RowCellData;
    final rowIndex = rowCellData.rowIndex;

    final columnIndex = int.parse(column.columnName.replaceAll('column', ''));

    final cell = row
        .getCells()
        .firstWhere(
          (cell) => cell.columnName == column.columnName,
          orElse: () =>
              DataGridCell<dynamic>(columnName: column.columnName, value: null),
        )
        .value as InventoryCellModel?;

    bool isCalculatedCell = cell != null && cell.isCalculated;

    String initialValue = '';
    String? cellColor;
    if (cell != null) {
      initialValue = cell.formula ?? cell.value ?? '';
      cellColor = cell.color;
    }

    final TextEditingController controller =
        TextEditingController(text: initialValue);

    Color? selectedColor =
        cellColor != null ? CellColorHandler.getColorFromHex(cellColor) : null;

    final FocusNode focusNode = FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus && !isCalculatedCell) {
        cellSubmitCallback(
          rowIndex,
          columnIndex,
          controller.text,
          selectedColor != null
              ? CellColorHandler.getHexFromColor(selectedColor)
              : null,
        );
        submitCell();
      }
    });

    return StatefulBuilder(
      builder: (context, setInnerState) {
        currentContext = context;

        String? colorHex = selectedColor != null
            ? CellColorHandler.getHexFromColor(selectedColor)
            : null;

        return Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) {
                  if (event is RawKeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter) {
                    if (!isCalculatedCell) {
                      cellSubmitCallback(
                        rowIndex,
                        columnIndex,
                        controller.text,
                        colorHex,
                      );
                    }
                    submitCell();
                  }
                },
                child: TextField(
                  autofocus: true,
                  focusNode: focusNode,
                  controller: controller,
                  enabled: !isCalculatedCell,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          BorderSide(color: AppColors.primary.withOpacity(0.5)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12, // Reduced padding since no icon
                    ),
                    fillColor: selectedColor,
                    filled: selectedColor != null,
                  ),
                  onSubmitted: (value) {
                    if (!isCalculatedCell) {
                      cellSubmitCallback(
                        rowIndex,
                        columnIndex,
                        value,
                        colorHex,
                      );
                    }
                    submitCell();
                  },
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddRowsDialog(int afterRowIndex) {
    if (currentContext == null || addMultipleCalculationRowsCallback == null)
      return;

    final TextEditingController controller = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: currentContext!,
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
                  addMultipleCalculationRowsCallback!(afterRowIndex, rowCount);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    return isEditable && column.columnName != 'itemName';
  }
}
