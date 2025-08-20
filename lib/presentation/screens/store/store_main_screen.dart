import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing_banner.dart';
import 'package:cherrypic/presentation/screens/store/store_type_selector.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/font.dart';
import '../../widgets/menu_button.dart';

class StoreMainScreen extends StatelessWidget {
  const StoreMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MenuButton(iconType: EventStoreIconType.store, title: '스토어'),
          Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 72,),

                      /// 사진 인화 서비스 배너
                      PhotoPrintingBanner(),
                      const SizedBox(height: 57,),

                      /// 정기 구독 Selector Title 과 SubTitle
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CherryPic 정기 구독',
                              style: AppFont.size20.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              '한장의 사진도 놓치지 마세요!\nPro 또는 Premium 앨범을 구매해서, 용량 걱정 없이 사진을 공유해보세요!',
                              style: AppFont.size10.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColor.subGrey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22.5,),

                      /// 구독 Selector
                      StoreTypeSelector(),

                      const SizedBox(height: 221,),
                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
