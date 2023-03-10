import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disable = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.06,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: disable ? Colors.black54 : Colors.teal, width: 2),
        ),
        onPressed: disable ? null : onPressed,
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
