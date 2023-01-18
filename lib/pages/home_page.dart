import 'dart:async';
import 'dart:ui';
import 'package:chime/animation/flip_animation.dart';
import 'package:chime/components/app/lotus_icon.dart';
import 'package:chime/enums/session_state.dart';
import 'package:chime/pages/settings_page.dart';
import 'package:chime/state/preferences_main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../animation/fade_in_animation.dart';
import '../components/home/home_contents.dart';
import '../configs/app_colors.dart';
import '../models/prefs_model.dart';
import '../configs/constants.dart';
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
        backgroundColor: Colors.black,
        body: FutureBuilder<PrefsModel>(
          future: _prefsFuture,
          builder: (context, snapshot) {

            if(_showUI){
              return Align(
                alignment: const Alignment(0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.almostBlack,
                  ),
                  child: state.sessionState == SessionState.ended
                      ? const CompletedPage()
                      : const HomePageContents(),
                ),
              );
            }


            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.hasData) {

              Timer(Duration(milliseconds: 100), () {
                print('timer up!');
                _showUI = true;
                setState(() {

                });
              });

              if (!_prefsDataUpdated) {
                PrefsModel data = snapshot.data as PrefsModel;

                print(
                    '${data.totalTime} ${data.bellSelected} ${data.bellInterval}'
                    ' ${data.bellVolume} ${data.ambienceVolume} ${data.ambienceSelected}');

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  notifier.setTotalTime(data.totalTime);
                  notifier.setBellIntervalTime(data.bellInterval);
                  notifier.setBellSelected(data.bellSelected);
                  notifier.setBellVolume(data.bellVolume);
                });
                _prefsDataUpdated = true;
              }

              print('show UI? ${_showUI}');
            }
            return Center(child: const LotusIcon());
            // return const LotusIcon();
          },
        ),
      ),
    );
  }
}
