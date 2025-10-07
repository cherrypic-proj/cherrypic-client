/// 이벤트 목록 조회 응답 DTO
class EventListResponse {
  final List<EventDto> content;
  final bool isLast;

  EventListResponse({required this.content, required this.isLast});

  factory EventListResponse.fromJson(Map<String, dynamic> json) {
    return EventListResponse(
      content: (json['content'] as List)
          .map((item) => EventDto.fromJson(item))
          .toList(),
      isLast: json['isLast'] as bool,
    );
  }
}

/// 개별 이벤트 DTO
class EventDto {
  final int eventId;
  final String title;
  final String coverUrl;
  final int numberOfImages;

  EventDto({
    required this.eventId,
    required this.title,
    required this.coverUrl,
    required this.numberOfImages,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) {
    return EventDto(
      eventId: json['eventId'] as int,
      title: json['title'] as String,
      coverUrl: json['coverUrl'] as String,
      numberOfImages: json['numberOfImages'] as int,
    );
  }

  /// DTO를 도메인 모델(EventAlbum)로 변환
  Map<String, dynamic> toEventAlbum() {
    return {
      'eventId': eventId,
      'imageUrl': coverUrl,
      'title': title,
      'photoCount': numberOfImages,
    };
  }
}
