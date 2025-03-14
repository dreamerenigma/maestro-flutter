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

  const FavoriteButton({super.key, required this.songEntity});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.songEntity.isFavorite;
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

        return GestureDetector(
          onTap: () {
            if (!_isFavorite) {
              context.read<FavoriteButtonCubit>().favoriteButtonUpdated(
                widget.songEntity.songId, _likeCount
              );
              if (!_isFavorite) {
                Get.snackbar('Success', 'Added to favorites!');
              }
            }
          },
          child: Row(
            children: [
              Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
                color: _isFavorite ? AppColors.primary : context.isDarkMode ? AppColors.white : AppColors.black,
                size: 28,
              ),
              SizedBox(width: 5),
              if (_likeCount > 0)
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
        );
      },
    );
  }
}

