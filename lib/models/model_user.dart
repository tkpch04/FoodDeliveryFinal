class UserModel {
  final String id;
  final String nama;
  final String email;
  final String password;
  final String lokasi;

  UserModel(
      {required this.id,
      required this.nama,
      required this.email,
      required this.password,
      required this.lokasi});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        nama: json['nama'],
        email: json['email'],
        password: json['password'],
        lokasi: json['lokasi']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'lokasi': lokasi
    };
  }
}
