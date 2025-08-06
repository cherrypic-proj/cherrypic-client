import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/my_page/settings/setting_toggle.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_tab_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool albumAlert = false;
  bool photoUpload = true;
  bool adToggle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomTabBar(title: '설정'),
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
                  child: Column(
                    children: [
                      SettingToggle(
                        label: '앨범 알림',
                        value: albumAlert,
                        onChanged: (bool value) {
                          setState(() => albumAlert = value);
                        },
                      ),
                      const SizedBox(height: 26.72,),
                      SettingToggle(
                        label: '사진 업로드',
                        value: photoUpload,
                        onChanged: (bool value) {
                          setState(() => photoUpload = value);
                        },
                      ),
                      const SizedBox(height: 26.72,),
                      SettingToggle(
                        label: '광고',
                        value: adToggle,
                        onChanged: (bool value) {
                          setState(() => adToggle = value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 101.1,),
                SettingToggle(
                  label: '로컬 사진 삭제',
                  value: photoUpload,
                  onChanged: (bool value) {
                    setState(() => photoUpload = value);
                  },
                  textStyle: AppFont.size18.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '사진을 공유 앨범에 업로드하면, 로컬에서 해당 사진을 삭제합니다',
                    style: AppFont.size12.copyWith(
                      color: AppColor.subGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
