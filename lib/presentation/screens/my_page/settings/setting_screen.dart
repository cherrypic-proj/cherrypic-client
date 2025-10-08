import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/my_page/settings/setting_toggle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/custom_sub_app_bar.dart';
import '../../../widgets/common_popup_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool albumAlert = false;
  bool photoUpload = true;
  bool adToggle = false;
  bool deleteLocalImage = false;

  /// SettingToggle 리스트
  List<Widget> _buildToggles() {
    return [
      SettingToggle(
        label: '서비스 알림 수신 동의',
        value: albumAlert,
        onChanged: (value) => setState(() => albumAlert = value),
      ),
      const SizedBox(height: 26.72),
      SettingToggle(
        label: '마케팅 알림 수신 동의',
        value: photoUpload,
        onChanged: (value) => setState(() => photoUpload = value),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '설정'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 29.28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '알림',
                    style: AppFont.size18.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 26.72, 0, 0),
                  child: Column(children: _buildToggles()),
                ),
                const SizedBox(height: 101.1),
                SettingToggle(
                  label: '로컬 사진 삭제',
                  value: deleteLocalImage,
                  onChanged: (bool value) {
                    if (value) {
                      showDialog(
                        context: context,
                        builder: (context) => CommonPopupDialog(
                          title: '로컬 사진 삭제',
                          messages: [
                            '앨범에 업로드된 사진은 기기에서 자동으로 삭제되며, 복구가 어려울 수 있습니다.',
                            '삭제를 허용하시겠습니까?',
                          ],
                          leftButtonText: '취소',
                          rightButtonText: '허용',
                          onLeftTap: () {context.pop();},
                          onRightTap: () {
                            setState(() => deleteLocalImage = true);
                            context.pop();
                          },
                        ),
                      );
                    } else {
                      setState(() => deleteLocalImage = false);
                    }
                  },
                  textStyle: AppFont.size18.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '사진을 공유 앨범에 업로드하면, 로컬에서 해당 사진을 삭제하여\n스마트폰 용량을 절약할 수 있습니다.',
                    style: AppFont.size12.copyWith(
                      color: AppColor.subGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
