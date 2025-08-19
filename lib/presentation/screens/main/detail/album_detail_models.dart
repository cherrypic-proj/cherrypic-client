/// 날짜별 이미지 묶음(그룹)
class AlbumDayGroup {
  final String date;
  final List<String> imageUrls;
  final Set<int> selectedIndexes;

  AlbumDayGroup({
    required this.date,
    required this.imageUrls,
    Set<int>? selectedIndexes,
  }) : selectedIndexes = selectedIndexes ?? <int>{};

  bool get isAllSelected =>
      imageUrls.isNotEmpty && selectedIndexes.length == imageUrls.length;

  AlbumDayGroup copyWith({
    String? date,
    List<String>? imageUrls,
    Set<int>? selectedIndexes,
  }) {
    return AlbumDayGroup(
      date: date ?? this.date,
      imageUrls: imageUrls ?? this.imageUrls,
      selectedIndexes: selectedIndexes ?? Set<int>.from(this.selectedIndexes),
    );
  }
}
