import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/password_text_field.dart';
import '../../widgets/common/confirmation_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.updatePassword(
      _newPasswordController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        await SuccessDialog.show(
          context,
          title: 'Password Changed',
          message: 'Your password has been updated successfully.',
        );
        if (mounted) Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Failed to change password'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.lock_outline,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Create a new password',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your new password must be at least 6 characters long.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PasswordTextField(
                controller: _newPasswordController,
                label: 'New Password',
                hint: 'Enter new password',
                validator: Validators.password,
                showStrengthIndicator: true,
              ),
              const SizedBox(height: 16),
              PasswordTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Confirm new password',
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Change Password',
                onPressed: _changePassword,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
