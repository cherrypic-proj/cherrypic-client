import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/add_to_event_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/components/event_album_cover.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToEventSheet extends StatelessWidget {
  final int albumId;
  final int imageId;

  const AddToEventSheet({
    super.key,
    required this.albumId,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddToEventViewModel(albumId: albumId, imageId: imageId),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
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
    final vm = context.watch<AddToEventViewModel>();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              controller: scrollController,
              children: [
                const SizedBox(height: 24),
                _buildHeader(context, vm),
                const SizedBox(height: 40),
                if (vm.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (vm.error != null)
                  Center(child: Text(vm.error!))
                else if (vm.events.isEmpty)
                  const Center(child: Text('추가할 이벤트가 없습니다.'))
                else
                  _buildEventGrid(context, vm),
              ],
            ),
            if (vm.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AddToEventViewModel vm) {
    final isEventSelected = vm.selectedEventId != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // '이벤트 추가' 버튼
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.mainLightRed.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.mainRed.withOpacity(0.7)),
            ),
            child: Row(
              children: [
                Text(
                  '이벤트 추가',
                  style: AppFont.size16.copyWith(
                    color: AppColor.mainRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppColor.mainRed.withOpacity(0.8),
                  size: 20,
                ),
              ],
            ),
          ),
          // '완료' 버튼 (이벤트가 선택됐을 때만 활성화)
          GestureDetector(
            onTap: isEventSelected
                ? () async {
                    final success = await vm.addPhotoToSelectedEvent();
                    if (success && context.mounted) {
                      Navigator.pop(context); // 시트 닫기
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('사진을 이벤트에 추가했습니다.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (vm.error != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(vm.error!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                : null, // 선택 안됐으면 비활성화
            child: Text(
              '완료',
              style: AppFont.size18.copyWith(
                fontWeight: FontWeight.bold,
                color: isEventSelected ? AppColor.mainRed : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventGrid(BuildContext context, AddToEventViewModel vm) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.events.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2, // 가로세로 비율 조정
      ),
      itemBuilder: (context, index) {
        final event = vm.events[index];
        return EventAlbumCover(
          album: event,
          isSelectable: true, // 선택 모드 활성화
          isSelected: vm.selectedEventId == event.eventId,
          onTap: () => vm.selectEvent(event.eventId),
        );
      },
    );
  }
}
