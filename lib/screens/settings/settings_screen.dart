import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/confirmation_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Appearance'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: AppColors.primary,
                  ),
                  title: const Text('Dark Mode'),
                  subtitle: Text(isDark ? 'On' : 'Off'),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (_) => themeProvider.toggleTheme(),
                    activeColor: AppColors.primary,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Theme Color'),
                  subtitle: const Text('Primary'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Theme customization coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive push notifications'),
                  value: true,
                  onChanged: (value) {
                  },
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.email_outlined),
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive email updates'),
                  value: true,
                  onChanged: (value) {
                  },
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.chat_outlined),
                  title: const Text('Chat Notifications'),
                  subtitle: const Text('New message alerts'),
                  value: true,
                  onChanged: (value) {
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Privacy & Security'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppConstants.changePasswordRoute,
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint),
                  title: const Text('Biometric Login'),
                  subtitle: const Text('Use fingerprint or face ID'),
                  value: false,
                  onChanged: (value) {
                  },
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.devices),
                  title: const Text('Active Sessions'),
                  subtitle: const Text('Manage your active sessions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Support'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help Center'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, AppConstants.supportRoute);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('Report a Bug'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: const Text('Send Feedback'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, AppConstants.aboutRoute);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppConstants.privacyPolicyRoute,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, AppConstants.termsRoute);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: const Text('Version'),
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(color: AppColors.gray500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Account'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.logout, color: AppColors.warning),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: AppColors.warning),
                  ),
                  onTap: () => _showLogoutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: AppColors.error),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        confirmText: 'Logout',
        confirmColor: AppColors.warning,
        onConfirm: () {
          context.read<AuthProvider>().signOut();
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppConstants.loginRoute,
            (route) => false,
          );
        },
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Account',
        message:
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        confirmText: 'Delete',
        confirmColor: AppColors.error,
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deletion feature coming soon'),
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
