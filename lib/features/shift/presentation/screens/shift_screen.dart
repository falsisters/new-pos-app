import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShiftScreen extends ConsumerWidget {
  const ShiftScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentShift = ref.watch(currentShiftProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Shift Screen'),
            Text('Current Shift: $currentShift'),
            ElevatedButton(
                onPressed: () => {ref.read(shiftProvider.notifier).endShift()},
                child: Text('End Shift'))
          ],
        ),
      ),
    );
  }
}
