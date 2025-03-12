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
      followers: data['followers'] ?? 0,
      links: List<String>.from(data['links'] ?? []),
      limitUploads: data['limitUploads'] ?? 0,
      tracksCount: data['tracksCount'] ?? 0,
    );
  }
}