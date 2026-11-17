import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/app_shell.dart';
import '../shared/charts.dart';
import '../shared/ui.dart';

class DemandaPage extends StatelessWidget {
  const DemandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    const total = 236165.0;
    const partes = [
      ('Catraca (pagantes)', 43780.0, AppColors.paid, '18,5%'),
      ('Antecipados (créditos)', 17485.0, Color(0xFF8FB8BD), '7,4%'),
      ('Gratuidades', 174900.0, AppColors.free, '74,1%'),
    ];
    return AppShell(
      route: '/demanda',
      title: 'Demanda',
      child: Column(
        children: [
          SectionBox(
            title: 'Composição dos passageiros',
            subtitle: 'Semana de 01 a 07/09 · total ${fmtInt(total)}',
            child: Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 16,
                  child: Row(children: [
                    for (final p in partes) Expanded(flex: p.$2.round(), child: Container(color: p.$3)),
                  ]),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(spacing: 28, runSpacing: 10, children: [
                for (final p in partes)
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: p.$3, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    cellText(p.$1, color: AppColors.muted),
                    const SizedBox(width: 8),
                    cellText(fmtInt(p.$2), bold: true),
                    const SizedBox(width: 6),
                    cellText(p.$4, color: AppColors.muted),
                  ]),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          SectionBox(
            title: 'Passageiros por dia útil',
            subtitle: 'Total, gratuidades e pagantes, em milhares',
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Legend(const [
                (AppColors.total, 'Total'),
                (AppColors.free, 'Gratuidades'),
                (AppColors.paid, 'Pagantes'),
              ]),
              const SizedBox(height: 10),
              LineChart(
                height: 260,
                series: [
                  Series([for (final p in demandaDiaria) p.total], AppColors.total),
                  Series([for (final p in demandaDiaria) p.free], AppColors.free),
                  Series([for (final p in demandaDiaria) p.paid], AppColors.paid),
                ],
                xLabels: [for (final p in demandaDiaria) fmtDay(p.date)],
                yFormat: (v) => fmtInt(v),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Cols(
            flex: const [3, 2],
            children: [
              SectionBox(
                title: 'Mesma quinta-feira, semana a semana',
                subtitle: 'Passageiros totais',
                child: BarChart(
                  height: 240,
                  showValues: true,
                  valueFormat: (v) => fmtInt(v),
                  yFormat: (v) => fmtInt(v),
                  groups: [
                    for (final q in compararQuintas)
                      BarGroup(q.$1, [q.$2.toDouble()],
                          color: q.$1 == '10/09' ? AppColors.bad : AppColors.sidebar),
                  ],
                ),
              ),
              const SectionBox(
                title: 'Leitura',
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Tag('Atenção', kind: 'bad'),
                  SizedBox(height: 10),
                  Text('Quinta-feira, 10/09, teve 39.479 passageiros: 14,5% abaixo da mediana das quintas anteriores (46.149).',
                      style: TextStyle(fontSize: 14, height: 1.45, color: AppColors.ink)),
                  SizedBox(height: 10),
                  Text('Confira a tela de Ocorrências para ver se houve viagens não realizadas no dia.',
                      style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}