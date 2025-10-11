import 'dart:typed_data';

import 'package:cherrypic/data/member/dto/request/member_edit_profile_request_dto.dart';
import 'package:cherrypic/data/member/dto/response/member_edit_profile_dto.dart';
import 'package:cherrypic/data/member/dto/response/member_info_dto.dart';

import '../services/member_remote_data_source.dart';

class MemberRepository {
  final MemberRemoteDataSource _remoteDataSource;

  MemberRepository({MemberRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? MemberRemoteDataSource();

  /// 회원 정보 조회
  Future<MemberInfoDto> getMemberInfo() async {
    try {
      return await _remoteDataSource.getMemberInfo();
    } catch (e) {
      rethrow;
    }
  }

  /// 회원 정보 수정
  Future<MemberEditProfileDto> updateProfile(
      MemberEditProfileRequestDto requestDto,
      ) async {
    return await _remoteDataSource.updateProfile(requestDto);
  }
}
