import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../data/services/playlist/playlist_firebase_service.dart';
import '../../../../../service_locator.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../../bloc/playlist/playlist_cubit.dart';
import '../../../bloc/playlist/playlist_state.dart';
import '../../../widgets/dialogs/are_your_sure_dialog.dart';
import '../../../widgets/tabs/details_tab.dart';
import '../../../widgets/tabs/tracks_tab.dart';

class EditPlaylist extends StatefulWidget {
  final Map<String, dynamic> playlist;

  const EditPlaylist({super.key, required this.playlist});

  @override
  State<EditPlaylist> createState() => _EditPlaylistState();
}

class _EditPlaylistState extends State<EditPlaylist> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isPublic = true;
  AssetEntity? selectedImage;
  String? _playlistImageUrl;
  String description = 'Describe your track';
  List<String> tags = [];
  int trackCount = 0;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.playlist['title'] ?? '';
    _descriptionController.text = widget.playlist['description'] ?? '';
  }

  void _updatePlaylistTitle(String newTitle) {
    setState(() {
      _titleController.text = newTitle;
    });
  }

  void _updatePlaylistDescription(String newDescription) {
    setState(() {
      _descriptionController.text = newDescription;
    });
  }

  void _updatePlaylistTags(List<String> newTags) {
    setState(() {
      tags = newTags;
    });
  }

  void _updatePlaylistImageUrl(String newImageUrl) {
    setState(() {
      _playlistImageUrl = newImageUrl;
    });
  }

  Future<void> _onSavePressed() async {
  log('Saving playlist with data:');
  log('Title: ${_titleController.text}');
  log('Description: $description');
  log('Track count: $trackCount');
  log('Tags: $tags');
  log('Cover image URL: $_playlistImageUrl');
  log('Is Public: $isPublic');

  GetStorage().remove('tags');

  final playlistState = context.read<PlaylistCubit>().state;
  if (playlistState is PlaylistLoaded) {
    final playlist = playlistState.playlist;
    log('Current playlist data: ${playlist.title}, ${playlist.description}, ${playlist.trackCount}');

    final updatedCover = _playlistImageUrl ?? playlist.coverImage;
    final updatedTitle = _titleController.text;
    final updatedDescription = description;
    final updatedTrackCount = trackCount;
    final updatedTags = tags;
    final updatedIsPublic = isPublic;

    try {
      final result = await sl<PlaylistFirebaseService>().updatePlaylist(
        playlist.playlistId,
        updatedCover,
        updatedTitle,
        updatedDescription,
        updatedTrackCount,
        updatedTags,
        updatedIsPublic,
      );

      result.fold(
        (error) {
          Get.snackbar('Failed', 'Failed to update playlist: $error');
          log('Error updating playlist: $error');
        },
        (successMessage) {
          Get.snackbar('Success', 'Upload Playlist Complete');
          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      log('Error saving playlist: $e');
      Get.snackbar('Error', 'An error occurred while saving the playlist');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: BasicAppBar(
          title: Text('Edit', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
          saveButtonText: 'Save',
          onSavePressed: _onSavePressed,
          showCloseIcon: true,
          onBackPressed: () {
            GetStorage().remove('tags');
            showAreYouSureDialog(context);
          },
          centerTitle: false,
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: context.isDarkMode ? AppColors.white : AppColors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: context.isDarkMode ? AppColors.white : AppColors.black,
              labelStyle: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold),
              labelPadding: const EdgeInsets.only(left: 6, right: 6),
              splashBorderRadius: BorderRadius.circular(6),
              unselectedLabelColor: AppColors.grey,
              dividerColor: AppColors.transparent,
              overlayColor: WidgetStateProperty.all(AppColors.darkGrey.withAlpha((0.2 * 255).toInt())),
              tabs: [
                Tab(text: 'Tracks'),
                Tab(text: 'Details'),
              ],
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: TabBarView(
                  children: [
                    const TracksTab(),
                    DetailsTab(
                      playlist: widget.playlist,
                      onTitleChanged: _updatePlaylistTitle,
                      onDescriptionChanged: _updatePlaylistDescription,
                      onTagsChanged: _updatePlaylistTags,
                      onImageUrlChanged: _updatePlaylistImageUrl,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
