import 'package:flutter/material.dart';

import '../../core/constants/color.dart';
import '../../core/constants/font.dart';

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