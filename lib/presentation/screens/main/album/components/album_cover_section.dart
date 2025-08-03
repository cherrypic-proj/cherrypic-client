import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/widgets/text/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';

class AlbumCoverSection extends StatefulWidget {
  const AlbumCoverSection({super.key});

  @override
  State<AlbumCoverSection> createState() => _AlbumCoverSectionState();
}

class _AlbumCoverSectionState extends State<AlbumCoverSection> {
  bool isDefaultSelected = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 앨범 커버 미리보기
        Container(
          width: 210,
          height: 294,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColor.mainLightRed,
                blurRadius: 2,
                spreadRadius: 0,
                offset: Offset(0, 0),
              ),
            ],
          ),

          child: Column(
            children: [
              Container(
                width: 210,
                height: 224,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text('앨범 커버가 표시됩니다', style: AppFont.size14),
                ),
              ),
              Container(
                width: 210,
                height: 68,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '앨범 이름이 표시됩니다',
                    style: AppFont.size14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 55),

        // 앨범 커버 타이틀
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '앨범 커버',
            style: AppFont.size18.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 버튼 2개
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 112,
              height: 37,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isDefaultSelected = true;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: isDefaultSelected
                      ? AppColor.mainRed
                      : Colors.white,
                  side: const BorderSide(color: AppColor.mainRed, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  '기존 이미지 사용',
                  style: AppFont.size14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDefaultSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 60),
            SizedBox(
              width: 112,
              height: 37,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isDefaultSelected = false;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: isDefaultSelected
                      ? Colors.white
                      : AppColor.mainRed,
                  side: const BorderSide(color: AppColor.mainRed, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  '사진 업로드 하기',
                  style: AppFont.size14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDefaultSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),

        // 앨범 이름
        const SizedBox(height: 12),
        const CustomLabeledTextField(
          hintText: '앨범 이름을 작성해주세요. (최대 00자)',
          title: '앨범이름',
        ),
      ],
    );
  }
}
