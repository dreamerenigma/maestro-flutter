import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../song_player/bloc/song_player_cubit.dart';
import '../../screens/follow_screen.dart';

class SearchHistoryItem extends StatefulWidget {
  final int initialIndex;
  final Map<String, dynamic> item;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final UserEntity? user;

  const SearchHistoryItem({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onTap,
    required this.initialIndex,
    required this.user,
  });

  @override
  State<SearchHistoryItem> createState() => _SearchHistoryItemState();
}

class _SearchHistoryItemState extends State<SearchHistoryItem> {
  SongEntity? currentSong;

  @override
  Widget build(BuildContext context) {
    final songEntity = context.read<SongPlayerCubit>().currentSong;

    return InkWell(
      onTap: () {
        if (widget.item['type'] == 'user') {
          Navigator.push(context, createPageRoute(FollowScreen(initialIndex: 2, user: widget.user)));
        } else if (widget.item['type'] == 'song') {
          context.read<SongPlayerCubit>().playOrPauseSong(songEntity);
        }
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 4, top: 8, bottom: 8),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1)),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                backgroundImage: widget.item['image'] != null && widget.item['image'].isNotEmpty ? NetworkImage(widget.item['image']) : null,
                child: widget.item['image'] == null || widget.item['image'].isEmpty ? SvgPicture.asset(AppVectors.avatar, width: 50, height: 50) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.item['name'], style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold))),
            IconButton(icon: Icon(Icons.close, color: AppColors.grey, size: 23), onPressed: widget.onDelete),
          ],
        ),
      ),
    );
  }
}
