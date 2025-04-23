class Participant {
  final String username;
  final bool? isHost;
  final bool? isOwner;

  Participant({required this.username, this.isHost, this.isOwner});

  Participant copyWith({String? username, bool? isHost, bool? isOwner}) {
    return Participant(
      username: username ?? this.username,
      isHost: isHost ?? this.isHost,
      isOwner: isOwner ?? this.isOwner,
    );
  }
}
