import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../models/forum_model.dart';
import '../../providers/forum_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class EditPostScreen extends StatefulWidget {
  final ForumPostModel post;

  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  String? _selectedCategory;

  final List<String> _categories = [
    'General',
    'Questions',
    'Discussion',
    'Announcements',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    _selectedCategory = widget.post.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    if (!_formKey.currentState!.validate()) return;

    final forumProvider = context.read<ForumProvider>();
    final post = await forumProvider.updatePost(
      postId: widget.post.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _selectedCategory,
    );

    if (post != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post updated successfully'),
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
        title: const Text('Edit Post'),
        actions: [
          TextButton(
            onPressed: forumProvider.isLoading ? null : _updatePost,
            child: const Text('Save'),
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
                text: 'Update Post',
                onPressed: _updatePost,
                isLoading: forumProvider.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
