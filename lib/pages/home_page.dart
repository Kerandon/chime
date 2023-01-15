import 'dart:ui';
import 'package:chime/animation/flip_animation.dart';
import 'package:chime/enums/session_status.dart';
import 'package:chime/pages/settings_page.dart';
import 'package:chime/state/preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../animation/fade_in_animation.dart';
import '../components/home/home_contents.dart';
import '../components/home/lotus_icon.dart';
import '../models/prefs_model.dart';
import '../utils/constants.dart';
import 'completed_page.dart';
import '../state/state_manager.dart';

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
    _prefsFuture = PreferencesManager.getPreferences();
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
                        builder: (context) => const SettingsPage()));
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final biggest = constraints.biggest;
                          return Align(
                          alignment: const Alignment(0, 0),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Padding(
                                padding: EdgeInsets.all(size.width * 0.02),
                                child: Container(
                                  // width: size.width * 0.95,
                                  // height: size.height * 0.82,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(kBorderRadius),
                                    color: Colors.black.withOpacity(0.95),
                                  ),
                                  child: state.sessionStatus == SessionStatus.ended
                                      ? const CompletedPage()
                                      : const HomePageContents(),
                                ),
                              ),
                            ),
                          ),
                        );
                        },
                      ),
                    ),
                  ),
                  // Container(
                  //   width: size.width,
                  //   height: size.height * 0.05,
                  //   color: Colors.black,
                  //   child: IconButton(
                  //       alignment: const Alignment(0.90, 0),
                  //       onPressed: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     const SettingsPage()));
                  //       },
                  //       icon: Icon(
                  //         Icons.settings_outlined, color: Colors.white,
                  //         size: size.height * 0.02,
                  //       )),
                  // ),
                ],
              );
            }
            return SizedBox.shrink();
           // return const LotusIcon();
          },
        ),
      ),
    );
  }
}
