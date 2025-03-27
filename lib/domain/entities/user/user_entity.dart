import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/home/models/user_model.dart';
import '../playlist/playable_item.dart';

class UserEntity implements PlayableItem {
  final String id;
  final String name;
  final String image;
  final String bio;
  final String city;
  final String country;
  final String flag;
  final String backgroundImage;
  final int followers;
  final List<String> links;
  final int limitUploads;
  final int tracksCount;
  final bool verifyAccount;

  UserEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.bio,
    required this.city,
    required this.country,
    required this.flag,
    required this.backgroundImage,
    required this.followers,
    required this.links,
    required this.limitUploads,
    required this.tracksCount,
    required this.verifyAccount,
  });

  factory UserEntity.fromUserModel(UserModel userModel) {
    return UserEntity(
      id: userModel.id,
      name: userModel.name,
      image: userModel.image,
      bio: userModel.bio,
      city: userModel.city,
      country: userModel.country,
      flag: userModel.flag,
      backgroundImage: userModel.backgroundImage,
      followers: userModel.followers,
      links: userModel.links,
      limitUploads: userModel.limitUploads,
      tracksCount: userModel.tracksCount,
      verifyAccount: userModel.verifyAccount,
    );
  }

  factory UserEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserEntity(
      id: doc.id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      bio: data['bio'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      flag: data['flag'] ?? '',
      backgroundImage: data['backgroundImage'] ?? '',
      followers: (data['followers'] ?? 0) as int,
      links: (data['links'] as List?)?.cast<String>() ?? [],
      limitUploads: (data['limitUploads'] ?? 0) as int,
      tracksCount: (data['tracksCount'] ?? 0) as int,
      verifyAccount: (data['verifyAccount'] ?? false) as bool,
    );
  }

  UserModel toUserModel() {
    return UserModel(
      id: id,
      name: name,
      image: image,
      bio: bio,
      city: city,
      country: country,
      flag: flag,
      backgroundImage: backgroundImage,
      followers: followers,
      links: links,
      limitUploads: limitUploads,
      tracksCount: tracksCount,
      verifyAccount: verifyAccount,
    );
  }
}
