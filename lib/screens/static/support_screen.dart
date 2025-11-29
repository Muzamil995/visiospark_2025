import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'General';
  bool _isLoading = false;

  final List<String> _categories = [
    'General',
    'Bug Report',
    'Feature Request',
    'Account Issue',
    'Billing',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Support ticket submitted successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),

            _buildQuickHelp(context),
            const SizedBox(height: 32),

            _buildFAQ(context),
            const SizedBox(height: 32),

            _buildContactForm(context),
            const SizedBox(height: 32),

            _buildContactInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How can we help?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'re here to help you with any questions or issues.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.support_agent,
            size: 60,
            color: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHelp(BuildContext context) {
    final quickHelp = [
      {'icon': Icons.book_outlined, 'title': 'Documentation', 'subtitle': 'Read our guides'},
      {'icon': Icons.video_library_outlined, 'title': 'Tutorials', 'subtitle': 'Watch videos'},
      {'icon': Icons.chat_outlined, 'title': 'Live Chat', 'subtitle': 'Chat with us'},
      {'icon': Icons.email_outlined, 'title': 'Email', 'subtitle': 'Send us a message'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Help',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: quickHelp.length,
          itemBuilder: (context, index) {
            final item = quickHelp[index];
            return Card(
              child: InkWell(
                onTap: () {
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        item['subtitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFAQ(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I reset my password?',
        'answer': 'Go to the login screen and tap "Forgot Password". Enter your email and follow the instructions sent to your inbox.',
      },
      {
        'question': 'How do I change my profile picture?',
        'answer': 'Navigate to Profile > Edit Profile and tap on your avatar to upload a new image.',
      },
      {
        'question': 'Is my data secure?',
        'answer': 'Yes, we use industry-standard encryption and security measures to protect your data. Read our Privacy Policy for more details.',
      },
      {
        'question': 'How do I contact support?',
        'answer': 'You can use the contact form below or email us directly at support@visiospark.com.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: ExpansionPanelList.radio(
            elevation: 0,
            children: faqs.asMap().entries.map((entry) {
              final faq = entry.value;
              return ExpansionPanelRadio(
                value: entry.key,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(faq['answer']!),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Submit a Ticket',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value!);
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _subjectController,
                    label: 'Subject',
                    hint: 'Brief description of your issue',
                    prefixIcon: Icons.subject,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _messageController,
                    label: 'Message',
                    hint: 'Describe your issue in detail...',
                    prefixIcon: Icons.message_outlined,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your message';
                      }
                      if (value.length < 20) {
                        return 'Please provide more details (at least 20 characters)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Submit Ticket',
                    onPressed: _submitTicket,
                    isLoading: _isLoading,
                    icon: Icons.send,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other Ways to Reach Us',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.email, color: AppColors.primary),
                ),
                title: const Text('Email'),
                subtitle: const Text('support@visiospark.com'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.phone, color: AppColors.primary),
                ),
                title: const Text('Phone'),
                subtitle: const Text('+1 (555) 123-4567'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.chat_bubble, color: AppColors.primary),
                ),
                title: const Text('Social Media'),
                subtitle: const Text('@visiospark'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
