import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../bloc/videos_cubit.dart';
import '../../bloc/videos_state.dart';

class VideosTab extends StatelessWidget {
  const VideosTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please sign in to view content'));
    }

    return BlocProvider(
      create: (_) => VideosCubit()..getVideos(),
      child: BlocBuilder<VideosCubit, VideosState>(
        builder: (context, state) {
          if (state is VideosLoading) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
          }

          if (state is VideosLoaded) {
            if (state.videos.isEmpty) {
              return const Center(
                child: Text('No videos available', style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
              );
            }

            return ListView.builder(
              itemCount: state.videos.length,
              itemBuilder: (context, index) {
                final video = state.videos[index];
                return ListTile(
                  title: Text(video.title),
                  subtitle: Text('Video'),
                );
              },
            );
          }

          if (state is VideosLoadFailure) {
            return const Center(
              child: Text('Failed to load videos', style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.red)),
            );
          }

          return const Center(
            child: Text('Something went wrong', style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
          );
        },
      ),
    );
  }
}
