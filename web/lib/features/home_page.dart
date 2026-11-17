import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/app_shell.dart';
import '../shared/charts.dart';
import '../shared/ui.dart';

/// Visão geral.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ultimos = demandaDiaria.length > 20 ? demandaDiaria.sublist(demandaDiaria.length - 20) : demandaDiaria;
    return AppShell(
      route: '/visao-geral',
      title: 'Visão geral',
      actions: [
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pushNamed('/tv'),
          icon: const Icon(Icons.tv_outlined, size: 18),
          label: const Text('Modo TV'),
        ),
      ],
      child: Column(
        children: [
          KpiGrid(kpisVisaoGeral, minWidth: 200),
          const SizedBox(height: 16),
          Cols(
            flex: const [3, 2],
            children: [
              SectionBox(
                title: 'Passageiros por dia útil',
                subtitle: 'Últimos 20 dias úteis, em milhares',
                child: LineChart(
                  series: [Series([for (final p in ultimos) p.total], AppColors.sidebar, fill: true)],
                  xLabels: [for (final p in ultimos) fmtDay(p.date)],
                  minY: 30,
                  maxY: 50,
                  yFormat: (v) => fmtInt(v),
                ),
              ),
              SectionBox(
                title: 'Conferência dos dados',
                subtitle: 'Regras aplicadas aos relatórios do período',
                trailing: const Tag('5 de 6', kind: 'warn'),
                child: Column(
                  children: [
                    for (final r in regrasResumo)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.check_circle, size: 18, color: AppColors.ok),
                          const SizedBox(width: 10),
                          Expanded(child: cellText(r)),
                        ]),
                      ),
                    const Divider(height: 22),
                    const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.schedule, size: 18, color: AppColors.warn),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('Pendente: faltam passageiros de 01 a 14/07',
                            style: TextStyle(fontSize: 13.5, color: AppColors.warn, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}