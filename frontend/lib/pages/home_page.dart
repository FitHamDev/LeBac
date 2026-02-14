import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/ViewModel/home_viewmodel.dart';
import 'package:frontend/styles/theme_styles.dart';
import 'package:frontend/widgets/record_button.dart';
import 'package:frontend/widgets/icon_shower.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Determine style based on current song or fallback to last known style
  SongStyle _getDisplayStyle(HomeViewModel viewModel) {
    if (viewModel.currentSong.coverImage.isNotEmpty) {
      return SongStyle.getStyle(viewModel.currentSong.theme);
    }
    // Fallback: If we had a last style, we could persist it, but for simplicity
    // we return the default (stigma) or whatever the "none" song implies.
    // However, to keep the background from flashing to black when song ends:
    return SongStyle.getStyle('stigma'); // Or keep global variable if persistence needed
  }

  @override
  void initState() {
    super.initState();
    // Defer actions to next frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAllCovers();
      _tryAutoPlay();
    });
  }

  void _precacheAllCovers() {
    final viewModel = context.read<HomeViewModel>();
    for (final song in viewModel.songRepository.allSongs) {
      if (song.coverImage.isNotEmpty) {
        precacheImage(AssetImage(song.coverImage), context);
      }
    }
  }
  
  void _tryAutoPlay() {
    final viewModel = context.read<HomeViewModel>();
    if (viewModel.currentSong.coverImage.isEmpty) {
      viewModel.playRandomSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          // Use current song style, fallback to Stigma if not playing
          // Note: If you want to persist the LAST played style when stopped,
          // you'd need a variable in ViewModel "lastPlayedTheme".
          // For now, defaulting to Stigma (Standard) when stopped is cleaner.
          final style = viewModel.currentSong.coverImage.isNotEmpty
              ? SongStyle.getStyle(viewModel.currentSong.theme)
              : SongStyle.getStyle('stigma');

          return Stack(
            children: [
              // Background Gradient with smooth transition
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: style.gradientColors,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              
              // Falling Icons
              Positioned.fill(
                child: IconShower(iconPath: viewModel.currentSong.icon),
              ),
              
              // Center Button
              Center(
                child: SpinningRecordButton(
                  viewModel: viewModel,
                  style: style,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

