import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_cover_view_model.dart';
import 'package:cherrypic/presentation/widgets/text/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';

class AlbumCoverSection extends StatefulWidget {
  final AlbumCoverViewModel viewModel;

  const AlbumCoverSection({super.key, required this.viewModel});

  @override
  State<AlbumCoverSection> createState() => _AlbumCoverSectionState();
}

class _AlbumCoverSectionState extends State<AlbumCoverSection> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.viewModel.albumName);
    _textController.addListener(() {
      widget.viewModel.updateAlbumName(_textController.text);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 앨범 커버 미리보기
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
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 210,
                    height: 224,
                    decoration: const BoxDecoration(
                      // 배경색은 이미지가 없을 때만 보이도록 ClipRRect 안으로 이동
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: widget.viewModel.coverImage != null
                          // 1. 새로 선택한 이미지가 있을 경우 (Uint8List)
                          ? Image.memory(
                              widget.viewModel.coverImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          // 2. 기존 네트워크 이미지가 있을 경우 (String URL)
                          : (widget.viewModel.coverImageUrl != null &&
                                widget.viewModel.coverImageUrl!.isNotEmpty)
                          ? Image.network(
                              widget.viewModel.coverImageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            )
                          // 3. 표시할 이미지가 아무것도 없을 경우
                          : Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Text(
                                  '앨범 커버가 표시됩니다',
                                  style: AppFont.size14,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    width: 210,
                    height: 68,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.viewModel.albumName,
                        style: AppFont.size14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textHeightBehavior: const TextHeightBehavior(
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
                      widget.viewModel.selectImageType(true);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: widget.viewModel.isDefaultSelected
                          ? AppColor.mainRed
                          : Colors.white,
                      side: const BorderSide(color: AppColor.mainRed, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      '기존 이미지 사용',
                      style: AppFont.size14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.viewModel.isDefaultSelected
                            ? Colors.white
                            : Colors.black,
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
                      widget.viewModel.selectImageType(false);
                      widget.viewModel.pickImage(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: widget.viewModel.isDefaultSelected
                          ? Colors.white
                          : AppColor.mainRed,
                      side: const BorderSide(color: AppColor.mainRed, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      '사진 업로드 하기',
                      style: AppFont.size14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.viewModel.isDefaultSelected
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // 앨범 이름
            const SizedBox(height: 12),
            CustomLabeledTextField(
              controller: _textController,
              hintText:
                  '앨범 이름을 작성해주세요. (최대 ${AlbumCoverViewModel.maxAlbumNameLength}자)',
              title: '앨범이름',
              maxLength: AlbumCoverViewModel.maxAlbumNameLength,
              showCounter: true,
            ),
          ],
        );
      },
    );
  }
}
