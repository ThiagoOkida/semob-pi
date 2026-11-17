import 'package:flutter/material.dart';
import '../core/theme.dart';

class NavItem {
  const NavItem(this.route, this.label, this.icon);
  final String route, label;
  final IconData icon;
}

const navItems = [
  NavItem('/visao-geral', 'Visão geral', Icons.dashboard_outlined),
  NavItem('/demanda', 'Demanda', Icons.groups_outlined),
  NavItem('/receita', 'Receita e créditos', Icons.payments_outlined),
  NavItem('/quilometragem', 'Quilometragem', Icons.route_outlined),
  NavItem('/ocorrencias', 'Ocorrências', Icons.warning_amber_rounded),
  NavItem('/conferencia', 'Conferência', Icons.fact_check_outlined),
  NavItem('/importacoes', 'Importações', Icons.upload_file_outlined),
  NavItem('/usuarios', 'Usuários', Icons.manage_accounts_outlined),
];

const kDadosAte = 'Dados até 14/09/2026';

/// Moldura comum às telas: menu lateral no desktop, gaveta no celular/tablet.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.route, required this.title, required this.child, this.actions = const []});
  final String route, title;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= Bp.desktop;
    final body = _Body(title: title, wide: wide, actions: actions, child: child);
    if (wide) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Row(children: [
          SizedBox(width: 248, child: _Sidebar(route: route, inDrawer: false)),
          Expanded(child: body),
        ]),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.sidebar,
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          IconButton(
            tooltip: 'Modo TV',
            icon: const Icon(Icons.tv_outlined),
            onPressed: () => Navigator.of(context).pushNamed('/tv'),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.sidebar,
        child: _Sidebar(route: route, inDrawer: true),
      ),
      body: body,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.title, required this.wide, required this.actions, required this.child});
  final String title;
  final bool wide;
  final List<Widget> actions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final pad = wide ? 28.0 : 16.0;
    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (wide)
                    Text(title,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.event_available_outlined, size: 15, color: AppColors.muted),
                      SizedBox(width: 6),
                      Text(kDadosAte, style: TextStyle(fontSize: 12.5, color: AppColors.muted, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                  ...actions,
                ],
              ),
              const SizedBox(height: 20),
              child,
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.route, required this.inDrawer});
  final String route;
  final bool inDrawer;

  void _go(BuildContext context, String r) {
    final nav = Navigator.of(context);
    if (inDrawer) nav.pop();
    if (r != route) nav.pushReplacementNamed(r);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebar,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 24, 22, 18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('SEMOB', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1)),
                SizedBox(height: 2),
                Text('Painel de Operação', style: TextStyle(color: Color(0xFFC9D4F0), fontSize: 12.5)),
              ]),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final it in navItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Material(
                        color: it.route == route ? Colors.white.withValues(alpha: 0.16) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _go(context, it.route),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                            child: Row(children: [
                              Icon(it.icon, size: 19, color: Colors.white),
                              const SizedBox(width: 12),
                              Text(it.label,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: it.route == route ? FontWeight.w800 : FontWeight.w500)),
                            ]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0x80FFFFFF)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (inDrawer) Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/tv');
                  },
                  icon: const Icon(Icons.tv_outlined, size: 18),
                  label: const Text('Modo TV', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 10, 14),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0x33FFFFFF)))),
              child: Row(children: [
                const CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.white,
                  child: Text('MP', style: TextStyle(color: AppColors.sidebar, fontWeight: FontWeight.w800, fontSize: 12)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Marcelo Pante', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    Text('Administrador', style: TextStyle(color: Color(0xFFC9D4F0), fontSize: 11.5)),
                  ]),
                ),
                IconButton(
                  tooltip: 'Sair',
                  icon: const Icon(Icons.logout, color: Colors.white, size: 19),
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
