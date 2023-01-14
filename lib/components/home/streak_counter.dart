import 'package:chime/state/preferences_manager.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StreakCounter extends ConsumerStatefulWidget {
  const StreakCounter({
    super.key,
  });

  @override
  ConsumerState<StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends ConsumerState<StreakCounter> {
  @override
  Widget build(BuildContext context) {
    if (ref.watch(stateProvider).checkIfStatsUpdated) {
      setState(() {});
    }

    final checkStreakCurrentFuture =
        PreferencesManager.checkIfStreakStillCurrent();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(stateProvider.notifier).checkIfStatsUpdated(false);
    });

    final size = MediaQuery.of(context).size;
    return FutureBuilder<bool>(
        future: checkStreakCurrentFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasData) {
            final streakIsCurrent = snapshot.data!;

            if (!streakIsCurrent) {
              return const SizedBox.shrink();
            } else {
              return FutureBuilder<int>(
                  future: PreferencesManager.getCurrentStreakTotal(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final streak = snapshot.data as int;

                      if (streak > 0) {
                        return Align(
                          alignment: const Alignment(0.85, -0.80),
                          child: SizedBox(
                            width: size.width * 0.20,
                            height: size.height * 0.10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.award,
                                      size: 12,
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    Text(
                                      '$streak',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
                  });
            }
          }
          return const SizedBox.shrink();
        });
  }
}
