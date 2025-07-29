import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

import '../../core/constants/font.dart';

class CustomBoxCard extends StatelessWidget {
  final bool selected;
  final Color borderColor;
  final Color dotColor;
  final String title;
  final String subtitle;
  final String priceText;
  final Color? priceColor;
  final VoidCallback onTap;
  final Color? divideColor;

  const CustomBoxCard({
    Key? key,
    // required this.selected,
    this.selected = false,
    required this.borderColor,
    required this.dotColor,
    required this.title,
    required this.subtitle,
    required this.priceText,
    required this.priceColor,
    required this.onTap,
    required this.divideColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: SizedBox(
        width: screenWidth - 40,
        child: Container(
          padding: const EdgeInsets.all(16),
          // margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? borderColor : Colors.grey.shade300,
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
                      title,
                      style: AppFont.size16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: AppColor.subGrey)),
                    selected
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            width: double.infinity,
                            height: 1,
                            child: CustomPaint(
                              painter: DottedLinePainter(divideColor!),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            width: double.infinity,
                            height: 1,
                            child: CustomPaint(
                              painter: DottedLinePainter(Colors.white),
                            ),
                          ),
                    Text(
                      priceText,
                      style: TextStyle(
                        color: priceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Padding(
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
                                  border: Border.all(color: dotColor, width: 2),
                                ),
                              ),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: dotColor,
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

class AddressBoxCard extends StatelessWidget {
  final String title;
  final String label;
  final String receiver;
  final String phone;
  final String address;
  final bool isFixed;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressBoxCard({
    super.key,
    required this.title,
    required this.label,
    required this.receiver,
    required this.phone,
    required this.address,
    required this.isFixed,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth - 40,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.mainRed, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppFont.size16.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 23),
                Text(
                  label,
                  style: AppFont.size14.copyWith(color: AppColor.mainRed),
                ),
                if (isFixed) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.check_circle, color: AppColor.mainRed, size: 20),
                ],
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('수령인', receiver),
            const SizedBox(height: 14),
            _buildInfoRow('연락처', phone),
            const SizedBox(height: 14),
            _buildInfoRow('주소', address),
            if (isFixed)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: Text(
                      '수정',
                      style: AppFont.size14.copyWith(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onDelete,
                    child: Text(
                      '삭제',
                      style: AppFont.size14.copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: AppFont.size14.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppFont.size14.copyWith(color: AppColor.subGrey),
          ),
        ),
      ],
    );
  }
}
