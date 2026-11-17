import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import '../shared/app_shell.dart';
import '../shared/ui.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final List<Usuario> _lista = usuariosIniciais();

  Future<void> _novo() async {
    final nome = TextEditingController();
    final email = TextEditingController();
    var admin = false;
    final criado = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Novo usuário'),
          content: SizedBox(
            width: 380,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome')),
              const SizedBox(height: 12),
              TextField(controller: email, decoration: const InputDecoration(labelText: 'E-mail')),
              const SizedBox(height: 14),
              Row(children: [
                ChoiceChip(label: const Text('Usuário'), selected: !admin, onSelected: (_) => setD(() => admin = false)),
                const SizedBox(width: 8),
                ChoiceChip(label: const Text('Administrador'), selected: admin, onSelected: (_) => setD(() => admin = true)),
              ]),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Criar')),
          ],
        ),
      ),
    );
    final n = nome.text.trim();
    final e = email.text.trim();
    nome.dispose();
    email.dispose();
    if (criado == true && n.isNotEmpty && e.isNotEmpty) {
      setState(() => _lista.add(Usuario(n, e, admin ? 'Administrador' : 'Usuário', true)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: '/usuarios',
      title: 'Usuários',
      actions: [
        FilledButton.icon(
          onPressed: _novo,
          icon: const Icon(Icons.person_add_alt, size: 18),
          label: const Text('Novo usuário'),
        ),
      ],
      child: SectionBox(
        title: 'Acesso ao painel',
        subtitle: 'Somente administradores veem esta tela. A regra é validada também no servidor.',
        child: DataTbl(
          minWidth: 680,
          headers: const ['Nome', 'E-mail', 'Perfil', 'Situação'],
          flex: const [4, 5, 3, 3],
          rows: [
            for (final u in _lista)
              [
                cellText(u.nome, bold: true),
                cellText(u.email, color: AppColors.muted),
                Tag(u.perfil, kind: u.perfil == 'Administrador' ? 'ok' : 'neutral'),
                Tag(u.ativo ? 'Ativo' : 'Desativado', kind: u.ativo ? 'ok' : 'bad'),
              ],
          ],
        ),
      ),
    );
  }
}