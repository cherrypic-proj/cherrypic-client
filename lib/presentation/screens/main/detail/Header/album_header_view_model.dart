import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/components/member_list_popup.dart';
import 'package:flutter/material.dart';

class AlbumHeaderViewModel extends ChangeNotifier {
  final int albumId;
  final AlbumRepository _albumRepository;

  AlbumDetailDto? _originalDto; // 원본 DTO 보관
  AlbumDetailDto? get originalDto => _originalDto;
  AlbumHeaderData? header;
  bool isLoading = false;
  String? error;

  // 참가자 목록
  List<MemberListData> participants = [];
  bool isLoadingParticipants = false;

  AlbumHeaderViewModel(this.albumId, {AlbumRepository? albumRepository})
    : _albumRepository = albumRepository ?? AlbumRepository() {
    loadAlbumDetail();
    loadParticipants();
  }

  /// 앨범 상세 정보 로드
  Future<void> loadAlbumDetail() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final dto = await _albumRepository.getAlbumDetail(albumId);
      _originalDto = dto; // 원본 DTO 저장

      header = AlbumHeaderData(
        albumId: albumId,
        title: dto.title,
        coverUrl: dto.coverUrl ?? '',
        photoCount: 0,
        progress: dto.capacityUsed / dto.totalCapacity,
        badgeText: _getBadgeText(dto.type),
        hostName: dto.hostName,
        numOfParticipants: dto.numOfParticipants,
        capacityUsed: dto.capacityUsed,
        totalCapacity: dto.totalCapacity,
      );
    } catch (e) {
      error = e.toString();
      debugPrint('앨범 상세 정보 로드 실패: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 참가자 목록 로드
  Future<void> loadParticipants() async {
    isLoadingParticipants = true;
    notifyListeners();

    try {
      final response = await _albumRepository.getParticipants(albumId);
      participants = response.content.map((dto) {
        return MemberListData(dto.nickname, NetworkImage(dto.profileImageUrl));
      }).toList();
    } catch (e) {
      debugPrint('참가자 목록 로드 실패: $e');
    } finally {
      isLoadingParticipants = false;
      notifyListeners();
    }
  }

  /// 앨범 타입에 따른 배지 텍스트 반환
  String _getBadgeText(String type) {
    switch (type) {
      case 'PRO':
        return 'PRO';
      case 'BASIC':
        return 'BASIC';
      case 'PREMIUM':
        return 'PREMIUM';
      default:
        return type;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await Future.wait([loadAlbumDetail(), loadParticipants()]);
  }
}
