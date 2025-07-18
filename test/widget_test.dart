import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cherrypic/presentation/screens/login/login_screen.dart';

void main() {
  testWidgets('로그인 화면에 텍스트가 보이는지 확인', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text('로그인 / 회원가입'), findsOneWidget);
  });

  testWidgets('CherryPic 로고 이미지가 있는지 확인', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.byType(Image), findsNWidgets(4)); // logo, title, kakao/apple 아이콘
  });
}
