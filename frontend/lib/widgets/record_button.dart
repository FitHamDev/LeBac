import 'package:flutter/material.dart';
import 'package:frontend/ViewModel/home_viewmodel.dart';
import 'package:frontend/styles/theme_styles.dart';

class SpinningRecordButton extends StatefulWidget {
  final HomeViewModel viewModel;
  final SongStyle style;

  const SpinningRecordButton({
    super.key,
    required this.viewModel,
    required this.style,
  });

  @override
  State<SpinningRecordButton> createState() => _SpinningRecordButtonState();
}

class _SpinningRecordButtonState extends State<SpinningRecordButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _baseTurns = 0.0;
  int _direction = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 15), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDirection() {
    setState(() {
      _baseTurns += _controller.value * _direction;
      _direction *= -1;
      _controller.reset();
      _controller.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = widget.viewModel.currentSong.coverImage.isNotEmpty;
    
    if (isPlaying && !_controller.isAnimating) _controller.repeat();
    if (!isPlaying && _controller.isAnimating) _controller.reset();

    return Stack(
      alignment: Alignment.center,
      children: [
        if (isPlaying) ...List.generate(3, (i) => _buildRipple(i * 0.33)), 
        GestureDetector(
          onTap: () { _toggleDirection(); widget.viewModel.playRandomSong(); },
          child:
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => Transform.rotate(
                angle: (_baseTurns + (_controller.value * _direction)) * 2 * 3.14159, 
                child: child
              ),
              child: CircleAvatar(
                radius: 120,
                backgroundImage: AssetImage(widget.viewModel.currentSong.coverImage),
                backgroundColor: Colors.transparent,
              ),
            )
        ),
      ],
    );
  }

  Widget _buildRipple(double offset) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = (_controller.value * 3 + offset) % 1.0;
        return Transform.scale(
          scale: 1.0 + t * 0.3, 
          child: Opacity(
            opacity: 1.0 - t, 
            child: Container(
              width: 250, height: 250, 
              decoration: BoxDecoration(shape: BoxShape.circle, color: widget.style.buttonColor.withValues(alpha: 50))
            )
          )
        );
      }
    );
  }
}

