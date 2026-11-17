import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/charts.dart';

/// Modo TV: tela escura, números grandes, troca de painel a cada 25 s.
/// Esc sai. Setas trocam de painel. Use F11 para tela cheia no navegador.
class TvPage extends StatefulWidget {
  const TvPage({super.key});

  @override
  State<TvPage> createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  static const _intervalo = 25;
  int _i = 0;
  int _left = _intervalo;
  DateTime _now = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
        _left--;
        if (_left <= 0) _ir(_i + 1);
      });
    });
  }

  void _ir(int n) {
    _i = (n % tvSlides.length + tvSlides.length) % tvSlides.length;
    _left = _intervalo;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static Color _cor(String kind) {
    switch (kind) {
      case 'ok':
        return const Color(0xFF5FD39A);
      case 'warn':
        return const Color(0xFFF2B84B);
      case 'bad':
        return const Color(0xFFFF7A70);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = tvSlides[_i];
    final width = MediaQuery.sizeOf(context).width;
    final k = (width / 1600).clamp(0.5, 1.6).toDouble();
    final wide = width >= 900;
    return Focus(
      autofocus: true,
      onKeyEvent: (node, e) {
        if (e is! KeyDownEvent) return KeyEventResult.ignored;
        if (e.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).maybePop();
          return KeyEventResult.handled;
        }
        if (e.logicalKey == LogicalKeyboardKey.arrowRight) {
          setState(() => _ir(_i + 1));
          return KeyEventResult.handled;
        }
        if (e.logicalKey == LogicalKeyboardKey.arrowLeft) {
          setState(() => _ir(_i - 1));
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: AppColors.tvBg,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(28 * k),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(s, k),
                SizedBox(height: 16 * k),
                _tabs(k),
                SizedBox(height: 20 * k),
                if (wide) ...[
                  _cards(s, k, true),
                  SizedBox(height: 20 * k),
                  Expanded(child: _lower(s, k, true)),
                ] else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        _cards(s, k, false),
                        SizedBox(height: 20 * k),
                        _lower(s, k, false),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(TvSlide s, double k) {
    final hora = '${two(_now.hour)}:${two(_now.minute)}:${two(_now.second)}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('SEMOB · Painel de Operação',
                style: TextStyle(color: const Color(0xFF9FB0D9), fontSize: 15 * k, fontWeight: FontWeight.w600)),
            SizedBox(height: 4 * k),
            Text(s.titulo, style: TextStyle(color: Colors.white, fontSize: 34 * k, fontWeight: FontWeight.w800)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(hora, style: TextStyle(color: Colors.white, fontSize: 34 * k, fontWeight: FontWeight.w800)),
          Text('${fmtDate(_now)} · $kDadosAteTv',
              style: TextStyle(color: const Color(0xFF9FB0D9), fontSize: 13 * k)),
        ]),
        SizedBox(width: 14 * k),
        IconButton(
          tooltip: 'Sair do Modo TV (Esc)',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.close, color: Colors.white, size: 26 * k.clamp(0.8, 1.4).toDouble()),
        ),
      ],
    );
  }

  Widget _tabs(double k) {
    return Row(
      children: [
        for (var i = 0; i < tvSlides.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == tvSlides.length - 1 ? 0 : 10 * k),
              child: InkWell(
                onTap: () => setState(() => _ir(i)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tvSlides[i].nome,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: i == _i ? Colors.white : const Color(0xFF6F82B5),
                          fontSize: 14 * k,
                          fontWeight: i == _i ? FontWeight.w800 : FontWeight.w500)),
                  SizedBox(height: 6 * k),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: i == _i ? (_intervalo - _left) / _intervalo : (i < _i ? 1.0 : 0.0),
                      minHeight: 4 * k.clamp(0.8, 1.5).toDouble(),
                      backgroundColor: AppColors.tvLine,
                      color: i == _i ? Colors.white : const Color(0xFF4A5E94),
                    ),
                  ),
                ]),
              ),
            ),
          ),
      ],
    );
  }

  Widget _cards(TvSlide s, double k, bool wide) {
    Widget card(TvCard c) => Container(
          padding: EdgeInsets.all(18 * k),
          decoration: BoxDecoration(
            color: AppColors.tvCard,
            borderRadius: BorderRadius.circular(14 * k),
            border: Border.all(color: AppColors.tvLine),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.label, style: TextStyle(color: const Color(0xFF9FB0D9), fontSize: 15 * k, fontWeight: FontWeight.w600)),
            SizedBox(height: 8 * k),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(c.value, style: TextStyle(color: _cor(c.kind), fontSize: 46 * k, fontWeight: FontWeight.w800)),
            ),
            SizedBox(height: 6 * k),
            Text(c.sub, style: TextStyle(color: const Color(0xFF9FB0D9), fontSize: 13 * k)),
          ]),
        );
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < s.cards.length; i++) ...[
            if (i > 0) SizedBox(width: 14 * k),
            Expanded(child: card(s.cards[i])),
          ],
        ],
      );
    }
    return LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 12) / 2;
      return Wrap(spacing: 12, runSpacing: 12, children: [
        for (final it in s.cards) SizedBox(width: w, child: card(it)),
      ]);
    });
  }

  Widget _lower(TvSlide s, double k, bool wide) {
    final labels = [
      for (var i = 0; i < 42; i++) fmtDay(DateTime(2026, 8, 4 + i)),
    ];
    final chart = Container(
      padding: EdgeInsets.all(18 * k),
      decoration: BoxDecoration(
        color: AppColors.tvCard,
        borderRadius: BorderRadius.circular(14 * k),
        border: Border.all(color: AppColors.tvLine),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.graficoTitulo, style: TextStyle(color: Colors.white, fontSize: 17 * k, fontWeight: FontWeight.w700)),
        SizedBox(height: 2 * k),
        Text(s.legenda, style: TextStyle(color: const Color(0xFF9FB0D9), fontSize: 12.5 * k)),
        SizedBox(height: 10 * k),
        if (wide)
          Expanded(
            child: LayoutBuilder(builder: (context, c) {
              return LineChart(
                dark: true,
                height: c.maxHeight,
                series: [Series(tvSerie(s.seed, s.base), const Color(0xFF7FA8FF), fill: true)],
                xLabels: labels,
              );
            }),
          )
        else
          LineChart(
            dark: true,
            height: 240,
            series: [Series(tvSerie(s.seed, s.base), const Color(0xFF7FA8FF), fill: true)],
            xLabels: labels,
          ),
      ]),
    );
    final alertas = Container(
      padding: EdgeInsets.all(18 * k),
      decoration: BoxDecoration(
        color: AppColors.tvCard,
        borderRadius: BorderRadius.circular(14 * k),
        border: Border.all(color: AppColors.tvLine),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Alertas', style: TextStyle(color: Colors.white, fontSize: 17 * k, fontWeight: FontWeight.w700)),
        SizedBox(height: 12 * k),
        for (final a in s.alertas)
          Padding(
            padding: EdgeInsets.only(bottom: 12 * k),
            child: IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(width: 4 * k.clamp(0.8, 1.5).toDouble(), color: _cor(a.kind)),
                SizedBox(width: 12 * k),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a.title, style: TextStyle(color: Colors.white, fontSize: 16 * k, fontWeight: FontWeight.w700)),
                    Text(a.text, style: TextStyle(color: const Color(0xFF9FB0D9), fontSize: 14 * k)),
                  ]),
                ),
              ]),
            ),
          ),
      ]),
    );
    if (wide) {
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(flex: 3, child: chart),
        SizedBox(width: 16 * k),
        Expanded(flex: 2, child: alertas),
      ]);
    }
    return Column(children: [chart, SizedBox(height: 16 * k), alertas]);
  }
}

const kDadosAteTv = 'Dados até 14/09/2026';
