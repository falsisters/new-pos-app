import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/app/data/providers/home_provider.dart';
import 'package:falsisters_pos_android/features/app/presentation/widgets/sidebar_item.dart';
import 'package:falsisters_pos_android/features/auth/data/model/auth_state.dart';
import 'package:falsisters_pos_android/features/auth/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final cashier = ref.watch(cashierProvider);
    final drawerIndex = ref.watch(drawerIndexProvider);
    final isCollapsed = ref.watch(sidebarCollapseProvider);
    final permissions = cashier?.permissions ?? [];

    return authState.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(body: null),
      data: (AuthState state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isCollapsed ? 70 : 230,
          decoration: BoxDecoration(
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with hamburger menu
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          ref.read(sidebarCollapseProvider.notifier).toggle(),
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 24,
                      ),
                      tooltip:
                          isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Falsisters',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isCollapsed) ...[
                // Enhanced Falsisters title section (only when expanded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      // Logo/Icon container
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      Text(
                        'POS System',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Decorative divider
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],

              // Menu items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      horizontal: isCollapsed ? 8.0 : 16.0),
                  children: [
                    if (permissions.contains('SALES'))
                      SidebarItem(
                        title: 'Sales',
                        icon: Icons.point_of_sale,
                        isSelected: drawerIndex == 0,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(0),
                      ),
                    const SizedBox(height: 2),
                    if (permissions.contains('SALES'))
                      SidebarItem(
                        title: 'Orders',
                        icon: Icons.receipt_long,
                        isSelected: drawerIndex == 10,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(10),
                      ),
                    const SizedBox(height: 2),
                    if (permissions.contains('STOCKS'))
                      SidebarItem(
                        title: 'Stocks',
                        icon: Icons.inventory_2,
                        isSelected: drawerIndex == 2,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(2),
                      ),
                    const SizedBox(height: 2),
                    if (permissions.contains('DELIVERIES'))
                      SidebarItem(
                        title: 'Deliveries',
                        icon: Icons.local_shipping,
                        isSelected: drawerIndex == 1,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(1),
                      ),
                    const SizedBox(height: 2),
                    if (permissions.contains('KAHON'))
                      SidebarItem(
                        title: 'Expenses',
                        icon: Icons.payments,
                        isSelected: drawerIndex == 4,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(4),
                      ),
                    const SizedBox(height: 2),
                    if (permissions.contains('BILLS'))
                      SidebarItem(
                        title: 'Bills',
                        icon: Icons.description,
                        isSelected: drawerIndex == 8,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(8),
                      ),
                    const SizedBox(height: 2),
                    if (permissions.contains('ATTACHMENTS'))
                      SidebarItem(
                        title: 'Attachments',
                        icon: Icons.attachment,
                        isSelected: drawerIndex == 6,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(6),
                      ),
                    const SizedBox(height: 2),
                    if (permissions.contains('SALES_HISTORY'))
                      SidebarItem(
                        title: 'Sales History',
                        icon: Icons.analytics,
                        isSelected: drawerIndex == 7,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(7),
                      ),
                    const SizedBox(height: 2),
                    if (permissions.contains('KAHON'))
                      SidebarItem(
                        title: 'Kahon',
                        icon: Icons.account_balance_wallet,
                        isSelected: drawerIndex == 3,
                        isCollapsed: isCollapsed,
                        onTap: () =>
                            ref.read(drawerIndexProvider.notifier).setIndex(3),
                      ),
                    const SizedBox(height: 6),

                    // Bottom section divider
                    if (!isCollapsed)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    const SizedBox(height: 6),

                    SidebarItem(
                      title: 'Profile',
                      icon: Icons.account_circle,
                      isSelected: drawerIndex == 9,
                      isCollapsed: isCollapsed,
                      onTap: () =>
                          ref.read(drawerIndexProvider.notifier).setIndex(9),
                    ),
                    const SizedBox(height: 4),
                    SidebarItem(
                      title: 'Settings',
                      icon: Icons.settings,
                      isSelected: drawerIndex == 11,
                      isCollapsed: isCollapsed,
                      onTap: () =>
                          ref.read(drawerIndexProvider.notifier).setIndex(11),
                    ),
                    const SizedBox(height: 4),
                    SidebarItem(
                      title: 'Logout',
                      icon: Icons.exit_to_app,
                      isSelected: false,
                      isCollapsed: isCollapsed,
                      onTap: () => ref.read(authProvider.notifier).logout(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
