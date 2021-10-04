
class UpdateProfileUser {
  UpdateProfileUser({
    this.email,
    this.name,
    this.phone,
    this.id,
    this.level,
    this.status,
    this.deviceName,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.profile,
  });

  final String? profile;
  final String? email;
  final String? name;
  final String? deviceName;
  final String? phone;
  final String? createdAt;
  final String? updatedAt;
  final String? emailVerifiedAt;
  final int? id;
  final bool? status;
  final int? level;

  factory UpdateProfileUser.fromJson(Map<String, dynamic> json) {
    return UpdateProfileUser(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      profile: json['profile'] ?? "null",
      status: json['status'] as bool,
      level: json['level'] as int,
      deviceName: json['device_name'] as String ,
      emailVerifiedAt: json['email_verified_at'] as String ,
      createdAt: json['created_at'] as String ,
      updatedAt: json['updated_at'] as String,
    );
  }

}
