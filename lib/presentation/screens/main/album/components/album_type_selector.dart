import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';

class AlbumTypeSelector extends StatefulWidget {
  const AlbumTypeSelector({super.key});

  @override
  State<AlbumTypeSelector> createState() => _AlbumTypeSelectorState();
}

enum AlbumType { basic, pro, premium }

class _AlbumTypeSelectorState extends State<AlbumTypeSelector> {
  AlbumType _selectedType = AlbumType.basic;

  Widget _buildAlbumOption({
    required AlbumType type,
    required String title,
    required String description,
    required String imagePath,
    required Color backgroundColor,
    bool showSubscribe = false,
    String? basicCapacityStatus,
  }) {
    final isSelected = _selectedType == type;
    final isPremium = type == AlbumType.premium;
    final textColor = isPremium ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColor.mainRed : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 333,
          height: 77,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 34,
                height: 53,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFont.size16.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: AppFont.size12.copyWith(
                        height: 1.1,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (showSubscribe)
                Text(
                  '구독하기',
                  style: AppFont.size14.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                )
              else if (basicCapacityStatus != null)
                Text(
                  basicCapacityStatus,
                  style: AppFont.size14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAlbumOption(
          type: AlbumType.basic,
          title: 'Basic 앨범',
          description: '기본 제공되는 앨범이에요\n최대 nGB 저장 가능',
          imagePath: 'assets/images/basic_lgoo.png',
          backgroundColor: AppColor.subSlicer,
          basicCapacityStatus: '7/10',
        ),
        _buildAlbumOption(
          type: AlbumType.pro,
          title: 'CherryPic Pro 앨범',
          description: '용량 300GB 증대\n공유앨범 40개 생성 및 가입 가능\n+ 그 외 추가혜택 n개',
          imagePath: 'assets/images/pro_logo.png',
          backgroundColor: AppColor.mainLightRed,
          showSubscribe: true,
        ),
        _buildAlbumOption(
          type: AlbumType.premium,
          title: 'CherryPic Premium 앨범',
          description: '용량 1TB 증대\n공유앨범 100개 생성 및 가입 가능\n+ 그 외 추가혜택 n개',
          imagePath: 'assets/images/premium_logo.png',
          backgroundColor: AppColor.mainRed,
          showSubscribe: true,
        ),
      ],
    );
  }
}
