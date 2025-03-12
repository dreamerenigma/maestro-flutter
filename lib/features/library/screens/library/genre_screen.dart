import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../bloc/song/song_cubit.dart';
import '../../bloc/song/song_state.dart';

class PickGenreScreen extends StatefulWidget {
  const PickGenreScreen({super.key});

  @override
  PickGenreScreenState createState() => PickGenreScreenState();
}

class PickGenreScreenState extends State<PickGenreScreen> {
  String? selectedGenre;
  String? selectedAudio;
  final _storageBox = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> genres = [
    "Alternative Rock", "Ambient", "Classical", "Country", "Dance & EDM",
    "Dancehall", "Deep House", "Disco", "Drum & Base", "Dubstep", "Electronic",
    "Folk & Singer-Songwriter", "Hip-hop & Rap", "House", "Indie", "Jazz & Blues",
    "Latin", "Metal", "Piano", "Pop", "R&B Soul", "Reggae", "Reggaeton", "Rock",
    "Soundtrack", "Speech", "Techno", "Trance", "Trap", "Triphop", "World",
  ];

  List<String> audio = [
    "Audiobooks", "Business", "Comedy", "Entertainment", "Learning", "News & Politics",
    "Religion & Spirituality", "Science", "Sports", "Storytelling", "Technology",
  ];

  @override
  void initState() {
    super.initState();
    selectedGenre = _storageBox.read('selectedGenre');
    selectedAudio = _storageBox.read('selectedAudio');
    _getGenreFromFirestore();
  }

  Future<void> _getGenreFromFirestore() async {
    final songState = context.read<SongCubit>().state;
    if (songState is SongLoaded) {
      String songId = songState.song.songId;

      try {
        DocumentSnapshot doc = await _firestore.collection('Songs').doc(songId).get();
        if (doc.exists) {
          String genre = doc['genre'] ?? "Unknown Genre";
          log('Fetched genre from Firestore: $genre');

          setState(() {
            selectedGenre = genre;
          });
        } else {
          log('Song document not found');
        }
      } catch (e) {
        log('Error getting genre from Firestore: $e');
      }
    }
  }

  Future<void> _updateGenreInFirestore(String genre) async {
  final songState = context.read<SongCubit>().state;
  if (songState is SongLoaded) {
    String songId = songState.song.songId;

    try {
      await _firestore.collection('Songs').doc(songId).update({
        'genre': genre,
      });
      log('Genre updated in Firestore');
    } catch (e) {
      log('Error updating genre in Firestore: $e');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Pick genre', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Music', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w200, color: AppColors.lightGrey)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  String genre = genres[index];
                  return InkWell(
                    onTap: () async {
                      setState(() {
                        selectedGenre = genre;
                        _storageBox.write('selectedGenre', selectedGenre);
                      });
                      await _updateGenreInFirestore(selectedGenre!);
                      Navigator.pop(context, selectedGenre);
                    },
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(genre, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w200, letterSpacing: -0.5)),
                          if (selectedGenre == genre) const Icon(Icons.check, color: AppColors.primary),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Audio', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w200, color: AppColors.lightGrey)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: audio.length,
                itemBuilder: (context, index) {
                  String audioCategory = audio[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedAudio = audioCategory;
                        _storageBox.write('selectedAudio', selectedAudio);
                      });
                      Navigator.pop(context, selectedAudio);
                    },
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(audioCategory, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w200, letterSpacing: -0.5)),
                          if (selectedAudio == audioCategory)
                            const Icon(Icons.check, color: AppColors.blue),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
