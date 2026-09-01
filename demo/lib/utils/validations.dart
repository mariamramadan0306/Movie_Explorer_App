String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Name field is required";
  }
  if (value.length < 3) {
    return "name must be at least 3 characters";
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Email field is required";
  }
  final emailRegex = RegExp(r'^[^@\s]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(value.trim())) {
    return "Invalid Email Format";
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Password field is required";
  }
  if (value.trim().length < 6) {
    return "Password Must be at least 6 chars";
  }
  return null;
}
