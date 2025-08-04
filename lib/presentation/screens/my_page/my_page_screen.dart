import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/my_page/notice/notice_screen.dart';
import 'package:cherrypic/presentation/screens/my_page/subscription_payment_info/subscription_payment_info_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/font.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/text/horizontal_labeled_text_field.dart';
import 'logout_popup_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              ClipOval(
                child: Image.asset(
                  'assets/images/sample_photo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  debugPrint("프로필 수정");
                },
                child: Text(
                  '프로필 사진 수정',
                  style: AppFont.size14.copyWith(
                    color: AppColor.highlightBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '내 정보',
                      style: AppFont.size20.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 20),
                    child: HorizontalLabeledTextField(
                      title: '이름',
                      hintText: '홍길동',
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 20),
                    child: _buildSocialLoginInfo(),
                  ),
                  const SizedBox(height: 20),
                  _buildCustomDivider(1),
                  Column(
                    children: [
                      _buildListItem('공지사항', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticeScreen(),
                          ),
                        );
                      }),
                      _buildCustomDivider(2),
                      _buildListItem('구독 및 결제정보', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionPaymentInfoScreen(),
                          ),
                        );
                      }),
                      _buildListItem('실물사진 배송지 관리', () {debugPrint("실물사진 배송지 관리");}),
                      _buildListItem('앨범 가입 이력', () {debugPrint("앨범 가입 이력");}),
                      _buildCustomDivider(2),
                      _buildListItem('설정', () {debugPrint("설정");}),
                      _buildCustomDivider(2),
                      _buildListItem('로그아웃', () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.5),
                          builder: (_) => const LogoutPopupScreen(),
                        );
                      }),
                      _buildListItem('회원탈퇴', () {debugPrint("회원탈퇴");}),
                      _buildCustomDivider(2),
                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginInfo() {
    return Row(
      children: [
        Text(
          '연동 정보',
          style: AppFont.size16.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 50),
        ClipOval(
          child: Image.asset(
            'assets/images/kakao_icon.png',
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 20),
        Text(
          '카카오 로그인',
          style: AppFont.size16.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomDivider(double thickness) {
    return Divider(
      color: AppColor.subSlicer,
      thickness: thickness,
      height: 2,
      indent: 0,
      endIndent: 0,
    );
  }

  Widget _buildListItem(String title, VoidCallback onTap) {
    return Column(
      children: [
        _buildCustomDivider(2),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            color: Colors.white,
            width: double.infinity,
            child: Text(
              title,
              style: AppFont.size16.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
