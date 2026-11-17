import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/mock.dart';

/// Blocos reutilizáveis de interface.

class Box extends StatelessWidget {
  const Box({super.key, required this.child, this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}

class SectionBox extends StatelessWidget {
  const SectionBox({super.key, required this.title, required this.child, this.subtitle, this.trailing});
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(subtitle!, style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  const Tag(this.text, {super.key, this.kind = 'neutral'});
  final String text;
  final String kind; // ok | warn | bad | neutral

  @override
  Widget build(BuildContext context) {
    late Color bg, fg;
    switch (kind) {
      case 'ok':
        bg = AppColors.okBg;
        fg = AppColors.ok;
        break;
      case 'warn':
        bg = AppColors.warnBg;
        fg = AppColors.warn;
        break;
      case 'bad':
        bg = AppColors.badBg;
        fg = AppColors.bad;
        break;
      default:
        bg = AppColors.head;
        fg = AppColors.muted;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 11.5, fontWeight: FontWeight.w700)),
    );
  }
}

class KpiCard extends StatelessWidget {
  const KpiCard(this.k, {super.key});
  final Kpi k;

  @override
  Widget build(BuildContext context) {
    return Box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(k.label,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.muted)),
              ),
              const SizedBox(width: 6),
              Tag(k.conferido ? 'Conferido' : 'Estimado', kind: k.conferido ? 'ok' : 'neutral'),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 6,
            children: [
              Text(k.value,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.ink)),
              if (k.unit != null)
                Text(k.unit!, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
              if (k.of != null) Text(k.of!, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 6),
          Text(k.sub, style: const TextStyle(fontSize: 12, color: AppColors.muted, height: 1.35)),
        ],
      ),
    );
  }
}

/// Grade de KPIs que se ajusta à largura disponível.
class KpiGrid extends StatelessWidget {
  const KpiGrid(this.items, {super.key, this.minWidth = 210});
  final List<Kpi> items;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      const gap = 14.0;
      var cols = (c.maxWidth / minWidth).floor();
      cols = max(1, min(cols, items.length));
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final k in items) SizedBox(width: w, child: KpiCard(k))],
      );
    });
  }
}

/// Colunas lado a lado no desktop, empilhadas no celular/tablet.
class Cols extends StatelessWidget {
  const Cols({super.key, required this.children, this.flex});
  final List<Widget> children;
  final List<int>? flex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth >= Bp.desktop - 260) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              Expanded(flex: flex == null ? 1 : flex![i], child: children[i]),
            ],
          ],
        );
      }
      return Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            children[i],
          ],
        ],
      );
    });
  }
}

class Legend extends StatelessWidget {
  const Legend(this.items, {super.key, this.dark = false});
  final List<(Color, String)> items;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        for (final it in items)
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: it.$1, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 6),
            Text(it.$2,
                style: TextStyle(fontSize: 12, color: dark ? const Color(0xFF9FB0D9) : AppColors.muted)),
          ]),
      ],
    );
  }
}

Widget cellText(String s, {bool bold = false, Color? color, double size = 13.5}) => Text(
      s,
      style: TextStyle(
        fontSize: size,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        color: color ?? AppColors.ink,
      ),
    );

/// Tabela simples; rola na horizontal quando a tela é estreita.
class DataTbl extends StatelessWidget {
  const DataTbl({
    super.key,
    required this.headers,
    required this.rows,
    required this.flex,
    this.minWidth = 640,
    this.alignRight = const {},
  });
  final List<String> headers;
  final List<List<Widget>> rows;
  final List<int> flex;
  final double minWidth;
  final Set<int> alignRight;

  Widget _row(List<Widget> cells, {Color? bg, bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: bg,
        border: last ? null : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < flex.length; i++)
            Expanded(
              flex: flex[i],
              child: Align(
                alignment: alignRight.contains(i) ? Alignment.centerRight : Alignment.centerLeft,
                child: cells[i],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = max(c.maxWidth, minWidth);
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: w,
          child: Column(
            children: [
              _row(
                [
                  for (final h in headers)
                    Text(h.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: .4)),
                ],
                bg: AppColors.head,
              ),
              for (var i = 0; i < rows.length; i++) _row(rows[i], last: i == rows.length - 1),
            ],
          ),
        ),
      );
    });
  }
}
