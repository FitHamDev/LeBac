import 'dart:math';
import 'package:flutter/material.dart';

class IconShower extends StatefulWidget {
  final String? iconPath;
  
  const IconShower({super.key, required this.iconPath});

  @override
  State<IconShower> createState() => _IconShowerState();
}

class _IconShowerState extends State<IconShower> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FallingIcon> _icons = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    
    _controller.addListener(_update);
  }

  @override
  void didUpdateWidget(covariant IconShower oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconPath != widget.iconPath) {
      setState(() {
        for (final icon in _icons) {
          icon.speed *= 10.0; 
        }
      });
    }
  }

  void _update() {
    if (!mounted) return;

    setState(() {
      if (widget.iconPath != null) {
        if (_random.nextDouble() < 0.18) { 
             _icons.add(FallingIcon(
                 x: _random.nextDouble(), 
                 y: -0.1, 
                 speed: 0.003 + _random.nextDouble() * 0.005,
                 size: 30.0 + _random.nextDouble() * 20.0,
                 rotation: _random.nextDouble() * 2 * pi,
                 rotationSpeed: (_random.nextDouble() - 0.5) * 0.05,
                 iconPath: widget.iconPath!,
             ));
        }
      }

      for (var icon in _icons) {
        icon.y += icon.speed;
        icon.rotation += icon.rotationSpeed;
      }

      _icons.removeWhere((icon) => icon.y > 1.1);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return IgnorePointer(
          child: Stack(
            children: _icons.map((icon) {
              return Positioned(
                left: icon.x * constraints.maxWidth - icon.size / 2,
                top: icon.y * constraints.maxHeight - icon.size / 2,
                child: Transform.rotate(
                  angle: icon.rotation,
                  child: Image.asset(
                    'assets/icons/${icon.iconPath}',
                    width: icon.size,
                    height: icon.size,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
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
