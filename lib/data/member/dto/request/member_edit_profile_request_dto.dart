class MemberEditProfileRequestDto {
  final String nickname;
  final String? profileImageUrl;

  MemberEditProfileRequestDto({required this.nickname, this.profileImageUrl});

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    };
  }
}
