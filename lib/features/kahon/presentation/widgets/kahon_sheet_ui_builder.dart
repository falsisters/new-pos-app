import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_color_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_data_source.dart';

class KahonSheetUIBuilder {
  final BuildContext context;
  final VoidCallback onRefresh;
  final VoidCallback onToggleEditMode;
  final VoidCallback onAddCalculationRows;
  final VoidCallback onShowFormulaHelp;
  final VoidCallback onDeleteSelectedRow;
  final VoidCallback onSaveChanges;
  final VoidCallback onShowQuickFormulas;
  final VoidCallback onEraseSelectedCell;
  final VoidCallback onShowColorPicker;
  final Function(DataGridCellTapDetails) onCellTap;
  final Function(DataGridCellDoubleTapDetails) onCellDoubleTap;

  KahonSheetUIBuilder({
    required this.context,
    required this.onRefresh,
    required this.onToggleEditMode,
    required this.onAddCalculationRows,
    required this.onShowFormulaHelp,
    required this.onDeleteSelectedRow,
    required this.onSaveChanges,
    required this.onShowQuickFormulas,
    required this.onEraseSelectedCell,
    required this.onShowColorPicker,
    required this.onCellTap,
    required this.onCellDoubleTap,
  });

  Widget buildMainContainer({
    required String sheetName,
    required bool isEditable,
    required bool isLoading,
    required Animation<double> scaleAnimation,
    required Animation<Color?> borderColorAnimation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([scaleAnimation, borderColorAnimation]),
      builder: (context, _) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColorAnimation.value ??
                    AppColors.primaryLight.withValues(alpha: 0.2),
                width: isEditable ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  spreadRadius: 0,
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                if (isEditable)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    spreadRadius: 0,
                    blurRadius: 32,
                    offset: const Offset(0, 0),
                  ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget buildModernHeader({
    required String sheetName,
    required bool isEditable,
  }) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.03),
            Colors.white.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.table_chart_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        sheetName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (!isEditable)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.secondary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 14,
                          color: AppColors.secondary.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Double-tap to edit',
                          style: TextStyle(
                            color: AppColors.secondary.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          buildModernActionButtons(isEditable: isEditable),
        ],
      ),
    );
  }

  Widget buildModernActionButtons({required bool isEditable}) {
    return Row(
      children: [
        buildModernActionButton(
          icon: Icons.refresh_rounded,
          tooltip: 'Refresh Data',
          onPressed: () {
            HapticFeedback.lightImpact();
            onRefresh();
          },
        ),
        const SizedBox(width: 8),
        buildModernActionButton(
          icon: isEditable ? Icons.visibility_rounded : Icons.edit_rounded,
          tooltip: isEditable ? 'View Mode' : 'Edit Mode',
          onPressed: onToggleEditMode,
          isActive: isEditable,
          gradient: isEditable
              ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
              : null,
        ),
        if (isEditable) ...[
          const SizedBox(width: 8),
          buildModernActionButton(
            icon: Icons.add_circle_outline_rounded,
            tooltip: 'Add Calculation Rows',
            onPressed: () {
              HapticFeedback.lightImpact();
              onAddCalculationRows();
            },
          ),
          const SizedBox(width: 8),
          buildModernActionButton(
            icon: Icons.help_outline_rounded,
            tooltip: 'Formula Help',
            onPressed: () {
              HapticFeedback.lightImpact();
              onShowFormulaHelp();
            },
          ),
          const SizedBox(width: 8),
          buildModernActionButton(
            icon: Icons.delete_outline_rounded,
            tooltip: 'Delete Selected Row',
            onPressed: () {
              HapticFeedback.lightImpact();
              onDeleteSelectedRow();
            },
            gradient: [Colors.red.withOpacity(0.8), Colors.red],
          ),
        ],
      ],
    );
  }

  Widget buildModernActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isActive = false,
    List<Color>? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient != null
            ? LinearGradient(colors: gradient)
            : LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gradient != null
              ? Colors.transparent
              : AppColors.primaryLight.withOpacity(0.3),
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: (gradient?.first ?? Colors.black).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: gradient != null ? Colors.white : AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primaryLight.withOpacity(0.3),
            AppColors.primaryLight.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget buildDataGrid({
    required KahonSheetDataSource dataSource,
    required DataGridController controller,
    required List<GridColumn> columns,
  }) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SfDataGrid(
          source: dataSource,
          controller: controller,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columnWidthMode: ColumnWidthMode.auto,
          allowEditing: true,
          selectionMode: SelectionMode.multiple,
          navigationMode: GridNavigationMode.cell,
          frozenColumnsCount: 1,
          columns: columns,
          onCellTap: onCellTap,
          onCellDoubleTap: onCellDoubleTap,
          headerRowHeight: 56,
          rowHeight: 48,
        ),
      ),
    );
  }

  Widget buildModernEditControls({
    required bool hasPendingChanges,
    required int pendingChangesCount,
    required bool isLoading,
    required bool hasSelectedCell,
  }) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primary.withOpacity(0.02),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.primaryLight.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPendingChangesIndicator(
                hasPendingChanges: hasPendingChanges,
                count: pendingChangesCount,
              ),
              buildModernControlButtons(
                hasSelectedCell: hasSelectedCell,
                isLoading: isLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPendingChangesIndicator({
    required bool hasPendingChanges,
    required int count,
  }) {
    if (!hasPendingChanges) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.pending_actions_rounded,
              size: 16,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$count unsaved change${count == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModernControlButtons({
    required bool hasSelectedCell,
    required bool isLoading,
  }) {
    return Row(
      children: [
        if (hasSelectedCell) ...[
          buildModernControlButton(
            icon: Icons.functions_rounded,
            label: 'Formulas',
            onPressed: onShowQuickFormulas,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          buildModernControlButton(
            icon: Icons.clear_rounded,
            label: 'Clear',
            onPressed: onEraseSelectedCell,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          buildModernControlButton(
            icon: Icons.palette_rounded,
            label: 'Color',
            onPressed: onShowColorPicker,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 20),
        ],
        buildModernControlButton(
          icon: isLoading ? Icons.hourglass_empty : Icons.save_rounded,
          label: isLoading ? 'Saving...' : 'Save Changes',
          onPressed: isLoading ? null : onSaveChanges,
          color: AppColors.primary,
          isPrimary: true,
          isLoading: isLoading,
        ),
      ],
    );
  }

  Widget buildModernControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
    bool isPrimary = false,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary && onPressed != null
            ? LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPrimary
            ? null
            : (onPressed != null
                ? color.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: onPressed != null
              ? (isPrimary ? Colors.transparent : color.withOpacity(0.3))
              : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: isPrimary && onPressed != null
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPrimary ? Colors.white : color,
                      ),
                    ),
                  )
                else
                  Icon(
                    icon,
                    color: isPrimary ? Colors.white : color,
                    size: 20,
                  ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: onPressed != null
                        ? (isPrimary ? Colors.white : color)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<GridColumn> buildColumns({
    required int columnCount,
    required String Function(int) getColumnLetter,
  }) {
    final columns = <GridColumn>[
      GridColumn(
        columnName: 'itemName',
        label: buildColumnHeader('Row Number'),
        width: 150,
      ),
    ];

    for (int i = 0; i < columnCount; i++) {
      columns.add(
        GridColumn(
          columnName: 'column$i',
          width: 150,
          label: buildColumnHeader(getColumnLetter(i)),
        ),
      );
    }
    return columns;
  }

  Widget buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget buildSelectedCellInfo({
    required String cellAddress,
    required String? cellValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.edit_location_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Cell: $cellAddress',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                if (cellValue?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Value: $cellValue',
                    style: TextStyle(
                      color: AppColors.secondary.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showColorPicker({
    required int rowIndex,
    required int columnIndex,
    required String value,
    required String? currentColorHex,
    required Function(int, int, String, String?) onColorSelected,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Colors.white, AppColors.primary.withOpacity(0.02)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.palette_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Select Cell Color',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: CellColorHandler.colorPalette.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return InkWell(
                          onTap: () {
                            onColorSelected(rowIndex, columnIndex, value, null);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(Icons.format_color_reset_rounded),
                            ),
                          ),
                        );
                      }

                      final colorEntry = CellColorHandler.colorPalette.entries
                          .elementAt(index - 1);
                      final colorHex =
                          CellColorHandler.getHexFromColor(colorEntry.value);

                      return InkWell(
                        onTap: () {
                          onColorSelected(
                              rowIndex, columnIndex, value, colorHex);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorEntry.value,
                            border: Border.all(
                              color: Colors.black,
                              width: currentColorHex == colorHex ? 2 : 0.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildModernControlButton(
                      icon: Icons.close_rounded,
                      label: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showModernSnackBar({
    required String message,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 8,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
