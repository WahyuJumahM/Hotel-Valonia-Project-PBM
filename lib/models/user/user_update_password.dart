class UserUpdatePasswordDto {
  final String oldPassword;
  final String newPassword;

  UserUpdatePasswordDto({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };
}
