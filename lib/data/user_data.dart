class UserData {
  String? userName;
  String? email;
  String? createdAt;
  String? alamat;

  UserData({
    this.userName,
    this.email,
    this.createdAt,
    this.alamat,
  });

  factory UserData.fromJson(Map<dynamic, dynamic> json) {
    return UserData(
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      createdAt: json['createdAt'] as String?,
      alamat: json['alamat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'createdAt': createdAt,
      'alamat': alamat,
    };
  }
}
