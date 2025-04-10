import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_handler.dart';

class FormulaDependencyTest extends ConsumerStatefulWidget {
  const FormulaDependencyTest({Key? key}) : super(key: key);

  @override
  ConsumerState<FormulaDependencyTest> createState() =>
      _FormulaDependencyTestState();
}

class _FormulaDependencyTestState extends ConsumerState<FormulaDependencyTest> {
  late SheetModel _testSheet;
  late FormulaHandler _formulaHandler;
  Map<String, Set<String>> _formulaDependencies = {};
  Map<String, String> _cellValues = {};
  String _calculationLog = '';

  @override
  void initState() {
    super.initState();
    _createTestSheet();
    _formulaHandler = FormulaHandler(sheet: _testSheet);
    _buildFormulaDependencyMap();
    _logCellValues();
  }

  void _createTestSheet() {
    // Create a test sheet with chained formulas:
    // A1 = 5
    // B1 = 10
    // C1 = =A1+B1 (should be 15)
    // D1 = =C1*2 (should be 30)
    // E1 = =D1+A1 (should be 35)

    _testSheet = SheetModel(
      id: 'test_sheet',
      name: 'Test Sheet',
      columns: 5, // A to E
      kahonId: 'test_kahon',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rows: [
        RowModel(
          id: 'row1',
          sheetId: 'test_sheet',
          rowIndex: 1,
          isItemRow: false,
          itemId: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          cells: [
            CellModel(
              id: 'cell_A1',
              rowId: 'row1',
              columnIndex: 0, // Column A
              value: '5',
              formula: null,
              color: null,
              isCalculated: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            CellModel(
              id: 'cell_B1',
              rowId: 'row1',
              columnIndex: 1, // Column B
              value: '10',
              formula: null,
              color: null,
              isCalculated: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            CellModel(
              id: 'cell_C1',
              rowId: 'row1',
              columnIndex: 2, // Column C
              value: '15',
              formula: '=A1+B1',
              color: null,
              isCalculated: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            CellModel(
              id: 'cell_D1',
              rowId: 'row1',
              columnIndex: 3, // Column D
              value: '30',
              formula: '=C1*2',
              color: null,
              isCalculated: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            CellModel(
              id: 'cell_E1',
              rowId: 'row1',
              columnIndex: 4, // Column E
              value: '35',
              formula: '=D1+A1',
              color: null,
              isCalculated: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ],
        ),
      ],
    );
  }

  void _buildFormulaDependencyMap() {
    _formulaDependencies.clear();
    _addLog("Building formula dependency map...");

    for (var row in _testSheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          // Get cell references from formula
          Set<String> dependencies =
              _formulaHandler.extractCellReferencesFromFormula(cell.formula!);

          // For each cell this formula depends on, add this cell as a dependent
          for (String dependency in dependencies) {
            if (!_formulaDependencies.containsKey(dependency)) {
              _formulaDependencies[dependency] = {};
            }

            String cellKey = '${row.rowIndex}_${cell.columnIndex}';
            _formulaDependencies[dependency]!.add(cellKey);

            _addLog("Added dependency: $dependency -> $cellKey");
          }
        }
      }
    }

    _addLog('Dependency map built with ${_formulaDependencies.length} entries');
  }

  void _logCellValues() {
    _addLog("\nCurrent cell values:");
    _cellValues.clear();

    for (var row in _testSheet.rows) {
      for (var cell in row.cells) {
        String colLetter = _getColumnLetter(cell.columnIndex);
        String cellRef = '$colLetter${row.rowIndex}';
        _cellValues['${row.rowIndex}_${cell.columnIndex}'] = cell.value ?? '';
        _addLog(
            "$cellRef = ${cell.value ?? ''} ${cell.formula != null ? '(formula: ${cell.formula})' : ''}");
      }
    }
  }

  void _updateCell(int columnIndex, String newValue) {
    setState(() {
      _addLog("\nUpdating cell ${_getColumnLetter(columnIndex)}1 to $newValue");

      // Find the cell and update its value
      int rowIndex = _testSheet.rows[0].rowIndex; // Get the actual row index
      CellModel cell = _testSheet.rows[0].cells.firstWhere(
        (cell) => cell.columnIndex == columnIndex,
      );

      // Create updated cell
      CellModel updatedCell = CellModel(
        id: cell.id,
        rowId: cell.rowId,
        columnIndex: cell.columnIndex,
        value: newValue,
        formula: cell.formula,
        color: cell.color,
        isCalculated: cell.isCalculated,
        createdAt: cell.createdAt,
        updatedAt: DateTime.now(),
      );

      // Update sheet
      int cellIndex =
          _testSheet.rows[0].cells.indexWhere((c) => c.id == cell.id);
      _testSheet.rows[0].cells[cellIndex] = updatedCell;

      // Update formula handler
      _formulaHandler = FormulaHandler(sheet: _testSheet);

      // Process dependent cells
      Set<String> dependentCells = {};
      String cellKey = '${rowIndex}_${columnIndex}';
      String namedKey = '${_getColumnLetter(columnIndex)}$rowIndex';

      if (_formulaDependencies.containsKey(cellKey)) {
        dependentCells.addAll(_formulaDependencies[cellKey]!);
      }
      if (_formulaDependencies.containsKey(namedKey)) {
        dependentCells.addAll(_formulaDependencies[namedKey]!);
      }

      _addLog("Processing dependent cells: $dependentCells");

      // Process all dependent cells
      if (dependentCells.isNotEmpty) {
        Set<String> processed = {cellKey, namedKey};
        _processDependentCellsTest(dependentCells, processed);
      }

      // Log final values
      _logCellValues();
    });
  }

  void _processDependentCellsTest(
      Set<String> cellsToUpdate, Set<String> processedCells) {
    for (String cellKey in cellsToUpdate.toList()) {
      // Skip already processed cells to prevent infinite recursion
      if (processedCells.contains(cellKey)) {
        _addLog("Skipping already processed cell: $cellKey");
        continue;
      }

      _addLog("Processing dependent cell: $cellKey");
      processedCells.add(cellKey);

      // Parse the cell key to get row and column indices
      List<String> parts = cellKey.split('_');
      if (parts.length == 2) {
        int rowIndex = int.parse(parts[0]);
        int columnIndex = int.parse(parts[1]);

        // Find the cell that contains a formula
        var row = _testSheet.rows.firstWhere(
          (r) => r.rowIndex == rowIndex,
          orElse: () => throw Exception("Row not found: $rowIndex"),
        );

        var cell = row.cells.firstWhere(
          (c) => c.columnIndex == columnIndex,
          orElse: () =>
              throw Exception("Cell not found at column: $columnIndex"),
        );

        if (cell.formula == null || !cell.formula!.startsWith('=')) {
          _addLog("Cell doesn't contain a formula: $cellKey");
          continue;
        }

        try {
          _addLog("Recalculating formula: ${cell.formula}");

          // Recalculate formula using updated cell values
          String newValue = _formulaHandler.evaluateFormula(
              cell.formula!, rowIndex, columnIndex);

          _addLog("Formula result: $newValue (old value: ${cell.value})");

          // Update the cell
          if (newValue != cell.value) {
            int rowIdx = _testSheet.rows.indexWhere((r) => r.id == row.id);
            int cellIdx = _testSheet.rows[rowIdx].cells
                .indexWhere((c) => c.id == cell.id);

            // Create updated cell
            _testSheet.rows[rowIdx].cells[cellIdx] = CellModel(
              id: cell.id,
              rowId: cell.rowId,
              columnIndex: cell.columnIndex,
              value: newValue,
              formula: cell.formula,
              color: cell.color,
              isCalculated: true,
              createdAt: cell.createdAt,
              updatedAt: DateTime.now(),
            );

            // Rebuild formula handler with updated sheet
            _formulaHandler = FormulaHandler(sheet: _testSheet);

            // Find next level of dependencies
            Set<String> nextDependents = {};

            String thisCellKey = '${rowIndex}_${columnIndex}';
            String namedKey = '${_getColumnLetter(columnIndex)}$rowIndex';

            if (_formulaDependencies.containsKey(thisCellKey)) {
              nextDependents.addAll(_formulaDependencies[thisCellKey]!);
            }
            if (_formulaDependencies.containsKey(namedKey)) {
              nextDependents.addAll(_formulaDependencies[namedKey]!);
            }

            // Remove already processed cells
            nextDependents = nextDependents.difference(processedCells);

            if (nextDependents.isNotEmpty) {
              _addLog("Processing next level dependencies: $nextDependents");
              _processDependentCellsTest(nextDependents, processedCells);
            }
          }
        } catch (e) {
          _addLog("Error recalculating formula: $e");
        }
      }
    }
  }

  void _addLog(String message) {
    setState(() {
      _calculationLog += message + "\n";
    });
  }

  String _getColumnLetter(int index) {
    const Map<int, String> columnNames = {
      0: "A",
      1: "B",
      2: "C",
      3: "D",
      4: "E"
    };
    return columnNames[index] ?? "?";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formula Dependency Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Test Sheet with Formulas:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
                'A1 = 5\nB1 = 10\nC1 = =A1+B1 (15)\nD1 = =C1*2 (30)\nE1 = =D1+A1 (35)'),
            const SizedBox(height: 16),

            const Text('Update Cells:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            // Buttons to update cells
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _updateCell(0, '10'), // A1 = 10
                  child: const Text('A1 = 10'),
                ),
                ElevatedButton(
                  onPressed: () => _updateCell(1, '20'), // B1 = 20
                  child: const Text('B1 = 20'),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Calculation Log:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            // Log output
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Text(_calculationLog),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
