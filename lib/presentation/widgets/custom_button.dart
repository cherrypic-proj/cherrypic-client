import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

class PressedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PressedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 40,
      height: 43,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.mainRed,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppFont.size16,
        ),
      ),
    );
  }
}

class EnabledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const EnabledButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 40,
      height: 43,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.mainRed,
          side: BorderSide(color: AppColor.mainRed),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppFont.size16,
        ),
      ),
    );
  }
}

class DisabledButton extends StatelessWidget {
  final String text;

  const DisabledButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 40,
      height: 43,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          disabledBackgroundColor: Colors.white,
          disabledForegroundColor: Colors.grey,
          side: const BorderSide(color: Colors.grey),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: null,
        child: Text(
          text,
          style: AppFont.size16,
        ),
      ),
    );
  }
}

class SquaredMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SquaredMenuButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.mainRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        fixedSize: const Size.fromHeight(35),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: AppFont.size16
      ),
    );
  }
}

class RoundedMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RoundedMenuButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.mainRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        fixedSize: const Size.fromHeight(29),
      ),
      onPressed: onPressed,
      child: Text(
          text,
          style: AppFont.size16
      ),
    );
  }
}

class ExitAlbumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ExitAlbumButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.mainRed,
        side: BorderSide(color: AppColor.mainRed),
        padding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
        fixedSize: const Size.fromHeight(43),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: AppFont.size16),
          Image.asset(
            'assets/images/door_open.png',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}

class UnSubscribeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const UnSubscribeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.mainRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
        fixedSize: const Size.fromHeight(43),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: AppFont.size16),
          Image.asset(
            'assets/images/trash_icon.png',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}