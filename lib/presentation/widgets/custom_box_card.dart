import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

import '../../core/constants/font.dart';
import '../screens/store/photo_printing/service_step/select_option/print_option_model.dart';

class CustomBoxCard extends StatelessWidget {
  final bool selected;
  final PrintOptionModel model;
  final VoidCallback onTap;
  final Color? borderColor;

  const CustomBoxCard({
    super.key,
    this.selected = false,
    required this.model,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: screenWidth - 40,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? (borderColor ?? model.dotColor) : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: AppFont.size16.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(model.subtitle, style: TextStyle(color: AppColor.subGrey)),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: double.infinity,
                      height: 1,
                      child: CustomPaint(
                        painter: DottedLinePainter(selected ? model.divideColor : Colors.white),
                      ),
                    ),
                    Text(
                      model.priceText,
                      style: TextStyle(
                        color: model.priceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: selected
                      ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: model.dotColor, width: 2),
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: model.dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  )
                      : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 4;
    const double dashSpace = 4;
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
