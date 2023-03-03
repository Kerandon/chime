
import 'package:flutter/material.dart';

class ChipOutlinedButton extends StatelessWidget {
  const ChipOutlinedButton({
    super.key, required this.text, required this.isSelected, required this.onPressed,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).secondaryHeaderColor,
        ),
      ),
      onPressed: onPressed,
      child: Text(text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: isSelected ? Theme.of(context).textTheme.bodyMedium!.color :
            Theme.of(context).secondaryHeaderColor
        ),
      ),
    );
  }
}
