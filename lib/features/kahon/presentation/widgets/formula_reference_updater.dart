import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_handler_new.dart';

class FormulaReferenceUpdate {
  final String cellId;
  final String newFormula;
  final String newValue;
  final int rowIndex;
  final int columnIndex;
  
  const FormulaReferenceUpdate({
    required this.cellId,
    required this.newFormula,
    required this.newValue,
    required this.rowIndex,
    required this.columnIndex,
  });
}

class FormulaReferenceUpdater {
  /// Calculate formula updates when rows are reordered
  static List<FormulaReferenceUpdate> calculateFormulaUpdates(
    SheetModel sheet,
    Map<int, int> rowIndexMappings, // oldRowIndex -> newRowIndex
  ) {
    final updates = <FormulaReferenceUpdate>[];
    
    if (rowIndexMappings.isEmpty) return updates;
    
    print('Calculating formula updates for row mappings: $rowIndexMappings');
    
    // Create formula handler for evaluation
    final formulaHandler = FormulaHandler(sheet: sheet);
    
    // Find all cells with formulas
    for (final row in sheet.rows) {
      for (final cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          // Check if this formula references any moved rows
          final updatedFormula = _updateFormulaReferences(cell.formula!, rowIndexMappings);
          
          if (updatedFormula != cell.formula) {
            // Formula was updated, calculate new value
            try {
              final newValue = formulaHandler.evaluateFormula(
                updatedFormula,
                row.rowIndex,
                cell.columnIndex,
              );
              
              updates.add(FormulaReferenceUpdate(
                cellId: cell.id,
                newFormula: updatedFormula,
                newValue: newValue,
                rowIndex: row.rowIndex,
                columnIndex: cell.columnIndex,
              ));
              
              print('Formula update: ${cell.formula} -> $updatedFormula = $newValue');
            } catch (e) {
              print('Error evaluating updated formula: $e');
              // Add update with error value
              updates.add(FormulaReferenceUpdate(
                cellId: cell.id,
                newFormula: updatedFormula,
                newValue: '#ERROR',
                rowIndex: row.rowIndex,
                columnIndex: cell.columnIndex,
              ));
            }
          }
        }
      }
    }
    
    print('Generated ${updates.length} formula updates');
    return updates;
  }
  
  /// Update formula references when rows are moved
  static String _updateFormulaReferences(
    String formula,
    Map<int, int> rowIndexMappings,
  ) {
    String updatedFormula = formula;
    
    // Pattern to match cell references like A1, B2, Quantity5, Name2, etc.
    final cellReferencePattern = RegExp(r'([A-Za-z]+)(\d+)');
    
    updatedFormula = updatedFormula.replaceAllMapped(cellReferencePattern, (match) {
      final column = match.group(1)!;
      final rowIndexStr = match.group(2)!;
      final rowIndex = int.parse(rowIndexStr);
      
      final newRowIndex = rowIndexMappings[rowIndex];
      if (newRowIndex != null) {
        return '$column$newRowIndex';
      }
      
      return match.group(0)!; // No change needed
    });
    
    // Handle range references like SUM(A1:A10)
    final rangePattern = RegExp(r'([A-Za-z]+)(\d+):([A-Za-z]+)(\d+)');
    
    updatedFormula = updatedFormula.replaceAllMapped(rangePattern, (match) {
      final startCol = match.group(1)!;
      final startRowStr = match.group(2)!;
      final endCol = match.group(3)!;
      final endRowStr = match.group(4)!;
      
      final startRow = int.parse(startRowStr);
      final endRow = int.parse(endRowStr);
      
      final newStartRow = rowIndexMappings[startRow] ?? startRow;
      final newEndRow = rowIndexMappings[endRow] ?? endRow;
      
      return '$startCol$newStartRow:$endCol$newEndRow';
    });
    
    return updatedFormula;
  }

  /// Find all cells that depend on moved rows
  static List<FormulaReferenceUpdate> findDependentFormulas(
    SheetModel sheet,
    List<int> movedRowIndices,
  ) {
    final dependentUpdates = <FormulaReferenceUpdate>[];
    final formulaHandler = FormulaHandler(sheet: sheet);
    
    print('Finding formulas dependent on moved rows: $movedRowIndices');
    
    for (final row in sheet.rows) {
      for (final cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          // Check if this formula references any of the moved rows
          if (_formulaReferencesMovedRows(cell.formula!, movedRowIndices)) {
            try {
              // Recalculate the formula with current sheet state
              final newValue = formulaHandler.evaluateFormula(
                cell.formula!,
                row.rowIndex,
                cell.columnIndex,
              );
              
              // Only add if value changed
              if (newValue != cell.value) {
                dependentUpdates.add(FormulaReferenceUpdate(
                  cellId: cell.id,
                  newFormula: cell.formula!,
                  newValue: newValue,
                  rowIndex: row.rowIndex,
                  columnIndex: cell.columnIndex,
                ));
                
                print('Dependent formula recalculated: ${cell.formula} = $newValue (was ${cell.value})');
              }
            } catch (e) {
              print('Error recalculating dependent formula: $e');
            }
          }
        }
      }
    }
    
    print('Found ${dependentUpdates.length} dependent formulas to update');
    return dependentUpdates;
  }

  /// Check if a formula references any of the moved rows
  static bool _formulaReferencesMovedRows(String formula, List<int> movedRowIndices) {
    final cellReferencePattern = RegExp(r'([A-Za-z]+)(\d+)');
    final matches = cellReferencePattern.allMatches(formula);
    
    for (final match in matches) {
      final rowIndex = int.parse(match.group(2)!);
      if (movedRowIndices.contains(rowIndex)) {
        return true;
      }
    }
    
    return false;
  }

  /// Create comprehensive formula updates for row reordering
  static List<FormulaReferenceUpdate> createComprehensiveUpdates(
    SheetModel sheet,
    Map<String, int> rowMappings, // rowId -> newRowIndex
  ) {
    final updates = <FormulaReferenceUpdate>[];
    
    // Create row index mappings
    final rowIndexMappings = <int, int>{};
    for (final entry in rowMappings.entries) {
      final rowModel = sheet.rows.firstWhere((r) => r.id == entry.key);
      rowIndexMappings[rowModel.rowIndex] = entry.value;
    }
    
    print('Creating comprehensive formula updates:');
    print('Row mappings: $rowMappings');
    print('Index mappings: $rowIndexMappings');
    
    // Get all affected row indices
    final movedRowIndices = rowIndexMappings.keys.toList();
    
    // First, update formulas that have row references that changed
    final referenceUpdates = calculateFormulaUpdates(sheet, rowIndexMappings);
    updates.addAll(referenceUpdates);
    
    // Then, find formulas that depend on moved rows (even if their references didn't change)
    final dependentUpdates = findDependentFormulas(sheet, movedRowIndices);
    
    // Merge dependent updates, avoiding duplicates
    for (final depUpdate in dependentUpdates) {
      final existingIndex = updates.indexWhere((u) => u.cellId == depUpdate.cellId);
      if (existingIndex == -1) {
        updates.add(depUpdate);
      } else {
        // If we already have an update for this cell, use the reference update (it has the new formula)
        // but verify the value is correct
        print('Merging updates for cell ${depUpdate.cellId}');
      }
    }
    
    print('Total comprehensive updates: ${updates.length}');
    return updates;
  }
}
