import 'package:flutter/material.dart';
import '../core/theme.dart';

const _breakpoint = 900.0;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= _breakpoint;
    return Scaffold(
      body: Row(children: [
        if (wide) const Expanded(flex: 57, child: _BrandPanel()),
        const Expanded(flex: 43, child: _FormSide()),
      ]),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebar,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SEMOB',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Secretaria de Mobilidade Urbana · São Caetano do Sul',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: const Text('Painel de Operação do Transporte',
                style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w800, height: 1.15)),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: const Text('A operação da frota, conferida entre os relatórios da operadora antes de chegar à tela.',
                style: TextStyle(color: Colors.white, fontSize: 19, height: 1.5)),
          ),
          const SizedBox(height: 24),
          const _ResumoPill(),
          const Spacer(),
          const Text('Projeto Integrador TTI206 · Instituto Mauá de Tecnologia · 2026',
              style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ResumoPill extends StatelessWidget {
  const _ResumoPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: const Wrap(
        spacing: 14,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('236.165 passageiros de 08 a 14/09',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          _ConferidoBadge(),
        ],
      ),
    );
  }
}

class _ConferidoBadge extends StatelessWidget {
  const _ConferidoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.okBg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.ok),
      ),
      child: const Text.rich(TextSpan(children: [
        TextSpan(text: 'CONFERIDO', style: TextStyle(color: AppColors.ok, fontWeight: FontWeight.w700, fontSize: 11)),
        TextSpan(text: '  3 relatórios', style: TextStyle(color: AppColors.ok, fontSize: 10)),
      ])),
    );
  }
}

class _FormSide extends StatelessWidget {
  const _FormSide();

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < _breakpoint;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (narrow) ...const [
                Text('SEMOB',
                    style: TextStyle(color: AppColors.sidebar, fontSize: 22, fontWeight: FontWeight.w800)),
                SizedBox(height: 16),
              ],
              const _LoginCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatefulWidget {
  const _LoginCard();

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _esconder = true;
  bool _carregando = false;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _carregando = true);
    await Future.delayed(const Duration(milliseconds: 600)); // trocar pela chamada à API
    if (!mounted) return;
    setState(() => _carregando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados válidos. A navegação entra no próximo passo.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const small = TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4);
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Form(
        key: _form,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Entrar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          const Text('Use o e-mail cadastrado pelo administrador da SEMOB.',
              style: TextStyle(color: AppColors.muted, fontSize: 15)),
          const SizedBox(height: 24),
          const Text('E-mail', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(hintText: 'nome@semob.exemplo'),
            validator: (v) {
              final t = (v ?? '').trim();
              if (t.isEmpty) return 'Informe o e-mail.';
              if (!t.contains('@')) return 'Esse e-mail não parece válido.';
              return null;
            },
          ),
          const SizedBox(height: 20),
          const Text('Senha', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _senha,
            obscureText: _esconder,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => _entrar(),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                tooltip: _esconder ? 'Mostrar senha' : 'Ocultar senha',
                icon: Icon(_esconder ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                onPressed: () => setState(() => _esconder = !_esconder),
              ),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Informe a senha.' : null,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColors.sidebar,
            ),
            child: const Text('Esqueci minha senha', style: TextStyle(fontSize: 15)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _carregando ? null : _entrar,
              child: _carregando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Entrar'),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Não tem acesso? Peça ao administrador da SEMOB para criar seu usuário.', style: small),
          const SizedBox(height: 12),
          const Text.rich(
            TextSpan(style: small, children: [
              TextSpan(text: 'Acesso restrito à equipe da SEMOB. Dados tratados conforme a LGPD. '),
              TextSpan(text: 'Política de privacidade', style: TextStyle(color: AppColors.sidebar)),
            ]),
          ),
        ]),
      ),
    );
  }
}