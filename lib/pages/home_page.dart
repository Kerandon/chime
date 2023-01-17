import 'dart:ui';
import 'package:chime/animation/flip_animation.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/settings_page.dart';
import 'package:chime/state/preferences_main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../animation/fade_in_animation.dart';
import '../components/home/home_contents.dart';
import '../configs/app_colors.dart';
import '../models/prefs_model.dart';
import '../utils/constants.dart';
import 'completed_page.dart';
import '../state/app_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final Future<PrefsModel> _prefsFuture;

  bool _prefsDataUpdated = false;

  @override
  void initState() {
    _prefsFuture = PreferencesMain.getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage(),),);
              },
              icon: const Icon(
                Icons.settings_outlined,
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: FutureBuilder<PrefsModel>(
          future: _prefsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.hasData) {
              if (!_prefsDataUpdated) {
                PrefsModel data = snapshot.data as PrefsModel;

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  notifier.setTotalTime(data.time);
                  notifier.setIntervalTime(data.interval);

                  notifier.setSound(data.sound);
                });
                _prefsDataUpdated = true;
              }
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/rocks.jpg',
                        ),
                      ),
                    ),
                  ),
                  FadeInAnimation(
                    child: FlipAnimation(
                      child: Align(
                      alignment: const Alignment(0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.almostBlack,
                        ),
                        child: state.sessionState == SessionState.ended
                            ? const CompletedPage()
                            : const HomePageContents(),
                      ),
                        ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
           // return const LotusIcon();
          },
        ),
      ),
    );
  }
}
