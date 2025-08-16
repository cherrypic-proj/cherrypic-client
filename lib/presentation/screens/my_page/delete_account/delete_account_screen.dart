import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/font.dart';
import '../../../widgets/custom_box_card.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_tab_bar.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isChecked = false;
  bool _buttonPressed = false;

  /// 탈퇴 시 안내 문구 리스트
  final List<String> _withdrawalNotices = [
    '가입 시 사용하신 모든 계정 정보와 프로필이 삭제됩니다.',
    '공유 앨범 및 개인 앨범이 모두 삭제되며, 다른 사용자와 공유한 사진도 함께 사라질 수 있습니다.',
    '업로드한 사진, 이벤트 정보, 댓글, 좋아요 내역 등 모든 활동 기록이 삭제됩니다.',
    '탈퇴 후에는 동일한 이메일로 재가입이 가능하나, 기존 데이터는 복구되지 않습니다.',
    '유료 서비스를 이용 중인 경우, 탈퇴와 동시에 자동 해지되며 환불은 불가합니다. (환불 정책은 이용약관을 참조해 주세요.)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTabBar(title: '회원 탈퇴'),
            const SizedBox(height: 37.26),
            Padding(
              padding: const EdgeInsets.fromLTRB(42.97, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 탈퇴 Title
                  Text(
                    '체리픽 회원 탈퇴 전 꼭 확인해주세요.',
                    style: AppFont.size18.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// 탈퇴 SubTitle
                  Text(
                    '탈퇴하시면 아래 내용이 즉시 적용되며, 복구는 불가능합니다.',
                    style: AppFont.size12.copyWith(
                      color: AppColor.subLightGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 37.26),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 37.64, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                /// 탈퇴 안내 문구
                children: _withdrawalNotices
                    .map(
                      (text) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _bulletText(text),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 106.8),

            /// 구분선
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              height: 1,
              child: CustomPaint(painter: DottedLinePainter(AppColor.mainRed)),
            ),
            const SizedBox(height: 48.2),

            /// 확인 체크 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: _isChecked,
                    activeColor: AppColor.mainRed,
                    side: const BorderSide(color: AppColor.mainRed),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _isChecked = val ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '확인했습니다',
                  style: AppFont.size16.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 37),

            /// 회원 탈퇴하기 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GestureDetector(
                onTapDown: (_) {
                  if (_isChecked) {
                    setState(() => _buttonPressed = true);
                  }
                },
                onTapUp: (_) {
                  if (_isChecked) {
                    setState(() => _buttonPressed = false);
                  }
                },
                onTapCancel: () {
                  if (_isChecked) {
                    setState(() => _buttonPressed = false);
                  }
                },
                child: CustomButton(
                  variant: _isChecked
                      ? (_buttonPressed
                            ? AppButtonVariant.filled
                            : AppButtonVariant.outlined)
                      : AppButtonVariant.disabled,
                  text: '회원 탈퇴하기',
                  onPressed: _isChecked ? () {} : null,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 탈퇴 안내 텍스트 위젯
  Widget _bulletText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(height: 1.5)),
        Expanded(
          child: Text(
            text,
            style: AppFont.size14.copyWith(
              color: AppColor.subGrey,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
