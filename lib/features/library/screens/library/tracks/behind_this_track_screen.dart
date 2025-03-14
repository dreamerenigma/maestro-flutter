import 'package:flutter/material.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../utils/constants/app_colors.dart';

class BehindThisTrackScreen extends StatelessWidget {
  const BehindThisTrackScreen({super.key});

  Future<void> simulateAsyncOperation() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cast, size: 23, color: AppColors.lightGrey),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: simulateAsyncOperation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [

              ],
            );
          }
        },
      ),
    );
  }
}
