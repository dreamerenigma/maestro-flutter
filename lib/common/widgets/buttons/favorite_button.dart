import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:get/get.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class FavoriteButton extends StatefulWidget {
  final SongEntity songEntity;
  final bool showLikeCount;

  const FavoriteButton({super.key, required this.songEntity, this.showLikeCount = true});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.songEntity.likeCount;
    context.read<FavoriteButtonCubit>().loadInitialState(widget.songEntity.isFavorite, _likeCount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
      builder: (context, state) {
        if (state is FavoriteButtonUpdated) {
          _likeCount = state.likeCount;
        }

        return InkWell(
          onTap: () {
            context.read<FavoriteButtonCubit>().favoriteButtonUpdated(widget.songEntity.songId, _likeCount);
            if (state is FavoriteButtonUpdated) {
              Get.snackbar('Success', state.isFavorite ? 'Added to favorites!' : 'Removed from favorites!');
            }
          },
          splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  _likeCount > 0 ? Icons.favorite : Icons.favorite_border_rounded,
                  size: AppSizes.iconLg,
                  color: _likeCount > 0 ? AppColors.primary : context.isDarkMode ? AppColors.white : AppColors.black,
                ),
                if (widget.showLikeCount && _likeCount > 0)
                  SizedBox(width: 5),
                if (widget.showLikeCount && _likeCount > 0)
                Text(
                  _likeCount.toString(),
                  style: TextStyle(
                    color: _likeCount > 0 ? AppColors.primary : (context.isDarkMode ? AppColors.white : AppColors.black),
                    fontSize: AppSizes.fontSizeLg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

