import 'package:cherrypic/presentation/widgets/text/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/widgets/custom_button.dart';

class AlbumPermissionToggle extends StatefulWidget {
  final bool showLockSetting;

  const AlbumPermissionToggle({super.key, required this.showLockSetting});

  @override
  State<AlbumPermissionToggle> createState() => _AlbumPermissionToggleState();
}

class _AlbumPermissionToggleState extends State<AlbumPermissionToggle> {
  bool isOn = false;
  bool _showTooltip = false;
  final GlobalKey _iconKey = GlobalKey();
  double _tooltipLeft = 0;
  final double _arrowOffset = 140; // 툴팁 너비 / 2 (툴팁 width = 280 기준)

  void _toggleTooltip() {
    final RenderBox renderBox =
        _iconKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    setState(() {
      _tooltipLeft = position.dx + size.width / 2 - _arrowOffset;
      _showTooltip = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showTooltip = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 권한 부여 + 툴팁 아이콘 + 스위치
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '멤버별 권한 부여',
                      style: AppFont.size18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _toggleTooltip,
                      child: Icon(
                        Icons.info_outline,
                        key: _iconKey,
                        size: 18,
                        color: AppColor.mainRed,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isOn,
                  activeColor: AppColor.mainRed,
                  onChanged: (value) {
                    setState(() {
                      isOn = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 75),

            // 조건부 잠금 설정 UI
            if (widget.showLockSetting) ...[
              const CustomLabeledTextField(
                title: '앨범 잠금 설정',
                hintText: '사용할 비밀번호를 작성해주세요',
              ),
              const SizedBox(height: 60),
            ],

            // 저장 버튼
            CustomButton(
              text: '변경 사항 저장',
              variant: AppButtonVariant.disabled,
              onPressed: () {},
            ),
          ],
        ),

        // 툴팁 (Stack의 의미 있는 요소는 이거 하나뿐임)
        if (_showTooltip)
          Positioned(
            top: 40,
            left: _tooltipLeft,
            child: TooltipWithArrow(
              text:
                  '앨범 생성자가 방장이 되어, 멤버의 편집권한을 관리할 수 있어요.\n실수로 사진이 삭제되거나 앨범이 손상되는 일을 방지할 수 있어요.',
            ),
          ),
      ],
    );
  }
}

class TooltipWithArrow extends StatelessWidget {
  final String text;

  const TooltipWithArrow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TooltipBubblePainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 8),
        child: Text(
          text,
          style: AppFont.size12.copyWith(color: Colors.black, height: 1.0),
        ),
      ),
    );
  }
}

class TooltipBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = 12;
    final double arrowW = 12;
    final double arrowH = 8;
    final double arrowLeft = 113;

    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppColor.mainRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final Path path = Path()
      ..moveTo(radius, arrowH)
      ..lineTo(arrowLeft, arrowH)
      ..lineTo(arrowLeft + arrowW / 2, 0)
      ..lineTo(arrowLeft + arrowW, arrowH)
      ..lineTo(size.width - radius, arrowH)
      ..quadraticBezierTo(size.width, arrowH, size.width, arrowH + radius)
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      )
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - radius)
      ..lineTo(0, arrowH + radius)
      ..quadraticBezierTo(0, arrowH, radius, arrowH)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
