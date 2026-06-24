import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_auth_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _createUserFormKey = GlobalKey<FormState>();
  final _passwordFormKey   = GlobalKey<FormState>();

  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  String _selectedRole = 'cashier';
  bool _isProcessing = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  /// Dispatches secondary registration workflow via current Auth Provider
  void _handleCreateUser() async {
    if (!_createUserFormKey.currentState!.validate()) return;
    setState(() => _isProcessing = true);

    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
      await authProvider.registerNewUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole,
      );

      _emailController.clear();
      _passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff user deployed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deployment Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// Dispatches core text mutation instructions to active profile
  void _handleChangePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() => _isProcessing = true);

    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
      await authProvider.changeCurrentPassword(_newPasswordController.text.trim());
      _newPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password Update Failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Account Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── SECTION 1: PASSWORD MODIFICATION (Available to both roles) ──
            const Text('Change Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text)),
            const SizedBox(height: 10),
            Form(
              key: _passwordFormKey,
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.border)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(labelText: 'New Secret Password', hintText: '••••••••'),
                        validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _isProcessing ? null : _handleChangePassword,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Text('Update Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── SECTION 2: ADMINISTRATIVE STAFF CREATION (Admin Only) ──
            if (authProvider.isAdmin) ...[
              const Text('Provision New System User', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text)),
              const SizedBox(height: 10),
              Form(
                key: _createUserFormKey,
                child: Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.border)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(labelText: 'Email Address', hintText: 'cashier@bunhut.com'),
                          validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid structural email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(labelText: 'Assigned Initial Password', hintText: '••••••••'),
                          validator: (v) => (v == null || v.length < 6) ? 'Minimum length is 6 characters' : null,
                        ),
                        const SizedBox(height: 16),
                        const Text('System Permission Role', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSec)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Cashier', style: TextStyle(fontSize: 13)),
                                value: 'cashier',
                                activeColor: AppColors.primary,
                                contentPadding: EdgeInsets.zero,
                                groupValue: _selectedRole,
                                onChanged: (val) => setState(() => _selectedRole = val!),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Admin', style: TextStyle(fontSize: 13)),
                                value: 'admin',
                                activeColor: AppColors.primary,
                                contentPadding: EdgeInsets.zero,
                                groupValue: _selectedRole,
                                onChanged: (val) => setState(() => _selectedRole = val!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: _isProcessing ? null : _handleCreateUser,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(color: AppColors.primaryDark, borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: _isProcessing
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Deploy User Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}