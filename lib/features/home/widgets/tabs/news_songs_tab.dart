import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../bloc/news_songs_cubit.dart';
import '../../bloc/news_songs_state.dart';

class NewsSongsTab extends StatelessWidget {
  const NewsSongsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please sign in to view content'));
    }

    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
          builder: (context, state) {
            if (state is NewsSongsLoading) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
              );
            }
            if (state is NewsSongsLoaded) {
              return _buildNews(state.songs);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildNews(List<SongEntity> songs) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        bool isFirstItem = index == 0;
        bool isLastItem = index == songs.length - 1;

        return Padding(
          padding: EdgeInsets.only(left: isFirstItem ? 10 : 0, right: isLastItem ? 10 : 0),
          child: InkWell(
            onTap: () async {},
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(AppImages.albumImage),
                            onError: (exception, stackTrace) {
                              log('Error loading image: $exception');
                            },
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 40,
                            width: 40,
                            transform: Matrix4.translationValues(10, 10, 0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.isDarkMode ? AppColors.darkGrey : AppColors.grey
                            ),
                            child: Icon(Icons.play_arrow_rounded, color: context.isDarkMode ? AppColors.darkerGrey : AppColors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      songs[index].title,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppSizes.fontSizeMd),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      songs[index].artist,
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: songs.length,
    );
  }
}
