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
    final permissions = cashier?.permissions ?? [];

    return authState.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(body: null),
      data: (AuthState state) {
        return Drawer(
          backgroundColor: AppColors.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          width: 230,
          child: ListView(
            padding: const EdgeInsets.only(top: 32),
            children: [
              // Enhanced Falsisters title section
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
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
                    // Title with enhanced styling
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: Text(
                        'Falsisters',
                        style: TextStyle(
                          fontSize: 24,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
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
              const SizedBox(height: 12),

              // Menu items with reduced spacing
              if (permissions.contains('SALES'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Sales',
                      icon: Icons.point_of_sale,
                      isSelected: drawerIndex == 0,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(0)}),
                ),
              const SizedBox(height: 2),
              if (permissions.contains('SALES'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Orders',
                      icon: Icons.receipt_long,
                      isSelected: drawerIndex == 10,
                      onTap: () => {
                            ref.read(drawerIndexProvider.notifier).setIndex(10)
                          }),
                ),
              const SizedBox(height: 2),
              if (permissions.contains('STOCKS'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Stocks',
                      icon: Icons.inventory_2,
                      isSelected: drawerIndex == 2,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(2)}),
                ),
              const SizedBox(height: 2),
              if (permissions.contains('DELIVERIES'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Deliveries',
                      icon: Icons.local_shipping,
                      isSelected: drawerIndex == 1,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(1)}),
                ),
              const SizedBox(height: 2),
              if (permissions.contains('KAHON'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Expenses',
                      icon: Icons.payments,
                      isSelected: drawerIndex == 4,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(4)}),
                ),
              const SizedBox(height: 2),
              if (permissions.contains('BILLS'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Bills',
                      icon: Icons.description,
                      isSelected: drawerIndex == 8,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(8)}),
                ),
              const SizedBox(height: 2),
              if (permissions.contains('ATTACHMENTS'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Attachments',
                      icon: Icons.attachment,
                      isSelected: drawerIndex == 6,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(6)}),
                ),
              const SizedBox(height: 2),
              if (permissions.contains('SALES_HISTORY'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Sales History',
                      icon: Icons.analytics,
                      isSelected: drawerIndex == 7,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(7)}),
                ),
              const SizedBox(height: 2),
              if (permissions.contains('KAHON'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Kahon',
                      icon: Icons.account_balance_wallet,
                      isSelected: drawerIndex == 3,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(3)}),
                ),
              const SizedBox(height: 6),

              // Bottom section divider
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SidebarItem(
                  title: 'Profile',
                  icon: Icons.account_circle,
                  isSelected: drawerIndex == 9,
                  onTap: () =>
                      ref.read(drawerIndexProvider.notifier).setIndex(9),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SidebarItem(
                    title: 'Logout',
                    icon: Icons.exit_to_app,
                    isSelected: false,
                    onTap: () => ref.read(authProvider.notifier).logout()),
              ),
              const SizedBox(height: 8), // Small bottom padding
            ],
          ),
        );
      },
    );
  }
}
