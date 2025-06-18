import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_color_handler.dart';

class InventorySheetUIBuilder {
  static Widget buildModernHeader({
    required String sheetName,
    required bool isEditable,
    required VoidCallback onToggleEditMode,
    required VoidCallback onRefresh,
    required VoidCallback onAddRows,
    required VoidCallback onShowHelp,
    VoidCallback? onDeleteRow,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheetName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                if (!isEditable)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 16,
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Double-click to edit',
                          style: TextStyle(
                            color: AppColors.primary.withOpacity(0.8),
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
          _buildActionButtons(
            isEditable: isEditable,
            onToggleEditMode: onToggleEditMode,
            onRefresh: onRefresh,
            onAddRows: onAddRows,
            onShowHelp: onShowHelp,
            onDeleteRow: onDeleteRow,
          ),
        ],
      ),
    );
  }

  static Widget _buildActionButtons({
    required bool isEditable,
    required VoidCallback onToggleEditMode,
    required VoidCallback onRefresh,
    required VoidCallback onAddRows,
    required VoidCallback onShowHelp,
    VoidCallback? onDeleteRow,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        buildModernActionButton(
          icon: Icons.refresh,
          label: 'Refresh',
          onPressed: onRefresh,
          color: AppColors.secondary,
        ),
        buildModernActionButton(
          icon: isEditable ? Icons.visibility : Icons.edit,
          label: isEditable ? 'View Mode' : 'Edit Mode',
          onPressed: onToggleEditMode,
          color: isEditable ? Colors.orange : AppColors.primary,
          isPrimary: true,
        ),
        buildModernActionButton(
          icon: Icons.add,
          label: 'Add Rows',
          onPressed: onAddRows,
          color: Colors.green,
        ),
        buildModernActionButton(
          icon: Icons.help_outline,
          label: 'Help',
          onPressed: onShowHelp,
          color: Colors.blue,
        ),
        if (isEditable && onDeleteRow != null)
          buildModernActionButton(
            icon: Icons.delete,
            label: 'Delete',
            onPressed: onDeleteRow,
            color: Colors.red,
          ),
      ],
    );
  }

  static Widget buildModernActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isPrimary = false,
  }) {
    return Material(
      elevation: isPrimary ? 6 : 3,
      shadowColor: color.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildEditControlsPanel({
    required bool isEditable,
    required int totalPendingChanges,
    required int pendingRowReorders,
    required bool isLoading,
    required bool hasSelectedCell,
    required VoidCallback onSaveChanges,
    VoidCallback? onShowQuickFormulas,
    VoidCallback? onEraseCell,
    VoidCallback? onShowColorPicker,
  }) {
    if (!isEditable) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.02),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildPendingChangesIndicator(
              totalPendingChanges, pendingRowReorders),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasSelectedCell)
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (onShowQuickFormulas != null)
                        buildEditActionButton(
                          icon: Icons.functions,
                          label: 'Quick Formulas',
                          onPressed: onShowQuickFormulas,
                          color: Colors.blue,
                        ),
                      if (onEraseCell != null)
                        buildEditActionButton(
                          icon: Icons.clear,
                          label: 'Erase Cell',
                          onPressed: onEraseCell,
                          color: Colors.red,
                        ),
                      if (onShowColorPicker != null)
                        buildEditActionButton(
                          icon: Icons.color_lens,
                          label: 'Change Color',
                          onPressed: onShowColorPicker,
                          color: Colors.purple,
                        ),
                    ],
                  ),
                ),
              const SizedBox(width: 16),
              buildSaveButton(
                isLoading: isLoading,
                onPressed: onSaveChanges,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildPendingChangesIndicator(
      int totalPendingChanges, int pendingRowReorders) {
    if (totalPendingChanges == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pending_actions, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$totalPendingChanges unsaved change${totalPendingChanges == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (pendingRowReorders > 0)
                Text(
                  '$pendingRowReorders row position${pendingRowReorders == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: Colors.orange.shade600,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildEditActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Material(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildSaveButton({
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 6,
      shadowColor: AppColors.primary.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                const Icon(Icons.save, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                isLoading ? 'Saving...' : 'Save Changes',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<GridColumn> buildColumns(InventorySheetModel sheet) {
    List<GridColumn> columns = [];

    // Add row number column
    columns.add(
      GridColumn(
        columnName: 'itemName',
        label: Container(
          padding: const EdgeInsets.all(8),
          color: AppColors.primary.withAlpha(25),
          alignment: Alignment.center,
          child: const Text(
            'Row Number',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        width: 150,
      ),
    );

    // Add data columns
    for (int i = 0; i < sheet.columns; i++) {
      columns.add(
        GridColumn(
          columnName: 'column$i',
          width: 150,
          label: Container(
            padding: const EdgeInsets.all(8),
            color: AppColors.primary.withOpacity(0.1),
            alignment: Alignment.center,
            child: Text(
              _getColumnLetter(i),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      );
    }

    return columns;
  }

  static String _getColumnLetter(int index) {
    String columnLetter = '';
    int tempIndex = index;

    while (tempIndex >= 0) {
      columnLetter = String.fromCharCode((tempIndex % 26) + 65) + columnLetter;
      tempIndex = (tempIndex ~/ 26) - 1;
    }
    return columnLetter;
  }

  static Widget buildColorPickerDialog({
    required String? currentColorHex,
    required VoidCallback onRemoveColor,
    required Function(String colorHex) onSelectColor,
  }) {
    return Container(
      width: 320,
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose a color for this cell',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: CellColorHandler.colorPalette.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return buildColorOption(
                  color: null,
                  label: 'Remove Color',
                  icon: Icons.format_color_reset,
                  isSelected: currentColorHex == null,
                  onTap: onRemoveColor,
                );
              }

              final colorEntry =
                  CellColorHandler.colorPalette.entries.elementAt(index - 1);
              final colorHex =
                  CellColorHandler.getHexFromColor(colorEntry.value);
              final isSelected = currentColorHex == colorHex;

              return buildColorOption(
                color: colorEntry.value,
                label: colorEntry.key,
                isSelected: isSelected,
                onTap: () => onSelectColor(colorHex),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget buildColorOption({
    Color? color,
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: isSelected ? 4 : 2,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
              width: isSelected ? 3 : 1,
            ),
          ),
          child: Center(
            child: icon != null
                ? Icon(
                    icon,
                    color: Colors.grey[600],
                    size: 20,
                  )
                : Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
