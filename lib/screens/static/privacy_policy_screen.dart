import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              'Introduction',
              'Welcome to VisioSpark. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we handle your personal data and your privacy rights.',
            ),
            _buildSection(
              context,
              'Information We Collect',
              '''We collect information you provide directly to us, such as:
              
• Account information (name, email, password)
• Profile information (avatar, bio)
• Content you create (posts, comments, messages)
• Usage data and analytics
• Device information''',
            ),
            _buildSection(
              context,
              'How We Use Your Information',
              '''We use the information we collect to:

• Provide, maintain, and improve our services
• Send you technical notices and support messages
• Respond to your comments and questions
• Analyze usage patterns to enhance user experience
• Protect against fraud and abuse''',
            ),
            _buildSection(
              context,
              'Data Sharing',
              '''We do not sell your personal information. We may share your information only in the following circumstances:

• With your consent
• To comply with legal obligations
• To protect our rights and safety
• With service providers who assist our operations''',
            ),
            _buildSection(
              context,
              'Data Security',
              'We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction.',
            ),
            _buildSection(
              context,
              'Your Rights',
              '''You have the right to:

• Access your personal data
• Correct inaccurate data
• Delete your data
• Export your data
• Withdraw consent at any time''',
            ),
            _buildSection(
              context,
              'Data Retention',
              'We retain your personal data only for as long as necessary to fulfill the purposes for which it was collected, including legal, accounting, or reporting requirements.',
            ),
            _buildSection(
              context,
              'Cookies',
              'We use cookies and similar tracking technologies to track activity on our service and hold certain information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.',
            ),
            _buildSection(
              context,
              'Children\'s Privacy',
              'Our service is not intended for children under 13. We do not knowingly collect personal information from children under 13. If we discover that a child under 13 has provided us with personal information, we will delete it.',
            ),
            _buildSection(
              context,
              'Changes to This Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
            ),
            _buildSection(
              context,
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at privacy@visiospark.com',
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
