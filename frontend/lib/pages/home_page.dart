import 'package:flutter/material.dart';
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
  HomeViewModel viewModel = HomeViewModel();
  late SongStyle _lastStyle;
  
  @override
  void initState() {
    super.initState();
    _lastStyle = SongStyle.getStyle('stigma');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheCovers();
    });
    _autoPlayFirstSong();
  }
  
  Future<void> _precacheCovers() async {
    const covers = [
      'assets/images/stigma_cover.png',
      'assets/images/leblanc_cover.jpg',
      'assets/images/legoon_cover.jpg',
    ];
    for (final path in covers) {
      await precacheImage(AssetImage(path), context);
    }
  }
  
  Future<void> _autoPlayFirstSong() async {
    if (viewModel.currentSong.coverImage.isEmpty) {
      await viewModel.playRandomSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final currentStyle = SongStyle.getStyle(viewModel.currentSong.theme);
        if (viewModel.currentSong.coverImage.isNotEmpty) {
          _lastStyle = currentStyle;
        }
        final displayStyle = _lastStyle;

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: displayStyle.gradientColors,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IconShower(iconPath: viewModel.currentSong.icon),
              ),
              Center(
                child: SpinningRecordButton(
                  viewModel: viewModel,
                  style: currentStyle,
                ),
              ),
            ],
          )
        );
      },
    );
  }
}

