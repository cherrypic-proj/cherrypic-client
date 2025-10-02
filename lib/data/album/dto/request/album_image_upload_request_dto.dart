class AlbumImageUploadRequestDto {
  final List<ImagePayload> payloads;

  AlbumImageUploadRequestDto({required this.payloads});

  Map<String, dynamic> toJson() {
    return {'payloads': payloads.map((p) => p.toJson()).toList()};
  }
}

class ImagePayload {
  final String fileExtension;
  final String md5Hashes;
  final String generatedAt;
  final double capacity;

  ImagePayload({
    required this.fileExtension,
    required this.md5Hashes,
    required this.generatedAt,
    required this.capacity,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileExtension': fileExtension,
      'md5Hashes': md5Hashes,
      'generatedAt': generatedAt,
      'capacityMb': capacity,
    };
  }
}
