class AppValidators {
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  static String? Function(String?) required(String message) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }

  static String? Function(String?) email(String message) {
    return (String? value) {
      final email = value?.trim() ?? '';
      if (email.isEmpty) return null;
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return message;
      }
      return null;
    };
  }
}
