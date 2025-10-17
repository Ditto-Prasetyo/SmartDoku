class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String bidang;
  final String role;
  final String address;
  final String phone_number;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.bidang,
    required this.role,
    required this.address,
    required this.phone_number
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      username: json['username'],
      email: json['email'],
      bidang: json['bidang'],
      role: json['role'],
      address: json['address'],
      phone_number: json['phone_number']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'bidang': bidang,
      'role': role,
      'address': address,
      'phone_number': phone_number
    };
  }
}
