
class UserEntity {
  late int id;
  late String name;
  late String password;
  UserEntity({
    required this.id,
    required this.name,
    required this.password
  });

  UserEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    password = json['password'];
  }
}
