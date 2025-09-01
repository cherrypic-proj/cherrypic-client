import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';

class FixedButtonFooter extends StatefulWidget {
  final String text;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const FixedButtonFooter({
    super.key,
    required this.text,
    this.isEnabled = true,
    this.onPressed,
  });

  @override
  State<FixedButtonFooter> createState() => _FixedButtonFooterState();
}

class _FixedButtonFooterState extends State<FixedButtonFooter> {
  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
        child: GestureDetector(
          onTapDown: (_) {
            if (widget.isEnabled) setState(() => _buttonPressed = true);
          },
          onTapUp: (_) {
            if (widget.isEnabled) setState(() => _buttonPressed = false);
          },
          onTapCancel: () {
            if (widget.isEnabled) setState(() => _buttonPressed = false);
          },
          child: CustomButton(
            text: widget.text,
            onPressed: widget.isEnabled ? widget.onPressed : null,
            variant: widget.isEnabled
                ? (_buttonPressed
                ? AppButtonVariant.filled
                : AppButtonVariant.outlinedStatic)
                : AppButtonVariant.disabled,
          ),
        ),
      ),
    );
  }
}