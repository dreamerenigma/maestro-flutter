import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:get/get.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteButton extends StatefulWidget {
  final SongEntity songEntity;
  final bool showLikeCount;

  const FavoriteButton({super.key, required this.songEntity, this.showLikeCount = true});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;
  late int _likeCount;

  final GetStorage _storage = GetStorage();
  late String _storageKey;

  @override
  void initState() {
    super.initState();
    _storageKey = 'favorite_${widget.songEntity.songId}';
    _isFavorite = _storage.read(_storageKey) ?? widget.songEntity.isFavorite;
    _likeCount = widget.songEntity.likeCount;
    context.read<FavoriteButtonCubit>().loadInitialState(_isFavorite, _likeCount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
      builder: (context, state) {
        if (state is FavoriteButtonUpdated) {
          _isFavorite = state.isFavorite;
          _likeCount = state.likeCount;
        }

        return InkWell(
          onTap: () {
            if (!_isFavorite) {
              context.read<FavoriteButtonCubit>().favoriteButtonUpdated(widget.songEntity.songId, _likeCount);
              _storage.write(_storageKey, true);
              setState(() {
                _isFavorite = true;
              });
              Get.snackbar('Success', 'Added to favorites!');
            } else {
              context.read<FavoriteButtonCubit>().favoriteButtonUpdated(widget.songEntity.songId, _likeCount);
              _storage.write(_storageKey, false);
              setState(() {
                _isFavorite = false;
              });
              Get.snackbar('Success', 'Removed from favorites!');
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
                  _isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
                  color: _isFavorite ? AppColors.primary : context.isDarkMode ? AppColors.white : AppColors.black,
                  size: 28,
                ),
                SizedBox(width: 5),
                if (widget.showLikeCount && _likeCount > 0)
                Text(
                  '$_likeCount',
                  style: TextStyle(
                    color: _isFavorite ? AppColors.primary : context.isDarkMode ? AppColors.white : AppColors.black,
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


