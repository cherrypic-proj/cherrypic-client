import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';

class AlbumGroupSection extends StatelessWidget {
  final String date;
  final bool isAllSelected;
  final VoidCallback onToggleAll;
  final List<String> imageUrls;
  final Set<int> selectedIndexes;
  final void Function(int index) onImageTap;

  const AlbumGroupSection({
    super.key,
    required this.date,
    required this.isAllSelected,
    required this.onToggleAll,
    required this.imageUrls,
    required this.selectedIndexes,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = (MediaQuery.of(context).size.width - 18 * 2) / 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: AppFont.size18.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: onToggleAll,
                style: TextButton.styleFrom(
                  minimumSize: const Size(74, 22),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: isAllSelected
                      ? AppColor.mainRed
                      : Colors.transparent,
                  side: const BorderSide(color: AppColor.mainRed),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '전체선택',
                      style: TextStyle(
                        color: isAllSelected ? Colors.white : Colors.black,
                        fontSize: 12,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      isAllSelected
                          ? 'assets/images/check_circle.png'
                          : 'assets/images/uncheck_circle.png',
                      width: 12,
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: imageUrls.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final imageUrl = imageUrls[index];
              final isSelected = selectedIndexes.contains(index);
              return GestureDetector(
                onTap: () => onImageTap(index),
                child: Stack(
                  children: [
                    Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: AppColor.mainRed, width: 2)
                            : null,
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
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
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
