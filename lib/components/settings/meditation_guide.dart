import 'package:flutter/material.dart';

class MeditationGuide extends StatelessWidget {
  const MeditationGuide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Step by Step Guide', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall
      !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),),
      content: Text.rich(
        TextSpan(
            text: 'Step 1',  style: Theme.of(context).textTheme.bodySmall
        !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: ' Place your attention on your breath', style: Theme.of(context).textTheme.bodySmall
              !.copyWith(fontSize: 20, color: Colors.black),
              ),
              TextSpan(
                text: '\n\nStep 2',style: Theme.of(context).textTheme.bodySmall
              !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: ' When you notice your mind has wandered, gently return your attention to your breath',
                style: Theme.of(context).textTheme.bodySmall
                !.copyWith(fontSize: 20, color: Colors.black),
              ),
              TextSpan(
                text: '\n\nStep 3', style: Theme.of(context).textTheme.bodySmall
              !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: ' Repeat', style: Theme.of(context).textTheme.bodySmall
              !.copyWith(fontSize: 20, color: Colors.black),
              )
            ]

        ),
      ),
    );
  }
}
