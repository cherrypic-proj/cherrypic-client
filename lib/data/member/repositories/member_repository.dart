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
}
