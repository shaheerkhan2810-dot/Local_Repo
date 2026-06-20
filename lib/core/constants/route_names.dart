class RouteNames {
  RouteNames._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  static const String home = '/home';
  static const String streak = '/streak';

  static const String trackers = '/trackers';
  static const String trackerNew = '/trackers/new';
  static String trackerDetail(String id) => '/trackers/$id';
  static String trackerEdit(String id) => '/trackers/$id/edit';
  static String trackerEntry(String id) => '/trackers/$id/entry';

  static const String tasks = '/tasks';

  static const String challenges = '/challenges';
  static String challengeDetail(String id) => '/challenges/$id';

  static const String journal = '/journal';
  static const String journalNew = '/journal/new';
  static String journalEntry(String id) => '/journal/$id';

  static const String analytics = '/analytics';
  static const String routine = '/routine';
  static const String profile = '/profile';
}
