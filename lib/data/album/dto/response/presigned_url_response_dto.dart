class PresignedUrlResponseDto {
  final List<PresignedUrlItem> presignedUrls;

  PresignedUrlResponseDto({required this.presignedUrls});

  factory PresignedUrlResponseDto.fromJson(Map<String, dynamic> json) {
    return PresignedUrlResponseDto(
      presignedUrls: (json['presignedUrls'] as List)
          .map((item) => PresignedUrlItem.fromJson(item))
          .toList(),
    );
  }
}

class PresignedUrlItem {
  final String presignedUrl;
  final String imageKey;

  PresignedUrlItem({required this.presignedUrl, required this.imageKey});

  factory PresignedUrlItem.fromJson(Map<String, dynamic> json) {
    return PresignedUrlItem(
      presignedUrl: json['presignedUrl'],
      imageKey: json['imageKey'],
    );
  }
}
