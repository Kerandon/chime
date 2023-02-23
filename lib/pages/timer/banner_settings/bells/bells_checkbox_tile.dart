import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../enums/bell.dart';
import '../../../../state/audio_state.dart';

class BellsCheckBoxTile extends ConsumerWidget {
  const BellsCheckBoxTile({
    super.key,
    required this.bell,
  });

  final Bell bell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);
    return CheckboxListTile(
      title: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.03),
            child: Text(
              bell.toText(),
            ),
          ),
        ],
      ),
      value: audioState.bellSelected == bell,
      onChanged: (value) async {
        audioNotifier.setBellSelected(bell);
      },
    );
  }
}
