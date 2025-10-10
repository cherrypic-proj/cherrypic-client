class AlbumImageDeleteRequestDto {
  final List<int> imageIds;

  AlbumImageDeleteRequestDto({required this.imageIds});

  Map<String, dynamic> toJson() {
    return {'imageIds': imageIds};
  }
}
