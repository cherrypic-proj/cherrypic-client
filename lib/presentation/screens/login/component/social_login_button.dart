import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

class SocialLoginButton extends StatefulWidget {
  final Color backgroundColor;
  final Widget image;
  final String text;
  final Color textColor;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.backgroundColor,
    required this.image,
    required this.text,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: _scaleAnimation.value < 1.0
                    ? [] // 눌렸을 때 그림자 제거
                    : [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 36, child: widget.image),
                  Center(
                    child: Text(
                      widget.text,
                      style: AppFont.size16.copyWith(
                        fontWeight: FontWeight.w700,
                        color: widget.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
