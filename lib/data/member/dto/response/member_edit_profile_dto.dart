class MemberEditProfileDto {
  final String nickname;
  final String profileImageUrl;

  MemberEditProfileDto({
    required this.nickname,
    required this.profileImageUrl,
  });

  factory MemberEditProfileDto.fromJson(Map<String, dynamic> json) {
    return MemberEditProfileDto(
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
    };
  }
}
