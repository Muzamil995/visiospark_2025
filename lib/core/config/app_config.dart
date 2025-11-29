class AppConfig {
  static const String appName = 'Hackathon App';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Built for Visiospark 2025';

  static const bool enableChat = true;
  static const bool enableForum = true;
  static const bool enableAI = true;
  static const bool enableFileUpload = true;
  static const bool enableOfflineMode = true;
  static const bool enableNotifications = true;

  static const int pageSize = 20;
  static const int chatPageSize = 50;

  static const int maxFileSizeMB = 10;
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedFileTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'zip'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];

  static const Duration cacheDuration = Duration(hours: 1);

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);

  static const String supportEmail = 'support@example.com';

  static const String? websiteUrl = null;
  static const String? privacyPolicyUrl = null;
  static const String? termsUrl = null;
}
