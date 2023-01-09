import 'dart:ui';
import 'package:chime/components/start_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/interval_dropdown.dart';
import '../components/app_timer.dart';
import '../components/sound_selection.dart';
import '../state/state_manager.dart';

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

    final state = ref.read(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    if (!state.initialTimeIsSet) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setTotalTime(60);
        notifier.setIfInitialTimeSet(true);
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 0.02),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/rocks.jpg',
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.70),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: size.width * 0.90,
                        height: size.height * 0.85,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
                          color: Colors.black.withOpacity(0.80),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: size.width,
                  height: size.height * 0.90,
                  child: Column(children: const [
                    Expanded(
                        flex: 15,
                        child: SizedBox()),
                    Expanded(flex: 120, child: AppTimer()),
                    Expanded(flex: 5, child: SizedBox()),
                    Expanded(flex: 35, child: IntervalDropdown()),
                    Expanded(
                        flex: 20,
                        child: SoundSelection()),
                    Expanded(
                      flex: 80,
                      child: StartButton(),
                    ),
                  ],),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.05,
                  color: Colors.black,
                  child: IconButton(
                      alignment: Alignment(0.90,0),
                      onPressed: (){}, icon: Icon(Icons.menu_outlined, size: size.height * 0.03,)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
