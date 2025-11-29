import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/config/supabase_config.dart';
import '../../core/utils/helpers.dart';
import '../../models/forum_model.dart';
import '../../providers/forum_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/loading_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ForumProvider>().loadPost(widget.postId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final success = await context.read<ForumProvider>().addComment(
      postId: widget.postId,
      content: _commentController.text.trim(),
    );

    if (success && mounted) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final forumProvider = context.watch<ForumProvider>();
    final post = forumProvider.currentPost;

    if (forumProvider.isLoading && post == null) {
      return const Scaffold(body: LoadingWidget());
    }

    if (post == null) {
      return const Scaffold(body: Center(child: Text('Post not found')));
    }

    final isOwner = post.userId == SupabaseConfig.currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final navigator = Navigator.of(context);
                final provider = context.read<ForumProvider>();
                
                await navigator.pushNamed(
                  '/forum/edit',
                  arguments: post,
                );
                
                if (mounted) {
                  provider.loadPost(widget.postId);
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PostHeader(post: post),
                  const SizedBox(height: 16),
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  MarkdownBody(data: post.content),
                  const SizedBox(height: 16),
                  _VoteButtons(post: post),
                  const Divider(height: 32),
                  Text(
                    'Comments (${forumProvider.comments.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ...forumProvider.comments.map((comment) {
                    return _CommentCard(
                      comment: comment,
                      isPostAuthor: post.userId == SupabaseConfig.currentUserId,
                    );
                  }),
                  if (forumProvider.comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text('No comments yet. Be the first!'),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              color: AppColors.primary,
              onPressed: _addComment,
            ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final ForumPostModel post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            post.author?.initials ?? 'U',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author?.displayName ?? 'Unknown',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                Helpers.timeAgo(post.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray500,
                ),
              ),
            ],
          ),
        ),
        if (post.category != null)
          Chip(
            label: Text(post.category!),
            labelStyle: const TextStyle(fontSize: 10),
          ),
      ],
    );
  }
}

class _VoteButtons extends StatelessWidget {
  final ForumPostModel post;

  const _VoteButtons({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_upward,
            color: post.userVote == 1 ? AppColors.success : AppColors.gray500,
          ),
          onPressed: () {
            context.read<ForumProvider>().voteOnPost(post.id, true);
          },
        ),
        Text(
          post.score.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: post.score > 0
                ? AppColors.success
                : post.score < 0
                    ? AppColors.error
                    : AppColors.gray500,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_downward,
            color: post.userVote == -1 ? AppColors.error : AppColors.gray500,
          ),
          onPressed: () {
            context.read<ForumProvider>().voteOnPost(post.id, false);
          },
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.visibility_outlined, size: 16, color: AppColors.gray500),
            const SizedBox(width: 4),
            Text(
              '${post.viewCount} views',
              style: const TextStyle(color: AppColors.gray500, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool isPostAuthor;

  const _CommentCard({
    required this.comment,
    required this.isPostAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: comment.isBestAnswer
            ? AppColors.success.withValues(alpha: 0.1)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: comment.isBestAnswer
            ? Border.all(color: AppColors.success)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  comment.author?.initials ?? 'U',
                  style: TextStyle(color: AppColors.primary, fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.author?.displayName ?? 'Unknown',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                Helpers.timeAgo(comment.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray500,
                ),
              ),
              if (comment.isBestAnswer) ...[
                const Spacer(),
                const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                const SizedBox(width: 4),
                const Text(
                  'Best Answer',
                  style: TextStyle(color: AppColors.success, fontSize: 12),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.content),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                  size: 16,
                  color: comment.userVote == 1 ? AppColors.success : AppColors.gray500,
                ),
                onPressed: () {
                  context.read<ForumProvider>().voteOnComment(comment.id, true);
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 4),
              Text(
                comment.score.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  Icons.arrow_downward,
                  size: 16,
                  color: comment.userVote == -1 ? AppColors.error : AppColors.gray500,
                ),
                onPressed: () {
                  context.read<ForumProvider>().voteOnComment(comment.id, false);
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
