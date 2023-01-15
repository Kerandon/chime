import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MeditationGuide extends StatelessWidget {
  const MeditationGuide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tips_and_updates_outlined,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            '  Step by Step Guide',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
      content: SizedBox(
        height: size.height * 0.45,
        child: Text.rich(
          TextSpan(
              text: '\nStep 1',  style: Theme.of(context).textTheme.bodySmall
          !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '\n\nPlace your attention on your breath', style: Theme.of(context).textTheme.bodySmall
                !.copyWith(fontSize: 20, color: Colors.black),
                ),
                TextSpan(
                  text: '\n\nStep 2',style: Theme.of(context).textTheme.bodySmall
                !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: '\n\nWhen you notice your mind has wandered, gently return your attention to your breath',
                  style: Theme.of(context).textTheme.bodySmall
                  !.copyWith(fontSize: 20, color: Colors.black),
                ),
                TextSpan(
                  text: '\n\nStep 3', style: Theme.of(context).textTheme.bodySmall
                !.copyWith(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: '\n\nRepeat', style: Theme.of(context).textTheme.bodySmall
                !.copyWith(fontSize: 20, color: Colors.black),
                )
              ],

          ),
        ),
      ),
      actionsPadding: EdgeInsets.all(size.width * 0.05),
      actions: [
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
            ),
            onPressed: ()async{await Navigator.of(context).maybePop();}, child: Text('CLOSE', style: TextStyle(
          fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal
        ),
        ),),
      ],
    );
  }
}
