class AlbumDetailDto {
  final String title;
  final String? coverUrl;
  final String type;
  final double capacityUsed;
  final double totalCapacity;
  final String hostName;
  final int numOfParticipants;

  AlbumDetailDto({
    required this.title,
    this.coverUrl,
    required this.type,
    required this.capacityUsed,
    required this.totalCapacity,
    required this.hostName,
    required this.numOfParticipants,
  });

  factory AlbumDetailDto.fromJson(Map<String, dynamic> json) {
    return AlbumDetailDto(
      title: json['title'] as String,
      coverUrl: json['coverUrl'] as String?,
      type: json['type'] as String,
      capacityUsed: (json['capacityUsedGb'] is String)
          ? double.parse(json['capacityUsedGb'] as String)
          : (json['capacityUsedGb'] as num).toDouble(),
      totalCapacity: (json['totalCapacityGb'] is String)
          ? double.parse(json['totalCapacityGb'] as String)
          : (json['totalCapacityGb'] as num).toDouble(),
      hostName: json['hostName'] as String,
      numOfParticipants: json['numOfParticipants'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'coverUrl': coverUrl,
      'type': type,
      'capacityUsedGb': capacityUsed,
      'totalCapacityGb': totalCapacity,
      'hostName': hostName,
      'numOfParticipants': numOfParticipants,
    };
  }
}
