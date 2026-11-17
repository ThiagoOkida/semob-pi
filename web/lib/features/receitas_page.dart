import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/app_shell.dart';
import '../shared/charts.dart';
import '../shared/ui.dart';

class ReceitasPage extends StatelessWidget {
  const ReceitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inicio = DateTime(2026, 7, 15);
    return AppShell(
      route: '/receita',
      title: 'Receita e créditos',
      child: Column(
        children: [
          KpiGrid(kpisReceita, minWidth: 220),
          const SizedBox(height: 16),
          SectionBox(
            title: 'Receita por dia',
            subtitle: 'Catraca estimada e venda antecipada, em milhares de reais',
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Legend(const [
                (AppColors.paid, 'Catraca (estimada)'),
                (AppColors.free, 'Venda antecipada'),
              ]),
              const SizedBox(height: 10),
              BarChart(
                height: 260,
                colors: const [AppColors.paid, AppColors.free],
                groups: [
                  for (final d in receitaDiaria) BarGroup(fmtDay(d.date), [d.catraca, d.antecipada]),
                ],
                yFormat: (v) => 'R\$ ${fmtInt(v)} mil',
              ),
            ]),
          ),
          const SizedBox(height: 16),
          SectionBox(
            title: 'Crédito circulante',
            subtitle: 'Saldo de créditos em poder dos passageiros, de 15/07 a 14/09, em milhares de reais',
            trailing: const Tag('Alerta acima de 90 dias de uso', kind: 'warn'),
            child: LineChart(
              height: 240,
              series: [Series(creditoCirculante, AppColors.sidebar, fill: true)],
              xLabels: [
                for (var i = 0; i < creditoCirculante.length; i++)
                  fmtDay(DateTime(inicio.year, inicio.month, inicio.day + i)),
              ],
              yFormat: (v) => fmtInt(v),
            ),
          ),
        ],
      ),
    );
  }
}