import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/data/album/dto/request/album_image_upload_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/presigned_url_response_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:dio/dio.dart';

class AlbumImageUploadService {
  final AlbumRepository _albumRepository;

  AlbumImageUploadService({AlbumRepository? albumRepository})
    : _albumRepository = albumRepository ?? AlbumRepository();

  /// 갤러리에서 이미지 선택 (최대 100장)
  Future<List<AssetEntity>?> pickImages(BuildContext context) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      // 권한이 없으면 null 반환
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
    // 1. 각 이미지의 메타데이터 생성
    final List<ImagePayload> payloads = [];
    final List<Uint8List> imageDataList = [];

    for (int i = 0; i < assets.length; i++) {
      final asset = assets[i];
      final imageData = await asset.originBytes;

      if (imageData == null) continue;

      imageDataList.add(imageData);

      final md5Hash = md5.convert(imageData).toString();
      final fileSizeBytes = imageData.length; // 바이트 단위

      // 파일 확장자 추출 (JPEG, PNG 등)
      String extension = 'JPEG';
      final mimeType = await asset.mimeTypeAsync;
      if (mimeType != null) {
        if (mimeType.contains('png')) {
          extension = 'PNG';
        } else if (mimeType.contains('heic') || mimeType.contains('heif')) {
          extension = 'HEIC';
        }
      }

      payloads.add(
        ImagePayload(
          fileExtension: extension,
          md5Hashes: md5Hash,
          capacity: fileSizeBytes.toDouble(), // Double 타입, 바이트 단위
        ),
      );

      onProgress?.call(i + 1, assets.length * 2); // 메타데이터 생성 진행률
    }

    // 2. Presigned URL 요청
    final requestDto = AlbumImageUploadRequestDto(payloads: payloads);
    final presignedResponse = await _albumRepository.getPresignedUrls(
      albumId,
      requestDto,
    );

    // 3. S3에 직접 업로드
    for (int i = 0; i < presignedResponse.presignedUrls.length; i++) {
      final presignedUrl = presignedResponse.presignedUrls[i].presignedUrl;
      final imageData = imageDataList[i];
      final extension = payloads[i].fileExtension;

      await _uploadToS3(presignedUrl, imageData, extension);

      // S3 업로드 진행률
      onProgress?.call(assets.length + i + 1, assets.length * 2);
    }

    // 4. 서버에 완료 알림
    await _albumRepository.notifyUploadComplete(
      albumId,
      presignedResponse.presignedUrls.map((item) => item.imageKey).toList(),
    );
  }

  /// S3에 직접 업로드
  Future<void> _uploadToS3(
    String presignedUrl,
    Uint8List imageData,
    String extension,
  ) async {
    final dio = Dio();

    // 확장자에 따른 Content-Type 설정
    String contentType = 'image/jpeg';
    if (extension == 'PNG') {
      contentType = 'image/png';
    } else if (extension == 'HEIC') {
      contentType = 'image/heic';
    }

    await dio.put(
      presignedUrl,
      data: imageData,
      options: Options(headers: {'Content-Type': contentType}),
    );
  }
}
