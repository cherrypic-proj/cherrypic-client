import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_view_model.dart';

// --- Mock Data ---
class MockAlbum {
  final int id;
  final String name;
  final String coverImageUrl;

  MockAlbum({
    required this.id,
    required this.name,
    required this.coverImageUrl,
  });
}

final Map<int, MockAlbum> mockAlbumDatabase = {
  1: MockAlbum(
    id: 1,
    name: '음식',
    coverImageUrl:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
  ),
  2: MockAlbum(
    id: 2,
    name: '여행',
    coverImageUrl:
        'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1',
  ),
  3: MockAlbum(
    id: 3,
    name: '반려동물',
    coverImageUrl:
        'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
  ),
};
// --- End of Mock Data ---

// Member 데이터 모델
class Member {
  final int id;
  final String name;
  final String profileImageUrl;
  String role;

  Member({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.role,
  });
}

class AlbumEditViewModel extends ChangeNotifier {
  final int albumId;
  late final AlbumCoverViewModel albumCoverViewModel;

  List<Member> _allMembers = [];
  List<Member> _filteredMembers = [];
  List<Member> get filteredMembers => _filteredMembers;

  final TextEditingController searchController = TextEditingController();
  bool _isPermissionEnabled = true;
  bool get isPermissionEnabled => _isPermissionEnabled;

  AlbumEditViewModel({required this.albumId}) {
    _loadInitialData(albumId);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    albumCoverViewModel.dispose();
    super.dispose();
  }

  void _loadInitialData(int currentAlbumId) {
    final albumData =
        mockAlbumDatabase[currentAlbumId] ??
        MockAlbum(id: currentAlbumId, name: '새 앨범', coverImageUrl: '');

    albumCoverViewModel = AlbumCoverViewModel();
    albumCoverViewModel.updateAlbumName(albumData.name);
    albumCoverViewModel.setCoverImageUrl(albumData.coverImageUrl);

    _allMembers = List.generate(5 + (currentAlbumId % 5), (index) {
      final roles = ['방장', '일반회원', '읽기 전용'];
      return Member(
        id: index,
        name: '멤버 ${index + 1}',
        profileImageUrl: 'https://placehold.co/40x40/EFEFEF/AAAAAA?text=P',
        role: roles[Random().nextInt(roles.length)],
      );
    });
    if (_allMembers.isNotEmpty) _allMembers[0].role = '방장';
    _filteredMembers = _allMembers;

    _isPermissionEnabled = true;

    notifyListeners();
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      _filteredMembers = _allMembers;
    } else {
      _filteredMembers = _allMembers
          .where((member) => member.name.toLowerCase().contains(query))
          .toList();
    }
    notifyListeners();
  }

  void updateMemberRole(Member member, String newRole) {
    final index = _allMembers.indexWhere((m) => m.id == member.id);
    if (index != -1) {
      _allMembers[index].role = newRole;
      final filteredIndex = _filteredMembers.indexWhere(
        (m) => m.id == member.id,
      );
      if (filteredIndex != -1) _filteredMembers[filteredIndex].role = newRole;
      notifyListeners();
    }
  }

  void kickMember(Member member) {
    _allMembers.removeWhere((m) => m.id == member.id);
    _filteredMembers.removeWhere((m) => m.id == member.id);
    notifyListeners();
  }

  void togglePermission(bool value) {
    _isPermissionEnabled = value;
    notifyListeners();
  }
}
