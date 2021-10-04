class User {
  final int? uid;
  final String? email;
  final String? name;
  final String? phone;
  final String? password;
  final String? confirmPassword;
  final String? token;
  final String? deviceName;
  final String? emailVerifiedAt;
  final String? profile;
  final String? createdAt;
  final String? updatedAt;

  const User({
    this.profile,
    this.email,
    this.name,
    this.phone,
    this.uid,
    this.password,
    this.confirmPassword,
    this.deviceName,
    this.token,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJsonUserData(Map<String, dynamic> json) {
    return User(
        profile: json['profile'] as String,
        uid: json['id'] as int,
        email: json['email'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
            );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'device_name': deviceName,
        'profile': profile
      };

  @override
  String toString() {
    return 'User{uid: $uid, email: $email, phone: $phone, name: $name}';
  }
}
