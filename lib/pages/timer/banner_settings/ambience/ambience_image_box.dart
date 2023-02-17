import 'package:chime/enums/ambience.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../configs/constants.dart';
import '../../../../models/ambience_model.dart';
import '../../../../state/app_state.dart';

class AmbienceImageBox extends ConsumerWidget {
  const AmbienceImageBox({
    super.key,
    required this.ambienceData,
  });

  final AmbienceData ambienceData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: state.ambienceIsOn ? () {
            notifier.setAmbienceSelected(ambienceData.ambience);
          } : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius),
              border: Border.all(
                color: state.ambienceIsOn &&
                        ambienceData.ambience == state.ambienceSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).secondaryHeaderColor,
                width: 3,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.01),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/images/ambience/${ambienceData.ambience.name}.jpg'),
                      ),
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      border: Border.all(
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.01),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        color: Theme.of(context).primaryColorDark.withOpacity(0.50)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.01),
                        child: Text(ambienceData.ambience.toText(), overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 1.seconds).scaleXY(begin: 0.95);
  }
}
