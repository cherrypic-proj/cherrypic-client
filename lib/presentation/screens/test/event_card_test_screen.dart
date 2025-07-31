import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/event/event_cover_card.dart';

class EventCardTestScreen extends StatelessWidget {
  const EventCardTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이벤트 카드 테스트')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            EventCoverCard(
              title: '이벤트 1',
              photoCount: 4,
              imageUrl: 'https://picsum.photos/200/300?1',
            ),
            EventCoverCard(
              title: '이벤트 2',
              photoCount: 13,
              imageUrl: 'https://picsum.photos/200/300?2',
            ),
            EventCoverCard(
              title: '이벤트 3',
              photoCount: 7,
              imageUrl: 'https://picsum.photos/200/300?3',
            ),
          ],
        ),
      ),
    );
  }
}
