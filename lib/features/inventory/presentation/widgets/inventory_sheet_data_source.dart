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
  final Function(String rowId, int oldIndex, int newIndex)?
      onRowReorder; // Add row reorder callback

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
    this.onRowReorder, // Add to constructor
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
          return _buildRowHeaderCell(cell.value as RowCellData);
        } else if (cell.value is InventoryCellModel) {
          return _buildDataCell(cell.value as InventoryCellModel);
        } else {
          return _buildEmptyCell();
        }
      }).toList(),
    );
  }

  Widget _buildRowHeaderCell(RowCellData rowData) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary.withOpacity(0.08),
            AppColors.secondary.withOpacity(0.04),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: AppColors.secondary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isEditable && onRowReorder != null)
                _buildReorderHandle(rowData),
              if (isEditable) _buildRowActionMenu(rowData),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReorderHandle(RowCellData rowData) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
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
      child: ReorderableDragStartListener(
        index: _getRowDisplayIndex(rowData.rowIndex),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.drag_handle_rounded,
            size: 16,
            color: AppColors.secondary.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  int _getRowDisplayIndex(int rowIndex) {
    final sortedRows = List<InventoryRowModel>.from(sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    return sortedRows.indexWhere((row) => row.rowIndex == rowIndex);
  }

  Widget _buildDataCell(InventoryCellModel cellModel) {
    final backgroundColor = _getCellBackgroundColor(cellModel);
    final textColor = _getCellTextColor(cellModel);

    return GestureDetector(
      onDoubleTap: isEditable ? null : onDoubleTabHandler,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: _buildCellContent(cellModel, textColor),
      ),
    );
  }

  Widget _buildEmptyCell() {
    return GestureDetector(
      onDoubleTap: isEditable ? null : onDoubleTabHandler,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: const Text(''),
      ),
    );
  }

  Widget _buildCellContent(InventoryCellModel cellModel, Color textColor) {
    final value = cellModel.value ?? '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (cellModel.formula != null)
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.functions,
              size: 12,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight:
                  cellModel.isCalculated ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color? _getCellBackgroundColor(InventoryCellModel cellModel) {
    if (cellModel.color != null && cellModel.color!.isNotEmpty) {
      return CellColorHandler.getColorFromHex(cellModel.color);
    } else if (cellModel.isCalculated) {
      return AppColors.primaryLight.withOpacity(0.15);
    }
    return null;
  }

  Color _getCellTextColor(InventoryCellModel cellModel) {
    if (cellModel.isCalculated) {
      return AppColors.primary;
    }
    return Colors.black87;
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
        .value as InventoryCellModel?;

    return _buildModernEditWidget(
      cell,
      rowIndex,
      columnIndex,
      submitCell,
    );
  }

  Widget _buildModernEditWidget(
    InventoryCellModel? cell,
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
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
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
            borderSide: BorderSide(
              color: AppColors.primary.withOpacity(0.5),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
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

  Widget _buildRowActionMenu(RowCellData rowData) {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.more_vert,
            size: 16,
            color: AppColors.secondary,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        onSelected: (value) => _handleRowAction(value, rowData),
        itemBuilder: (context) => [
          _buildPopupMenuItem(
            'move_up',
            Icons.keyboard_arrow_up,
            'Move Up',
            AppColors.primary,
          ),
          _buildPopupMenuItem(
            'move_down',
            Icons.keyboard_arrow_down,
            'Move Down',
            AppColors.primary,
          ),
          const PopupMenuDivider(),
          _buildPopupMenuItem(
            'add_calculation',
            Icons.add_circle_outline,
            'Add Calculation Row After',
            Colors.green,
          ),
          _buildPopupMenuItem(
            'delete',
            Icons.delete_outline,
            'Delete Row',
            Colors.red,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleRowAction(String action, RowCellData rowData) {
    switch (action) {
      case 'add_calculation':
        if (addMultipleCalculationRowsCallback != null) {
          _showAddRowsDialog(rowData.rowIndex);
        } else {
          addCalculationRowCallback(rowData.rowIndex);
        }
        break;
      case 'delete':
        deleteRowCallback(rowData.rowId);
        break;
      case 'move_up':
        _moveRowUp(rowData);
        break;
      case 'move_down':
        _moveRowDown(rowData);
        break;
    }
  }

  void _moveRowUp(RowCellData rowData) {
    final sortedRows = List<InventoryRowModel>.from(sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    final currentIndex =
        sortedRows.indexWhere((row) => row.id == rowData.rowId);

    if (currentIndex > 0 && onRowReorder != null) {
      onRowReorder!(rowData.rowId, currentIndex, currentIndex - 1);
    }
  }

  void _moveRowDown(RowCellData rowData) {
    final sortedRows = List<InventoryRowModel>.from(sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    final currentIndex =
        sortedRows.indexWhere((row) => row.id == rowData.rowId);

    if (currentIndex < sortedRows.length - 1 && onRowReorder != null) {
      onRowReorder!(rowData.rowId, currentIndex, currentIndex + 1);
    }
  }
}
