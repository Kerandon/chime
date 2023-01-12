
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../enums/focus_state.dart';
import '../state/prefs_manager.dart';
import '../state/state_manager.dart';

class TimeField extends ConsumerWidget {
  const TimeField({
    super.key,
    required this.focusNode,
    required this.textEditingController,
  });

  final FocusNode focusNode;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(stateProvider.notifier);

    return TextFormField(
      focusNode: focusNode,
      controller: textEditingController,
      onChanged: (value) async {
        notifier.setTimerFocusState(FocusState.inFocus);
        PrefsManager.setPrefs(time: int.tryParse(value) ?? 0);
        if (value.trim() == "") {
          notifier.setTotalTime(0);
        } else {

          int time = int.parse(value);
          notifier.setTotalTime(time);



        }
      },
      maxLength: 4,
      style: Theme.of(context).textTheme.displayLarge,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        counterText: "",
      ),
    );
  }
}
