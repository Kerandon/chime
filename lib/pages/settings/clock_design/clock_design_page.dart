import 'package:flutter/material.dart';

class ClockDesignPage extends StatelessWidget {
  const ClockDesignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock design'),
      ),
      body: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2
      ), itemBuilder: (context, index) => Container(color: Colors.grey,)),
    );
  }
}
