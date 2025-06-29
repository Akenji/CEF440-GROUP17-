class ValidationService {
  // Admin codes for different levels
  static const Map<String, String> _adminCodes = {
    'ADMIN2024SYSTEM': 'system',
    'ADMIN2024DEPT': 'department',
    'ADMIN2024FACULTY': 'faculty',
  };

  static bool isValidAdminCode(String code) {
    return _adminCodes.containsKey(code.toUpperCase());
  }

  static String getAdminLevel(String code) {
    return _adminCodes[code.toUpperCase()] ?? 'department';
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-$$$$]{10,}$').hasMatch(phone);
  }

  static bool isValidMatricule(String matricule) {
    return matricule.length >= 6 && RegExp(r'^[A-Z0-9]+$').hasMatch(matricule.toUpperCase());
  }

  static bool isValidEmployeeId(String employeeId) {
    return employeeId.length >= 4 && RegExp(r'^[A-Z0-9]+$').hasMatch(employeeId.toUpperCase());
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (!isValidPassword(value)) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty && !isValidPhone(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateMatricule(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your matricule';
    }
    if (!isValidMatricule(value)) {
      return 'Matricule must be at least 6 characters and contain only letters and numbers';
    }
    return null;
  }

  static String? validateEmployeeId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your employee ID';
    }
    if (!isValidEmployeeId(value)) {
      return 'Employee ID must be at least 4 characters and contain only letters and numbers';
    }
    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a year';
    }
    final year = int.tryParse(value);
    if (year == null || year < 2000 || year > DateTime.now().year + 1) {
      return 'Please enter a valid year';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
}
