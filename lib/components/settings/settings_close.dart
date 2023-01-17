
import 'package:flutter/material.dart';

class SettingsClose extends StatelessWidget {
  const SettingsClose({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
          ),
          onPressed: () async {
            await Navigator.of(context).maybePop();
          },
          child: const Text(
            'CLOSE',
            style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
