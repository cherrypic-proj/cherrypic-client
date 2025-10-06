class EventAddImagesRequestDto {
  final List<int> imageIds;

  EventAddImagesRequestDto({required this.imageIds});

  Map<String, dynamic> toJson() {
    return {'imageIds': imageIds};
  }
}
