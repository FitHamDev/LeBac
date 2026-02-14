import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/ViewModel/settings_viewmodel.dart';
import 'package:frontend/repository/song_repository.dart';
import 'package:frontend/styles/theme_styles.dart';
import 'package:frontend/models/song.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const defaultGlobalStyle = SongStyle.defaultStyle;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: defaultGlobalStyle.gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Consumer<SettingsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              final songs = SongRepository().allSongs;

              return Column(
                children: [
                   Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return _SongSettingsCard(
                            song: song, 
                            viewModel: viewModel
                          );
                        },
                      ),
                   ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(77),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ]
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF00051E),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'APPLY CHANGES', 
                style: TextStyle(
                  fontWeight: FontWeight.w900, 
                  fontSize: 18,
                  letterSpacing: 1.5
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SongSettingsCard extends StatelessWidget {
  final Song song;
  final SettingsViewModel viewModel;

  const _SongSettingsCard({required this.song, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final weight = viewModel.getWeight(song.theme);
    final style = SongStyle.getStyle(song.theme);

    // Calculate slider value logic
    double sliderValue = _calculateSliderValue(weight);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: style.gradientColors.last.withAlpha(128),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Layer
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: style.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            
            // Watermark Layer
            if (song.icon != null)
              Positioned.fill(
                child: _WatermarkPattern(iconPath: song.icon!), 
              ),

            // Content Layer
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(weight),
                  const SizedBox(height: 20),
                  _buildSlider(context, sliderValue, weight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateSliderValue(int weight) {
    if (SettingsViewModel.allowedValues.contains(weight)) {
      return SettingsViewModel.allowedValues.indexOf(weight).toDouble();
    }
    int closest = SettingsViewModel.allowedValues.reduce((a, b) => 
      (weight - a).abs() < (weight - b).abs() ? a : b);
    return SettingsViewModel.allowedValues.indexOf(closest).toDouble();
  }

  Widget _buildHeader(int weight) {
    return Row(
      children: [
        // Album Art
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              song.coverImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => const Icon(Icons.music_note, color: Colors.white, size: 60),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Song Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "CHANCE FACTOR",
                style: TextStyle(
                  color: Colors.white.withAlpha(153),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Percentage Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(38),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withAlpha(51), width: 1.5),
          ),
          child: Text(
            "$weight%",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, double sliderValue, int weight) {
     return SizedBox(
        height: 30, // Fixed height for slider area
        child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.black.withAlpha(51),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withAlpha(51),
              trackHeight: 12.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0, elevation: 5),
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: sliderValue,
              min: 0,
              max: (SettingsViewModel.allowedValues.length - 1).toDouble(),
              divisions: SettingsViewModel.allowedValues.length - 1,
              label: '$weight',
              onChanged: (double value) {
                int index = value.round();
                int newWeight = SettingsViewModel.allowedValues[index];
                viewModel.updateWeight(song.theme, newWeight);
              },
            ),
        ),
     );
  }
}

class _WatermarkPattern extends StatelessWidget {
  final String iconPath;
  const _WatermarkPattern({required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: OverflowBox(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        alignment: Alignment.center,
        child: Opacity(
          opacity: 0.05,
          child: Transform.scale(
            scale: 1.5,
            child: Transform.rotate(
              angle: -0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(12, (rowIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (rowIndex % 2 != 0) const SizedBox(width: 40),
                        ...List.generate(8, (colIndex) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              iconPath,
                              width: 24,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
