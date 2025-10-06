class EventAlbum {
  final int eventId;
  final String imageUrl;
  final String title;
  final int photoCount;

  EventAlbum({
    required this.eventId,
    required this.imageUrl,
    required this.title,
    required this.photoCount,
  });

  factory EventAlbum.fromMap(Map<String, dynamic> map) {
    return EventAlbum(
      eventId: map['eventId'] as int,
      imageUrl: map['imageUrl'] as String,
      title: map['title'] as String,
      photoCount: map['photoCount'] as int,
    );
  }
}
