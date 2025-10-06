import 'package:cherrypic/core/network/api_path.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/data/album_event/dto/event_response.dart';

class EventRemoteDataSource {
  final DioClient _dioClient;

  EventRemoteDataSource({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// 이벤트 목록 조회
  ///
  /// [albumId] - 조회할 앨범 ID (필수)
  /// [lastEventId] - 페이징을 위한 마지막 이벤트 ID (선택)
  /// [size] - 페이지 사이즈 (필수)
  /// [direction] - 정렬 방향 ASC/DESC (선택, 기본값: DESC)
  Future<EventListResponse> getEvents({
    required int albumId,
    int? lastEventId,
    required int size,
    String? direction,
  }) async {
    final queryParameters = <String, dynamic>{
      'albumId': albumId,
      'size': size,
      if (lastEventId != null) 'lastEventId': lastEventId,
      if (direction != null) 'direction': direction,
    };

    final response = await _dioClient.dio.get(
      ApiPath.events,
      queryParameters: queryParameters,
    );

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => EventListResponse.fromJson(json as Map<String, dynamic>),
    );

    return apiResponse.data!;
  }
}
