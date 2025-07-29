import 'dart:ui';
import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

import '../../core/constants/font.dart';

class CustomAlbumBadge extends StatelessWidget {
  final String userName;
  final String memberCountText;
  final String badgeType;

  const CustomAlbumBadge({
    super.key,
    required this.userName,
    required this.memberCountText,
    required this.badgeType,
  });

  @override
  Widget build(BuildContext context) {
    String badgeImagePath;
    switch (badgeType) {
      case 'pro':
        badgeImagePath = 'assets/images/pro_badge.png';
        break;
      case 'premium':
        badgeImagePath = 'assets/images/premium_badge.png';
        break;
      case 'basic':
        badgeImagePath = 'assets/images/basic_badge.png';
        break;
      default:
        badgeImagePath = 'assets/images/basic_badge.png';
        break;
    }

    return SizedBox(
      width: 320,
      height: 45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/crown_icon.png',
                      width: 24,
                      height: 18,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      userName,
                      style: AppFont.size16.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Image.asset(badgeImagePath, height: 18),
                  ],
                ),
                const SizedBox(width: 14),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                memberCountText,
                                style: AppFont.size14.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          backgroundColor: AppColor.subSlicer,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text(
                          '멤버 추가',
                          style: AppFont.size14.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}