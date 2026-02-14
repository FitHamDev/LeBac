import 'dart:math';
import 'package:flutter/material.dart';

class IconShower extends StatefulWidget {
  final String? iconPath;
  const IconShower({super.key, this.iconPath});

  @override
  State<IconShower> createState() => _IconShowerState();
}

class _IconShowerState extends State<IconShower> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FallingIcon> _icons = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(hours: 1))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateIcons() {
    // Increased spawn rate slightly (0.08 instead of 0.05) to add more icons
    if (widget.iconPath != null && _random.nextDouble() < 0.08) {
      _icons.add(_FallingIcon(
        x: _random.nextDouble(),
        y: -0.1,
        speed: 0.002 + _random.nextDouble() * 0.003,
        size: 20.0 + _random.nextDouble() * 20.0,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.1,
      ));
    }

    for (var icon in _icons) {
      icon.y += icon.speed;
      icon.rotation += icon.rotationSpeed;
    }
    _icons.removeWhere((icon) => icon.y > 1.1);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.iconPath == null) return const SizedBox();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _updateIcons();
        return Stack(
          children: _icons.map((icon) {
            return Positioned(
              left: icon.x * MediaQuery.of(context).size.width,
              top: icon.y * MediaQuery.of(context).size.height,
              child: Transform.rotate(
                angle: icon.rotation,
                child: Image.asset(
                  widget.iconPath!,
                  width: icon.size,
                  height: icon.size,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FallingIcon {
  double x, y;
  double speed;
  double size;
  double rotation;
  double rotationSpeed;

  _FallingIcon({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });
}


class FallingIcon {
  double x;
  double y;
  double speed;
  double size;
  double rotation;
  double rotationSpeed;
  String iconPath;

  FallingIcon({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.iconPath,
  });
}
