class AppConstants {
  AppConstants._();

  // Streak milestones in days
  static const List<int> streakMilestones = [1, 3, 7, 14, 30, 60, 90, 180, 365];

  // Milestone labels
  static const Map<int, String> milestoneLabels = {
    1: 'First Step',
    3: 'Rising',
    7: '7 Day Warrior',
    14: 'Two Weeks Strong',
    30: 'Iron Will',
    60: 'Steel Mind',
    90: 'Diamond Mind',
    180: 'Unbreakable',
    365: 'LEGEND',
  };

  static const Map<int, String> milestoneBadgeIds = {
    7: 'badge_7_warrior',
    30: 'badge_30_iron',
    60: 'badge_60_steel',
    90: 'badge_90_diamond',
    180: 'badge_180_unbreakable',
    365: 'badge_365_legend',
  };

  // XP per action
  static const int xpStreakDay = 10;
  static const int xpTaskComplete = 5;
  static const int xpJournalEntry = 8;
  static const int xpChallengeDay = 15;
  static const int xpTrackerEntry = 5;
  static const int xpMilestone7 = 100;
  static const int xpMilestone30 = 500;
  static const int xpMilestone90 = 1500;
  static const int xpMilestone180 = 3500;
  static const int xpMilestone365 = 10000;

  // Level XP thresholds (index = level number, value = XP required to reach it)
  static const List<int> levelThresholds = [
    0, 100, 250, 500, 900, 1500, 2500, 4000, 6000, 9000,
    13000, 18000, 25000, 34000, 45000, 60000, 78000, 100000,
  ];

  // Pomodoro defaults (minutes)
  static const int pomodoroWorkMinutes = 25;
  static const int pomodoroBreakMinutes = 5;
  static const int pomodoroLongBreak = 15;
  static const int pomodorosBeforeLongBreak = 4;

  // Tracker limits
  static const int maxTrackerFields = 20;
  static const int urgeMaxIntensity = 10;
  static const int maxJournalBackfillDays = 7;
  static const int maxTrackerEntryBackfillDays = 7;

  // Domains
  static const String domainDiscipline = 'discipline';
  static const String domainBody = 'body';
  static const String domainMind = 'mind';
  static const String domainWealth = 'wealth';

  static const List<String> allDomains = [
    domainDiscipline,
    domainBody,
    domainMind,
    domainWealth,
  ];

  static const Map<String, String> domainLabels = {
    domainDiscipline: 'Discipline',
    domainBody: 'Body',
    domainMind: 'Mind',
    domainWealth: 'Wealth',
  };

  static const Map<String, String> domainEmojis = {
    domainDiscipline: '⚡',
    domainBody: '💪',
    domainMind: '🧠',
    domainWealth: '💰',
  };

  // Tracker field types
  static const String fieldTypeNumber = 'number';
  static const String fieldTypeBoolean = 'boolean';
  static const String fieldTypeText = 'text';
  static const String fieldTypeScale = 'scale';
  static const String fieldTypeDuration = 'duration';
  static const String fieldTypeSelect = 'select';

  // Relapse trigger categories
  static const List<String> relapseTriggerCategories = [
    'Boredom',
    'Stress',
    'Loneliness',
    'Curiosity',
    'Late Night',
    'Social Media',
    'Other',
  ];

  // Coping tools
  static const List<Map<String, String>> copingTools = [
    {'id': 'breathe', 'label': 'Box Breathing', 'emoji': '🌬️'},
    {'id': 'cold_shower', 'label': 'Cold Shower', 'emoji': '🚿'},
    {'id': 'exercise', 'label': 'Exercise', 'emoji': '🏃'},
    {'id': 'journal', 'label': 'Journal', 'emoji': '✍️'},
    {'id': 'call', 'label': 'Call Someone', 'emoji': '📞'},
    {'id': 'grounding', 'label': '5-4-3-2-1 Grounding', 'emoji': '🌿'},
    {'id': 'read', 'label': 'Read', 'emoji': '📚'},
    {'id': 'meditate', 'label': 'Meditate', 'emoji': '🧘'},
  ];

  // Default tracker templates
  static const List<Map<String, dynamic>> defaultTrackerTemplates = [
    {
      'name': 'Gym',
      'emoji': '💪',
      'colorHex': '#1565C0',
      'domain': 'body',
      'description': 'Track your workouts and lifts',
    },
    {
      'name': 'Study',
      'emoji': '📚',
      'colorHex': '#00695C',
      'domain': 'mind',
      'description': 'Track your daily study sessions',
    },
    {
      'name': 'Work',
      'emoji': '💼',
      'colorHex': '#E65100',
      'domain': 'wealth',
      'description': 'Track your work hours and tasks',
    },
    {
      'name': 'Meditation',
      'emoji': '🧘',
      'colorHex': '#7B1FA2',
      'domain': 'mind',
      'description': 'Track your meditation practice',
    },
    {
      'name': 'Reading',
      'emoji': '📖',
      'colorHex': '#00695C',
      'domain': 'mind',
      'description': 'Track pages read per day',
    },
  ];

  // Motivational quotes for notifications
  static const List<String> motivationalQuotes = [
    "Every day you stay strong, you become more of who you were meant to be.",
    "Discipline is choosing between what you want now and what you want most.",
    "The man who wins is the man who thinks he can.",
    "Your future self is watching. Make him proud.",
    "Urges pass. Regret doesn't.",
    "You are not your urges. You are your choices.",
    "One day at a time. One choice at a time.",
    "Strength grows when everything else falls away.",
    "Control your mind or it will control you.",
    "Champions aren't born. They're built one day at a time.",
    "The pain of discipline is nothing compared to the pain of regret.",
    "Every warrior was once a man who decided enough was enough.",
    "Your streak is not just a number — it's proof of who you're becoming.",
    "Iron sharpens iron. Today, sharpen yourself.",
    "Silence the noise. Do the work.",
    "You've made it this far. Keep going.",
    "Mastery is built in the moments no one sees.",
    "Hard days build the strongest men.",
    "The forge is hot. Stay in it.",
    "Legacy is not what you leave behind — it's who you become.",
  ];

  // Built-in challenges
  static const List<Map<String, dynamic>> builtInChallenges = [
    {
      'id': 'nofap_30',
      'title': '30-Day NoFap',
      'description': 'Build unshakeable discipline with 30 days of complete abstinence.',
      'type': 'streak',
      'targetValue': 30,
      'durationDays': 30,
      'xpReward': 1500,
      'domain': 'discipline',
      'difficulty': 'hard',
      'iconEmoji': '🔥',
    },
    {
      'id': 'monk_mode_90',
      'title': '90-Day Monk Mode',
      'description': 'The legendary 90-day challenge. No PMO. Pure focus.',
      'type': 'streak',
      'targetValue': 90,
      'durationDays': 90,
      'xpReward': 5000,
      'domain': 'discipline',
      'difficulty': 'elite',
      'iconEmoji': '⚡',
    },
    {
      'id': 'gym_30',
      'title': 'Gym 30x in 30 Days',
      'description': 'Hit the gym every single day for a month.',
      'type': 'count',
      'targetValue': 30,
      'durationDays': 30,
      'xpReward': 1200,
      'domain': 'body',
      'difficulty': 'hard',
      'iconEmoji': '💪',
    },
    {
      'id': 'journal_30',
      'title': '30-Day Journal Streak',
      'description': 'Write in your journal every day for 30 days.',
      'type': 'streak',
      'targetValue': 30,
      'durationDays': 30,
      'xpReward': 800,
      'domain': 'mind',
      'difficulty': 'medium',
      'iconEmoji': '✍️',
    },
    {
      'id': 'meditate_21',
      'title': '21-Day Meditation',
      'description': 'Meditate every day for 21 days. Build the habit.',
      'type': 'streak',
      'targetValue': 21,
      'durationDays': 21,
      'xpReward': 600,
      'domain': 'mind',
      'difficulty': 'medium',
      'iconEmoji': '🧘',
    },
    {
      'id': 'reading_10',
      'title': '10 Books in 90 Days',
      'description': 'Read 10 books in 3 months. Invest in your mind.',
      'type': 'count',
      'targetValue': 10,
      'durationDays': 90,
      'xpReward': 1000,
      'domain': 'mind',
      'difficulty': 'medium',
      'iconEmoji': '📚',
    },
  ];
}
