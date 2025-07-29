import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';

import '../../widgets/custom_album_app_bar.dart';
import '../../widgets/custom_album_badge.dart';
import '../../widgets/custom_gauge_bar.dart';

class MainAlbumScreen extends StatelessWidget {
  const MainAlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAlbumHeader(
            title: '음식(양식, 중식, 한식...)',
            profileImagePath: 'assets/images/albumCover.png',
          ),
          // 나머지 위젯
          Stack(
            children: [
              Container(
                height: 370,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/sample_photo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 20, // 위치 조정
                left: 20,
                right: 20,
                child: CustomGaugeBar(usedGB: 7.5, totalGB: 15),
              ),
              Positioned(
                bottom: 20, // Adjust vertical placement
                left: MediaQuery.of(context).size.width / 2 - 316 / 2,
                child: const CustomAlbumBadge(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
