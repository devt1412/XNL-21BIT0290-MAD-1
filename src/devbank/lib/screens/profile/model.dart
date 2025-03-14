class ProfileModel {
  final String username;
  final String phoneNumber;

  ProfileModel({
    required this.username,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'phoneNumber': phoneNumber,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
