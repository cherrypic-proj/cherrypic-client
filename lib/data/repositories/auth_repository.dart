import 'package:cherrypic/data/dto/request/social_login_request_dto.dart';
import 'package:cherrypic/data/dto/response/login_response_dto.dart';
import 'package:cherrypic/data/services/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepository({AuthRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? AuthRemoteDataSource();

  // 함수 시그니처는 동일
  Future<LoginResponseDto> socialLogin(String provider, String idToken) async {
    final requestDto = SocialLoginRequestDto(idToken: idToken);
    return await _dataSource.socialLogin(provider, requestDto);
  }
}
