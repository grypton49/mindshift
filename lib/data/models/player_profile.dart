/// The local player identity. Stored on-device (no account); survives app
/// restarts and pack refetches. See [ProfileRepository].
class PlayerProfile {
  const PlayerProfile({this.name = 'Explorer', this.avatar = '🦊'});

  final String name;

  /// An emoji used as the avatar. One of [kAvatarChoices].
  final String avatar;

  PlayerProfile copyWith({String? name, String? avatar}) =>
      PlayerProfile(name: name ?? this.name, avatar: avatar ?? this.avatar);
}

/// The avatar emojis a player can choose from on the profile screen.
const List<String> kAvatarChoices = [
  '🦊', '🦉', '🐢', '🐙', '🦄', '🐝', '🦔', '🐧',
  '🌱', '🌟', '🔮', '🧩', '🧠', '🚀', '🎯', '🍀',
];
