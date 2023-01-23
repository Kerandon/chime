import 'package:chime/components/app/lotus_icon.dart';
import 'package:chime/components/home/home_contents.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../configs/app_colors.dart';
import '../state/app_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);

    bool sessionUnderway = false;
    if (state.sessionState == SessionState.countdown ||
        state.sessionState == SessionState.inProgress ||
        state.sessionState == SessionState.paused) {
      sessionUnderway = true;
    }

    return SafeArea(
      child: Scaffold(
          appBar: sessionUnderway
              ? AppBar(
                  backgroundColor: AppColors.almostBlack,
                )
              : AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.08,
                      ),
                      LotusIcon(
                        width: size.width * 0.05,
                      ),
                      const Text('  Zense Meditation Timer'),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.settings_outlined,
                      ),
                    ),
                  ],
                ),
          resizeToAvoidBottomInset: false,
          body: HomePageContents()
          // return const LotusIcon();

          ),
    );
  }
}
