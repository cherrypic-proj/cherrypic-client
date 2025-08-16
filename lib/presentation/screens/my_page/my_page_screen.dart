import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/my_page/my_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/font.dart';
import '../../../core/router/route_path.dart';
import '../../widgets/text/horizontal_labeled_text_field.dart';
import 'common_popup_dialog.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late final MyPageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = MyPageViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  ClipOval(
                    child: viewModel.coverImage != null
                        ? Image.memory(
                      viewModel.coverImage!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/images/sample_photo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => viewModel.pickImage(context),
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
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 20),
                        child: HorizontalLabeledTextField(
                          title: '이름',
                          hintText: '홍길동',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 20),
                        child: _buildSocialLoginInfo(),
                      ),
                      const SizedBox(height: 20),
                      _buildCustomDivider(1),
                      Column(
                        children: [
                          _buildListItem('공지사항', () {
                            context.push(RoutePath.myPage_notice);
                          }),
                          _buildCustomDivider(2),
                          _buildListItem('앨범 및 결제정보', () {
                            context.push(RoutePath.myPage_album_payment_info);
                          }),
                          _buildListItem('실물사진 배송지 관리', () {
                            context.push(RoutePath.myPage_address_management);
                          }),
                          _buildListItem('앨범 가입 이력', () {
                            context.push(RoutePath.myPage_subscription_history);
                          }),
                          _buildCustomDivider(2),
                          _buildListItem('설정', () {
                            context.push(RoutePath.myPage_setting);
                          }),
                          _buildCustomDivider(2),
                          _buildListItem('로그아웃', () {
                            showDialog(
                              context: context,
                              builder: (_) => CommonPopupDialog(
                                title: '로컬 사진 삭제',
                                messages: const [
                                  '지금 로그아웃하면 앨범을 더 이상 확인할 수 없어요.',
                                  '계속 로그아웃하시겠어요?',
                                ],
                                leftButtonText: '취소',
                                rightButtonText: '로그아웃',
                                onLeftTap: () => Navigator.of(context).pop(),
                                onRightTap: () {
                                  /// 삭제 로직 구현 예정
                                },
                              ),
                            );
                          }),
                          _buildListItem('회원탈퇴', () {
                            context.push(RoutePath.myPage_delete_account);
                          }),
                          _buildCustomDivider(2),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 로그인 정보
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
        const SizedBox(width: 50),
        ClipOval(
          child: Image.asset(
            viewModel.loginIconAsset,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 20),
        Text(
          viewModel.loginTypeLabel,
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