class AlbumUpdateRequestDto {
  final String? title;
  final String? coverUrl;

  AlbumUpdateRequestDto({this.title, this.coverUrl});

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (coverUrl != null) 'coverUrl': coverUrl,
    };
  }
}
