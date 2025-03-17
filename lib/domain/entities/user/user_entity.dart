import '../../../features/home/models/user_model.dart';

class UserEntity {
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

