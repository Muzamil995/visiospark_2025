import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = '';
  static const String supabaseAnonKey = '';

  static String get url => supabaseUrl;
  static String get anonKey => supabaseAnonKey;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static GoTrueClient get auth => client.auth;
  static User? get currentUser => auth.currentUser;
  static String? get currentUserId => currentUser?.id;
  static bool get isAuthenticated => currentUser != null;

  static const String avatarsBucket = 'avatars';
  static const String filesBucket = 'files';
  static const String chatFilesBucket = 'chat-files';

  static const String profilesTable = 'profiles';
  static const String chatRoomsTable = 'chat_rooms';
  static const String chatParticipantsTable = 'chat_participants';
  static const String messagesTable = 'messages';
  static const String forumPostsTable = 'forum_posts';
  static const String forumCommentsTable = 'forum_comments';
  static const String votesTable = 'votes';
  static const String bookmarksTable = 'bookmarks';
  static const String notificationsTable = 'notifications';
  static const String filesTable = 'files';
  static const String itemsTable = 'items';
}
