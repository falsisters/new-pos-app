class CellChange {
  final bool isUpdate;
  final String? cellId;
  final String rowId;
  final int columnIndex;
  final String displayValue;
  final String? formula;

  CellChange({
    required this.isUpdate,
    this.cellId,
    this.rowId = '',
    this.columnIndex = 0,
    required this.displayValue,
    this.formula,
  });
}
