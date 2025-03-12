import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maestro/domain/entities/song/song_entity.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../data/services/user/user_firebase_service.dart';
import '../../../../../service_locator.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

class AddMusicScreen extends StatefulWidget {
  const AddMusicScreen({super.key});

  @override
  AddMusicScreenState createState() => AddMusicScreenState();
}

class AddMusicScreenState extends State<AddMusicScreen> {
  List<SongEntity> recommendedTracks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getRecommendedTracks();
  }

  Future<void> _getRecommendedTracks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        log("No user is logged in.");
        return;
      }

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isLoading = true;
      });

      final createResult = await sl<UserFirebaseService>().createRecommendedCollection(user.uid);

      createResult.fold(
        (error) {
          log('Error creating recommended collection: $error');
          setState(() {
            isLoading = false;
          });
        },
        (recommendedTracks) async {
          final result = await sl<UserFirebaseService>().getRecommendedTracks(user.uid);

          result.fold(
            (error) {
              log('Error fetching recommended tracks: $error');
              setState(() {
                isLoading = false;
              });
            },
            (tracks) {
              setState(() {
                this.recommendedTracks = tracks;
                isLoading = false;
              });
            },
          );
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Error fetching recommended tracks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Add music', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        saveButtonText: 'Save',
        onSavePressed: () {},
        showCloseIcon: true,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Recommended', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
            if (!isLoading)
              Expanded(
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: ListView.builder(
                    itemCount: recommendedTracks.length,
                    itemBuilder: (context, index) {
                      final track = recommendedTracks[index];
                      return ListTile(
                        leading: Image.network(track.cover),
                        title: Text(track.title),
                        subtitle: Text(track.artist),
                        trailing: IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () {},
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
