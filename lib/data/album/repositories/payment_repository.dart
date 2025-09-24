import 'package:cherrypic/data/album/dto/request/payment_ready_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/payment_ready_response_dto.dart';
import 'package:cherrypic/data/album/dto/request/payment_verify_request_dto.dart';
import 'package:cherrypic/data/album/services/payment_remote_data_source.dart';

class PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepository({PaymentRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? PaymentRemoteDataSource();

  Future<PaymentReadyResponseDto> readyPayment({
    required String type,
    int? albumId,
  }) async {
    final requestDto = PaymentReadyRequestDto(type: type, albumId: albumId);

    return await _remoteDataSource.readyPayment(requestDto);
  }

  Future<PaymentVerifyResponseDto> verifyPayment(String impUid) async {
    return await _remoteDataSource.verifyPayment(impUid);
  }
}
