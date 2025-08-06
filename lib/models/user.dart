class UserModel {
  final String id;
  final String email;
  final String bidang;
  final String name;
  final String username;
  final String role;

  UserModel({
    required this.id, 
    required this.email,
    required this.bidang, 
    required this.name, 
    required this.username, 
    required this.role,
    });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'],
      bidang: json['bidang'],
      name: json['name'],
      username: json['username'],
      role: json['role'],
    );
  }
}