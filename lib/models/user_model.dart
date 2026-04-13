class UserModel {
  final String name;
  final String email;
  final String phone;

  const UserModel({
    this.name = '',
    this.email = '',
    this.phone = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return UserModel(
      name: user['name'] as String? ?? '',
      email: user['email'] as String? ?? '',
      phone: user['phone'] as String? ?? '',
    );
  }
}
