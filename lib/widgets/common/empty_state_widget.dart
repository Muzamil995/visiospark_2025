import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.gray500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray500,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class NoDataWidget extends StatelessWidget {
  final String message;

  const NoDataWidget({
    super.key,
    this.message = 'No data available',
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: message,
      icon: Icons.inbox_outlined,
    );
  }
}

class NoSearchResultsWidget extends StatelessWidget {
  final String query;

  const NoSearchResultsWidget({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No results found',
      subtitle: 'No results found for "$query"',
      icon: Icons.search_off,
    );
  }
}
