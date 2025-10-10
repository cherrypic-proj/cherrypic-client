class EventDeleteImagesRequestDto {
  final List<int> eventImageIds;

  EventDeleteImagesRequestDto({required this.eventImageIds});

  Map<String, dynamic> toJson() {
    return {'eventImageIds': eventImageIds};
  }
}
