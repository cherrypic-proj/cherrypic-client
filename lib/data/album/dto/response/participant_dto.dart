class ParticipantDto {
  final int participantId;
  final String nickname;
  final String profileImageUrl;
  final String role;

  ParticipantDto({
    required this.participantId,
    required this.nickname,
    required this.profileImageUrl,
    required this.role,
  });

  factory ParticipantDto.fromJson(Map<String, dynamic> json) {
    return ParticipantDto(
      participantId: json['participantId'] as int,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'role': role,
    };
  }
}

class ParticipantListResponseDto {
  final List<ParticipantDto> content;
  final bool isLast;

  ParticipantListResponseDto({required this.content, required this.isLast});

  factory ParticipantListResponseDto.fromJson(Map<String, dynamic> json) {
    return ParticipantListResponseDto(
      content: (json['content'] as List? ?? [])
          .map((item) => ParticipantDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      isLast: json['isLast'] as bool? ?? true,
    );
  }
}
