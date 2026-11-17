import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/app_shell.dart';
import '../shared/ui.dart';

class QuilometragemPage extends StatelessWidget {
  const QuilometragemPage({super.key});

  @override
  Widget build(BuildContext context) {
    var tv = 0;
    var tk = 0.0;
    var maxKm = 0.0;
    for (final l in linhasKm) {
      tv += l.viagens;
      tk += l.km;
      if (l.km > maxKm) maxKm = l.km;
    }
    return AppShell(
      route: '/quilometragem',
      title: 'Quilometragem',
      child: Column(
        children: [
          KpiGrid(kpisKm, minWidth: 220),
          const SizedBox(height: 16),
          SectionBox(
            title: 'Quilometragem por linha',
            subtitle: 'Agosto de 2026',
            child: DataTbl(
              minWidth: 760,
              headers: const ['Linha', 'Nome', 'Viagens', 'Km produtivo', 'Km por viagem', ''],
              flex: const [1, 5, 2, 2, 2, 3],
              alignRight: const {2, 3, 4},
              rows: [
                for (final l in linhasKm)
                  [
                    cellText(l.code, bold: true),
                    cellText(l.nome),
                    cellText(fmtInt(l.viagens)),
                    cellText(fmtDec(l.km)),
                    cellText(fmtDec(l.km / l.viagens, 2), color: AppColors.muted),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: l.km / maxKm,
                          minHeight: 8,
                          backgroundColor: AppColors.head,
                          color: AppColors.sidebar,
                        ),
                      ),
                    ),
                  ],
                [
                  cellText(''),
                  cellText('Total', bold: true),
                  cellText(fmtInt(tv), bold: true),
                  cellText(fmtDec(tk), bold: true),
                  cellText(fmtDec(tk / tv, 2), bold: true),
                  cellText(''),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}