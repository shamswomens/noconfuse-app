import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  final bool initialLogin;
  const AuthScreen({super.key, this.initialLogin = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isLogin = widget.initialLogin;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _busy = false;

  Future<void> _submit() async {
    final appState = context.read<AppState>();
    setState(() {
      _error = null;
      _busy = true;
    });
    String? error;
    if (isLogin) {
      error = await appState.login(_emailController.text, _passwordController.text);
    } else {
      error = await appState.register(
          _nameController.text, _emailController.text, _passwordController.text);
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (error == null) {
      Navigator.pop(context);
    } else {
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(child: _tabButton("Sign in", isLogin, () => setState(() => isLogin = true))),
                  Expanded(child: _tabButton("Create account", !isLogin, () => setState(() => isLogin = false))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!isLogin) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full name", hintText: "Your name"),
              ),
              const SizedBox(height: 14),
            ],
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email", hintText: "you@example.com"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password", hintText: "At least 4 characters"),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12.5)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isLogin ? "Sign in" : "Create account"),
            ),
            const SizedBox(height: 12),
            const Text(
              "This demo stores your account locally on this device — no data leaves your phone.",
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppColors.textMuted)),
      ),
    );
  }
}
