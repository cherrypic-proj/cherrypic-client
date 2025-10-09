import 'album_subscription_history_list.dart';

class AlbumSubscriptionHistoryModel {
  final String date;
  final String title;
  final NoticeIconType iconType;

  const AlbumSubscriptionHistoryModel({
    required this.date,
    required this.title,
    required this.iconType,
  });
}