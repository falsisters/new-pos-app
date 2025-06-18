import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_sheet_data_source.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/row_reorder_change.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';

class InventorySheetState with ChangeNotifier {
  final InventorySheetModel sheet;
  final TickerProvider tickerProvider;

  InventorySheetState({
    required this.sheet,
    required this.tickerProvider,
  }) {
    _initializeAnimations();
  }

  // Controllers and Animation
  final DataGridController _dataGridController = DataGridController();
  late AnimationController _editModeAnimationController;
  late Animation<double> _editModeScaleAnimation;
  late Animation<Color?> _editModeBorderColorAnimation;

  // Data Source
  InventorySheetDataSource? _dataSource;

  // State Variables
  bool _isEditable = false;
  bool _isLoading = false;

  // Selection State
  int? _selectedRowIndex;
  int? _selectedColumnIndex;
  InventoryCellModel? _selectedCell;
  String? _selectedCellValue;
  String? _selectedCellColorHex;

  // Pending Changes
  final Map<String, CellChange> _pendingChanges = {};
  final Map<String, RowReorderChange> _pendingRowReorders = {};

  // Getters
  DataGridController get dataGridController => _dataGridController;
  InventorySheetDataSource? get dataSource => _dataSource;
  bool get isEditable => _isEditable;
  bool get isLoading => _isLoading;
  AnimationController get editModeAnimationController =>
      _editModeAnimationController;
  Animation<double> get editModeScaleAnimation => _editModeScaleAnimation;
  Animation<Color?> get editModeBorderColorAnimation =>
      _editModeBorderColorAnimation;

  int? get selectedRowIndex => _selectedRowIndex;
  int? get selectedColumnIndex => _selectedColumnIndex;
  InventoryCellModel? get selectedCell => _selectedCell;
  String? get selectedCellValue => _selectedCellValue;
  String? get selectedCellColorHex => _selectedCellColorHex;

  Map<String, CellChange> get pendingChanges => _pendingChanges;
  Map<String, RowReorderChange> get pendingRowReorders => _pendingRowReorders;

  int get totalPendingChanges =>
      _pendingChanges.length + _pendingRowReorders.length;

  void _initializeAnimations() {
    _editModeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: tickerProvider,
    );

    _editModeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _editModeAnimationController,
      curve: Curves.easeInOut,
    ));

    _editModeBorderColorAnimation = ColorTween(
      begin: AppColors.primary.withOpacity(0.3),
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _editModeAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  // State Management Methods
  void setDataSource(InventorySheetDataSource dataSource) {
    _dataSource = dataSource;
    notifyListeners();
  }

  void toggleEditMode() {
    _isEditable = !_isEditable;

    if (_isEditable) {
      _editModeAnimationController.forward();
    } else {
      _editModeAnimationController.reverse();
    }

    notifyListeners();
  }

  void setEditMode(bool editable) {
    _isEditable = editable;

    if (_isEditable) {
      _editModeAnimationController.forward();
    } else {
      _editModeAnimationController.reverse();
    }

    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateSelectedCell({
    int? rowIndex,
    int? columnIndex,
    InventoryCellModel? cell,
    String? value,
    String? colorHex,
  }) {
    _selectedRowIndex = rowIndex;
    _selectedColumnIndex = columnIndex;
    _selectedCell = cell;
    _selectedCellValue = value;
    _selectedCellColorHex = colorHex;
    notifyListeners();
  }

  void addPendingCellChange(String key, CellChange change) {
    _pendingChanges[key] = change;
    notifyListeners();
  }

  void addPendingRowReorder(String key, RowReorderChange change) {
    _pendingRowReorders[key] = change;
    notifyListeners();
  }

  void clearPendingChanges() {
    _pendingChanges.clear();
    notifyListeners();
  }

  void clearPendingRowReorders() {
    _pendingRowReorders.clear();
    notifyListeners();
  }

  void clearAllPendingChanges() {
    _pendingChanges.clear();
    _pendingRowReorders.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _editModeAnimationController.dispose();
    super.dispose();
  }
}
