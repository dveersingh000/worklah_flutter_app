class UserModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String employmentStatus;
  final String profilePicture;
  final bool profileCompleted;
  final String createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.employmentStatus,
    required this.profilePicture,
    required this.profileCompleted,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      employmentStatus: json['employmentStatus'],
      profilePicture: json['profilePicture'],
      profileCompleted: json['profileCompleted'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'employmentStatus': employmentStatus,
      'profilePicture': profilePicture,
      'profileCompleted': profileCompleted,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? employmentStatus,
    String? profilePicture,
    bool? profileCompleted,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      profilePicture: profilePicture ?? this.profilePicture,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
