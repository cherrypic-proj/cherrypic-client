class EventListInfoViewModel {
  final List<String> participationMethods = [
    '가족과 함께 찍은 사진을 체리픽 임시 앨범에 업로드',
    '업로드 시, 앨범 제목에 #우리가족 콘테스트] 태그 포함',
    '추첨을 통해 당첨자 선정!',
  ];

  final List<BulletItem> eventBenefits = [
    BulletItem(icon: '📦', text: '가족 맞춤 프레임 액자 무료 증정!'),
    BulletItem(icon: '🎉', text: '소소한 추가 선물도 함께 드려요 (커피 기프티콘 등)'),
  ];

  final List<BulletItem> eventDateNotes = [
    BulletItem(icon: '※', text: '당첨자는 8월 5일(화) 체리픽 앱 공지 및 개별 연락 예정'),
    BulletItem(icon: '※', text: '당첨자는 8월 5일(화) 체리픽 앱 공지 및 개별 연락 예정'),
  ];

  final List<BulletItem> participationNotes = [
    BulletItem(icon: '•', text: '사진은 본인이 촬영하거나 직접 소유한 이미지여야 합니다'),
    BulletItem(icon: '•', text: '선정된 사진은 체리픽 공식 SNS/이벤트 페이지에 소개될 수 있습니다 (사전 동의 절차 진행)'),
    BulletItem(icon: '•', text: '1인 최대 3장까지 응모 가능'),
  ];
}

class BulletItem {
  final String icon;
  final String text;

  BulletItem({required this.icon, required this.text});
}