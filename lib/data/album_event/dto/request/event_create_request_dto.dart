class EventCreateResponseDto {
  final int eventId;
  final String title;
  final String coverUrl;

  EventCreateResponseDto({
    required this.eventId,
    required this.title,
    required this.coverUrl,
  });

  factory EventCreateResponseDto.fromJson(Map<String, dynamic> json) {
    return EventCreateResponseDto(
      eventId: json['eventId'] as int,
      title: json['title'] as String,
      coverUrl: json['coverUrl'] as String,
    );
  }
}
