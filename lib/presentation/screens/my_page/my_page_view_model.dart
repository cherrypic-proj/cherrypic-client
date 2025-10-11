import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:cherrypic/data/member/dto/response/member_info_dto.dart';
import 'package:cherrypic/data/member/dto/request/member_edit_profile_request_dto.dart';
import '../../../data/member/repositories/member_repository.dart';
import '../../../data/member/services/profile_image_upload_service.dart'; // 추가

enum LoginType { kakao, apple }

class MyPageViewModel extends ChangeNotifier {
  final MemberRepository _memberRepository;
  final ProfileImageUploadService _uploadService;

  MyPageViewModel({
    MemberRepository? memberRepository,

    ProfileImageUploadService? uploadService,
  })  : _memberRepository = memberRepository ?? MemberRepository(),
        _uploadService = uploadService ?? ProfileImageUploadService(); // 기본 인스턴스 생성

  MemberInfoDto? _memberInfo;
  MemberInfoDto? get memberInfo => _memberInfo;

  Uint8List? _coverImage;
  Uint8List? get coverImage => _coverImage;

  LoginType loginType = LoginType.kakao;

  Future<void> pickAndSetProfileImage(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );

    if (assets != null && assets.isNotEmpty) {
      final AssetEntity selectedAsset = assets.first;
      final Uint8List? imageData = await selectedAsset.thumbnailDataWithSize(
        const ThumbnailSize(500, 500),
      );

      _coverImage = imageData;
      notifyListeners();

      if (_coverImage != null) {
        final success = await updateProfile(
          newCoverImage: _coverImage,
          newNickname: memberInfo?.nickname,
        );

        if (!success) {
          debugPrint('프로필 이미지 수정 실패');
        } else {
          debugPrint('프로필 이미지 수정 성공');
        }
      }
    }
  }

  /// 멤버 정보 불러오기 (로직 유지)
  Future<void> fetchMemberInfo() async {
    try {
      _memberInfo = await _memberRepository.getMemberInfo();

      if (_memberInfo?.oauthProvider.toLowerCase() == 'apple') {
        loginType = LoginType.apple;
      } else {
        loginType = LoginType.kakao;
      }
    } catch (e) {
      debugPrint('Error fetching member info: $e');
      _memberInfo = null;
    }
    notifyListeners();
  }

  /// 프로필 이미지 수정
  Future<String?> _uploadCoverImage(Uint8List imageData) async {
    try {
      return await _uploadService.uploadCoverImage(imageData);
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      return null;
    }
  }

  /// 프로필 수정
  Future<bool> updateProfile({
    String? newNickname,
    Uint8List? newCoverImage,
  }) async {
    if (_memberInfo == null) {
      debugPrint('Error: Member info is not loaded.');
      return false;
    }

    String nicknameToSend;
    String? profileImageUrlToSend;

    nicknameToSend = newNickname ?? _memberInfo!.nickname;

    if (newCoverImage != null) {
      profileImageUrlToSend = await _uploadCoverImage(newCoverImage);
      if (profileImageUrlToSend == null) {
        debugPrint('Image upload failed. Profile update aborted.');
        return false;
      }
    } else {
      profileImageUrlToSend = _memberInfo!.profileImageUrl;
    }

    try {
      final requestDto = MemberEditProfileRequestDto(
        nickname: nicknameToSend,
        profileImageUrl: profileImageUrlToSend,
      );

      await _memberRepository.updateProfile(requestDto);

      await fetchMemberInfo();
      _coverImage = null;

      debugPrint('Profile update successful! New Nickname: $nicknameToSend');
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// 로그인 Type 라벨
  String get loginTypeLabel {
    switch (loginType) {
      case LoginType.kakao:
        return '카카오 로그인';
      case LoginType.apple:
        return '애플 로그인';
    }
  }

  /// 로그인 Type 아이콘
  String get loginIconAsset {
    switch (loginType) {
      case LoginType.kakao:
        return 'assets/images/kakao_icon_2.png';
      case LoginType.apple:
        return 'assets/images/apple_icon_2.png';
    }
  }

  void setLoginType(LoginType type) {
    loginType = type;
    notifyListeners();
  }
}