class PresignedUrlResponseDto {
  final bool localImageDeletion;
  final List<PresignedUrlItem> presignedUrls;

  PresignedUrlResponseDto({
    required this.localImageDeletion,
    required this.presignedUrls,
  });

  factory PresignedUrlResponseDto.fromJson(Map<String, dynamic> json) {
    return PresignedUrlResponseDto(
      localImageDeletion: json['localImageDeletion'] as bool? ?? false,
      presignedUrls:
          (json['content'] as List<dynamic>?)
              ?.map(
                (item) =>
                    PresignedUrlItem.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class PresignedUrlItem {
  final int imageId;
  final String presignedUrl;

  PresignedUrlItem({required this.imageId, required this.presignedUrl});

  factory PresignedUrlItem.fromJson(Map<String, dynamic> json) {
    return PresignedUrlItem(
      imageId: json['imageId'] as int,
      presignedUrl: json['presignedUrl'] as String,
    );
  }

  // imageKey는 URL에서 경로 추출
  String get imageKey {
    final uri = Uri.parse(presignedUrl);
    // /dev/album-image/1/xxx.heic → dev/album-image/1/xxx.heic
    return uri.path.substring(1);
  }
}
