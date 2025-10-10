import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImageActionService {
  final Dio _dio = Dio();

  /// 선택된 이미지들을 기기 갤러리에 다운로드합니다.
  Future<void> downloadImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('다운로드를 시작합니다...')));

    try {
      int successCount = 0;
      for (final url in imageUrls) {
        final response = await _dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: DateTime.now().toIso8601String(),
        );
        if (result['isSuccess'] == true) {
          successCount++;
        }
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$successCount개의 사진을 앨범에 저장했습니다.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('다운로드 실패: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사진 저장에 실패했습니다.'), backgroundColor: Colors.red),
      );
    }
  }

  /// 선택된 이미지들을 네이티브 공유 시트로 공유합니다.
  Future<void> shareImages(BuildContext context, List<String> imageUrls) async {
    final box = context.findRenderObject() as RenderBox?;
    final shareOrigin = box!.localToGlobal(Offset.zero) & box.size;

    try {
      final tempDir = await getTemporaryDirectory();
      final List<XFile> localFiles = [];

      for (int i = 0; i < imageUrls.length; i++) {
        final url = imageUrls[i];
        final filePath = '${tempDir.path}/image_$i.jpg';
        await _dio.download(url, filePath);
        localFiles.add(XFile(filePath));
      }

      if (localFiles.isNotEmpty) {
        await SharePlus.instance.share(
          ShareParams(
            files: localFiles,
            text: '사진을 공유합니다!',
            sharePositionOrigin: shareOrigin,
          ),
        );
      }
    } catch (e) {
      debugPrint('공유 실패: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('공유 준비에 실패했습니다.'), backgroundColor: Colors.red),
      );
    }
  }
}
