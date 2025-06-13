class RowReorderChange {
  final String rowId;
  final int oldRowIndex;
  final int newRowIndex;

  RowReorderChange({
    required this.rowId,
    required this.oldRowIndex,
    required this.newRowIndex,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RowReorderChange &&
          runtimeType == other.runtimeType &&
          rowId == other.rowId;

  @override
  int get hashCode => rowId.hashCode;
}
