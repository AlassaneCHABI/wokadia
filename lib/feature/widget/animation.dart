import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:wokadia/feature/widget/speechbubble.dart';

class AnimatedSpeechBubble extends StatefulWidget {
  final Widget child;
  const AnimatedSpeechBubble({super.key, required this.child});

  @override
  State<AnimatedSpeechBubble> createState() => _AnimatedSpeechBubbleState();
}

class _AnimatedSpeechBubbleState extends State<AnimatedSpeechBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 999), // un peu plus long
    );

    // 👉 Fade simple
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // 👉 Scale avec rebond
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: SpeechBubble(
         // borderColor: Colors.black,
          backgroundColor: Colors.white,
         // borderWidth: 1.0,
          radius: 12,
          triangleWidth: 16,
          triangleHeight: 9,
          child: widget.child,
        ),
      ),
    );
  }
}
