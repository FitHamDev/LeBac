import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/song.dart';
import 'package:frontend/repository/song_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SongRepository _songRepository = SongRepository();
  List<Song> get songs => _songRepository.allSongs;

  Map<String, int> _songWeights = {
      'stigma': 75,
      'leblanc': 15,
      'legoon': 5,
      'leschnable': 5,
  };

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  SettingsViewModel() {
    _loadSettings();
  }

  int getWeight(String theme) {
    return _songWeights[theme] ?? 0;
  }
  
  double getProbability(String theme) {
    int total = _songWeights.values.fold(0, (sum, item) => sum + item);
    if (total == 0) return 0.0;
    return (_songWeights[theme] ?? 0) / total;
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _songWeights = {
        'stigma': prefs.getInt('weight_stigma') ?? 75,
        'leblanc': prefs.getInt('weight_leblanc') ?? 15,
        'legoon': prefs.getInt('weight_legoon') ?? 5,
        'leschnable': prefs.getInt('weight_leschnable') ?? 5,
      };
      
      for (var song in _songRepository.allSongs) {
        if (!_songWeights.containsKey(song.theme)) {
          _songWeights[song.theme] = 5; 
        }
      }
    } catch (e) {
      debugPrint("Error loading settings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWeight(String theme, int newWeight) async {
    if (theme == 'stigma') {
       if (newWeight < 25) newWeight = 25;
    } else {
       if (newWeight > 75) newWeight = 75;
    }

    final oldWeight = _songWeights[theme] ?? 0;
    if (newWeight == oldWeight) return;

    _songWeights[theme] = newWeight;
    
    int total = _songWeights.values.fold(0, (sum, item) => sum + item);
    int diff = total - 100;

    if (diff != 0) {

       final userKeys = _songWeights.keys.where((k) => k != theme).toList();
       
       userKeys.sort((a, b) => (_songWeights[b] ?? 0).compareTo(_songWeights[a] ?? 0));

       for (var key in userKeys) {
         if (diff == 0) break;
         
         int current = _songWeights[key] ?? 0;
         
         if (diff > 0) {
            int minAllowed = (key == 'stigma') ? 25 : 0;
            int canTake = current - minAllowed;
            if (canTake < 0) canTake = 0;
            
            int toTake = diff > canTake ? canTake : diff;
            
            _songWeights[key] = current - toTake;
            diff -= toTake;
         } 
         else {
            _songWeights[key] = current - diff;
            diff = 0;
         }
       }
    }
    
    notifyListeners();
    
    // Save all
    final prefs = await SharedPreferences.getInstance();
    _songWeights.forEach((key, val) {
       prefs.setInt('weight_$key', val);
    });
  }
  
  static const List<int> allowedValues = [
    0, 1, 2, 3, 4, 5,
    10, 15, 20, 25, 30, 35, 40, 45, 50,
    55, 60, 65, 70, 75, 80, 85, 90, 95, 100
  ];

  static final Map<int, int> _weightToSliderIndex = {
    for (var i = 0; i < allowedValues.length; i++) allowedValues[i]: i
  };

  /// O(1) slider index for a weight; uses closest allowed value if not exact.
  static double sliderValueForWeight(int weight) {
    final index = _weightToSliderIndex[weight];
    if (index != null) return index.toDouble();
    final closest = allowedValues.reduce(
      (a, b) => (weight - a).abs() < (weight - b).abs() ? a : b,
    );
    return _weightToSliderIndex[closest]!.toDouble();
  }
}
