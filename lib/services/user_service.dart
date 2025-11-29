import '../core/config/supabase_config.dart';
import '../core/utils/logger.dart';
import '../models/user_model.dart';

class UserService {
  final _client = SupabaseConfig.client;

  Future<UserModel?> getCurrentUserProfile() async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) return null;

      AppLogger.debug('Fetching current user profile: $userId');
      final response = await _client
          .from(SupabaseConfig.profilesTable)
          .select()
          .eq('id', userId)
          .single();

      AppLogger.success('User profile fetched');
      return UserModel.fromJson(response);
    } catch (e) {
      AppLogger.error('Get current user profile error', e);
      return null;
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      AppLogger.debug('Fetching user profile: $userId');
      final response = await _client
          .from(SupabaseConfig.profilesTable)
          .select()
          .eq('id', userId)
          .single();

      AppLogger.success('User profile fetched: $userId');
      return UserModel.fromJson(response);
    } catch (e) {
      AppLogger.error('Get user profile error', e);
      return null;
    }
  }

  Future<UserModel?> updateProfile({
    String? fullName,
    String? phone,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      AppLogger.info('Updating profile: $userId');
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await _client
          .from(SupabaseConfig.profilesTable)
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      AppLogger.success('Profile updated');
      return UserModel.fromJson(response);
    } catch (e) {
      AppLogger.error('Update profile error', e);
      rethrow;
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      
      AppLogger.debug('Searching users: $query');
      final response = await _client
          .from(SupabaseConfig.profilesTable)
          .select()
          .neq('id', userId ?? '')
          .or('full_name.ilike.%$query%,email.ilike.%$query%')
          .limit(20);

      AppLogger.success('User search completed: ${(response as List).length} results');
      return (response).map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      AppLogger.error('Search users error', e);
      return [];
    }
  }

  Future<List<UserModel>> getAllUsers({int limit = 50, int offset = 0}) async {
    try {
      AppLogger.debug('Fetching all users (limit: $limit, offset: $offset)');
      final response = await _client
          .from(SupabaseConfig.profilesTable)
          .select()
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      AppLogger.success('Fetched ${(response as List).length} users');
      return (response).map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      AppLogger.error('Get all users error', e);
      return [];
    }
  }
}
