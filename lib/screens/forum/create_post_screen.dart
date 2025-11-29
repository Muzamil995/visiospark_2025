import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../providers/forum_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = [
    'General',
    'Questions',
    'Discussion',
    'Announcements',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate()) return;

    final forumProvider = context.read<ForumProvider>();
    final post = await forumProvider.createPost(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _selectedCategory,
    );

    if (post != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else if (mounted && forumProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(forumProvider.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final forumProvider = context.watch<ForumProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: forumProvider.isLoading ? null : _createPost,
            child: const Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter a descriptive title',
                validator: (value) => Validators.required(value, 'Title'),
                maxLength: 100,
              ),
              const SizedBox(height: 16),
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
                  setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _contentController,
                label: 'Content',
                hint: 'Write your post content...',
                validator: (value) => Validators.required(value, 'Content'),
                maxLines: 10,
                maxLength: 5000,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Create Post',
                onPressed: _createPost,
                isLoading: forumProvider.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
