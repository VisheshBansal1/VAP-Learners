extension ListDeepContains on List<String> {
  bool deepContains(String term) {
    final query = term.toLowerCase().trim();
    if (query.isEmpty) return false;

    return any(
      (element) => element.toLowerCase().contains(query),
    );
  }
}
