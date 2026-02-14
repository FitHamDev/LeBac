import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:frontend/models/song.dart';
import 'package:frontend/repository/song_repository.dart';
import 'package:frontend/ViewModel/settings_viewmodel.dart';



class HomeViewModel extends ChangeNotifier {

  final SettingsViewModel settings;
  final player = AudioPlayer();
  final SongRepository songRepository = SongRepository();

  late Song _currentSong = songRepository.none;
  Song get currentSong => _currentSong;
  
  bool _isBlocked = false;
  bool get isOnCooldown => _isBlocked;
  
  bool _isProcessing = false;
  
  Timer? _cooldownTimer;
  
  late Song _nextSong = songRepository.leStigma;
  
  DateTime _lastSpecialSongStart = DateTime.fromMillisecondsSinceEpoch(0);

  HomeViewModel(this.settings) {
    _prequeueNextSong();
  }
  
  void _prequeueNextSong() {
    int totalWeight = 0;
    for (var song in songRepository.allSongs) {
      totalWeight += settings.getWeight(song.theme);
    }
    
    if (totalWeight <= 0) {
      _nextSong = songRepository.leStigma;
      return;
    }

    int random = Random().nextInt(totalWeight);
    int currentSum = 0;
    
    for (var song in songRepository.allSongs) {
      currentSum += settings.getWeight(song.theme);
      if (random < currentSum) {
        _nextSong = song;
        return;
      }
    }
    
    _nextSong = songRepository.leStigma;
  }

  Future<void> playSong(Song song) async {
    try {
      _currentSong = song;
      
      if (song.theme != 'stigma') {
        _isBlocked = true;
        _lastSpecialSongStart = DateTime.now(); // Mark start time
        debugPrint("Cooldown started for ${song.name}");
        
        _cooldownTimer?.cancel();
        _cooldownTimer = Timer(const Duration(seconds: 3), () {
          debugPrint("Cooldown ended");
          _isBlocked = false;
          notifyListeners();
        });
      }

      notifyListeners();

      // Force reset by awaiting stop first
      await player.stop();
      await player.play(AssetSource(song.sound));
      
    } catch (e) {
      debugPrint("Error playing song: $e");
    }
  }
  
  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }
  
  Future<void> stopMusic() async {
    try {
      await player.stop();
      _currentSong = songRepository.none;
      notifyListeners();
    } catch (e) {
       debugPrint("Error stopping song: $e");
    }
  }
  
  Future<bool> playRandomSong() async {
    if ((_currentSong.theme != 'stigma') &&
        DateTime.now().difference(_lastSpecialSongStart).inMilliseconds < 3000) {
       debugPrint("Hard block: Mandatory 3s listen time not met");
       return false;
    }

    if (_isBlocked || _isProcessing) {
      debugPrint("Blocked: cooldown=$_isBlocked, processing=$_isProcessing");
      return false;
    }
    
    _isProcessing = true;
    
    try {
      final songToPlay = _nextSong;

      if (songToPlay.theme != 'stigma') {
        _isBlocked = true;
        notifyListeners();
      }
      
      _prequeueNextSong();
      
      await playSong(songToPlay);
      return true;
    } finally {
      _isProcessing = false;
    }
  }
}