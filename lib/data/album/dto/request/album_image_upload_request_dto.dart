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
  final double capacity; // MB 단위

  ImagePayload({
    required this.fileExtension,
    required this.md5Hashes,
    required this.capacity,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileExtension': fileExtension,
      'md5Hashes': md5Hashes,
      'capacity': capacity,
    };
  }
}
