import 'package:chime/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppState {
  final List<String> allAudio;
  final String audioSelected;
  final bool startSession;

  AppState({required this.allAudio, required this.audioSelected, required this.startSession});

  AppState copyWith({List<String>? allAudio, String? audioSelected, bool? startSession}) {
    return AppState(
        allAudio: allAudio ?? this.allAudio,
        audioSelected: audioSelected ?? this.audioSelected, startSession: startSession ?? this.startSession);
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setAllAudio({required List<String> audioList}) {

    List<String> editedList = [];
    for(var a in audioList){
      a.capitalize();
      editedList.add(a.substring(13, a.indexOf('.')).capitalize());
    }
    state = state.copyWith(allAudio: editedList);
  }

  void setAudioType({required String audio}) {
    state = state.copyWith(audioSelected: audio);
  }

  void startSession({required bool start}){
    state = state.copyWith(startSession: start);
  }
}

final stateProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(AppState(
    allAudio: [],
    audioSelected: '',
    startSession: false,
  ));
});
