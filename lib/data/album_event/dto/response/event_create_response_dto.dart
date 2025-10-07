class EventCreateRequestDto {
  final int albumId;
  final String title;
  final String coverUrl;

  EventCreateRequestDto({
    required this.albumId,
    required this.title,
    required this.coverUrl,
  });

  Map<String, dynamic> toJson() {
    return {'albumId': albumId, 'title': title, 'coverUrl': coverUrl};
  }
}
