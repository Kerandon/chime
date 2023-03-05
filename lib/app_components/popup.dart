import 'package:chime/pages/timer/timers/session_countdown/countdown_timer.dart';
import 'package:flutter/material.dart';

Future<void> showPopup({required BuildContext context, required String text}) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PopUp(text));
  Future.delayed(const Duration(milliseconds: 2000), () async {
    await Navigator.of(context).maybePop();
  });
}

class PopUp extends StatelessWidget {
  const PopUp(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text, textAlign: TextAlign.center,),
    );
  }
}
