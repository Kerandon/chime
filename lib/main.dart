import 'package:chime/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'configs/app_theme.dart';

void main() => runApp(const ChimeApp());

class ChimeApp extends StatefulWidget {
  const ChimeApp({Key? key}) : super(key: key);

  @override
  State<ChimeApp> createState() => _ChimeAppState();
}

class _ChimeAppState extends State<ChimeApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const HomePage(),
      ),
    );
  }
}
