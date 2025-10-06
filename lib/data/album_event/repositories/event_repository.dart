import 'package:cherrypic/data/album_event/dto/request/event_create_request_dto.dart';
import 'package:cherrypic/data/album_event/dto/request/event_add_images_request_dto.dart';
import 'package:cherrypic/data/album_event/dto/response/event_create_response_dto.dart';
import 'package:cherrypic/data/album_event/dto/response/event_detail_response_dto.dart';
import 'package:cherrypic/data/album_event/dto/response/event_response.dart';
import 'package:cherrypic/data/album_event/services/event_remote_data_source.dart';

class EventRepository {
  final EventRemoteDataSource _remoteDataSource;

  EventRepository({EventRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? EventRemoteDataSource();

  /// 이벤트 목록 조회
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

  /// 이벤트 생성
  Future<EventCreateResponseDto> createEvent(
    EventCreateRequestDto requestDto,
  ) async {
    return await _remoteDataSource.createEvent(requestDto);
  }

  /// 이벤트에 이미지 추가
  Future<void> addImagesToEvent(
    int eventId,
    EventAddImagesRequestDto requestDto,
  ) async {
    return await _remoteDataSource.addImagesToEvent(eventId, requestDto);
  }

  /// 이벤트 커버 이미지 Presigned URL 생성
  Future<String> getEventCoverPresignedUrl({
    required String fileExtension,
    required String md5Hash,
  }) async {
    return await _remoteDataSource.getEventCoverPresignedUrl(
      fileExtension: fileExtension,
      md5Hash: md5Hash,
    );
  }

  /// 이벤트 이미지 목록 조회
  Future<EventImageListResponseDto> getEventImages({
    required int eventId,
    int? lastEventImageId,
    int size = 20,
    String parameter = 'UPLOAD',
    String direction = 'DESC',
  }) async {
    return await _remoteDataSource.getEventImages(
      eventId: eventId,
      lastEventImageId: lastEventImageId,
      size: size,
      parameter: parameter,
      direction: direction,
    );
  }
}
