class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String confirmpassword;
  final String? profile;
  final String phone;
  final String address;
  final String? deviceToken;
  final String? facebookid;
  final String? googleid;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmpassword,
    this.profile,
    required this.phone,
    required this.address,
    this.deviceToken,
    this.facebookid,
    this.googleid,
  });
}
