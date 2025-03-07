import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/concerts_cubit.dart';

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
    );
  }
}
