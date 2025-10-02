class AlbumImageListResponseDto {
  final List<AlbumImageGroup> content;
  final bool isLast;

  AlbumImageListResponseDto({required this.content, required this.isLast});

  factory AlbumImageListResponseDto.fromJson(Map<String, dynamic> json) {
    return AlbumImageListResponseDto(
      content:
          (json['content'] as List<dynamic>?)
              ?.map(
                (item) =>
                    AlbumImageGroup.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      isLast: json['isLast'] as bool? ?? true,
    );
  }
}

class AlbumImageGroup {
  final int imageId;
  final String imageUrl;
  final String date;

  AlbumImageGroup({
    required this.imageId,
    required this.imageUrl,
    required this.date,
  });

  factory AlbumImageGroup.fromJson(Map<String, dynamic> json) {
    return AlbumImageGroup(
      imageId: json['imageId'] as int,
      imageUrl: json['imageUrl'] as String,
      date: json['date'] as String,
    );
  }
}
