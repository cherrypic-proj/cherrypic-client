import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class EventCoverImageService {
  final Dio _dio;

  EventCoverImageService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  /// 이벤트 커버 이미지를 업로드하고 URL을 반환
  Future<String> uploadEventCoverImage(Uint8List imageData) async {
    try {
      // 1. 이미지의 MD5 해시 계산
      final bytes = imageData;
      final digest = md5.convert(bytes);
      final hash = digest.toString();

      // MD5를 Base64로 인코딩 (S3 요구사항)
      final md5Base64 = base64.encode(digest.bytes);

      // 2. 이미지 확장자 감지
      final extension = _detectImageExtension(imageData);

      debugPrint('🖼️ 이벤트 커버 이미지 정보:');
      debugPrint('  - 크기: ${imageData.length} bytes');
      debugPrint('  - 감지된 확장자: $extension');
      debugPrint('  - MD5 Hash: $hash');
      debugPrint('  - MD5 Base64: $md5Base64');

      // 3. Presigned URL 요청
      final presignedResponse = await _dio.post(
        '/events/cover-upload-url',
        data: {'fileExtension': extension, 'md5Hash': md5Base64},
      );

      final apiResponse = ApiResponse.fromJson(
        presignedResponse.data,
        (json) => json as Map<String, dynamic>,
      );

      final presignedUrl = apiResponse.data!['presignedUrl'] as String;
      debugPrint('✅ Presigned URL 받기 성공');

      // 4. S3에 이미지 업로드
      final uploadDio = Dio();
      await uploadDio.put(
        presignedUrl,
        data: bytes,
        options: Options(
          headers: {
            'Content-Type': _getContentType(extension),
            'Content-MD5': md5Base64,
          },
          validateStatus: (status) {
            debugPrint('📤 S3 업로드 상태: $status');
            return status != null && status >= 200 && status < 300;
          },
        ),
      );

      debugPrint('✅ S3 업로드 성공');

      // 5. 업로드된 이미지의 공개 URL 반환
      final uri = Uri.parse(presignedUrl);
      final publicUrl = '${uri.scheme}://${uri.host}${uri.path}';

      debugPrint('📍 Public URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('❌ 이벤트 커버 이미지 업로드 실패: $e');
      throw Exception('이벤트 커버 이미지 업로드 실패: $e');
    }
  }

  /// 이미지 데이터의 매직 넘버를 보고 확장자 판단
  String _detectImageExtension(Uint8List data) {
    if (data.length < 12) {
      debugPrint('이미지 크기가 너무 작음: ${data.length} bytes');
      return 'JPEG';
    }

    // PNG: 89 50 4E 47
    if (data[0] == 0x89 &&
        data[1] == 0x50 &&
        data[2] == 0x4E &&
        data[3] == 0x47) {
      return 'PNG';
    }

    // JPEG: FF D8 FF
    if (data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF) {
      return 'JPEG';
    }

    // WEBP
    if (data.length >= 12 &&
        data[0] == 0x52 &&
        data[1] == 0x49 &&
        data[2] == 0x46 &&
        data[3] == 0x46 &&
        data[8] == 0x57 &&
        data[9] == 0x45 &&
        data[10] == 0x42 &&
        data[11] == 0x50) {
      return 'WEBP';
    }

    // HEIC/HEIF
    if (data.length >= 12 &&
        data[4] == 0x66 &&
        data[5] == 0x74 &&
        data[6] == 0x79 &&
        data[7] == 0x70) {
      if (data.length >= 12 &&
          ((data[8] == 0x68 &&
                  data[9] == 0x65 &&
                  data[10] == 0x69 &&
                  data[11] == 0x63) ||
              (data[8] == 0x6D &&
                  data[9] == 0x69 &&
                  data[10] == 0x66 &&
                  data[11] == 0x31))) {
        return 'HEIC';
      }

      if (data.length >= 12 &&
          ((data[8] == 0x68 &&
                  data[9] == 0x65 &&
                  data[10] == 0x69 &&
                  data[11] == 0x66) ||
              (data[8] == 0x6D &&
                  data[9] == 0x73 &&
                  data[10] == 0x66 &&
                  data[11] == 0x31))) {
        return 'HEIF';
      }
    }

    debugPrint('⚠️ 알 수 없는 포맷, JPEG로 기본 설정');
    return 'JPEG';
  }

  /// 확장자에 따른 Content-Type 반환
  String _getContentType(String extension) {
    switch (extension.toUpperCase()) {
      case 'PNG':
        return 'image/png';
      case 'JPEG':
      case 'JPG':
        return 'image/jpeg';
      case 'WEBP':
        return 'image/webp';
      case 'HEIC':
        return 'image/heic';
      case 'HEIF':
        return 'image/heif';
      default:
        return 'image/jpeg';
    }
  }
}
