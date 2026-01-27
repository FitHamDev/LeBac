import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:frontend/models/song.dart';
import 'package:frontend/repository/song_repository.dart';



class HomeViewModel extends ChangeNotifier {

  final player = AudioPlayer();
  final SongRepository songRepository = SongRepository();

  late Song _currentSong = songRepository.none;
  Song get currentSong => _currentSong;
  
  bool _isOnCooldown = false;
  bool get isOnCooldown => _isOnCooldown;
  Timer? _cooldownTimer;

  Future<void> playSong(Song song) async {
    try {
      await player.stop(); 
      _currentSong = song;
      notifyListeners();
      unawaited(player.play(AssetSource(song.sound)));
      
      // Start 3-second cooldown for LeBlanc or LeGoon
      if (song.theme == 'leblanc' || song.theme == 'legoon') {
        _isOnCooldown = true;
        notifyListeners();
        _cooldownTimer?.cancel();
        _cooldownTimer = Timer(const Duration(seconds: 3), () {
          _isOnCooldown = false;
          notifyListeners();
        });
      }
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
  
  Future<void> playRandomSong() async {
    int random = Random().nextInt(100);
    Song nextSong;

    if (random < 75){
      nextSong = songRepository.solidStigma;
    } else if (random < 95){
      nextSong = songRepository.reneeLeBlanc;
    } else {
      nextSong = songRepository.reneeLeGoon;
    }
    await playSong(nextSong);
  }
}