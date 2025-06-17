import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';

class RowReorderValidation {
  final bool isValid;
  final List<String> errors;
  
  const RowReorderValidation({
    required this.isValid,
    required this.errors,
  });
}

class RowReorderValidator {
  static RowReorderValidation validateRowMappings(
    Map<String, int> newMappings,
    List<RowModel> allRows,
  ) {
    final errors = <String>[];
    
    // Get all new indices from mappings
    final newIndices = newMappings.values.toList();
    
    // Get indices of rows that won't change
    final unchangedIndices = allRows
        .where((row) => !newMappings.containsKey(row.id))
        .map((row) => row.rowIndex)
        .toList();
    
    // Combine all final indices
    final allFinalIndices = [...newIndices, ...unchangedIndices];
    
    // Check for duplicates
    final duplicates = <int>[];
    for (int i = 0; i < allFinalIndices.length; i++) {
      for (int j = i + 1; j < allFinalIndices.length; j++) {
        if (allFinalIndices[i] == allFinalIndices[j] && 
            !duplicates.contains(allFinalIndices[i])) {
          duplicates.add(allFinalIndices[i]);
        }
      }
    }
    
    if (duplicates.isNotEmpty) {
      errors.add('Duplicate indices detected: ${duplicates.join(', ')}');
    }
    
    // Check for invalid ranges
    final maxExpected = allRows.length;
    final outOfRange = allFinalIndices
        .where((index) => index < 1 || index > maxExpected)
        .toList();
    
    if (outOfRange.isNotEmpty) {
      errors.add('Indices out of valid range (1-$maxExpected): ${outOfRange.join(', ')}');
    }
    
    // Check for gaps (indices should be sequential)
    final sortedIndices = [...allFinalIndices]..sort();
    for (int i = 0; i < sortedIndices.length; i++) {
      if (sortedIndices[i] != i + 1) {
        errors.add('Gap detected in row sequence at index ${i + 1}, found ${sortedIndices[i]}');
        break;
      }
    }
    
    return RowReorderValidation(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
  
  static Map<String, int> calculateSequentialIndices(
    List<RowModel> reorderedRows,
    int startIndex,
  ) {
    final mappings = <String, int>{};
    
    for (int i = 0; i < reorderedRows.length; i++) {
      final newRowIndex = startIndex + i;
      final row = reorderedRows[i];
      
      // Only create mapping if row index actually changed
      if (newRowIndex != row.rowIndex) {
        mappings[row.id] = newRowIndex;
      }
    }
    
    return mappings;
  }

  /// Enhanced function to calculate proper row reordering without conflicts
  static Map<String, int> calculateRowReorderMappings(
    String draggedRowId,
    int draggedCurrentIndex,
    int targetIndex,
    List<RowModel> allRows,
  ) {
    final mappings = <String, int>{};

    // Sort rows by current row index
    final sortedRows = [...allRows]..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    print('Calculating row reorder mappings:');
    print('  draggedRowId: $draggedRowId');
    print('  draggedCurrentIndex: $draggedCurrentIndex');
    print('  targetIndex: $targetIndex');
    print('  totalRows: ${sortedRows.length}');

    // Find the dragged row
    final draggedRowIndex = sortedRows.indexWhere((r) => r.id == draggedRowId);
    if (draggedRowIndex == -1) {
      print('Could not find dragged row');
      return mappings;
    }

    // Validate target index
    if (targetIndex < 0 || targetIndex >= sortedRows.length) {
      print('Invalid target index: $targetIndex');
      return mappings;
    }

    // Don't reorder if dropping in the same position
    if (draggedRowIndex == targetIndex) {
      print('Row would end up in same position, no reordering needed');
      return mappings;
    }

    // Create new order by moving the dragged row
    final reorderedRows = [...sortedRows];
    final draggedRow = reorderedRows.removeAt(draggedRowIndex);
    reorderedRows.insert(targetIndex, draggedRow);

    // Recalculate all row indices sequentially to avoid conflicts
    final usedNewIndices = <int>{};

    // Assign new indices sequentially starting from 1
    for (int index = 0; index < reorderedRows.length; index++) {
      final row = reorderedRows[index];
      final newRowIndex = index + 1; // 1-based indexing
      final oldRowIndex = row.rowIndex;

      // Only create mapping if the row index actually changed
      if (newRowIndex != oldRowIndex) {
        mappings[row.id] = newRowIndex;
        print('Row ${row.id}: $oldRowIndex → $newRowIndex');
      }

      // Track used indices to detect duplicates
      if (usedNewIndices.contains(newRowIndex)) {
        print('Duplicate new index detected: $newRowIndex');
      }
      usedNewIndices.add(newRowIndex);
    }

    // Validation: ensure no duplicate new indices
    final newIndices = mappings.values.toList();
    final allNewIndices = [
      ...newIndices,
      ...sortedRows
          .where((r) => !mappings.containsKey(r.id))
          .map((r) => r.rowIndex),
    ];

    final duplicates = <int>[];
    for (int i = 0; i < allNewIndices.length; i++) {
      for (int j = i + 1; j < allNewIndices.length; j++) {
        if (allNewIndices[i] == allNewIndices[j] && !duplicates.contains(allNewIndices[i])) {
          duplicates.add(allNewIndices[i]);
        }
      }
    }

    if (duplicates.isNotEmpty) {
      print('Duplicate row indices would be created: $duplicates');
      mappings.clear();
      throw Exception('Row reordering would create duplicate indices');
    }

    print('Generated validated row mappings: $mappings');
    print('Used indices: ${usedNewIndices.toList()..sort()}');

    return mappings;
  }
}
