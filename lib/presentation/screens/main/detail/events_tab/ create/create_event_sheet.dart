import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'create_event_view_model.dart';

class CreateEventSheet extends StatelessWidget {
  const CreateEventSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateEventViewModel(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: _SheetContent(scrollController: scrollController),
          );
        },
      ),
    );
  }
}

class _SheetContent extends StatelessWidget {
  final ScrollController scrollController;
  const _SheetContent({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateEventViewModel>();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              controller: scrollController,
              padding: EdgeInsets.only(
                bottom: bottomPadding + (vm.isAnythingSelected ? 120 : 20),
              ),
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildCoverSection(context, vm),
                const SizedBox(height: 30),
                _buildPhotoGridSection(context, vm),
              ],
            ),

            if (vm.isAnythingSelected)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomActionBar(context, vm),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 40,
      decoration: BoxDecoration(
        color: AppColor.mainRed,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '새 이벤트 생성',
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
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  '이전',
                  style: AppFont.size14.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverSection(BuildContext context, CreateEventViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              image: vm.coverImage != null
                  ? DecorationImage(
                      image: FileImage(vm.coverImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: vm.coverImage == null
                ? Icon(
                    Icons.photo_library_outlined,
                    color: Colors.grey[400],
                    size: 40,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  width: 175,
                  height: 40,
                  child: TextField(
                    controller: vm.titleController,
                    style: AppFont.size14,
                    decoration: InputDecoration(
                      hintText: '이벤트 제목',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
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
                GestureDetector(
                  onTap: () => vm.pickCoverImage(context),
                  child: Container(
                    width: 115,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColor.mainRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '커버사진 업로드',
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
      ),
    );
  }

  Widget _buildPhotoGridSection(BuildContext context, CreateEventViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '사진 추가',
            style: AppFont.size18.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.allPhotos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final imageUrl = vm.allPhotos[index];
            final isSelected = vm.selectedPhotoIndexes.contains(index);
            return GestureDetector(
              onTap: () => vm.togglePhotoSelection(index),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(imageUrl, fit: BoxFit.cover),
                  if (isSelected)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.mainRed, width: 3),
                      ),
                    ),
                  if (isSelected)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.mainRed,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context, CreateEventViewModel vm) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColor.mainLightRed,
                  borderRadius: BorderRadius.circular(12.5),
                  border: Border.all(color: AppColor.mainRed, width: 1),
                ),
                child: Center(
                  child: Text(
                    '${vm.selectedPhotosCount}장 선택됨',
                    style: AppFont.size14.copyWith(
                      color: AppColor.mainRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: vm.createEvent,
            child: Container(
              width: 260,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.mainRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '이벤트 생성',
                  style: AppFont.size16.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
