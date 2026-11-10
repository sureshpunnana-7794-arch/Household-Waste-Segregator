import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class AuthSheet extends StatefulWidget {
  const AuthSheet({super.key});

  @override
  State<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<AuthSheet> {
  bool isLogin = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    if (email.isEmpty || pass.length < 6) {
      setState(() => error = 'Please enter a valid email and 6+ char password');
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    final s = FirebaseService.instance;
    final res = isLogin
        ? await s.signInWithEmail(email, pass)
        : await s.signUpWithEmail(email, pass);

    if (mounted) {
      if (res != null) {
        setState(() {
          error = res;
          loading = false;
        });
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isLogin ? 'Welcome back!' : 'Account registered!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = FirebaseService.instance;
    final user = s.currentUser;

    if (user != null && !user.isAnonymous) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF174C38),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.email ?? 'Eco Warrior',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            s.isFirebaseReady
                                ? Icons.cloud_done_rounded
                                : Icons.offline_bolt_rounded,
                            size: 14,
                            color: const Color(0xFF35A879),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            s.isFirebaseReady
                                ? 'Firebase Cloud Synced'
                                : 'Local Storage Mode',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF7D9187),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.stars_rounded, color: Color(0xFFB78128)),
              title: const Text('Eco Points Balance'),
              trailing: Text(
                '${s.cachedPoints} pts',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () async {
                await s.signOut();
                if (context.mounted) Navigator.pop(context);
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.energy_savings_leaf_rounded,
                  color: Color(0xFF174C38),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLogin ? 'Sign In to EcoSort' : 'Create EcoSort Account',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Sync your waste tracking across devices',
                    style: TextStyle(fontSize: 11, color: Color(0xFF7D9187)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (error != null)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                error!,
                style: TextStyle(color: Colors.red.shade900, fontSize: 12),
              ),
            ),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password (min 6 characters)',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: loading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF174C38),
              ),
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(isLogin ? 'Sign In' : 'Create Account'),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin
                    ? "Don't have an account? Sign up"
                    : 'Already registered? Sign in',
                style: const TextStyle(color: Color(0xFF174C38)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
