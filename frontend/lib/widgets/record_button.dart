import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class _SpinningRecordButtonState extends State<SpinningRecordButton> with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late Ticker _ticker;
  final ValueNotifier<double> _rotationNotifier = ValueNotifier(0.0);
  
  // Speed: 1 full rotation (2*pi) every 10 seconds
  static const double _baseSpeed = (2 * pi) / 10; 
  double _direction = 1.0;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 4)
    )..repeat();
    
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _rippleController.dispose();
    _rotationNotifier.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }
    
    final double dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    // Update rotation safely without setState
    _rotationNotifier.value += _baseSpeed * _direction * dt;
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.viewModel.currentSong;
    final isPlaying = currentSong.coverImage.isNotEmpty;
    final isOnCooldown = widget.viewModel.isOnCooldown;
    final coverImage = isPlaying ? currentSong.coverImage : null;

    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isPlaying)
          AnimatedBuilder(
            animation: _rippleController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: List.generate(3, (index) {
                  final progress = (_rippleController.value + (index * 0.33)) % 1.0;
                  return Transform.scale(
                    scale: 1.0 + (progress * 0.5),
                    child: Opacity(
                      opacity: (1.0 - progress).clamp(0.0, 1.0),
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.style.buttonColor.withAlpha(51),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          
        GestureDetector(
          onTap: isOnCooldown ? null : () {
            // Toggle direction immediately so the next frame paints the flip
            _direction *= -1;
            // Defer heavy work until after the next frame so rotation flip is visible first (fixes Android pause)
            SchedulerBinding.instance.addPostFrameCallback((_) {
              widget.viewModel.playRandomSong();
            });
          },
          child: ValueListenableBuilder<double>(
              valueListenable: _rotationNotifier,
              builder: (context, rotation, child) {
                return Transform.rotate(
                  angle: rotation,
                  child: child!,
                );
              },
              child: Container(
                width: 240,
                height: 240,
                // Removed padding and white background to remove white border
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // Keep shadow if desired
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage: coverImage != null ? AssetImage(coverImage) : null,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
        ),
        ],
      ),
    );
  }
}



