import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:dio/dio.dart';

class ImageUploadService {
  final Dio _dio;

  ImageUploadService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  // 이미지를 업로드하고 URL을 반환
  Future<String> uploadCoverImage(Uint8List imageData) async {
    try {
      // 1. 이미지의 MD5 해시 계산
      final bytes = imageData;
      final digest = md5.convert(bytes);
      final hash = digest.toString();

      // 2. Presigned URL 요청
      final presignedResponse = await _dio.post(
        '/albums/cover-upload-url',
        data: {
          'imageFileExtension': 'JPEG', // 또는 실제 확장자 감지
          'md5Hash': hash,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        presignedResponse.data,
        (json) => json as Map<String, dynamic>,
      );

      final presignedUrl = apiResponse.data!['presignedUrl'] as String;

      // 3. S3에 이미지 업로드
      final uploadDio = Dio(); // 별도 Dio 인스턴스 (인터셉터 없이)
      await uploadDio.put(
        presignedUrl,
        data: bytes,
        options: Options(headers: {'Content-Type': 'image/jpeg'}),
      );

      // 4. 업로드된 이미지의 공개 URL 반환 (Presigned URL에서 쿼리 파라미터 제거)
      final uri = Uri.parse(presignedUrl);
      final publicUrl = '${uri.scheme}://${uri.host}${uri.path}';

      return publicUrl;
    } catch (e) {
      throw Exception('이미지 업로드 실패: $e');
    }
  }

  // 이미지 확장자 감지 (옵션)
  String _detectImageExtension(Uint8List bytes) {
    if (bytes.length >= 2) {
      // JPEG
      if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
        return 'JPEG';
      }
      // PNG
      if (bytes.length >= 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47) {
        return 'PNG';
      }
    }
    return 'JPEG'; // 기본값
  }
}
