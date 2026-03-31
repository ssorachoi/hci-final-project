import 'package:flutter/material.dart';

class HoverScale extends StatefulWidget {
  final Widget child;
  final double hoverScale;
  final List<BoxShadow> hoverShadows;
  final BorderRadius? borderRadius;
  final Duration duration;
  final Curve curve;

  const HoverScale({
    super.key,
    required this.child,
    this.hoverScale = 1.03,
    this.hoverShadows = const [
      BoxShadow(color: Color(0x0F000000), blurRadius: 4, offset: Offset(0, 2)),
    ],
    this.borderRadius,
    this.duration = const Duration(milliseconds: 140),
    this.curve = Curves.easeOut,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? widget.hoverScale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: widget.curve,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.zero,
            boxShadow: _isHovering ? widget.hoverShadows : const [],
          ),
          child: borderRadius == null
              ? widget.child
              : ClipRRect(
                  borderRadius: borderRadius,
                  child: widget.child,
                ),
        ),
      ),
    );
  }
}
