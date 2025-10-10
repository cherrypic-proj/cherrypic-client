import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';

class HorizontalLabeledTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool showEditIcon;
  final VoidCallback? onEditTap;

  const HorizontalLabeledTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.showEditIcon = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            title,
            style: AppFont.size16.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: AppFont.size16.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              hintText: hintText,
              hintStyle: AppFont.size16.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.mainLightRed, width: 1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.mainLightRed, width: 1),
              ),

              suffixIcon: showEditIcon
                  ? IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Image.asset(
                  'assets/images/ic_edit.png',
                  width: 20,
                  height: 20,
                  color: Colors.black,
                ),
                onPressed: onEditTap,
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}