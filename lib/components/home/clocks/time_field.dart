import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../enums/focus_state.dart';
import '../../../state/preferences_main.dart';
import '../../../state/app_state.dart';

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
    final size = MediaQuery.of(context).size;
    final notifier = ref.read(stateProvider.notifier);

    return SizedBox(
      width: size.width * 0.30,
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        focusNode: focusNode,
        controller: textEditingController,
        onChanged: (value) async {
          notifier.setTimerFocusState(FocusState.inFocus);
          PreferencesMain.setPreferences(totalTime: int.tryParse(value) ?? 0);
          if (value.trim() == "") {
            notifier.setTotalTime(1);
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
          isDense: true,
          enabledBorder:
              // OutlineInputBorder(
              //   borderSide: BorderSide(color: Theme.of(context).primaryColor)
              // ),

              const UnderlineInputBorder(
            borderSide: BorderSide.none,
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
      ),
    );
  }
}
