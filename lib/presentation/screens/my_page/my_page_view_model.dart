import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:cherrypic/data/member/dto/response/member_info_dto.dart';
import 'package:cherrypic/data/member/dto/request/member_edit_profile_request_dto.dart';
import '../../../data/member/repositories/member_repository.dart'; // 추가

enum LoginType { kakao, apple }

class MyPageViewModel extends ChangeNotifier {
  final MemberRepository _memberRepository;

  MyPageViewModel({MemberRepository? memberRepository})
      : _memberRepository = memberRepository ?? MemberRepository();

  MemberInfoDto? _memberInfo;
  MemberInfoDto? get memberInfo => _memberInfo;

  Uint8List? _coverImage;
  Uint8List? get coverImage => _coverImage;

  LoginType loginType = LoginType.kakao;

  /// 갤러리에서 이미지를 선택
  Future<void> pickImage(BuildContext context) async {
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

      /// 미리보기
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

  /// 멤버 정보 불러오기
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


  /// TODO: 이 함수를 실제 이미지 업로드 로직으로 교체해야 합니다.
  Future<String?> _uploadCoverImage(Uint8List imageData) async {
    debugPrint('Uploading image... (Placeholder)');
    // 실제 이미지 업로드 로직 후 반환된 URL이라고 가정
    return 'https://new-profile-image.com/uploaded-pic-${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  /// 프로필 수정 (닉네임 또는 이미지 URL)
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
      // 1. 이미지를 업로드하고 URL을 받습니다.
      profileImageUrlToSend = await _uploadCoverImage(newCoverImage);
      if (profileImageUrlToSend == null) {
        debugPrint('Image upload failed. Profile update aborted.');
        return false;
      }
    } else {
      // 이미지 변경이 없다면 기존 URL을 사용합니다.
      profileImageUrlToSend = _memberInfo!.profileImageUrl;
    }

    try {
      // 2. 받은 URL을 포함하여 프로필 정보를 업데이트합니다.
      final requestDto = MemberEditProfileRequestDto(
        nickname: nicknameToSend,
        profileImageUrl: profileImageUrlToSend,
      );

      await _memberRepository.updateProfile(requestDto);

      // 3. 수정 성공 후 최신 정보를 다시 불러와 화면을 갱신합니다.
      await fetchMemberInfo();
      _coverImage = null; // 미리 보기 이미지는 성공적으로 서버에 반영되었으므로 초기화

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