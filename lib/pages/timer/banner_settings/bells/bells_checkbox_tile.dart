import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../enums/bell.dart';
import '../../../../enums/prefs.dart';
import '../../../../state/app_state.dart';

class BellsCheckBoxTile extends ConsumerWidget {
  const BellsCheckBoxTile({
    super.key,
    required this.bell,
  });

  final Bell bell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return CheckboxListTile(
      title: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.03),
            child: Text(
              bell.toText(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      value: state.bellSelected == bell,
      onChanged: (value) async {
        notifier.setBellSelected(bell);

        await DatabaseManager().insertIntoPrefs(k: Prefs.bellSelected.name, v: bell.name);
      },
    );
  }
}
