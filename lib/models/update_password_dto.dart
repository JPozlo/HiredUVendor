class UpdatePasswordDTO {
  UpdatePasswordDTO({required this.password,required this.newPassword});
  final String password;
  final String newPassword;

  Map<String, dynamic> toJson() => {'password': password, 'new_password': newPassword};
}
