class User {
  final String login;
  final String password;
  final String uuid;
  final String? imageUrl;
  final String name;

  User({
    required this.login,
    required this.password,
    required this.uuid,
    this.imageUrl,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'password': password,
      'uuid': uuid,
      'image_url': imageUrl,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      login: map['login'],
      password: map['password'],
      uuid: map['uuid'],
      imageUrl: map['image_url'],
      name: map['name'],
    );
  }

  @override
  String toString() {
    return 'User{login: $login, password: $password, uuid: $uuid, image_url: $imageUrl, name: $name}';
  }
}
