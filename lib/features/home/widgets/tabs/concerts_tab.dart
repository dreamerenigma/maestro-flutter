import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../bloc/concerts_cubit.dart';
import '../../bloc/concerts_state.dart';
import '../lists/concert_list.dart';

class ConcertsTab extends StatelessWidget {
  const ConcertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please sign in to view content'));
    }

    return BlocProvider(
      create: (_) => ConcertsCubit()..getConcerts(),
      child: BlocBuilder<ConcertsCubit, ConcertsState>(
        builder: (context, state) {
          if (state is ConcertsLoading) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
          }

          if (state is ConcertsLoaded) {
            final concerts = state.concerts;

            return Column(
              children: [
                const Text('Upcoming Concerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ConcertList(concerts: concerts),
              ],
            );
          }

          if (state is ConcertsLoadFailure) {
            return const Center(child: Text('Failed to load concerts'));
          }

          return const Center(child: Text('No concerts available'));
        },
      ),
    );
  }
}
