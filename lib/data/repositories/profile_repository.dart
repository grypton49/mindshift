import 'package:shared_preferences/shared_preferences.dart';

import '../models/player_profile.dart';

/// Persists the [PlayerProfile] to [SharedPreferences]. Profile keys are separate
/// from progress and puzzle-pack keys, so refetching content never touches it.
class ProfileRepository {
  ProfileRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kName = 'mindshift.profile.name';
  static const _kAvatar = 'mindshift.profile.avatar';

  PlayerProfile load() {
    return PlayerProfile(
      name: _prefs.getString(_kName) ?? 'Explorer',
      avatar: _prefs.getString(_kAvatar) ?? '🦊',
    );
  }

  Future<void> save(PlayerProfile profile) async {
    await _prefs.setString(_kName, profile.name);
    await _prefs.setString(_kAvatar, profile.avatar);
  }
}
