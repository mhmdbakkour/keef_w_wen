class RegistrationValidator {
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Minimum 8 characters, at least one letter and one number
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  static bool isValidUsername(String username) {
    // Letters, numbers, underscores, 3-20 characters
    final regex = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9_]{3,20}$');
    return regex.hasMatch(username);
  }

  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static Map<String, String?> validateRegistration({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
  }) {
    return {
      'email': isValidEmail(email) ? null : 'Invalid email format.',
      'password':
          isValidPassword(password)
              ? null
              : 'Password must be at least 8 characters long and include a letter and a number.',
      'confirmPassword':
          doPasswordsMatch(password, confirmPassword)
              ? null
              : 'Passwords do not match.',
      'username':
          isValidUsername(username)
              ? null
              : 'Username must be 3-20 characters long and can include letters, numbers, and underscores.',
    };
  }
}
