import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';

class RowMapping {
  final String rowId;
  final int oldRowIndex;
  final int newRowIndex;

  RowMapping({
    required this.rowId,
    required this.oldRowIndex,
    required this.newRowIndex,
  });

  Map<String, dynamic> toJson() => {
        'rowId': rowId,
        'oldRowIndex': oldRowIndex,
        'newRowIndex': newRowIndex,
      };
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({
    required this.isValid,
    required this.errors,
  });
}

class FormulaUpdate {
  final String cellId;
  final String newFormula;
  final String value;
  final String? color;

  FormulaUpdate({
    required this.cellId,
    required this.newFormula,
    required this.value,
    this.color,
  });

  Map<String, dynamic> toJson() => {
        'cellId': cellId,
        'formula': newFormula,
        'value': value,
        'color': color,
      };
}

class EnhancedRowReorderHandler {
  static List<RowMapping> calculateSequentialMappings(
    List<RowModel> currentRows,
    String movedRowId,
    int oldIndex,
    int newIndex,
  ) {
    // Create a working copy and sort by current row index
    final sortedRows = List<RowModel>.from(currentRows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    // Remove the moved row and insert at new position
    final movedRow = sortedRows.removeAt(oldIndex);
    sortedRows.insert(newIndex, movedRow);

    // Generate sequential mappings for ALL rows that need updating
    final mappings = <RowMapping>[];

    for (int i = 0; i < sortedRows.length; i++) {
      final newRowIndex = i + 1; // 1-based indexing
      final row = sortedRows[i];

      // Only create mapping if row index actually changed
      if (newRowIndex != row.rowIndex) {
        mappings.add(RowMapping(
          rowId: row.id,
          oldRowIndex: row.rowIndex,
          newRowIndex: newRowIndex,
        ));
      }
    }

    print('Generated ${mappings.length} row mappings for reordering');
    return mappings;
  }

  static ValidationResult validateRowMappings(
    List<RowMapping> mappings,
    List<RowModel> allRows,
  ) {
    final errors = <String>[];

    // Check for duplicate new indices
    final newIndices = mappings.map((m) => m.newRowIndex).toList();
    final duplicates = <int>[];

    for (int i = 0; i < newIndices.length; i++) {
      for (int j = i + 1; j < newIndices.length; j++) {
        if (newIndices[i] == newIndices[j] &&
            !duplicates.contains(newIndices[i])) {
          duplicates.add(newIndices[i]);
        }
      }
    }

    if (duplicates.isNotEmpty) {
      errors.add('Duplicate row indices: ${duplicates.join(', ')}');
    }

    // Check if all row IDs exist
    final allRowIds = allRows.map((r) => r.id).toSet();
    final invalidRowIds = mappings
        .map((m) => m.rowId)
        .where((id) => !allRowIds.contains(id))
        .toList();

    if (invalidRowIds.isNotEmpty) {
      errors.add('Invalid row IDs: ${invalidRowIds.join(', ')}');
    }

    // Check for valid row index range
    final maxIndex = allRows.length;
    final invalidIndices = mappings
        .map((m) => m.newRowIndex)
        .where((index) => index < 1 || index > maxIndex)
        .toList();

    if (invalidIndices.isNotEmpty) {
      errors.add(
          'Invalid row indices (must be 1-$maxIndex): ${invalidIndices.join(', ')}');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  static List<FormulaUpdate> calculateFormulaUpdates(
    SheetModel sheet,
    List<RowMapping> rowMappings,
  ) {
    final updates = <FormulaUpdate>[];

    // Create a mapping of old row index to new row index
    final indexMappings = <int, int>{};
    for (final mapping in rowMappings) {
      indexMappings[mapping.oldRowIndex] = mapping.newRowIndex;
    }

    // Process all cells with formulas
    for (final row in sheet.rows) {
      for (final cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          final newFormula =
              _updateFormulaReferences(cell.formula!, indexMappings);

          if (newFormula != cell.formula) {
            updates.add(FormulaUpdate(
              cellId: cell.id,
              newFormula: newFormula,
              value: cell.value ?? '',
              color: cell.color,
            ));
          }
        }
      }
    }

    print('Generated ${updates.length} formula updates for row reordering');
    return updates;
  }

  static String _updateFormulaReferences(
    String formula,
    Map<int, int> indexMappings,
  ) {
    // Pattern to match cell references like A1, B2, AA34, Quantity1, Name2
    final cellReferencePattern = RegExp(r'([A-Za-z]+)(\d+)');

    return formula.replaceAllMapped(cellReferencePattern, (match) {
      final columnRef = match.group(1)!;
      final rowRef = match.group(2)!;

      try {
        final oldRowIndex = int.parse(rowRef);

        // Check if this row index was remapped
        if (indexMappings.containsKey(oldRowIndex)) {
          final newRowIndex = indexMappings[oldRowIndex]!;
          return '$columnRef$newRowIndex';
        }

        // No change needed
        return match.group(0)!;
      } catch (e) {
        // If parsing fails, return original
        return match.group(0)!;
      }
    });
  }

  // static String _getColumnLetter(int index) {
  //   // Match the UI's _getColumnLetter method
  //   if (index == 0) return "Quantity";
  //   if (index == 1) return "Name";

  //   String columnLetter = '';
  //   int adjustedIndex = index - 2;
  //   while (adjustedIndex >= 0) {
  //     columnLetter =
  //         String.fromCharCode((adjustedIndex % 26) + 65) + columnLetter;
  //     adjustedIndex = (adjustedIndex ~/ 26) - 1;
  //   }
  //   return columnLetter;
  // }
}
