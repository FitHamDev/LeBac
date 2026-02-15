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

  @override
  void initState() {
    super.initState();
    // Defer actions to next frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<HomeViewModel>();
      _precachePriorityCovers(viewModel);
      _precacheRemainingCoversLater(viewModel);
      _tryAutoPlay(viewModel);
    });
  }

  /// Precache only current + default cover so the first frame stays light.
  void _precachePriorityCovers(HomeViewModel viewModel) {
    final repo = viewModel.songRepository;
    if (viewModel.currentSong.coverImage.isNotEmpty) {
      precacheImage(AssetImage(viewModel.currentSong.coverImage), context);
    }
    if (repo.leStigma.coverImage.isNotEmpty) {
      precacheImage(AssetImage(repo.leStigma.coverImage), context);
    }
  }

  /// Precache the rest of the covers after a short delay so UI stays responsive.
  void _precacheRemainingCoversLater(HomeViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        for (final song in viewModel.songRepository.allSongs) {
          if (song.coverImage.isEmpty) continue;
          if (song.coverImage == viewModel.currentSong.coverImage) continue;
          if (song.coverImage == viewModel.songRepository.leStigma.coverImage) continue;
          precacheImage(AssetImage(song.coverImage), context);
        }
      });
    });
  }

  void _tryAutoPlay(HomeViewModel viewModel) {
    if (viewModel.currentSong.coverImage.isEmpty) {
      viewModel.playRandomSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          final theme = viewModel.currentSong.coverImage.isNotEmpty
              ? viewModel.currentSong.theme
              : 'stigma';
          final style = SongStyle.getStyle(theme);

          return Stack(
            children: [
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

