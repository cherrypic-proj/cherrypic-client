import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:cherrypic/data/member/dto/response/member_info_dto.dart';

import '../../../data/member/repositories/member_repository.dart';


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

      _coverImage = imageData;
      notifyListeners();
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