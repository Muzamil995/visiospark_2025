import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLastUpdated(context),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Acceptance of Terms',
              'By accessing and using VisioSpark, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use our service.',
            ),
            _buildSection(
              context,
              '2. Description of Service',
              'VisioSpark provides a platform for collaboration, communication, and content creation. Our services include but are not limited to user profiles, messaging, forums, AI assistance, and file sharing.',
            ),
            _buildSection(
              context,
              '3. User Accounts',
              '''To use certain features, you must register for an account. You agree to:

• Provide accurate and complete information
• Maintain the security of your password
• Accept responsibility for all activities under your account
• Notify us immediately of any unauthorized use

We reserve the right to suspend or terminate accounts that violate these terms.''',
            ),
            _buildSection(
              context,
              '4. User Content',
              '''You retain ownership of content you create. By posting content, you grant us a non-exclusive license to use, display, and distribute your content on our platform.

You agree not to post content that:
• Is illegal, harmful, or offensive
• Infringes intellectual property rights
• Contains malware or harmful code
• Violates others' privacy
• Is spam or misleading''',
            ),
            _buildSection(
              context,
              '5. Acceptable Use',
              '''You agree to use our service only for lawful purposes. Prohibited activities include:

• Harassment or abuse of other users
• Impersonation of others
• Interference with the service
• Circumventing security measures
• Commercial use without authorization
• Automated data collection without permission''',
            ),
            _buildSection(
              context,
              '6. Intellectual Property',
              'The service and its original content (excluding user content), features, and functionality are owned by VisioSpark and are protected by international copyright, trademark, and other intellectual property laws.',
            ),
            _buildSection(
              context,
              '7. AI Features',
              'Our AI features are provided "as is" without warranty. AI-generated content may not always be accurate. You are responsible for reviewing and verifying any AI-generated content before use.',
            ),
            _buildSection(
              context,
              '8. Privacy',
              'Your use of the service is also governed by our Privacy Policy. Please review our Privacy Policy to understand our practices.',
            ),
            _buildSection(
              context,
              '9. Disclaimers',
              '''THE SERVICE IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND. WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING:

• Merchantability
• Fitness for a particular purpose
• Non-infringement
• Uninterrupted or error-free service''',
            ),
            _buildSection(
              context,
              '10. Limitation of Liability',
              'To the maximum extent permitted by law, VisioSpark shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of the service.',
            ),
            _buildSection(
              context,
              '11. Termination',
              'We may terminate or suspend your account at any time, without prior notice, for conduct that we believe violates these terms or is harmful to other users, us, or third parties.',
            ),
            _buildSection(
              context,
              '12. Changes to Terms',
              'We reserve the right to modify these terms at any time. We will notify users of significant changes. Continued use of the service after changes constitutes acceptance of the new terms.',
            ),
            _buildSection(
              context,
              '13. Governing Law',
              'These terms shall be governed by the laws of the jurisdiction in which our company is registered, without regard to its conflict of law provisions.',
            ),
            _buildSection(
              context,
              '14. Contact',
              'For questions about these Terms of Service, please contact us at legal@visiospark.com',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.update, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            'Last Updated: January 2025',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}
