class UserModel {
  String id;
  String name;
  String email;
  String password;
  String confirmPassword;
  String role;
  String? resetToken;

  UserModel(this.id, this.name, this.email, this.password, this.confirmPassword,
      this.role, this.resetToken);
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        json['_id'] as String,
        json['name'] as String,
        json['email'] as String,
        json['password'] as String,
        json['confirmPassword'] as String,
        json['role'] as String,
        json['resetToken'] as String);
  }
  Map toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "role": role,
        "resetToken": resetToken
      };
}
