import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/storage_service.dart';
import '../core/config/supabase_config.dart';
import '../core/utils/logger.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  final StorageService _storageService = StorageService();

  UserModel? _user;
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  List<UserModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurrentUser() async {
    AppLogger.info('Loading current user');
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.getCurrentUserProfile();
      _error = null;
      AppLogger.success('Current user loaded');
    } catch (e) {
      AppLogger.error('Load current user failed', e);
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? bio,
  }) async {
    AppLogger.info('Updating profile');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userService.updateProfile(
        fullName: fullName,
        phone: phone,
        bio: bio,
      );
      AppLogger.success('Profile updated');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      AppLogger.error('Update profile failed', e);
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadAvatar(ImageSource source) async {
    AppLogger.info('Uploading avatar');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image == null) {
        AppLogger.warning('Avatar upload cancelled');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final avatarUrl = await _storageService.uploadImage(
        image: image,
        bucket: SupabaseConfig.avatarsBucket,
        folder: SupabaseConfig.currentUserId,
      );

      if (avatarUrl != null) {
        _user = await _userService.updateProfile(avatarUrl: avatarUrl);
        AppLogger.success('Avatar uploaded: $avatarUrl');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      AppLogger.error('Avatar upload failed', e);
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    AppLogger.debug('Searching users: $query');
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _userService.searchUsers(query);
      _error = null;
      AppLogger.info('Found ${_searchResults.length} users');
    } catch (e) {
      AppLogger.error('User search failed', e);
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
