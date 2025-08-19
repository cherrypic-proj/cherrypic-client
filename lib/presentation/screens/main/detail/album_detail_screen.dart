import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_view_model.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/main_album_header.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'album_detail_view_model.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/constants/color.dart';

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;
  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlbumHeaderViewModel(albumId)),
        ChangeNotifierProvider(create: (_) => AlbumDetailViewModel(albumId)),
      ],
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  // 0=전체, 1=이벤트
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final headerVm = context.watch<AlbumHeaderViewModel>();
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 상단 헤더
              SliverSafeArea(
                top: true,
                bottom: false,
                sliver: SliverToBoxAdapter(
                  child: MainAlbumHeader(data: headerVm.header),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 탭 별 본문
              if (_tabIndex == 0)
                Consumer<AlbumDetailViewModel>(
                  builder: (context, vm, _) {
                    return SliverList.builder(
                      itemCount: vm.groups.length,
                      itemBuilder: (context, index) {
                        final g = vm.groups[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: AlbumGroupSection(
                            date: g.date,
                            isAllSelected: g.isAllSelected,
                            onToggleAll: () => vm.toggleAll(index),
                            imageUrls: g.imageUrls,
                            selectedIndexes: g.selectedIndexes,
                            onImageTap: (imgIdx) =>
                                vm.toggleImage(index, imgIdx),
                          ),
                        );
                      },
                    );
                  },
                )
              else
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: ColoredBox(color: Colors.white),
                ),

              // 하단 고정 버튼들과 겹침 방지
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // 하단 좌측: 전체/이벤트 토글
          Positioned(
            bottom: 24 + bottomSafe,
            left: 0,
            right: 0, // 좌우 0으로 펼치고
            child: Center(
              // Center로 가운데 정렬
              child: _FloatingSegmented(
                value: _tabIndex,
                onChanged: (i) => setState(() => _tabIndex = i),
              ),
            ),
          ),

          // 하단 우측: 사진 추가 버튼(기능은 나중에 연결)
          Positioned(
            right: 45,
            bottom: 24 + bottomSafe,
            child: _AddPhotoButton(
              onTap: () {
                // TODO: 사진 추가 기능 연결
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 하단 토글: 전체/이벤트
class _FloatingSegmented extends StatelessWidget {
  const _FloatingSegmented({
    required this.value, // 0=전체, 1=이벤트
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    // 트랙/핸들 규격
    const double trackW = 120;
    const double trackH = 50;
    const double handleH = 35;
    const double edge = 5;
    const double leftHandleW = 50; // 전체
    const double rightHandleW = 60; // 이벤트

    final double handleW = value == 0 ? leftHandleW : rightHandleW;
    final double handleLeft = value == 0 ? edge : trackW - edge - handleW;

    // 각 절반의 중앙 좌표(라벨 기본 위치)
    const double centerLeft = trackW / 4; // 30
    const double centerRight = trackW * 3 / 4; // 90

    // 선택된 핸들의 실제 중앙 좌표
    final double handleCenter = value == 0
        ? edge + leftHandleW / 2
        : trackW - edge - rightHandleW / 2;

    // 라벨 보정: 선택된 쪽만 핸들 중심에 맞춰 살짝 이동
    final double dxLeftLabel = value == 0
        ? (handleCenter - centerLeft)
        : 0.0; // 0
    final double dxRightLabel = value == 1
        ? (handleCenter - centerRight)
        : 0.0; // -5

    return SizedBox(
      width: trackW,
      height: trackH,
      child: Stack(
        children: [
          // 트랙
          Container(
            width: trackW,
            height: trackH,
            decoration: BoxDecoration(
              color: AppColor.mainLightRed.withAlpha(70),
              borderRadius: BorderRadius.circular(25),
            ),
          ),

          // 선택 핸들 (폭/위치 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            left: handleLeft,
            top: (trackH - handleH) / 2,
            width: handleW,
            height: handleH,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColor.mainRed,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // 라벨 + 터치
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => onChanged(0),
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(dxLeftLabel, 0), // 선택 시만 미세정렬(0)
                      child: Text(
                        '전체',
                        style: AppFont.size16.copyWith(
                          fontWeight: FontWeight.w700,
                          color: value == 0 ? Colors.white : AppColor.mainRed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => onChanged(1),
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(dxRightLabel, 0), // 이벤트 선택 시 -5px
                      child: Text(
                        '이벤트',
                        style: AppFont.size16.copyWith(
                          fontWeight: FontWeight.w700,
                          color: value == 1 ? Colors.white : AppColor.mainRed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 하단 우측 사진 추가 버튼
class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.mainRed,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/img_add_bt.png',
          width: 25,
          height: 25,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
