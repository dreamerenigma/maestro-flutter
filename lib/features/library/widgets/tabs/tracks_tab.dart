import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TracksTab extends StatelessWidget {
  const TracksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please sign in to view content'));
    }

    return Column(
      children: [

      ],
    );
  }
}
