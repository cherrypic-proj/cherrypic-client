/// 이벤트 이미지 목록 조회 응답 DTO
class EventImageListResponseDto {
  final List<EventImageDto> content;
  final bool isLast;

  EventImageListResponseDto({required this.content, required this.isLast});

  factory EventImageListResponseDto.fromJson(Map<String, dynamic> json) {
    return EventImageListResponseDto(
      content: (json['content'] as List)
          .map((item) => EventImageDto.fromJson(item))
          .toList(),
      isLast: json['isLast'] as bool,
    );
  }
}

/// 개별 이벤트 이미지 DTO
class EventImageDto {
  final int eventImageId;
  final String imageUrl;
  final String date;

  EventImageDto({
    required this.eventImageId,
    required this.imageUrl,
    required this.date,
  });

  factory EventImageDto.fromJson(Map<String, dynamic> json) {
    return EventImageDto(
      eventImageId: json['eventImageId'] as int,
      imageUrl: json['imageUrl'] as String,
      date: json['date'] as String,
    );
  }
}
