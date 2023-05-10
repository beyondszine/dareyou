// ignore_for_file: unnecessary_this

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool gender;
  final String profileImageURL;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    this.profileImageURL = "",
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      profileImageURL: json['profileImageURL'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'gender': gender,
        'profileImageURL': profileImageURL,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  UserProfile copyWith({
    String? firstName,
  }) {
    return UserProfile(
      id: this.id,
      firstName: firstName ?? this.firstName,
      lastName: this.lastName,
      email: this.email,
      password: this.password,
      gender: this.gender,
      profileImageURL: this.profileImageURL,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    );
  }
}
