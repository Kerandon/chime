import 'package:chime/components/app/custom_outline_button.dart';
import 'package:flutter/material.dart';

class ConfirmationBox extends StatelessWidget {
  const ConfirmationBox({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        text,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomOutlineButton(text: 'Yes', onPressed: onPressed),
        CustomOutlineButton(
          text: 'No',
          onPressed: () async => await Navigator.of(context).maybePop(),
        ),
      ],
    );
  }
}
