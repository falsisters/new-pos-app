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
            padding: const EdgeInsets.only(top: 40),
            children: [
              Center(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Falsisters',
                    style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              )),
              const Divider(
                indent: 16,
                endIndent: 16,
                thickness: 4,
                color: Colors.white,
              ),
              const SizedBox(
                height: 16,
              ),
              if (permissions.contains('SALES'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Sales',
                      icon: Icons.shopping_cart,
                      isSelected: drawerIndex == 0,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(0)}),
                ),
              const SizedBox(
                height: 4,
              ),
              if (permissions.contains('DELIVERIES'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Deliveries',
                      icon: Icons.delivery_dining,
                      isSelected: drawerIndex == 1,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(1)}),
                ),
              const SizedBox(
                height: 4,
              ),
              if (permissions.contains('STOCKS'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Stocks',
                      icon: Icons.backpack,
                      isSelected: drawerIndex == 2,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(2)}),
                ),
              const SizedBox(
                height: 4,
              ),
              if (permissions.contains('KAHON'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Kahon',
                      icon: Icons.inventory,
                      isSelected: drawerIndex == 3,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(3)}),
                ),
              const SizedBox(
                height: 4,
              ),
              if (permissions.contains('KAHON'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Expenses',
                      icon: Icons.bookmark_add_rounded,
                      isSelected: drawerIndex == 4,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(4)}),
                ),
              const SizedBox(
                height: 4,
              ),
              if (permissions.contains('PROFITS'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Profits',
                      icon: Icons.attach_money,
                      isSelected: drawerIndex == 5,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(5)}),
                ),
              const SizedBox(
                height: 4,
              ),
              if (permissions.contains('ATTACHMENTS'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Attachments',
                      icon: Icons.attach_file,
                      isSelected: drawerIndex == 6,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(6)}),
                ),
              const SizedBox(
                height: 4,
              ),
              if (permissions.contains('SALES_HISTORY'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Sales History',
                      icon: Icons.history,
                      isSelected: drawerIndex == 7,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(7)}),
                ),
              const SizedBox(
                height: 4,
              ),
              if (permissions.contains('PROFITS'))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SidebarItem(
                      title: 'Bills',
                      icon: Icons.blinds_closed,
                      isSelected: drawerIndex == 8,
                      onTap: () =>
                          {ref.read(drawerIndexProvider.notifier).setIndex(8)}),
                ),
              const SizedBox(
                height: 16,
              ),
              const Divider(
                indent: 16,
                endIndent: 16,
                thickness: 4,
                color: Colors.white,
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SidebarItem(
                  title: 'Profile',
                  icon: Icons.person,
                  isSelected: drawerIndex == 9,
                  onTap: () =>
                      ref.read(drawerIndexProvider.notifier).setIndex(9),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SidebarItem(
                    title: 'Logout',
                    icon: Icons.logout,
                    isSelected: false,
                    onTap: () => ref.read(authProvider.notifier).logout()),
              ),
            ],
          ),
        );
      },
    );
  }
}
