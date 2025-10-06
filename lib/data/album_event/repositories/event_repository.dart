import 'package:cherrypic/data/album_event/dto/response/event_response.dart';
import 'package:cherrypic/data/album_event/services/event_remote_data_source.dart';

class EventRepository {
  final EventRemoteDataSource _remoteDataSource;

  EventRepository({EventRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? EventRemoteDataSource();

  /// 이벤트 목록 조회
  ///
  /// [albumId] - 조회할 앨범 ID
  /// [lastEventId] - 페이징을 위한 마지막 이벤트 ID (선택)
  /// [size] - 페이지 사이즈 (기본값: 20)
  /// [direction] - 정렬 방향 (기본값: DESC)
  Future<EventListResponse> getEvents({
    required int albumId,
    int? lastEventId,
    int size = 20,
    String direction = 'DESC',
  }) async {
    return await _remoteDataSource.getEvents(
      albumId: albumId,
      lastEventId: lastEventId,
      size: size,
      direction: direction,
    );
  }
}
