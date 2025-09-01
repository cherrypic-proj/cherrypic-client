import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../widgets/custom_sub_app_bar.dart';
import '../../../components/fixed_button_footer.dart';
import 'album_list/album_list_screen.dart';

class SelectAlbumScreen extends StatefulWidget {
  const SelectAlbumScreen({super.key});

  @override
  State<SelectAlbumScreen> createState() => _SelectAlbumScreenState();
}

class _SelectAlbumScreenState extends State<SelectAlbumScreen> {
  bool isChecked = true;

  int selectedAlbumId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '사진 인화 서비스'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 46),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/circle_one.png',
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '인화할 사진이 있는 앨범을 선택하세요.',
                        style: AppFont.size18.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 53.5),

                /// 앨범 리스트 띄우기
                AlbumListScreen(),

                const SizedBox(height: 150), /// 버튼과 겹치지 않도록 여유 공간
              ],
            ),
          ),

          /// 위치 고정 버튼
          FixedButtonFooter(
            text: '다음',
            isEnabled: isChecked,
            onPressed: () {
              context.push(
                RoutePath.select_image,
                extra: selectedAlbumId,
              );
            },
          ),
        ],
      ),
    );
  }
}