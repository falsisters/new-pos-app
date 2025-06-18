import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_new.dart'; // For RowReorderOperation

class KahonSheetState {
  // Core state variables
  bool _isEditable = false;
  bool _isLoading = false;
  int? _selectedRowIndex;
  int? _selectedColumnIndex;
  String? _selectedCellValue;
  String? _selectedCellColorHex;

  // Controllers
  late DataGridController _dataGridController;
  late TextEditingController _cellValueController;

  // Animation controllers
  late AnimationController _editModeController;
  late AnimationController _scaleController;
  late AnimationController _borderController;

  // Animations
  late Animation<double> _editModeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;

  // Pending changes tracking
  final Map<String, CellChange> _pendingChanges = {};
  List<RowReorderOperation> _pendingRowReorderOperations = [];

  // Dependencies tracking
  final Map<String, Set<String>> _formulaDependencies = {};

  KahonSheetState() {
    _dataGridController = DataGridController();
    _cellValueController = TextEditingController();
  }

  // Getters
  bool get isEditable => _isEditable;
  bool get isLoading => _isLoading;
  int? get selectedRowIndex => _selectedRowIndex;
  int? get selectedColumnIndex => _selectedColumnIndex;
  String? get selectedCellValue => _selectedCellValue;
  String? get selectedCellColorHex => _selectedCellColorHex;

  DataGridController get dataGridController => _dataGridController;
  TextEditingController get cellValueController => _cellValueController;

  Animation<double> get editModeAnimation => _editModeAnimation;
  Animation<double> get scaleAnimation => _scaleAnimation;
  Animation<Color?> get borderColorAnimation => _borderColorAnimation;

  Map<String, CellChange> get pendingChanges => _pendingChanges;
  List<RowReorderOperation> get pendingRowReorderOperations =>
      _pendingRowReorderOperations;
  Map<String, Set<String>> get formulaDependencies => _formulaDependencies;

  // Helper getters
  bool get hasPendingChanges =>
      _pendingChanges.isNotEmpty || _pendingRowReorderOperations.isNotEmpty;
  int get totalPendingChangesCount =>
      _pendingChanges.length + _pendingRowReorderOperations.length;

  // Setters
  void setEditable(bool value) => _isEditable = value;
  void setLoading(bool value) => _isLoading = value;

  void setSelectedCell({
    int? rowIndex,
    int? columnIndex,
    String? value,
    String? colorHex,
  }) {
    _selectedRowIndex = rowIndex;
    _selectedColumnIndex = columnIndex;
    _selectedCellValue = value;
    _selectedCellColorHex = colorHex;
    _cellValueController.text = value ?? '';
  }

  void clearSelectedCell() {
    _selectedRowIndex = null;
    _selectedColumnIndex = null;
    _selectedCellValue = null;
    _selectedCellColorHex = null;
    _cellValueController.clear();
  }

  // Animation initialization
  void initializeAnimations(TickerProvider vsync) {
    // Edit mode animation
    _editModeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: vsync,
    );
    _editModeAnimation = CurvedAnimation(
      parent: _editModeController,
      curve: Curves.easeInOutCubic,
    );

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Border color animation
    _borderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );
    _borderColorAnimation = ColorTween(
      begin: AppColors.primaryLight.withOpacity(0.2),
      end: AppColors.primary.withOpacity(0.6),
    ).animate(CurvedAnimation(
      parent: _borderController,
      curve: Curves.easeInOut,
    ));
  }

  // Animation control methods
  void startEditModeAnimations() {
    _editModeController.forward();
    _scaleController.forward();
    _borderController.forward();
  }

  void stopEditModeAnimations() {
    _editModeController.reverse();
    _scaleController.reverse();
    _borderController.reverse();
  }

  // Pending changes management
  void addPendingChange(String key, CellChange change) {
    _pendingChanges[key] = change;
  }

  void addPendingRowReorderOperation(RowReorderOperation operation) {
    _pendingRowReorderOperations.add(operation);
  }

  void clearPendingChanges() {
    _pendingChanges.clear();
    _pendingRowReorderOperations.clear();
  }

  // Dependency management
  void clearFormulaDependencies() {
    _formulaDependencies.clear();
  }

  void addFormulaDependency(String dependency, String cellKey) {
    if (!_formulaDependencies.containsKey(dependency)) {
      _formulaDependencies[dependency] = {};
    }
    _formulaDependencies[dependency]!.add(cellKey);
  }

  // Cleanup
  void dispose() {
    _editModeController.dispose();
    _scaleController.dispose();
    _borderController.dispose();
    _cellValueController.dispose();
    _dataGridController.dispose();
  }
}
