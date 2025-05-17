class AppUser {
  final String uid;
  final String name;
  final String email;
  final String avatar;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }
}