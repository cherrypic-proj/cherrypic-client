import 'package:cherrypic/core/network/api_path.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/data/album_event/dto/request/event_create_request_dto.dart';
import 'package:cherrypic/data/album_event/dto/request/event_add_images_request_dto.dart';
import 'package:cherrypic/data/album_event/dto/request/event_update_request_dto.dart';
import 'package:cherrypic/data/album_event/dto/response/event_create_response_dto.dart';
import 'package:cherrypic/data/album_event/dto/response/event_detail_response_dto.dart';
import 'package:cherrypic/data/album_event/dto/response/event_response.dart';
import 'package:dio/dio.dart';

class EventRemoteDataSource {
  final DioClient _dioClient;

  EventRemoteDataSource({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  /// 이벤트 목록 조회
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

  /// 이벤트 생성
  Future<EventCreateResponseDto> createEvent(
    EventCreateRequestDto requestDto,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        ApiPath.events,
        data: requestDto.toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => EventCreateResponseDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw Exception('이벤트 생성 실패: $e');
    }
  }

  /// 이벤트에 이미지 추가
  Future<void> addImagesToEvent(
    int eventId,
    EventAddImagesRequestDto requestDto,
  ) async {
    try {
      await _dioClient.dio.post(
        ApiPath.eventImages(eventId),
        data: requestDto.toJson(),
      );
    } on DioException catch (e) {
      throw Exception('이벤트 이미지 추가 실패: $e');
    }
  }

  /// 이벤트 커버 이미지 Presigned URL 생성
  Future<String> getEventCoverPresignedUrl({
    required String fileExtension,
    required String md5Hash,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiPath.eventsCoverUploadUrl,
        data: {'fileExtension': fileExtension, 'md5Hash': md5Hash},
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      return apiResponse.data!['presignedUrl'] as String;
    } on DioException catch (e) {
      throw Exception('Presigned URL 생성 실패: $e');
    }
  }

  /// 이벤트 이미지 목록 조회
  Future<EventImageListResponseDto> getEventImages({
    required int eventId,
    int? lastEventImageId,
    required int size,
    String? parameter,
    String? direction,
  }) async {
    final queryParameters = <String, dynamic>{
      'size': size,
      if (lastEventImageId != null) 'lastEventImageId': lastEventImageId,
      if (parameter != null) 'parameter': parameter,
      if (direction != null) 'direction': direction,
    };

    final response = await _dioClient.dio.get(
      ApiPath.eventImages(eventId),
      queryParameters: queryParameters,
    );

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) =>
          EventImageListResponseDto.fromJson(json as Map<String, dynamic>),
    );

    return apiResponse.data!;
  }

  Future<void> updateEvent(
    int eventId,
    EventUpdateRequestDto requestDto,
  ) async {
    try {
      await _dioClient.dio.patch(
        ApiPath.eventDetail(eventId),
        data: requestDto.toJson(),
      );
    } on DioException catch (e) {
      throw Exception('이벤트 수정 실패: $e');
    }
  }
}
