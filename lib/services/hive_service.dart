import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  static const String _pendingWritesBox = 'pendingWrites';
  static const String _cachedProfileBox = 'cachedProfile';
  static const String _cachedStreakBox = 'cachedStreak';
  static const String _draftJournalBox = 'draftJournal';
  static const String _settingsBox = 'settings';

  static late Box _pendingWrites;
  static late Box _cachedProfile;
  static late Box _cachedStreak;
  static late Box<String> _draftJournal;
  static late Box _settings;

  static Future<void> init() async {
    await Hive.initFlutter();

    _pendingWrites = await Hive.openBox(_pendingWritesBox);
    _cachedProfile = await Hive.openBox(_cachedProfileBox);
    _cachedStreak = await Hive.openBox(_cachedStreakBox);
    _draftJournal = await Hive.openBox<String>(_draftJournalBox);
    _settings = await Hive.openBox(_settingsBox);
  }

  // Draft journal
  static String? getDraftJournal() => _draftJournal.get('current');
  static Future<void> saveDraftJournal(String content) =>
      _draftJournal.put('current', content);
  static Future<void> clearDraftJournal() =>
      _draftJournal.delete('current');

  // Settings
  static T? getSetting<T>(String key) => _settings.get(key) as T?;
  static Future<void> saveSetting(String key, dynamic value) =>
      _settings.put(key, value);

  // Pending writes queue
  static List<Map> getPendingWrites() =>
      _pendingWrites.values.cast<Map>().toList();

  static Future<void> addPendingWrite(Map<String, dynamic> operation) async {
    await _pendingWrites.add(operation);
  }

  static Future<void> clearPendingWrites() async {
    await _pendingWrites.clear();
  }

  // Profile cache
  static Map? getCachedProfile() =>
      _cachedProfile.get('data') as Map?;

  static Future<void> cacheProfile(Map<String, dynamic> data) =>
      _cachedProfile.put('data', data);

  // Streak cache
  static Map? getCachedStreak() =>
      _cachedStreak.get('data') as Map?;

  static Future<void> cacheStreak(Map<String, dynamic> data) =>
      _cachedStreak.put('data', data);

  static Future<void> close() async {
    await Hive.close();
  }
}
