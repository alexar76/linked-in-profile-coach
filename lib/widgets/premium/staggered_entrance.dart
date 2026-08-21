import 'package:flutter/material.dart';

/// Staggered fade + slide-up for list children (premium reveal).
class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    super.key,
    required this.children,
    this.delay = const Duration(milliseconds: 55),
    this.duration = const Duration(milliseconds: 480),
    this.slideOffset = 18,
  });

  final List<Widget> children;
  final Duration delay;
  final Duration duration;
  final double slideOffset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++)
          _EntranceItem(
            index: i,
            delay: delay,
            duration: duration,
            slideOffset: slideOffset,
            child: children[i],
          ),
      ],
    );
  }
}

class _EntranceItem extends StatefulWidget {
  const _EntranceItem({
    required this.index,
    required this.delay,
    required this.duration,
    required this.slideOffset,
    required this.child,
  });

  final int index;
  final Duration delay;
  final Duration duration;
  final double slideOffset;
  final Widget child;

  @override
  State<_EntranceItem> createState() => _EntranceItemState();
}

class _EntranceItemState extends State<_EntranceItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset / 200),
      end: Offset.zero,
    ).animate(_fade);
    Future<void>.delayed(widget.delay * widget.index, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
