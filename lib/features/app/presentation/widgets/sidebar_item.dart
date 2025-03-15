import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Function onTap;

  const SidebarItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.secondary : Colors.white,
              size: 32, // Increased icon size
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.secondary : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 20, // Increased text size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
