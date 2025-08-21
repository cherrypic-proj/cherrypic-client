part of '../album_detail_screen.dart';

/// 하단 토글: 전체/이벤트
class _FloatingSegmented extends StatelessWidget {
  const _FloatingSegmented({
    required this.value, // 0=전체, 1=이벤트
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    // 트랙/핸들 규격
    const double trackW = 120;
    const double trackH = 50;
    const double handleH = 35;
    const double edge = 5;
    const double leftHandleW = 50; // 전체
    const double rightHandleW = 60; // 이벤트

    final double handleW = value == 0 ? leftHandleW : rightHandleW;
    final double handleLeft = value == 0 ? edge : trackW - edge - handleW;

    // 각 절반의 중앙 좌표(라벨 기본 위치)
    const double centerLeft = trackW / 4; // 30
    const double centerRight = trackW * 3 / 4; // 90

    // 선택된 핸들의 실제 중앙 좌표
    final double handleCenter = value == 0
        ? edge + leftHandleW / 2
        : trackW - edge - rightHandleW / 2;

    // 라벨 보정: 선택된 쪽만 핸들 중심에 맞춰 살짝 이동
    final double dxLeftLabel = value == 0
        ? (handleCenter - centerLeft)
        : 0.0; // 0
    final double dxRightLabel = value == 1
        ? (handleCenter - centerRight)
        : 0.0; // -5

    return SizedBox(
      width: trackW,
      height: trackH,
      child: Stack(
        children: [
          // 트랙
          Container(
            width: trackW,
            height: trackH,
            decoration: BoxDecoration(
              color: AppColor.mainLightRed.withAlpha(70),
              borderRadius: BorderRadius.circular(25),
            ),
          ),

          // 선택 핸들 (폭/위치 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            left: handleLeft,
            top: (trackH - handleH) / 2,
            width: handleW,
            height: handleH,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColor.mainRed,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // 라벨 + 터치
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => onChanged(0),
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(dxLeftLabel, 0),
                      child: Text(
                        '전체',
                        style: AppFont.size16.copyWith(
                          fontWeight: FontWeight.w700,
                          color: value == 0 ? Colors.white : AppColor.mainRed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => onChanged(1),
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(dxRightLabel, 0),
                      child: Text(
                        '이벤트',
                        style: AppFont.size16.copyWith(
                          fontWeight: FontWeight.w700,
                          color: value == 1 ? Colors.white : AppColor.mainRed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 하단 우측 사진 추가 버튼
class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.mainRed,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/img_add_bt.png',
          width: 25,
          height: 25,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
