import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../widgets/dialogs/playlist_bottom_dialog.dart';

class ActionIconsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> playlists;
  final int index;
  final bool isShuffleActive;
  final VoidCallback toggleShuffle;

  const ActionIconsWidget({
    super.key,
    required this.playlists,
    required this.index,
    required this.isShuffleActive,
    required this.toggleShuffle,
  });

  @override
  ActionIconsWidgetState createState() => ActionIconsWidgetState();
}

class ActionIconsWidgetState extends State<ActionIconsWidget> {

  void _showPlaylistDialog(BuildContext context) {
    if (widget.playlists.isNotEmpty) {
      showPlaylistBottomDialog(
        context,
        widget.playlists,
        widget.index,
        (newIsPublic) {
          setState(() {
            widget.playlists[widget.index]['isPublic'] = newIsPublic;
          });
        },
        onPlaylistDeleted: () {
          setState(() {
            widget.playlists.removeAt(widget.index);
          });
        },
        showAdditionalOption: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 20, bottom: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: AppSizes.iconLg),
            onPressed: () => _showPlaylistDialog(context),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              BootstrapIcons.shuffle,
              color: widget.isShuffleActive ? AppColors.primary : AppColors.steelGrey,
              size: AppSizes.iconMd,
            ),
            onPressed: widget.toggleShuffle,
          ),
          const SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.light ? AppColors.lightGrey : AppColors.steelGrey,
            ),
            child: IconButton(
              icon: Icon(
                Icons.play_arrow_rounded,
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                size: 32,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
