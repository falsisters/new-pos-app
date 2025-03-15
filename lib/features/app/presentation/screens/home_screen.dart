import 'package:falsisters_pos_android/features/app/data/providers/home_provider.dart';
import 'package:falsisters_pos_android/features/app/presentation/widgets/sidebar.dart';
import 'package:falsisters_pos_android/features/sales/presentation/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerIndex = ref.watch(drawerIndexProvider);

    return Scaffold(
      body: Row(
        children: [
          Sidebar(),
          if (drawerIndex == 0)
            Expanded(
              child: SalesScreen(),
            ),
          if (drawerIndex == 1)
            Expanded(
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Deliveries Screen',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
