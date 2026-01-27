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

  Future<void> playSong(Song song) async {
    try {
      await player.stop(); 
      await player.play(AssetSource(song.sound));
      _currentSong = song;
      notifyListeners();
    } catch (e) {
      debugPrint("Error playing song: $e");
    }
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
    await stopMusic();
    int random = Random().nextInt(100);

    if (random < 70){
      await playSong(songRepository.solidStigma);
    } else if (random < 95){
      await playSong(songRepository.reneeLeBlanc);
    } else {
      await playSong(songRepository.reneeLeGoon);
    }
    notifyListeners();
  }
}