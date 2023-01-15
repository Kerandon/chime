import 'package:chime/enums/ambience.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/ambience_list.dart';




class AmbienceSettings extends ConsumerStatefulWidget {
  const AmbienceSettings({
    super.key,
  });

  @override
  ConsumerState<AmbienceSettings> createState() => _AmbienceSettingsState();
}

class _AmbienceSettingsState extends ConsumerState<AmbienceSettings> {




  @override
  Widget build(BuildContext context) {

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    final size = MediaQuery.of(context).size;
    return SizedBox(
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.audiotrack_outlined,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              '  Ambience',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        insetPadding: EdgeInsets.all(size.width * 0.05),
        contentPadding: EdgeInsets.all(size.width * 0.03),
        content: SizedBox(
          height: size.height * 0.60,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.60,
                width: size.width * 0.90,
                child: ListView.builder(
                  itemCount: ambienceData.length,
                  itemBuilder: (context, index) =>
                      CheckboxListTile(
                          title: Row(
                            children: [
                              ambienceData[index].icon,
                              Padding(
                                padding: EdgeInsets.only(left: size.width * 0.03),
                                child: Text(ambienceData[index].ambience.toText()),
                              ),
                            ],
                          ),
                          value: false,
                          onChanged: (value) {}),
                ),
              )
            ],
          ),
        ),
        actionsPadding: EdgeInsets.all(size.width * 0.05),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
            ),
            onPressed: () async {
              await Navigator.of(context).maybePop();
            },
            child: const Text(
              'CLOSE',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
