class AIMessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;
  final String? error;

  AIMessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
    this.error,
  });

  factory AIMessageModel.user(String content) {
    return AIMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
  }

  factory AIMessageModel.ai(String content) {
    return AIMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  factory AIMessageModel.loading() {
    return AIMessageModel(
      id: 'loading',
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );
  }

  factory AIMessageModel.fromJson(Map<String, dynamic> json) {
    return AIMessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['is_user'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'error': error,
    };
  }
}
