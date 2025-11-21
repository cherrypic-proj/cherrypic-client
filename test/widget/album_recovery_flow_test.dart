import 'package:cherrypic/data/album/dto/response/unlinked_payment_response_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/repositories/payment_repository.dart';
import 'package:cherrypic/data/album/services/payment_remote_data_source.dart';
import 'package:cherrypic/presentation/screens/main/album/add/album_add_screen.dart';
import 'package:cherrypic/presentation/screens/main/album/add/album_add_view_model.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// --- Fakes for testing ---

// API 응답을 흉내 내는 가짜 DataSource
class FakePaymentDataSource extends PaymentRemoteDataSource {
  UnlinkedPaymentResponseDto? response;

  @override
  Future<UnlinkedPaymentResponseDto?> getUnlinkedPayment() {
    return Future.value(response);
  }
}

void main() {
  group('AlbumAddScreen Recovery Flow', () {
    late FakePaymentDataSource fakePaymentDataSource;
    late PaymentRepository paymentRepository;
    late AlbumAddViewModel albumAddViewModel;

    setUp(() {
      // 각 테스트 전에 필요한 객체들을 초기화합니다.
      fakePaymentDataSource = FakePaymentDataSource();
      paymentRepository = PaymentRepository(remoteDataSource: fakePaymentDataSource);
      albumAddViewModel = AlbumAddViewModel(
        albumRepository: AlbumRepository(), // 실제 레포지토리 사용 (createAlbum은 테스트 안함)
        paymentRepository: paymentRepository,
      );
    });

    testWidgets('should show normal screen when there is no orphaned payment',
        (WidgetTester tester) async {
      // 1. Arrange: 고아 결제가 없는 상황으로 설정
      fakePaymentDataSource.response = null;

      // 2. Act: AlbumAddScreen을 빌드하고, mock ViewModel을 주입합니다.
      await tester.pumpWidget(MaterialApp(
        home: AlbumAddScreen(viewModel: albumAddViewModel),
      ));

      // initState의 비동기 작업이 끝날 때까지 기다립니다.
      await tester.pumpAndSettle();

      // 3. Assert: 팝업이 표시되지 않는지 확인합니다.
      expect(find.byType(AlertDialog), findsNothing);
      // 앨범 타입 선택기가 활성화되어 있는지 확인합니다.
      final selector = tester.widget<AlbumTypeSelector>(find.byType(AlbumTypeSelector));
      expect(selector.enabled, isTrue);
    });

    testWidgets('should show recovery dialog when an orphaned payment is found',
        (WidgetTester tester) async {
      // 1. Arrange: 'PRO' 타입의 고아 결제가 있는 상황으로 설정
      fakePaymentDataSource.response = UnlinkedPaymentResponseDto(
        paymentId: 123,
        albumType: 'PRO',
        amount: 3900,
        purpose: 'CREATION',
        paidAt: '2025-01-01T12:00:00',
      );

      // 2. Act: AlbumAddScreen을 빌드합니다.
      await tester.pumpWidget(MaterialApp(
        home: AlbumAddScreen(viewModel: albumAddViewModel),
      ));
      await tester.pumpAndSettle();

      // 3. Assert: 팝업이 표시되었는지 확인합니다.
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('미완료된 결제 발견'), findsOneWidget);
      expect(find.textContaining('PRO'), findsOneWidget);
    });

    testWidgets('should disable AlbumTypeSelector when user accepts recovery',
        (WidgetTester tester) async {
      // 1. Arrange: 'PRO' 타입의 고아 결제가 있는 상황으로 설정
      fakePaymentDataSource.response = UnlinkedPaymentResponseDto(
        paymentId: 123,
        albumType: 'PRO',
        amount: 3900,
        purpose: 'CREATION',
        paidAt: '2025-01-01T12:00:00',
      );
      
      await tester.pumpWidget(MaterialApp(
        home: AlbumAddScreen(viewModel: albumAddViewModel),
      ));
      await tester.pumpAndSettle();

      // 팝업이 뜬 것을 확인
      expect(find.byType(AlertDialog), findsOneWidget);

      // 2. Act: '예' 버튼을 누릅니다.
      await tester.tap(find.text('예'));
      await tester.pumpAndSettle();

      // 3. Assert: 팝업이 사라졌는지 확인합니다.
      expect(find.byType(AlertDialog), findsNothing);

      // 앨범 타입 선택기가 비활성화되었는지 확인합니다.
      final selector = tester.widget<AlbumTypeSelector>(find.byType(AlbumTypeSelector));
      expect(selector.enabled, isFalse);
      // ViewModel의 상태도 확인합니다.
      expect(albumAddViewModel.isRecovering, isTrue);
      expect(albumAddViewModel.selectedAlbumType, AlbumType.pro);
    });

    testWidgets('should keep AlbumTypeSelector enabled when user rejects recovery',
        (WidgetTester tester) async {
      // 1. Arrange: 'PRO' 타입의 고아 결제가 있는 상황으로 설정
      fakePaymentDataSource.response = UnlinkedPaymentResponseDto(
        paymentId: 123,
        albumType: 'PRO',
        amount: 3900,
        purpose: 'CREATION',
        paidAt: '2025-01-01T12:00:00',
      );

      await tester.pumpWidget(MaterialApp(
        home: AlbumAddScreen(viewModel: albumAddViewModel),
      ));
      await tester.pumpAndSettle();

      // 팝업이 뜬 것을 확인
      expect(find.byType(AlertDialog), findsOneWidget);

      // 2. Act: '아니오' 버튼을 누릅니다.
      await tester.tap(find.text('아니오'));
      await tester.pumpAndSettle();

      // 3. Assert: 팝업이 사라졌는지 확인합니다.
      expect(find.byType(AlertDialog), findsNothing);

      // 앨범 타입 선택기가 여전히 활성화 상태인지 확인합니다.
      final selector = tester.widget<AlbumTypeSelector>(find.byType(AlbumTypeSelector));
      expect(selector.enabled, isTrue);
      // ViewModel의 상태도 확인합니다.
      expect(albumAddViewModel.isRecovering, isFalse);
    });
  });
}
