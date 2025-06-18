class CellChange {
  final bool isUpdate;
  final String? cellId;
  final String rowId;
  final int columnIndex;
  final String displayValue;
  final String? formula;
  final String? color; // Hex color string
  final bool isCalculated;

  CellChange({
    required this.isUpdate,
    this.cellId,
    required this.rowId,
    required this.columnIndex,
    required this.displayValue,
    this.formula,
    this.color,
    this.isCalculated = false,
  });

  @override
  String toString() {
    return 'CellChange{isUpdate: $isUpdate, cellId: $cellId, rowId: $rowId, '
        'columnIndex: $columnIndex, displayValue: $displayValue, formula: $formula, color: $color, isCalculated: $isCalculated}';
  }
}
