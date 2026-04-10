// Step 3: Utility class for form validation logic
class ValidationUtils {
  // Validates that email is not empty and has basic format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // Basic email format check using contains
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address';
    }
    return null; // null means valid
  }

  // Validates that password is not empty
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Validates that full name is not empty
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  // Validates that confirm password matches the original password
  static String? validateConfirmPassword(String? value, String original) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }
}