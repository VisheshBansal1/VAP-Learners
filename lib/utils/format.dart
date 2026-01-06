String fmtXp(int n) {
  final s = n.toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'),(m)=>',');
}