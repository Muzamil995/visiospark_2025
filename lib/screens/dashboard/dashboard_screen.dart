import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cards/stat_card.dart';
import '../../widgets/charts/bar_chart_widget.dart';
import '../../widgets/charts/line_chart_widget.dart';
import '../../widgets/charts/pie_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(user?.fullName ?? 'User'),
              const SizedBox(height: 32),

              _buildStatsGrid(),
              const SizedBox(height: 24),

              _buildActivityChart(),
              const SizedBox(height: 24),

              _buildDistributionSection(),
              const SizedBox(height: 24),

              _buildProgressChart(),
              const SizedBox(height: 24),

              _buildQuickActions(),
              const SizedBox(height: 24),

              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(String name) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = 'Good Morning';
      icon = Icons.wb_sunny_outlined;
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      icon = Icons.wb_sunny;
    } else {
      greeting = 'Good Evening';
      icon = Icons.nights_stay_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      greeting,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ready to be productive today?',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.rocket_launch,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {
        'title': 'Total Posts',
        'value': '24',
        'icon': Icons.article,
        'color': AppColors.primary,
      },
      {
        'title': 'Messages',
        'value': '156',
        'icon': Icons.message,
        'color': AppColors.success,
      },
      {
        'title': 'AI Queries',
        'value': '42',
        'icon': Icons.smart_toy,
        'color': AppColors.warning,
      },
      {
        'title': 'Connections',
        'value': '18',
        'icon': Icons.people,
        'color': AppColors.info,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return StatCard(
          title: stat['title'] as String,
          value: stat['value'] as String,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
        );
      },
    );
  }

  Widget _buildActivityChart() {
    final data = [
      BarChartData(label: 'Mon', value: 12),
      BarChartData(label: 'Tue', value: 19),
      BarChartData(label: 'Wed', value: 8),
      BarChartData(label: 'Thu', value: 15),
      BarChartData(label: 'Fri', value: 22),
      BarChartData(label: 'Sat', value: 10),
      BarChartData(label: 'Sun', value: 5),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChartWidget(data: data, barColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionSection() {
    final data = [
      PieChartData(label: 'Posts', value: 35, color: AppColors.primary),
      PieChartData(label: 'Chats', value: 45, color: AppColors.success),
      PieChartData(label: 'AI', value: 20, color: AppColors.warning),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: PieChartWidget(data: data)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    final data = [
      LineChartData(label: 'Week 1', value: 10),
      LineChartData(label: 'Week 2', value: 25),
      LineChartData(label: 'Week 3', value: 18),
      LineChartData(label: 'Week 4', value: 35),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChartWidget(data: data, lineColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'New Post',
                Icons.add_circle_outline,
                AppColors.primary,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Start Chat',
                Icons.chat_bubble_outline,
                AppColors.success,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Ask AI',
                Icons.smart_toy_outlined,
                AppColors.warning,
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': 'Posted a new question',
        'time': '2 hours ago',
        'icon': Icons.article,
      },
      {
        'title': 'Received 5 upvotes',
        'time': '4 hours ago',
        'icon': Icons.thumb_up,
      },
      {
        'title': 'Started a conversation',
        'time': 'Yesterday',
        'icon': Icons.chat,
      },
      {
        'title': 'AI generated a summary',
        'time': 'Yesterday',
        'icon': Icons.smart_toy,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(onPressed: () {}, child: const Text('See All')),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(activity['title'] as String),
                subtitle: Text(activity['time'] as String),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
