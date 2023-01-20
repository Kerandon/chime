import 'dart:async';
import 'package:chime/components/app/lotus_icon.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/settings_page.dart';
import 'package:chime/state/preferences_main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/home/home_contents.dart';
import '../configs/app_colors.dart';
import '../models/prefs_model.dart';
import 'completed_page.dart';
import '../state/app_state.dart';
import 'error_page.dart';

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
  bool _showUI = false;

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

    bool sessionUnderway = false;
    if (state.sessionState == SessionState.countdown ||
        state.sessionState == SessionState.inProgress ||

        state.sessionState == SessionState.paused){
      sessionUnderway = true;
    }

    return SafeArea(
      child: Scaffold(
        appBar: sessionUnderway ? AppBar(backgroundColor: AppColors.almostBlack,) : AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: size.width * 0.10,),
              LotusIcon(width: size.width * 0.05,),
              Text('   Zense Meditation Timer'),
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
        backgroundColor: AppColors.almostBlack,
        body: FutureBuilder<PrefsModel>(
          future: _prefsFuture,
          builder: (context, snapshot) {
            if (_showUI) {
              return Align(
                alignment: const Alignment(0, 0),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: state.sessionState == SessionState.ended
                      ? const CompletedPage()
                      : const HomePageContents(),
                ),
              );
            }

            if (snapshot.hasError) {
              return const ErrorPage();
            }
            if (snapshot.hasData) {
              Timer(const Duration(milliseconds: 100), () {
                _showUI = true;
                setState(() {});
              });

              if (!_prefsDataUpdated) {
                PrefsModel data = snapshot.data as PrefsModel;

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  notifier.setTotalTime(data.totalTime);
                  notifier.setBellSelected(data.bellSelected);
                  notifier.setBellIntervalTime(data.bellInterval);
                  notifier.setBellVolume(data.bellVolume);
                  notifier.setTotalCountdownTime(data.countdownTime);
                });
                _prefsDataUpdated = true;
              }
            }
            return const Center(child: LotusIcon());
            // return const LotusIcon();
          },
        ),
      ),
    );
  }
}
