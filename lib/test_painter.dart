import 'package:flutter/material.dart';

class LinePainterAnimation extends StatefulWidget {
  const LinePainterAnimation({Key? key}) : super(key: key);

  @override
  State<LinePainterAnimation> createState() => _LinePainterAnimationState();
}

class _LinePainterAnimationState extends State<LinePainterAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<Offset> _offsets = [
    const Offset(50, 300),
    const Offset(150, 100),
    const Offset(300, 300),
    const Offset(200, 300),
  ];

  int _index = 0;
  Offset _begin = const Offset(0, 0);
  Offset _end = const Offset(0, 0);

  @override
  void initState() {
    _begin = _offsets[0];
    _end = _offsets[1];

    _controller = AnimationController(
        duration: const Duration(seconds: 1), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _index++;
          if (_index < _offsets.length - 1) {
            _begin = _offsets[_index];
            _end = _offsets[_index + 1];
            _controller.reset();
            _controller.forward();
            setState(() {});
          }
        }
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> animation =
        Tween<Offset>(begin: _begin, end: _end).animate(_controller);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          painter: LinePainter(
            startOffset: _begin,
            endOffset: animation.value,
            offsets: _offsets,
            index: _index,
          ),
          child: Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          _controller.forward();
          _begin = _offsets[0];
          _end = _offsets[1];
          _index = 0;
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

  LinePainter({
    required this.startOffset,
    required this.endOffset,
    required this.offsets,
    required this.index,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    var pathExisting = Path();

    pathExisting.moveTo(offsets[0].dx, offsets[0].dy);
    for (int i = 0; i < index + 1; i++) {
      pathExisting.lineTo(offsets[i].dx, offsets[i].dy);
    }

    var pathNew = Path();
    pathNew.moveTo(startOffset.dx, startOffset.dy);
    pathNew.lineTo(endOffset.dx, endOffset.dy);

    canvas.drawPath(pathExisting, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
