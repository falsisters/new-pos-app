/// A simple class to hold cell reference information
class CellReference {
  final int columnIndex;
  final int rowIndex;

  CellReference(this.columnIndex, this.rowIndex);

  @override
  String toString() {
    return 'CellReference(columnIndex: $columnIndex, rowIndex: $rowIndex)';
  }
}
