import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'event_edit_view_model.dart';

class EventEditDialog extends StatelessWidget {
  final EventAlbum event;

  const EventEditDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventEditViewModel(event: event),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Consumer<EventEditViewModel>(
          builder: (context, vm, _) {
            // 다이얼로그의 너비를 화면 너비의 90%로 고정하여 너비 문제 해결
            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context, vm),
                    const SizedBox(height: 24),
                    _buildCoverSection(context, vm),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Header UI (with edit button) - 이미지와 똑같이 수정
  Widget _buildHeader(BuildContext context, EventEditViewModel vm) {
    // [수정] SizedBox를 추가하여 너비를 330으로 고정합니다.
    return SizedBox(
      width: 330,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColor.mainRed,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '이벤트 앨범 설정',
              style: AppFont.size18.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 15,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  color: Colors.transparent,
                  height: 44,
                  alignment: Alignment.center,
                  child: Text(
                    '취소',
                    style: AppFont.size14.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 15,
              child: GestureDetector(
                onTap: vm.isSaving || vm.isUploading
                    ? null
                    : () async {
                        final success = await vm.updateEvent();
                        if (success && context.mounted) {
                          // [수정] true 대신, 업데이트된 정보로 새 EventAlbum 객체를 만들어 반환합니다.
                          final updatedEvent = EventAlbum(
                            eventId: vm.event.eventId,
                            title: vm.titleController.text,

                            imageUrl: vm.coverImageUrl!,
                            photoCount: vm.event.photoCount, // 사진 개수는 그대로 유지
                          );
                          Navigator.pop(context, updatedEvent);
                        } else if (vm.error != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.error!),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                child: Container(
                  color: Colors.transparent,
                  height: 44,
                  alignment: Alignment.center,
                  child: Text(
                    '수정',
                    style: AppFont.size14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cover image and title UI
  Widget _buildCoverSection(BuildContext context, EventEditViewModel vm) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Cover Image (130x130)
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: vm.coverImage != null
                ? Image.file(vm.coverImage!, fit: BoxFit.cover)
                : (vm.coverImageUrl != null && vm.coverImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: vm.coverImageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        )
                      : Icon(
                          Icons.photo_library_outlined,
                          color: Colors.grey[400],
                          size: 40,
                        )),
          ),
        ),
        const SizedBox(width: 16),

        // Right: Title input and upload button
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Title Input
              SizedBox(
                height: 40,
                child: TextField(
                  controller: vm.titleController,
                  style: AppFont.size14,
                  decoration: InputDecoration(
                    hintText: '이벤트 제목',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColor.mainRed,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Upload Cover Photo Button
              GestureDetector(
                onTap: vm.isUploading ? null : () => vm.pickCoverImage(context),
                child: Container(
                  width: 115,
                  height: 30,
                  decoration: BoxDecoration(
                    color: vm.isUploading ? Colors.grey : AppColor.mainRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      vm.isUploading ? '업로드 중...' : '커버사진 업로드',
                      style: AppFont.size14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
