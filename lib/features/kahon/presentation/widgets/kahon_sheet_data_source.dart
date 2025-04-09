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
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_color_handler.dart';

class KahonSheetDataSource extends DataGridSource {
  // Static field to store the current BuildContext
  static BuildContext? currentContext;

  final SheetModel sheet;
  final List<KahonItemModel> kahonItems;
  final bool isEditable;
  final Function(int rowIndex, int columnIndex, String value, String? colorHex)
      cellSubmitCallback;
  final Function(int afterRowIndex) addCalculationRowCallback;
  final Function(String rowId) deleteRowCallback;
  final FormulaHandler formulaHandler;
  // Callback for when a cell is selected in edit mode
  final Function(
          int rowIndex, int columnIndex, String? value, String? colorHex)?
      onCellSelected;

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
    this.onCellSelected,
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
                        child: Text('Add Calculation Row(s) After'),
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

          // Get background color from cell model
          Color? backgroundColor;
          if (cellModel.color != null && cellModel.color!.isNotEmpty) {
            backgroundColor = CellColorHandler.getColorFromHex(cellModel.color);
          }

          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            color: backgroundColor ??
                (cellModel.isCalculated
                    ? AppColors.primaryLight.withAlpha(25)
                    : null),
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
        .value as CellModel?;

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
