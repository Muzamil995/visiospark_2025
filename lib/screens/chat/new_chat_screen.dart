import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/cards/user_card.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchUsers(String query) {
    context.read<UserProvider>().searchUsers(query);
  }

  Future<void> _startChat(String userId) async {
    final chatProvider = context.read<ChatProvider>();
    final room = await chatProvider.startDirectChat(userId);

    if (room != null && mounted) {
      Navigator.pushReplacementNamed(context, AppConstants.chatRoomRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchTextField(
              controller: _searchController,
              hint: 'Search users...',
              onChanged: _searchUsers,
              onClear: () {
                _searchController.clear();
                userProvider.clearSearchResults();
              },
            ),
          ),
          Expanded(
            child: _buildResults(userProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(UserProvider userProvider) {
    if (userProvider.isLoading) {
      return const LoadingWidget();
    }

    if (_searchController.text.isEmpty) {
      return const EmptyStateWidget(
        title: 'Search for users',
        subtitle: 'Find people to start a conversation',
        icon: Icons.search,
      );
    }

    if (userProvider.searchResults.isEmpty) {
      return NoSearchResultsWidget(query: _searchController.text);
    }

    return ListView.builder(
      itemCount: userProvider.searchResults.length,
      itemBuilder: (context, index) {
        final user = userProvider.searchResults[index];
        return UserListTile(
          user: user,
          onTap: () => _startChat(user.id),
          trailing: IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => _startChat(user.id),
          ),
        );
      },
    );
  }
}
