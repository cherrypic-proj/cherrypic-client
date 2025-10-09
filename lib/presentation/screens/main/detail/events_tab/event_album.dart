import 'package:cherrypic/data/album_event/dto/response/event_response.dart';

class EventAlbum {
  final int eventId;
  final String imageUrl;
  final int albumId;
  final String title;
  final int photoCount;

  EventAlbum({
    required this.eventId,
    required this.imageUrl,
    required this.albumId,
    required this.title,
    required this.photoCount,
  });

  // 기존 fromMap 생성자는 그대로 둡니다.
  factory EventAlbum.fromMap(Map<String, dynamic> map, {required int albumId}) {
    return EventAlbum(
      eventId: map['eventId'] as int,
      albumId: albumId,
      imageUrl: map['coverUrl'] as String? ?? '',
      title: map['title'] as String,
      photoCount: map['numberOfImages'] as int,
    );
  }

  // [신규] EventDto 객체를 직접 받아 변환하는 생성자 추가
  factory EventAlbum.fromDto(EventDto dto, {required int albumId}) {
    return EventAlbum(
      eventId: dto.eventId,
      albumId: albumId,
      imageUrl: dto.coverUrl ?? '',
      title: dto.title,
      photoCount: dto.numberOfImages,
    );
  }
}
