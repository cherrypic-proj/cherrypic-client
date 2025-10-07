import 'package:cherrypic/presentation/screens/main/detail/events_tab/detail/event_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventSortButtons extends StatelessWidget {
  const EventSortButtons({super.key});

  String _getSortButtonImage({
    required String type,
    required bool isSelected,
    required bool isAscending,
  }) {
    final prefix = type;
    final state = isSelected ? 'on' : 'off';
    final direction = isAscending ? 'up' : 'down';
    return 'assets/images/${prefix}_${state}_$direction.png';
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Consumer<EventDetailViewModel>(
          builder: (context, vm, _) {
            return Row(
              children: [
                _SortButton(
                  imageAsset: _getSortButtonImage(
                    type: 'shot',
                    isSelected: vm.sortParameter == 'GENERATE',
                    isAscending: vm.sortDirection == 'ASC',
                  ),
                  onTap: () => vm.toggleSort('GENERATE'),
                ),
                const SizedBox(width: 8),
                _SortButton(
                  imageAsset: _getSortButtonImage(
                    type: 'upload',
                    isSelected: vm.sortParameter == 'UPLOAD',
                    isAscending: vm.sortDirection == 'ASC',
                  ),
                  onTap: () => vm.toggleSort('UPLOAD'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _SortButton({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Image.asset(
          imageAsset,
          key: ValueKey(imageAsset),
          height: 35,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
