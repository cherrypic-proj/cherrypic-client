class EventUpdateRequestDto {
  final String? title;
  final String? coverUrl;

  EventUpdateRequestDto({this.title, this.coverUrl});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) {
      data['title'] = title;
    }
    if (coverUrl != null) {
      data['coverUrl'] = coverUrl;
    }
    return data;
  }
}
