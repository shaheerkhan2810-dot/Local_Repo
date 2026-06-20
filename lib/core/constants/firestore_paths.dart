class FirestorePaths {
  FirestorePaths._();

  // Users
  static String users() => 'users';
  static String user(String uid) => 'users/$uid';

  // Main streak
  static String mainStreakDoc(String uid) => 'users/$uid/main_streak/current';

  // Relapses
  static String relapses(String uid) => 'users/$uid/relapses';
  static String relapse(String uid, String id) => 'users/$uid/relapses/$id';

  // Urge logs
  static String urgeLogs(String uid) => 'users/$uid/urge_logs';
  static String urgeLog(String uid, String id) => 'users/$uid/urge_logs/$id';

  // Custom trackers
  static String trackers(String uid) => 'users/$uid/trackers';
  static String tracker(String uid, String trackerId) =>
      'users/$uid/trackers/$trackerId';

  // Tracker entries
  static String trackerEntries(String uid, String trackerId) =>
      'users/$uid/trackers/$trackerId/entries';
  static String trackerEntry(String uid, String trackerId, String entryId) =>
      'users/$uid/trackers/$trackerId/entries/$entryId';

  // Tasks
  static String tasks(String uid) => 'users/$uid/tasks';
  static String task(String uid, String taskId) => 'users/$uid/tasks/$taskId';

  // Challenges (user progress)
  static String challenges(String uid) => 'users/$uid/challenges';
  static String challenge(String uid, String challengeId) =>
      'users/$uid/challenges/$challengeId';

  // Journal entries
  static String journalEntries(String uid) => 'users/$uid/journal_entries';
  static String journalEntry(String uid, String entryId) =>
      'users/$uid/journal_entries/$entryId';

  // Routine blocks
  static String routineBlocks(String uid) => 'users/$uid/routine_blocks';
  static String routineBlock(String uid, String blockId) =>
      'users/$uid/routine_blocks/$blockId';

  // Badges
  static String badges(String uid) => 'users/$uid/badges';
  static String badge(String uid, String badgeId) =>
      'users/$uid/badges/$badgeId';

  // Global (read-only for users)
  static String builtInChallenges() => 'built_in_challenges';
  static String builtInChallenge(String id) => 'built_in_challenges/$id';
}
