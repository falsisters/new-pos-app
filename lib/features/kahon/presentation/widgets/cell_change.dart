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
    required this.rowId,
    required this.columnIndex,
    required this.displayValue,
    this.formula,
  });

  @override
  String toString() {
    return 'CellChange{isUpdate: $isUpdate, cellId: $cellId, rowId: $rowId, '
        'columnIndex: $columnIndex, displayValue: $displayValue, formula: $formula}';
  }
}
