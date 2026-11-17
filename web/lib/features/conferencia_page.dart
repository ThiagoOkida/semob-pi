import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/app_shell.dart';
import '../shared/ui.dart';

class ConferenciaPage extends StatelessWidget {
  const ConferenciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ok = regrasConferencia.where((r) => !r.pendente).length;
    return AppShell(
      route: '/conferencia',
      title: 'Conferência',
      child: Column(
        children: [
          Box(
            child: Row(children: [
              const Icon(Icons.fact_check_outlined, size: 28, color: AppColors.sidebar),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$ok de ${regrasConferencia.length} regras conferidas',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  const SizedBox(height: 3),
                  const Text('Cada regra cruza dois ou mais relatórios para garantir que os números fecham.',
                      style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          SectionBox(
            title: 'Regras de conferência',
            child: Column(
              children: [
                for (var i = 0; i < regrasConferencia.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      border: i == regrasConferencia.length - 1
                          ? null
                          : const Border(bottom: BorderSide(color: AppColors.line)),
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(regrasConferencia[i].pendente ? Icons.schedule : Icons.check_circle,
                          size: 20,
                          color: regrasConferencia[i].pendente ? AppColors.warn : AppColors.ok),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          cellText(regrasConferencia[i].titulo, bold: true),
                          const SizedBox(height: 3),
                          cellText(regrasConferencia[i].detalhe, color: AppColors.muted, size: 12.5),
                        ]),
                      ),
                      const SizedBox(width: 10),
                      regrasConferencia[i].pendente
                          ? const Tag('PENDENTE', kind: 'warn')
                          : const Tag('CONFERIDO', kind: 'ok'),
                    ]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Box(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.info_outline, size: 19, color: AppColors.warn),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Uma regra pendente aguarda aprovação: faltam os passageiros de 01 a 14/07. '
                  'Os indicadores que dependem dela aparecem como "Estimado" no painel.',
                  style: TextStyle(fontSize: 13.5, height: 1.45, color: AppColors.ink),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}