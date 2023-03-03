// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// class TabState {
//   final bool animateHomePage;
//   final bool homePageTabsAreOpen;
//
//   TabState({required this.animateHomePage, required this.homePageTabsAreOpen});
//
//   TabState copyWith({bool? animateHomePage, bool? homePageTabsAreOpen}){
//     return TabState(animateHomePage: animateHomePage ?? this.animateHomePage, homePageTabsAreOpen: homePageTabsAreOpen ?? this.homePageTabsAreOpen);
//   }
//
// }
//
//
//
// class TabNotifier extends StateNotifier<TabState> {
//   TabNotifier(state) : super(state);
//
//   void setAnimateHomePage(bool animate) {
//     state = state.copyWith(animateHomePage: animate);
//   }
//
//   void setHomePageTabsOpen(bool open) {
//     state = state.copyWith(homePageTabsAreOpen: open);
//   }
//
//
// }
//
// // final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
// // return AppNotifier(AppState(
// // sessionState: SessionState.notStarted,
// // colorTheme: AppColorTheme.turquoise,
//
// final tabProvider = StateNotifierProvider<TabNotifier, TabState>((ref) {
//   return TabNotifier(TabState(animateHomePage: false, homePageTabsAreOpen: false));
//
// });