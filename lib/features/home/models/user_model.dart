import '../../../domain/entities/user/user_entity.dart';

class UserModel {
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

  UserModel({
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

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      bio: data['bio'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      flag: data['flag'] ?? '',
      backgroundImage: data['backgroundImage'] ?? '',
      followers: data.containsKey('followers') ? data['followers'] : 0,
      links: (data['links'] is List) ? List<String>.from(data['links'].map((link) => link['webOrEmail'] ?? '')) : [],
      limitUploads: data.containsKey('limitUploads') ? data['limitUploads'] : 0,
      tracksCount: data['tracksCount'] ?? 0,
      verifyAccount: data.containsKey('verifyAccount') ? data['verifyAccount'] : false,
    );
  }

  UserEntity toUserEntity() {
    return UserEntity(
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
