/// Formatação no padrão brasileiro (sem depender do pacote intl).
String fmtInt(num v) {
  final neg = v < 0;
  final s = v.abs().round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return (neg ? '-' : '') + b.toString();
}

String fmtDec(num v, [int d = 1]) {
  final s = v.abs().toStringAsFixed(d);
  final parts = s.split('.');
  final intPart = fmtInt(int.parse(parts[0]));
  final out = d > 0 ? '$intPart,${parts[1]}' : intPart;
  return v < 0 ? '-$out' : out;
}

String two(int n) => n.toString().padLeft(2, '0');
String fmtDay(DateTime d) => '${two(d.day)}/${two(d.month)}';
String fmtDate(DateTime d) => '${two(d.day)}/${two(d.month)}/${d.year}';
