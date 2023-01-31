import 'package:flutter/material.dart';

class LinePainterAnimation extends StatefulWidget {
  const LinePainterAnimation({Key? key}) : super(key: key);

  @override
  State<LinePainterAnimation> createState() => _LinePainterAnimationState();
}

class _LinePainterAnimationState extends State<LinePainterAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  final List<Offset> _offsets = [
    const Offset(100, 100),
    const Offset(200, 200),
    const Offset(300, 300),
  ];

  Offset _startOffset = const Offset(0,0);
  Offset _endOffset = const Offset(0, 0);
  int _index = 0;
  double _eachTweenPercentage = 0.0;

  @override
  void initState() {
    _eachTweenPercentage = 1.0 / _offsets.length;
    List<TweenSequenceItem<Offset>> tweenPoints = [];
    Offset startPos = _offsets.first;
    for (int i = 0; i < _offsets.length - 1; i++) {
      Offset endPos = _offsets[i + 1];
      tweenPoints.add(TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: startPos, end: endPos), weight: 1));
      startPos = endPos;
    }


    _startOffset = _offsets[0];
    _controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..addListener(() {
            if (_controller.value > _eachTweenPercentage) {
              _index++;
              _startOffset = _offsets[_index];
              _eachTweenPercentage += _eachTweenPercentage;
            }
            _endOffset = _animation.value;
            setState(() {});
          });

    _animation = TweenSequence<Offset>(tweenPoints).animate(_controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: LinePainter(
          startOffset: _startOffset,
            endOffset: _endOffset, offsets: _offsets, index: _index),
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          _controller.forward();
          setState(() {});
        },
        child: const Text('Play'),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset startOffset;
  final Offset endOffset;
  final List<Offset> offsets;
  final int index;

  LinePainter(
      {required this.startOffset, required this.endOffset, required this.offsets, required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    var pathNew = Path();
    // var pathExisting = Path();
    //
    //
    // for (int i = 0; i < offsets.length; i++) {
    //   pathExisting.lineTo(offsets[i].dx, offsets[i].dy);
    // }

    for(int i = 0; i < offsets.length; i++){
      pathNew.moveTo(startOffset.dx, startOffset.dy);
      pathNew.lineTo(endOffset.dx, endOffset.dy);
    }

    canvas.drawPath(pathNew, paint);
  //  canvas.drawPath(pathExisting, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}