import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart'; // 버튼 정의 파일을 import

class ButtonTestScreen extends StatelessWidget {
  const ButtonTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('버튼 테스트'), backgroundColor: Colors.red),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DisabledButton(text: '앨범 생성'),
            const SizedBox(height: 16),
            EnabledButton(text: '앨범 생성', onPressed: () {}),
            const SizedBox(height: 16),
            PressedButton(text: '앨범 생성', onPressed: () {}),
            SquaredMenuButton(text: '공유', onPressed: () {}),
            SquaredMenuButton(text: '다운로드', onPressed: () {}),
            SquaredMenuButton(text: '삭제', onPressed: () {}),
            SquaredMenuButton(text: 'AI', onPressed: () {}),
            RoundedMenuButton(text: '유사한 사진 그룹화', onPressed: () {}),
            RoundedMenuButton(text: '흔들린 사진 삭제', onPressed: () {}),
            RoundedMenuButton(text: '눈 감은 사진 삭제', onPressed: () {}),
            ExitAlbumButton(text: '앨범 나가기', onPressed: () {}),
            const SizedBox(height: 8),
            UnSubscribeButton(text: '앨범 구독 해지', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
