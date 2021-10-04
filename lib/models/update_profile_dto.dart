class UpdateProfileDTO{
    UpdateProfileDTO({ this.name,  this.phone, this.email});
  final String? name;
  final String? phone;
  final String? email;

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone, 'email': email};
}