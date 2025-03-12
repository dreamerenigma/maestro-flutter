import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import 'package:get/get.dart';

import '../../../domain/entities/song/song_entity.dart';

class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;

  const FavoriteButton({super.key, required this.songEntity});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteButtonCubit(),
      child: BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
        builder: (context, state) {
          if (state is FavoriteButtonInitial || state is FavoriteButtonUpdated) {
            bool isFavorite = state is FavoriteButtonUpdated ? state.isFavorite : songEntity.isFavorite;

            return IconButton(
              onPressed: () {
                if (!isFavorite) {
                  Get.snackbar('Success', 'Added to favorites!');
                }
                context.read<FavoriteButtonCubit>().favoriteButtonUpdated(songEntity.songId);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
                size: 25,
                color: AppColors.darkerGrey,
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
