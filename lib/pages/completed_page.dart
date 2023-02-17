import 'package:chime/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../app_components/lotus_icon.dart';
import '../data/meditation_quotes.dart';
import '../state/app_state.dart';

class CompletedPage extends ConsumerStatefulWidget {
  const CompletedPage({
    super.key,
  });

  @override
  ConsumerState<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends ConsumerState<CompletedPage> {
  bool _playFinalBell = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    if (!_playFinalBell) {

      _playFinalBell = true;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_return_outlined,
                color: Colors.white24,
              ),
              onPressed: () {
                notifier.setSessionState(SessionState.notStarted);
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                child: Text(
                    'Congratulations!\n\nYour ${state.totalTimeMinutes} minute mediation session is complete',
                    //'Meditation session in process',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white)),
              ),
              Container(
                height: size.height * 0.30,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/people/person_3.png'))),
              ),
              Center(
                child: Text(
                  meditationQuotes.first,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.30),
                child: SizedBox(
                    child: SizedBox(
                        width: size.width * 0.20, child: const LotusIcon())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
