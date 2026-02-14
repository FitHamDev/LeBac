
import 'package:frontend/models/song.dart';

class SongRepository {
  final Song none = Song(name: '', sound: '', coverImage: '', theme: 'stigma', icon: null);
  final Song leStigma = Song(name: 'LeStigma', sound: 'songs/solid_stigma.mp3', coverImage: 'assets/images/stigma_cover.png', theme: 'stigma', icon: null);
  final Song reneeLeBlanc = Song(name: 'LeBac', sound: 'songs/renee_leblanc.mp3', coverImage: 'assets/images/leblanc_cover.jpg', theme: 'leblanc', icon: 'assets/icons/leblanc_icon.png');
  final Song reneeLeGoon = Song(name: 'LeGoon', sound: 'songs/renee_legoon.mp3', coverImage: 'assets/images/legoon_cover.jpg', theme: 'legoon', icon: 'assets/icons/legoon_icon.png');
  final Song leSchnable = Song(name: 'LeSchnabel', sound: 'songs/renee_leschnable.mp3', coverImage: 'assets/images/leschnable_cover.png', theme: 'leschnable', icon: 'assets/icons/leschnable_icon.png');

  List<Song> get allSongs => [leStigma, reneeLeBlanc, reneeLeGoon, leSchnable];
}