import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/data/album/dto/request/album_image_upload_request_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AlbumImageUploadService {
  final AlbumRepository _albumRepository;

  AlbumImageUploadService({AlbumRepository? albumRepository})
    : _albumRepository = albumRepository ?? AlbumRepository();

  /// 갤러리에서 이미지 선택 (최대 100장)
  Future<List<AssetEntity>?> pickImages(BuildContext context) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      return null;
    }

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 100,
        requestType: RequestType.image,
        selectedAssets: [],
      ),
    );

    return result;
  }

  /// 이미지 파일들을 앨범에 업로드 (진행률 콜백 포함)
  Future<void> uploadImagesToAlbum(
    int albumId,
    List<AssetEntity> assets, {
    Function(int current, int total)? onProgress,
  }) async {
    debugPrint('🎬 업로드 시작: ${assets.length}장의 이미지');

    // 1. 각 이미지의 메타데이터 생성
    final List<ImagePayload> payloads = [];
    final List<Uint8List> imageDataList = [];

    for (int i = 0; i < assets.length; i++) {
      final asset = assets[i];
      final imageData = await asset.originBytes;

      if (imageData == null) continue;

      imageDataList.add(imageData);

      final md5Digest = md5.convert(imageData);
      final md5Hash = base64.encode(md5Digest.bytes);
      final fileSizeBytes = imageData.length;

      String extension = 'JPEG';
      final mimeType = await asset.mimeTypeAsync;
      if (mimeType != null) {
        if (mimeType.contains('png')) {
          extension = 'PNG';
        } else if (mimeType.contains('heic') || mimeType.contains('heif')) {
          extension = 'HEIC';
        }
      }

      // 이미지 생성 시간을 ISO 8601 포맷으로
      final createdAt = asset.createDateTime;
      final generatedAt =
          createdAt?.toUtc().toIso8601String() ??
          DateTime.now().toUtc().toIso8601String();

      payloads.add(
        ImagePayload(
          fileExtension: extension,
          md5Hashes: md5Hash,
          generatedAt: generatedAt,
          capacity: fileSizeBytes / (1024 * 1024),
        ),
      );

      onProgress?.call(assets.length + i + 1, assets.length * 2);
    }
    debugPrint('✅ 메타데이터 생성 완료: ${payloads.length}개');

    // 2. Presigned URL 요청
    debugPrint('🔄 Presigned URL 요청 중...');
    final requestDto = AlbumImageUploadRequestDto(payloads: payloads);
    final presignedResponse = await _albumRepository.getPresignedUrls(
      albumId,
      requestDto,
    );

    debugPrint(
      '✅ Presigned URL 받음: ${presignedResponse.presignedUrls.length}개',
    );

    // 3. S3에 직접 업로드
    debugPrint('🚀 S3 업로드 시작...');
    for (int i = 0; i < presignedResponse.presignedUrls.length; i++) {
      debugPrint(
        '📤 이미지 ${i + 1}/${presignedResponse.presignedUrls.length} 업로드 중...',
      );

      final presignedUrl = presignedResponse.presignedUrls[i].presignedUrl;
      final imageData = imageDataList[i];
      final extension = payloads[i].fileExtension;

      await _uploadToS3(presignedUrl, imageData, extension);

      onProgress?.call(assets.length + i + 1, assets.length * 2);
    }

    debugPrint('✅ S3 업로드 완료');
    debugPrint('🎉 전체 업로드 프로세스 완료!');
  }

  /// S3에 직접 업로드
  Future<void> _uploadToS3(
    String presignedUrl,
    Uint8List imageData,
    String extension,
  ) async {
    final md5Digest = md5.convert(imageData);
    final md5Base64 = base64.encode(md5Digest.bytes);

    final uploadDio = Dio();
    final contentType = _getContentType(extension);

    debugPrint('📤 S3 업로드 시작:');
    debugPrint('  - URL: $presignedUrl');
    debugPrint('  - Content-Type: $contentType');
    debugPrint('  - Content-MD5: $md5Base64');
    debugPrint('  - 데이터 크기: ${imageData.length} bytes');

    await uploadDio.put(
      presignedUrl,
      data: imageData,
      options: Options(
        headers: {'Content-Type': contentType, 'Content-MD5': md5Base64},
        validateStatus: (status) {
          debugPrint('📤 S3 업로드 상태: $status');
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    debugPrint('✅ S3 업로드 성공');
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
