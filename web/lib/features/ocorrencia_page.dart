import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/app_shell.dart';
import '../shared/ui.dart';

class OcorrenciaPage extends StatelessWidget {
  const OcorrenciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final naoReal = ocorrencias.where((o) => o.situacao == 'Não realizada').length;
    final naoTerm = ocorrencias.length - naoReal;
    final porLinha = <String, int>{};
    for (final o in ocorrencias) {
      porLinha[o.linha] = (porLinha[o.linha] ?? 0) + 1;
    }
    final ordem = porLinha.keys.toList()..sort((a, b) => porLinha[b]!.compareTo(porLinha[a]!));
    return AppShell(
      route: '/ocorrencias',
      title: 'Ocorrências',
      child: Column(
        children: [
          KpiGrid([
            Kpi('Viagens com ocorrência', '${ocorrencias.length}', 'No período importado'),
            Kpi('Não realizadas', '$naoReal', 'Viagem programada que não saiu'),
            Kpi('Não terminadas', '$naoTerm', 'Viagem iniciada e interrompida'),
          ], minWidth: 220),
          const SizedBox(height: 16),
          Cols(
            flex: const [3, 1],
            children: [
              SectionBox(
                title: 'Viagens com ocorrência',
                subtitle: 'Mais recentes primeiro',
                child: DataTbl(
                  minWidth: 620,
                  headers: const ['Data', 'Linha', 'Horário', 'Situação'],
                  flex: const [2, 5, 2, 3],
                  rows: [
                    for (final o in ocorrencias)
                      [
                        cellText(o.data),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          cellText(o.linha, bold: true),
                          const SizedBox(width: 8),
                          Flexible(child: cellText(o.nome)),
                        ]),
                        cellText(o.horario),
                        Tag(o.situacao, kind: o.situacao == 'Não realizada' ? 'bad' : 'warn'),
                      ],
                  ],
                ),
              ),
              SectionBox(
                title: 'Por linha',
                child: Column(
                  children: [
                    for (final l in ordem)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(children: [
                          cellText('Linha $l', bold: true),
                          const Spacer(),
                          cellText('${porLinha[l]} viagens', color: AppColors.muted),
                        ]),
                      ),
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