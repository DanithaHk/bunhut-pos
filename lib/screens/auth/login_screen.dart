import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading        = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      AppAlert.show(
        context,
        message: "Please fill all fields correctly",
        type: AlertType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      if (mounted) {
        AppAlert.show(
          context,
          message: "Login successful",
          type: AlertType.success,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        AppAlert.show(
          context,
          message: _mapAuthError(e.code),
          type: AlertType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        AppAlert.show(
          context,
          message: "Something went wrong. Try again.",
          type: AlertType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // ── Logo / Brand ──────────────────────────
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20, offset: const Offset(0, 8),
                        )],
                      ),
                      child: const Icon(Icons.storefront_outlined,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 28),

                    const Text('Welcome back',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
                            color: AppColors.text, letterSpacing: -0.6)),
                    const SizedBox(height: 6),
                    const Text('Sign in to continue to BunHut POS',
                        style: TextStyle(fontSize: 14.5, color: AppColors.textSec)),
                    const SizedBox(height: 36),


                    // ── Email field ────────────────────────────
                    _label('Email'),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      style: const TextStyle(fontSize: 15, color: AppColors.text),
                      decoration: _inputDecoration(
                        hint: 'you@bunhut.com',
                        icon: Icons.mail_outline,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        final pattern = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
                        if (!pattern.hasMatch(v.trim())) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Password field ─────────────────────────
                    _label('Password'),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      style: const TextStyle(fontSize: 15, color: AppColors.text),
                      decoration: _inputDecoration(
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        suffix: GestureDetector(
                          onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSec, size: 19,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'Minimum 6 characters';
                        return null;
                      },
                      onFieldSubmitted: (_) => _login(),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading ? null : () {
                          // TODO: hook up forgot-password flow
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8)),
                        child: const Text('Forgot password?',
                            style: TextStyle(fontSize: 12.5, color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Login button ────────────────────────────
                    GestureDetector(
                      onTap: _isLoading ? null : _login,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isLoading
                                ? [AppColors.primary.withOpacity(0.6),
                              AppColors.primaryDark.withOpacity(0.6)]
                                : [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 16, offset: const Offset(0, 8),
                          )],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.4, color: Colors.white),
                          )
                              : const Text('Log In',
                              style: TextStyle(fontSize: 15.5,
                                  fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ),
                    ),

                    const Spacer(),
                    const SizedBox(height: 20),

                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an account?  ",
                          style: const TextStyle(fontSize: 13, color: AppColors.textSec),
                          children: [
                            TextSpan(
                              text: 'Contact Admin',
                              style: const TextStyle(fontSize: 13,
                                  color: AppColors.primary, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: AppColors.textSec, letterSpacing: 0.2)),
  );

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textTer, fontSize: 14.5),
    prefixIcon: Icon(icon, color: AppColors.textSec, size: 19),
    suffixIcon: suffix != null
        ? Padding(padding: const EdgeInsets.only(right: 14), child: suffix)
        : null,
    filled: true, fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(vertical: 14),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.expense)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.expense, width: 1.5)),
  );
}