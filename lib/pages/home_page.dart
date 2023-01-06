import 'package:chime/utils/read_asset_files.dart';
import 'package:chime/components/start_button.dart';
import 'package:chime/state/state_manager.dart';
import 'package:chime/components/timer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/constants.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final Future<List<String>> _audioAssetsFuture;

  @override
  void didChangeDependencies() {
    _audioAssetsFuture = readAssetFiles(context: context, subPath: 'audio/');

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(stateProvider);
    final notifier = ref.read(stateProvider.notifier);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Meditation Timer'),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<String>>(
          future: _audioAssetsFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                notifier.setAllAudio(audioList: snapshot.data!);
              });


              return SafeArea(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              opacity: 1,
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/images/rocks.jpg',
                              ))),
                    ),
                    Container(
                      child: Column(children: [
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: Text(
                              '54',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: times
                                  .map((e) => TimerButton(
                                        label: e,
                                      ))
                                  .toList()),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: FormBuilder(
                              child: provider.allAudio.isEmpty ? SizedBox() : FormBuilderDropdown(
                                initialValue: provider.allAudio.first,
                                name: 'sounds',
                                items: provider.allAudio
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Center(
                                          child: Text(
                                            e,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: StartButton(),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
