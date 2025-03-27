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

class EditPlaylistScreen extends StatefulWidget {
  final Map<String, dynamic> playlist;

  const EditPlaylistScreen({super.key, required this.playlist});

  @override
  State<EditPlaylistScreen> createState() => EditPlaylistScreenState();
}

class EditPlaylistScreenState extends State<EditPlaylistScreen> {
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
    log('Received playlist data: ${widget.playlist}');
    _titleController.text = widget.playlist['title'] ?? '';
    _descriptionController.text = widget.playlist['description'] ?? '';
    _playlistImageUrl = widget.playlist['coverImage'];
  }

  void _updatePlaylistTitle(String newTitle) {
    setState(() {
      _titleController.text = newTitle;
      log('Updated title: $newTitle');
    });
  }

  void _updatePlaylistDescription(String newDescription) {
    setState(() {
      _descriptionController.text = newDescription;
      log('Updated description: $newDescription');
    });
  }

  void _updatePlaylistTags(List<String> newTags) {
    setState(() {
      tags = newTags;
      log('Updated tags: $tags');
    });
  }

  void _updatePlaylistImageUrl(String newImageUrl) {
    setState(() {
      _playlistImageUrl = newImageUrl;
      log('Updated cover image URL: $newImageUrl');
    });
  }

  Future<void> _onSavePressed() async {
    log('Attempting to save playlist...');
    log('Title: ${_titleController.text}');
    log('Description: ${_descriptionController.text}');
    log('Track count: $trackCount');
    log('Tags: $tags');
    log('Cover image URL: $_playlistImageUrl');
    log('Is Public: $isPublic');

    GetStorage().remove('tags');

    final playlistState = context.read<PlaylistCubit>().state;
    log('Current PlaylistCubit state: $playlistState');

    if (playlistState is PlaylistLoading) {
      Get.snackbar('Error', 'Playlist is still loading. Please wait.');
      log('Error: playlist is loading');
      return;
    }

    if (playlistState is! PlaylistLoaded) {
      Get.snackbar('Error', 'Playlist is still loading. Try again.');
      log('Error: playlist is null inside PlaylistLoaded');
      return;
    }

    final playlist = playlistState.playlist;
    log('Existing playlist data before update:');
    log('ID: ${playlist.id}');
    log('Title: ${playlist.title}');
    log('Description: ${playlist.description}');
    log('Track count: ${playlist.trackCount}');
    log('Cover Image URL: ${playlist.coverImage}');

    final updatedPlaylist = playlist.copyWith(
      coverImage: _playlistImageUrl ?? playlist.coverImage,
      title: _titleController.text,
      description: _descriptionController.text,
      trackCount: trackCount,
      tags: tags,
      isPublic: isPublic,
    );

    log('Updated playlist data:');
    log('Title: ${updatedPlaylist.title}');
    log('Description: ${updatedPlaylist.description}');
    log('Track count: ${updatedPlaylist.trackCount}');
    log('Cover Image URL: ${updatedPlaylist.coverImage}');
    log('Tags: ${updatedPlaylist.tags}');
    log('Is Public: ${updatedPlaylist.isPublic}');

    try {
      final result = await sl<PlaylistFirebaseService>().updatePlaylist(
        updatedPlaylist.id,
        updatedPlaylist.title,
        updatedPlaylist.description,
        updatedPlaylist.coverImage,
        updatedPlaylist.trackCount,
        updatedPlaylist.tags,
        updatedPlaylist.isPublic,
      );

      result.fold(
        (error) {
          log('Error saving playlist: $error');
          Get.snackbar('Error', 'An error occurred while saving the playlist');
        },
        (successMessage) {
          Get.snackbar('Success', successMessage);
          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      log('Error saving playlist: $e');
      Get.snackbar('Error', 'An error occurred while saving the playlist');
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
