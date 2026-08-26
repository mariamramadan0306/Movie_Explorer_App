String getInitials(String fullName) {
  List<String> names = fullName.trim().split(RegExp(r'\s+'));

  String initials = names.length >= 2
      ? "${names.first[0]}${names.last[0]}"
      : names.first[0];
  return initials.toUpperCase();
}
