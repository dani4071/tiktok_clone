import 'package:flutter/material.dart';

class circularImageAnimation extends StatefulWidget {

  final Widget? widgetAnimation;

  const circularImageAnimation({super.key, this.widgetAnimation});

  @override
  State<circularImageAnimation> createState() => _circularImageAnimationState();
}

class _circularImageAnimationState extends State<circularImageAnimation> with SingleTickerProviderStateMixin {

  late AnimationController controllerAnimation;

  @override
  void initState() {
    controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    controllerAnimation.forward();
    controllerAnimation.repeat();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    controllerAnimation.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(controllerAnimation),
      child: widget.widgetAnimation,
    );
  }
}
