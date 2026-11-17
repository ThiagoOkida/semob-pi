import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/app_shell.dart';
import '../shared/ui.dart';

class ImportacaoPage extends StatefulWidget {
  const ImportacaoPage({super.key});

  @override
  State<ImportacaoPage> createState() => _ImportacaoPageState();
}

class _ImportacaoPageState extends State<ImportacaoPage> {
  final List<ImportacaoItem> _itens = importacoesIniciais();

  void _decidir(ImportacaoItem it, String nova) {
    setState(() {
      it.situacao = nova;
      it.por = 'Você';
    });
  }

  @override
  Widget build(BuildContext context) {
    final pend = _itens.where((i) => i.situacao == 'Pendente').length;
    return AppShell(
      route: '/importacoes',
      title: 'Importações',
      actions: [
        FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('O envio de relatórios entra junto com o back-end.')),
          ),
          icon: const Icon(Icons.upload_file, size: 18),
          label: const Text('Importar relatório'),
        ),
      ],
      child: SectionBox(
        title: 'Relatórios importados',
        subtitle: '$pend aguardando aprovação',
        child: DataTbl(
          minWidth: 900,
          headers: const ['Arquivo', 'Tipo', 'Período', 'Registros', 'Situação', 'Ação'],
          flex: const [6, 3, 3, 2, 2, 3],
          alignRight: const {3},
          rows: [
            for (final it in _itens)
              [
                cellText(it.arquivo, bold: true, size: 13),
                cellText(it.tipo),
                cellText(it.periodo),
                cellText(it.registros),
                Tag(it.situacao,
                    kind: it.situacao == 'Aprovada' ? 'ok' : (it.situacao == 'Rejeitada' ? 'bad' : 'warn')),
                it.situacao == 'Pendente'
                    ? Row(mainAxisSize: MainAxisSize.min, children: [
                        TextButton(onPressed: () => _decidir(it, 'Aprovada'), child: const Text('Aprovar')),
                        TextButton(
                          onPressed: () => _decidir(it, 'Rejeitada'),
                          style: TextButton.styleFrom(foregroundColor: AppColors.bad),
                          child: const Text('Rejeitar'),
                        ),
                      ])
                    : cellText(it.por ?? '', color: AppColors.muted, size: 12.5),
              ],
          ],
        ),
      ),
    );
  }
}