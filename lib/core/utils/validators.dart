class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    if (value.trim().length > 30) return 'Name must be 30 characters or fewer';
    return null;
  }

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? number(String? value, {double? min, double? max, String fieldName = 'Value'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return '$fieldName must be a number';
    if (min != null && parsed < min) return '$fieldName must be at least $min';
    if (max != null && parsed > max) return '$fieldName must be at most $max';
    return null;
  }

  static String? trackerName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Tracker name is required';
    if (value.trim().length > 30) return 'Name must be 30 characters or fewer';
    return null;
  }
}
