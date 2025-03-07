import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;
import '../../../../data/sources/user/user_firebase_service.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../home/models/user_model.dart';
import '../items/following_item.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({super.key});

  @override
  FollowingListState createState() => FollowingListState();
}

class FollowingListState extends State<FollowingList> {
  final UserFirebaseService _userService = UserFirebaseServiceImpl();
  late Future<dartz.Either<String, UserModel>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _userService.getUserDetails('user123');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Following')),
      body: FutureBuilder<dartz.Either<String, UserModel>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
          } else if (snapshot.hasError || snapshot.data?.isLeft() == true) {
            return const Center(child: Text('Error loading user details'));
          } else if (snapshot.hasData) {
            final user = snapshot.data?.getOrElse(() => UserModel(
              id: '',
              name: '',
              followers: 0,
              image: '',
              bio: '',
              city: '',
              country: '',
              flag: '',
              backgroundImage: '',
            ));
            if (user != null) {
              return ListView(
                children: [
                  FollowingItem(user: user),
                ],
              );
            }
          }
          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
