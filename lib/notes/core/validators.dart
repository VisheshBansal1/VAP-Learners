class Validators {
  Validators._();

  // ---------------- NAME ----------------
  static String? nameValidator(String? name) {
    name = name?.trim() ?? '';

    if (name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z ]+$');
    if (!nameRegex.hasMatch(name)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // ---------------- EMAIL ----------------
  static String? emailValidator(String? email) {
    email = email?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // ---------------- PASSWORD ----------------
  static String? passwordValidator(String? password) {
    password = password ?? '';

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).+$',
    );

    if (!passwordRegex.hasMatch(password)) {
      return 'Password must contain uppercase, lowercase, number and symbol';
    }

    return null;
  }
}
