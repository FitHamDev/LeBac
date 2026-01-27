
import 'package:frontend/models/song.dart';

class SongRepository {
  final Song none = Song(name: '', sound: '', coverImage: '', theme: 'stigma', icon: null);
  final Song solidStigma = Song(name: 'Solid Stigma', sound: 'songs/solid_stigma.mp3', coverImage: 'assets/images/stigma_cover.png', theme: 'stigma', icon: null);
  final Song reneeLeBlanc = Song(name: 'Renee Le Blanc', sound: 'songs/renee_leblanc.mp3', coverImage: 'assets/images/leblanc_cover.jpg', theme: 'leblanc', icon: 'leblanc_icon.png');
  final Song reneeLeGoon = Song(name: 'Renee Le Goon', sound: 'songs/renee_legoon.mp3', coverImage: 'assets/images/legoon_cover.jpg', theme: 'legoon', icon: 'legoon_icon.png');
}