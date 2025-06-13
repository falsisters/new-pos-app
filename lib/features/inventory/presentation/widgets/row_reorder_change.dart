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
  String toString() {
    return 'RowReorderChange(rowId: $rowId, oldRowIndex: $oldRowIndex, newRowIndex: $newRowIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RowReorderChange &&
        other.rowId == rowId &&
        other.oldRowIndex == oldRowIndex &&
        other.newRowIndex == newRowIndex;
  }

  @override
  int get hashCode {
    return rowId.hashCode ^ oldRowIndex.hashCode ^ newRowIndex.hashCode;
  }
}
