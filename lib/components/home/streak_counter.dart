import 'package:chime/components/settings/streak_settings.dart';
import 'package:chime/state/preferences_manager.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../configs/app_colors.dart';

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
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });

    }

    final checkStreakCurrentFuture =
        PreferencesManager.checkIfStreakStillCurrent();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(mounted) {
        ref.read(stateProvider.notifier).checkIfStatsUpdated(false);
      }
    });

    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context, builder: (context) => const StreakSettings());
        },
        child: FutureBuilder<bool>(
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
                          return Padding(
                            padding: EdgeInsets.only(right: size.width * 0.06),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.award,
                                  size: 12,
                                  color: AppColors.lightWhite,
                                ),
                                SizedBox(width: size.width * 0.02),
                                Text(
                                  '$streak',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      return const SizedBox.shrink();
                    },
                  );
                }
              }
              return const SizedBox.shrink();
            }),
      ),
    );
  }
}
