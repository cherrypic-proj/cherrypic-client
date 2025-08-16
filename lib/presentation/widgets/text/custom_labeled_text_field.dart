import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';

class CustomLabeledTextField extends StatefulWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool showCounter;

  const CustomLabeledTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.maxLength,
    this.showCounter = false,
  });

  @override
  State<CustomLabeledTextField> createState() => _CustomLabeledTextFieldState();
}

class _CustomLabeledTextFieldState extends State<CustomLabeledTextField> {
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _currentLength = widget.controller?.text.length ?? 0;
    widget.controller?.addListener(_updateCounter);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateCounter);
    super.dispose();
  }

  void _updateCounter() {
    if (mounted) {
      setState(() {
        _currentLength = widget.controller?.text.length ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppFont.size18.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 13),
        TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          inputFormatters: widget.maxLength != null
              ? [LengthLimitingTextInputFormatter(widget.maxLength)]
              : null,
          style: AppFont.size16.copyWith(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            hintText: widget.hintText,
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
          ),
        ),
        if (widget.showCounter && widget.maxLength != null)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 2.0),
              child: Text(
                '$_currentLength/${widget.maxLength}자',
                style: AppFont.size12.copyWith(color: AppColor.mainRed),
              ),
            ),
          ),
      ],
    );
  }
}
