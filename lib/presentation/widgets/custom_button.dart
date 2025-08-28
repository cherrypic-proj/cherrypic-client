import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, disabled, outlinedStatic, address }

enum AppButtonShape { rounded, squared, capsule }

enum CustomButtonType {
  createAlbum,
  share,
  download,
  delete,
  ai,
  similarGroup,
  deleteBlurryImage,
  deleteClosedEyeImage,
  exitAlbum,
  unSubscribeAlbum,
  addAddress,
}

class CustomButtonStyle {
  final double? width;
  final double height;
  final EdgeInsets padding;
  final TextStyle fontStyle;
  final String text;

  const CustomButtonStyle({
    this.width,
    required this.height,
    required this.padding,
    required this.fontStyle,
    required this.text,
  });
}

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonShape shape;
  final double height;
  final EdgeInsetsGeometry? padding;
  final String? iconPath;
  final double? width;
  final CustomButtonType? type;

  const CustomButton({
    super.key,
    this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.shape = AppButtonShape.rounded,
    this.height = 43,
    this.padding,
    this.iconPath,
    this.width,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled =
        variant == AppButtonVariant.disabled ||
        (onPressed == null && variant != AppButtonVariant.outlinedStatic);

    Color bgColor;
    Color fgColor;
    BorderSide? border;

    switch (variant) {
      case AppButtonVariant.filled:
        bgColor = AppColor.mainRed;
        fgColor = Colors.white;
        break;
      case AppButtonVariant.outlined:
        bgColor = Colors.transparent;
        fgColor = AppColor.mainRed;
        border = BorderSide(color: AppColor.mainRed);
        break;
      case AppButtonVariant.disabled:
        bgColor = Colors.white;
        fgColor = Colors.grey;
        border = BorderSide(color: Colors.grey);
        break;
      case AppButtonVariant.outlinedStatic:
        bgColor = Colors.white;
        fgColor = AppColor.mainRed;
        border = BorderSide(color: AppColor.mainRed);
        break;
      case AppButtonVariant.address:
        bgColor = AppColor.mainLightRed;
        fgColor = Colors.black;
        border = BorderSide(color: AppColor.mainLightRed);
        break;
    }

    BorderRadius borderRadius;
    switch (shape) {
      case AppButtonShape.capsule:
        borderRadius = BorderRadius.circular(999);
        break;
      case AppButtonShape.squared:
        borderRadius = BorderRadius.circular(8);
        break;
      case AppButtonShape.rounded:
        borderRadius = BorderRadius.circular(10);
        break;
    }

    final styleByType = _getStyleByType(type);

    // [수정] 아이콘 유무에 따라 child를 다르게 구성
    final textWidget = Text(
      text?.isNotEmpty == true ? text! : styleByType.text,
      style: styleByType.fontStyle.copyWith(
        fontWeight: type == CustomButtonType.addAddress
            ? FontWeight.w500
            : FontWeight.w800,
      ),
    );

    final Widget child;
    if (iconPath != null) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          textWidget,
          const SizedBox(width: 8),
          Image.asset(iconPath!, width: 24, height: 24),
        ],
      );
    } else {
      child = textWidget;
    }

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.all(bgColor),
      foregroundColor: WidgetStateProperty.all(fgColor),
      padding: WidgetStateProperty.all(padding ?? styleByType.padding),
      fixedSize: WidgetStateProperty.all(
        Size.fromHeight(height != 43 ? height : styleByType.height),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border ?? BorderSide.none,
        ),
      ),
      elevation: WidgetStateProperty.all(0),
    );

    final button = variant == AppButtonVariant.outlined
        ? OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: style,
            child: child,
          )
        : ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: style,
            child: child,
          );

    return SizedBox(
      width:
          width ?? styleByType.width ?? MediaQuery.of(context).size.width - 40,
      child: button,
    );
  }

  CustomButtonStyle _getStyleByType(CustomButtonType? type) {
    switch (type) {
      case CustomButtonType.createAlbum:
        return CustomButtonStyle(
          width: null,
          height: 43,
          padding: const EdgeInsets.symmetric(vertical: 12),
          fontStyle: AppFont.size16,
          text: '앨범 생성',
        );
      case CustomButtonType.share:
        return CustomButtonStyle(
          width: 56,
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          fontStyle: AppFont.size16,
          text: '공유',
        );
      case CustomButtonType.download:
        return CustomButtonStyle(
          width: 84,
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          fontStyle: AppFont.size16,
          text: '다운로드',
        );
      case CustomButtonType.delete:
        return CustomButtonStyle(
          width: 56,
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          fontStyle: AppFont.size16,
          text: '삭제',
        );
      case CustomButtonType.ai:
        return CustomButtonStyle(
          width: 44,
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          fontStyle: AppFont.size16,
          text: 'AI',
        );
      case CustomButtonType.similarGroup:
        return CustomButtonStyle(
          width: 128,
          height: 29,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          fontStyle: AppFont.size14,
          text: '유사한 사진 그룹화',
        );
      case CustomButtonType.deleteBlurryImage:
        return CustomButtonStyle(
          width: 117,
          height: 29,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          fontStyle: AppFont.size14,
          text: '흔들린 사진 삭제',
        );
      case CustomButtonType.deleteClosedEyeImage:
        return CustomButtonStyle(
          width: 120,
          height: 29,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          fontStyle: AppFont.size14,
          text: '눈 감은 사진 삭제',
        );
      case CustomButtonType.exitAlbum:
        return CustomButtonStyle(
          width: 130,
          height: 40,
          padding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
          fontStyle: AppFont.size16,
          text: '앨범 나가기',
        );
      case CustomButtonType.unSubscribeAlbum:
        return CustomButtonStyle(
          width: 155,
          height: 40,
          padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
          fontStyle: AppFont.size16,
          text: '앨범 구독 해지',
        );
      case CustomButtonType.addAddress:
        return CustomButtonStyle(
          width: 106,
          height: 35,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          fontStyle: AppFont.size16,
          text: '우편번호 찾기',
        );
      default:
        return CustomButtonStyle(
          width: null,
          height: 43,
          padding: const EdgeInsets.symmetric(vertical: 12),
          fontStyle: AppFont.size16,
          text: '',
        );
    }
  }
}
