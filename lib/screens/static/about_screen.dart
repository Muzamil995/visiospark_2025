import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'VisioSpark',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'VisioSpark is a comprehensive hackathon template designed to help developers quickly build feature-rich applications with modern technologies.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            _buildFeaturesList(context),
            const SizedBox(height: 32),

            _buildTechStack(context),
            const SizedBox(height: 32),

            _buildCredits(context),
            const SizedBox(height: 32),

            Text(
              ' 2025 VisioSpark Team',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Made with love for hackathons',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final features = [
      {'icon': Icons.person, 'title': 'User Authentication'},
      {'icon': Icons.chat, 'title': 'Real-time Chat'},
      {'icon': Icons.forum, 'title': 'Community Forum'},
      {'icon': Icons.smart_toy, 'title': 'AI Assistant'},
      {'icon': Icons.dark_mode, 'title': 'Dark Mode Support'},
      {'icon': Icons.cloud_upload, 'title': 'File Storage'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: features.map((feature) {
            return Chip(
              avatar: Icon(
                feature['icon'] as IconData,
                size: 18,
                color: AppColors.primary,
              ),
              label: Text(feature['title'] as String),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTechStack(BuildContext context) {
    final techStack = [
      'Flutter',
      'Dart',
      'Supabase',
      'Provider',
      'Gemini AI',
      'PostgreSQL',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Built With',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: techStack.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tech,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCredits(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Development Team',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(Icons.code, color: AppColors.primary),
              ),
              title: const Text('Hackathon Team'),
              subtitle: const Text('Full Stack Development'),
            ),
          ],
        ),
      ),
    );
  }
}
