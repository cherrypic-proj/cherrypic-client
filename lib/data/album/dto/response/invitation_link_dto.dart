class InvitationLinkDto {
  final String invitationLink;

  InvitationLinkDto({required this.invitationLink});

  factory InvitationLinkDto.fromJson(Map<String, dynamic> json) {
    return InvitationLinkDto(invitationLink: json['invitationLink'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'invitationLink': invitationLink};
  }
}
