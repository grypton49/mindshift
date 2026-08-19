import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindshift/data/models/player_profile.dart';
import 'package:mindshift/data/repositories/profile_repository.dart';

void main() {
  test('fresh profile has sensible defaults', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = ProfileRepository(await SharedPreferences.getInstance());
    final profile = repo.load();
    expect(profile.name, 'Explorer');
    expect(kAvatarChoices, contains(profile.avatar));
  });

  test('profile save/load round-trips and is independent of other data',
      () async {
    SharedPreferences.setMockInitialValues({
      // Pretend progress data is already stored under its own keys.
      'mindshift.solvedIds': ['tigers-and-sheep'],
    });
    final prefs = await SharedPreferences.getInstance();
    final repo = ProfileRepository(prefs);

    await repo.save(const PlayerProfile(name: 'Ada', avatar: '🦉'));
    final loaded = ProfileRepository(prefs).load();
    expect(loaded.name, 'Ada');
    expect(loaded.avatar, '🦉');

    // Saving the profile didn't disturb the unrelated progress keys.
    expect(prefs.getStringList('mindshift.solvedIds'), ['tigers-and-sheep']);
  });
}
