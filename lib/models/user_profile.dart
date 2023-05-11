// ignore_for_file: unnecessary_this

class UserProfile {
  final String userName;
  final String? email;
  final String? phoneno;
  final bool? gender;
  final String? profileImageURL;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile(
      {required this.userName,
      required this.email,
      required this.phoneno,
      required this.gender,
      required this.profileImageURL,
      required this.createdAt,
      required this.updatedAt});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userName: json['userName'],
      email: json['email'] ?? "",
      phoneno: json['phoneno'] ?? "",
      gender: json['gender'],
      profileImageURL: json['profileImageURL'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        "phoneno": phoneno,
        'gender': gender,
        'profileImageURL': profileImageURL,
        'createdAt': createdAt != null ? createdAt?.toIso8601String() : "",
        'updatedAt': updatedAt != null ? updatedAt?.toIso8601String() : "",
      };

  UserProfile copyWith({
    String? profileImageURL,
    bool? gender,
  }) {
    return UserProfile(
      userName: this.userName,
      email: this.email,
      phoneno: this.phoneno,
      gender: gender ?? this.gender,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    );
  }
}
