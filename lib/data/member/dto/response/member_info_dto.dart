class MemberInfoDto {
  final int memberId;
  final String oauthProvider;
  final String nickname;
  final String profileImageUrl;
  final String status;
  final String role;
  final bool localImageDeletion;

  MemberInfoDto({
    required this.memberId,
    required this.oauthProvider,
    required this.nickname,
    required this.profileImageUrl,
    required this.status,
    required this.role,
    required this.localImageDeletion
  });

  factory MemberInfoDto.fromJson(Map<String, dynamic> json) {
    return MemberInfoDto(
      memberId: json['memberId'] as int,
      oauthProvider: json['oauthProvider'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      status: json['status'] as String,
      role: json['role'] as String,
      localImageDeletion: json['localImageDeletion'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'oauthProvider': oauthProvider,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'status': status,
      'role': role,
      'localImageDeletion': localImageDeletion,
    };
  }
}
