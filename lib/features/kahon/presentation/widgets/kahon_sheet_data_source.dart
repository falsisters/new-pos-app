import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_handler_new.dart';
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
  static BuildContext? currentContext;

  final SheetModel sheet;
  final List<KahonItemModel> kahonItems;
  final bool isEditable;
  final Function(int rowIndex, int columnIndex, String value, String? colorHex)
      cellSubmitCallback;
  final Function(int afterRowIndex) addCalculationRowCallback;
  final Function(String rowId) deleteRowCallback;
  final FormulaHandler formulaHandler;
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
    final sortedRows = List<RowModel>.from(sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    return sortedRows.map((row) {
      final cells = <DataGridCell>[
        _buildItemNameCell(row, sortedRows),
        ..._buildDataCells(row),
      ];
      return DataGridRow(cells: cells);
    }).toList();
  }

  DataGridCell _buildItemNameCell(RowModel row, List<RowModel> sortedRows) {
    String itemNumber = '';
    if (row.isItemRow && row.itemId != null) {
      itemNumber = (sortedRows.indexOf(row) + 1).toString();
    } else if (!row.isItemRow) {
      itemNumber = row.rowIndex.toString();
    }

    return DataGridCell<RowCellData>(
      columnName: 'itemName',
      value: RowCellData(
        text: itemNumber,
        rowId: row.id,
        rowIndex: row.rowIndex,
        isItemRow: row.isItemRow,
      ),
    );
  }

  List<DataGridCell> _buildDataCells(RowModel row) {
    final cellMap = <int, CellModel>{};
    for (var cell in row.cells) {
      cellMap[cell.columnIndex] = cell;
    }

    return List.generate(sheet.columns, (i) {
      return DataGridCell<CellModel?>(
        columnName: 'column$i',
        value: cellMap[i],
      );
    });
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'itemName') {
          return _buildItemNameWidget(cell.value as RowCellData);
        } else if (cell.value is CellModel) {
          return _buildCellWidget(cell.value as CellModel);
        } else {
          return _buildEmptyCell();
        }
      }).toList(),
    );
  }

  Widget _buildItemNameWidget(RowCellData rowData) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.05),
        border: Border(
          right: BorderSide(
              color: AppColors.primaryLight.withOpacity(0.3), width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
              ),
              child: Text(
                rowData.text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                  fontSize: 13,
                ),
              ),
            ),
            if (isEditable) _buildRowActionMenu(rowData),
          ],
        ),
      ),
    );
  }

  Widget _buildRowActionMenu(RowCellData rowData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert_rounded,
          size: 18,
          color: AppColors.secondary.withOpacity(0.7),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (value) {
          if (value == 'add_calculation') {
            addCalculationRowCallback(rowData.rowIndex);
          } else if (value == 'delete') {
            deleteRowCallback(rowData.rowId);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'add_calculation',
            child: Row(
              children: const [
                Icon(Icons.add_circle_outline,
                    color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Text('Add Calculation Row(s) After'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: const [
                Icon(Icons.delete_outline, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Text('Delete Row', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCellWidget(CellModel cellModel) {
    final backgroundColor =
        cellModel.color != null && cellModel.color!.isNotEmpty
            ? CellColorHandler.getColorFromHex(cellModel.color)
            : (cellModel.isCalculated
                ? AppColors.primaryLight.withOpacity(0.1)
                : null);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: cellModel.isCalculated
              ? AppColors.primary.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          cellModel.value ?? '',
          style: TextStyle(
            color: cellModel.isCalculated ? AppColors.primary : Colors.black87,
            fontWeight:
                cellModel.isCalculated ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmptyCell() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text('', textAlign: TextAlign.center),
      ),
    );
  }

  @override
  Widget? buildEditWidget(DataGridRow row, RowColumnIndex rowColumnIndex,
      GridColumn column, CellSubmit submitCell) {
    if (column.columnName == 'itemName') return null;

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

    return _buildModernEditWidget(
      cell,
      rowIndex,
      columnIndex,
      submitCell,
    );
  }

  Widget _buildModernEditWidget(
    CellModel? cell,
    int rowIndex,
    int columnIndex,
    CellSubmit submitCell,
  ) {
    final isCalculatedCell = cell?.isCalculated ?? false;
    final initialValue = cell?.formula ?? cell?.value ?? '';
    final cellColor = cell?.color;

    final controller = TextEditingController(text: initialValue);
    final focusNode = FocusNode();

    Color? selectedColor =
        cellColor != null ? CellColorHandler.getColorFromHex(cellColor) : null;

    // Add focus listener like the working inventory sheet
    focusNode.addListener(() {
      if (!focusNode.hasFocus && !isCalculatedCell) {
        _submitCellEdit(
            controller.text, selectedColor, rowIndex, columnIndex, submitCell);
      }
    });

    return StatefulBuilder(
      builder: (context, setInnerState) {
        currentContext = context;

        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildEditTextField(
            controller,
            focusNode,
            selectedColor,
            isCalculatedCell,
            rowIndex,
            columnIndex,
            submitCell,
          ),
        );
      },
    );
  }

  Widget _buildEditTextField(
    TextEditingController controller,
    FocusNode focusNode,
    Color? selectedColor,
    bool isCalculatedCell,
    int rowIndex,
    int columnIndex,
    CellSubmit submitCell,
  ) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          if (!isCalculatedCell) {
            _submitCellEdit(controller.text, selectedColor, rowIndex,
                columnIndex, submitCell);
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
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isCalculatedCell ? AppColors.primary : Colors.black87,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: AppColors.primary.withOpacity(0.6), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          fillColor: selectedColor ??
              (isCalculatedCell
                  ? AppColors.primaryLight.withOpacity(0.1)
                  : Colors.white),
          filled: true,
        ),
        onSubmitted: (value) {
          if (!isCalculatedCell) {
            _submitCellEdit(
                value, selectedColor, rowIndex, columnIndex, submitCell);
          }
          submitCell();
        },
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }

  void _submitCellEdit(
    String value,
    Color? selectedColor,
    int rowIndex,
    int columnIndex,
    CellSubmit submitCell,
  ) {
    final colorHex = selectedColor != null
        ? CellColorHandler.getHexFromColor(selectedColor)
        : null;

    cellSubmitCallback(rowIndex, columnIndex, value, colorHex);
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
