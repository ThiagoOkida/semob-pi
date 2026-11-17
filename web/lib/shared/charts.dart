import 'dart:math';
import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme.dart';

/// Gráficos desenhados com CustomPaint (sem pacotes externos).

class Series {
  const Series(this.values, this.color, {this.fill = false});
  final List<double> values;
  final Color color;
  final bool fill;
}

class BarGroup {
  const BarGroup(this.label, this.values, {this.color});
  final String label;
  final List<double> values;
  final Color? color; // cor única (sobrepõe a paleta)
}

const _tvText = Color(0xFF9FB0D9);

double _niceStep(double span, int ticks) {
  if (span <= 0) return 1;
  final raw = span / ticks;
  final mag = pow(10, (log(raw) / ln10).floor()).toDouble();
  final n = raw / mag;
  final double f = n <= 1 ? 1 : (n <= 2 ? 2 : (n <= 2.5 ? 2.5 : (n <= 5 ? 5 : 10)));
  return f * mag;
}

String _defY(double v) => v == v.roundToDouble() ? fmtInt(v) : fmtDec(v, 1);

void _text(Canvas c, String s, Offset o,
    {Color color = AppColors.muted,
    double size = 11,
    TextAlign align = TextAlign.left,
    FontWeight w = FontWeight.w400}) {
  final tp = TextPainter(
    text: TextSpan(text: s, style: TextStyle(color: color, fontSize: size, fontWeight: w)),
    textDirection: TextDirection.ltr,
  )..layout();
  var dx = o.dx;
  if (align == TextAlign.right) {
    dx -= tp.width;
  } else if (align == TextAlign.center) {
    dx -= tp.width / 2;
  }
  tp.paint(c, Offset(dx, o.dy));
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.series,
    required this.xLabels,
    this.height = 220,
    this.minY,
    this.maxY,
    this.yFormat,
    this.dark = false,
  });
  final List<Series> series;
  final List<String> xLabels;
  final double height;
  final double? minY, maxY;
  final String Function(double)? yFormat;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _LinePainter(this)),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.c);
  final LineChart c;

  @override
  void paint(Canvas canvas, Size size) {
    const l = 52.0, r = 8.0, t = 8.0, b = 24.0;
    final w = size.width - l - r;
    final h = size.height - t - b;
    if (w <= 0 || h <= 0 || c.series.isEmpty) return;
    final n = c.series.first.values.length;
    if (n == 0) return;
    var dataMax = 0.0;
    for (final s in c.series) {
      for (final v in s.values) {
        if (v > dataMax) dataMax = v;
      }
    }
    final lo = c.minY ?? 0.0;
    final hi = c.maxY ?? dataMax;
    final step = _niceStep(hi - lo, 4);
    final top = lo + ((hi - lo) / step).ceil() * step;
    final span = top - lo;
    final txt = c.dark ? _tvText : AppColors.muted;
    final grid = Paint()
      ..color = c.dark ? AppColors.tvLine : AppColors.line
      ..strokeWidth = 1;
    final fy = c.yFormat ?? _defY;
    for (var v = lo; v <= top + step * 0.001; v += step) {
      final y = t + h - (v - lo) / span * h;
      canvas.drawLine(Offset(l, y), Offset(l + w, y), grid);
      _text(canvas, fy(v), Offset(l - 6, y - 7), align: TextAlign.right, color: txt);
    }
    double xAt(int i) => n == 1 ? l + w / 2 : l + w * i / (n - 1);
    double yAt(double v) => t + h - ((v - lo) / span).clamp(0.0, 1.0) * h;
    for (final s in c.series) {
      final path = Path();
      for (var i = 0; i < s.values.length; i++) {
        final p = Offset(xAt(i), yAt(s.values[i]));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      if (s.fill) {
        final area = Path.from(path)
          ..lineTo(xAt(s.values.length - 1), t + h)
          ..lineTo(xAt(0), t + h)
          ..close();
        canvas.drawPath(area, Paint()..color = s.color.withValues(alpha: 0.14));
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = s.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..strokeJoin = StrokeJoin.round,
      );
    }
    final every = max(1, (c.xLabels.length / 6).ceil());
    for (var i = 0; i < c.xLabels.length && i < n; i += every) {
      _text(canvas, c.xLabels[i], Offset(xAt(i), t + h + 6), align: TextAlign.center, color: txt);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.groups,
    this.colors = const [AppColors.sidebar],
    this.height = 220,
    this.showValues = false,
    this.yFormat,
    this.valueFormat,
    this.minY,
  });
  final List<BarGroup> groups;
  final List<Color> colors;
  final double height;
  final bool showValues;
  final String Function(double)? yFormat;
  final String Function(double)? valueFormat;
  final double? minY;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _BarPainter(this)),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.c);
  final BarChart c;

  @override
  void paint(Canvas canvas, Size size) {
    const l = 52.0, r = 8.0, t = 18.0, b = 24.0;
    final w = size.width - l - r;
    final h = size.height - t - b;
    final n = c.groups.length;
    if (w <= 0 || h <= 0 || n == 0) return;
    double total(BarGroup g) => g.values.fold(0.0, (a, v) => a + v);
    var dataMax = 0.0;
    for (final g in c.groups) {
      dataMax = max(dataMax, total(g));
    }
    final lo = c.minY ?? 0.0;
    final step = _niceStep(dataMax - lo, 4);
    final top = lo + ((dataMax - lo) / step).ceil() * step;
    final span = top - lo;
    final grid = Paint()
      ..color = AppColors.line
      ..strokeWidth = 1;
    final fy = c.yFormat ?? _defY;
    for (var v = lo; v <= top + step * 0.001; v += step) {
      final y = t + h - (v - lo) / span * h;
      canvas.drawLine(Offset(l, y), Offset(l + w, y), grid);
      _text(canvas, fy(v), Offset(l - 6, y - 7), align: TextAlign.right);
    }
    final slot = w / n;
    final bw = min(slot * 0.62, 56.0);
    final every = max(1, (n / 8).ceil());
    for (var i = 0; i < n; i++) {
      final g = c.groups[i];
      final cx = l + slot * i + slot / 2;
      var acc = lo;
      for (var j = 0; j < g.values.length; j++) {
        final y0 = t + h - (acc - lo) / span * h;
        acc += g.values[j];
        final y1 = t + h - (acc - lo) / span * h;
        final col = g.color ?? c.colors[j % c.colors.length];
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(cx - bw / 2, min(y0, y1), cx + bw / 2, max(y0, y1)),
            topLeft: j == g.values.length - 1 ? const Radius.circular(3) : Radius.zero,
            topRight: j == g.values.length - 1 ? const Radius.circular(3) : Radius.zero,
          ),
          Paint()..color = col,
        );
      }
      if (c.showValues) {
        final y = t + h - (acc - lo) / span * h;
        final vf = c.valueFormat ?? _defY;
        _text(canvas, vf(total(g)), Offset(cx, y - 15),
            align: TextAlign.center, color: AppColors.ink, size: 11, w: FontWeight.w700);
      }
      if (i % every == 0) {
        _text(canvas, g.label, Offset(cx, t + h + 6), align: TextAlign.center);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
