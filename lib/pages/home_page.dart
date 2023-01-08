import 'dart:ui';
import 'package:chime/components/start_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/interval_dropdown.dart';
import '../components/app_timer.dart';
import '../components/custom_title.dart';
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

    final state= ref.read(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    if(!state.initialTimeIsSet) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifier.setTotalTime(60);
        notifier.setIfInitialTimeSet(true);
      });
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: size.height * 0.10,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.all(size.height * 0.08,),
          child: Image.asset('assets/images/logo2.png', fit: BoxFit.scaleDown,),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
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
            Center(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: size.width * 0.80,
                    height: size.height * 0.85,
                    decoration: const BoxDecoration(color: Colors.black54),
                  ),
                ),
              ),
            ),
            Column(children: [
              const Expanded(flex: 1, child: SizedBox()),
              const AppTimer(),
              const CustomTitle(text: 'Play sound every'),
              const IntervalDropdown(),
              SizedBox(
                height: size.height * 0.05,
              ),
              const SoundSelection(),
              const Expanded(
                flex: 2,
                child: StartButton(),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
