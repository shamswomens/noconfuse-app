/// Groups a non-negative integer the Indian way: last 3 digits, then
/// pairs of 2 -- e.g. 7199900 -> "71,99,900".
String _indianGroup(int amount) {
  final s = amount.toString();
  if (s.length <= 3) return s;
  final last3 = s.substring(s.length - 3);
  final rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  var i = rest.length;
  while (i > 2) {
    parts.insert(0, rest.substring(i - 2, i));
    i -= 2;
  }
  if (i > 0) parts.insert(0, rest.substring(0, i));
  return "${parts.join(',')},$last3";
}

String fmtRupees(int amount) => "\u20b9${_indianGroup(amount)}";

String fmtReviews(int n) => _indianGroup(n);
