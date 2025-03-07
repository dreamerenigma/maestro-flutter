class CreateUserReq {
  CreateUserReq({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    required this.gender,
    required this.age,
  });

  late String id;
  late String createdAt;
  late String name;
  late String email;
  late String password;
  late String image;
  late String? gender;
  late int? age;

  CreateUserReq.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    createdAt = json['createdAt'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    image = json['image'] ?? '';
    gender = json['gender'] ?? '';
    age = json['age'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['name'] = name;
    data['email'] = email;
    data['image'] = password;
    data['image'] = image;
    data['created_at'] = gender;
    data['is_online'] = age;
    return data;
  }
}
