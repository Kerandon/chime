// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// class AudioTween extends ConsumerStatefulWidget {
//   const AudioTween({
//     Key? key,
//     required this.animate,
//     required this.duration,
//     required this.begin,
//     required this.end,
//   }) : super(key: key);
//
//   final bool animate;
//   final Duration duration;
//   final double begin;
//   final double end;
//
//   @override
//   ConsumerState<AudioTween> createState() => _AudioTweenState();
// }
//
// class _AudioTweenState extends ConsumerState<AudioTween>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: widget.duration, vsync: this);
//     _animation = Tween<double>(begin: widget.begin, end: widget.end)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didUpdateWidget(covariant AudioTween oldWidget) {
//     if (widget.animate && !_controller.isAnimating) {
//       _controller.forward();
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return _controller.isAnimating
//         ? AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                 // notifier.setAmbienceVolume(_animation.value);
//               });
//
//               return const SizedBox.shrink();
//             })
//         : const SizedBox.shrink();
//   }
// }
