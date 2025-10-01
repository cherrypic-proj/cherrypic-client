class AlbumDetailDto {
  final String title;
  final String coverUrl;
  final String type;
  final int capacityUsed;
  final int totalCapacity;
  final String hostName;
  final int numOfParticipants;

  AlbumDetailDto({
    required this.title,
    required this.coverUrl,
    required this.type,
    required this.capacityUsed,
    required this.totalCapacity,
    required this.hostName,
    required this.numOfParticipants,
  });

  factory AlbumDetailDto.fromJson(Map<String, dynamic> json) {
    return AlbumDetailDto(
      title: json['title'] as String,
      coverUrl: json['coverUrl'] as String,
      type: json['type'] as String,
      capacityUsed: json['capacityUsed'] as int,
      totalCapacity: json['totalCapacity'] as int,
      hostName: json['hostName'] as String,
      numOfParticipants: json['numOfParticipants'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'coverUrl': coverUrl,
      'type': type,
      'capacityUsed': capacityUsed,
      'totalCapacity': totalCapacity,
      'hostName': hostName,
      'numOfParticipants': numOfParticipants,
    };
  }
}
