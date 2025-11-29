import 'package:flutter/material.dart';
import '../models/ai_message_model.dart';
import '../services/ai_service.dart';
import '../core/utils/logger.dart';

class AIProvider extends ChangeNotifier {
  final AIService _aiService = AIService();

  List<AIMessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;
  List<String> _suggestions = [];

  List<AIMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get suggestions => _suggestions;
  bool get isConfigured => _aiService.isConfigured;

  AIProvider() {
    AppLogger.info('AIProvider initializing');
    _aiService.initSession();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    AppLogger.info('Sending AI message');
    _messages.add(AIMessageModel.user(message));
    _messages.add(AIMessageModel.loading());
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _aiService.sendMessage(message);
      
      _messages.removeWhere((m) => m.isLoading);
      _messages.add(response);
      AppLogger.success('AI response received');

      _getSuggestions(response.content);
    } catch (e) {
      AppLogger.error('AI message failed', e);
      _messages.removeWhere((m) => m.isLoading);
      _error = e.toString();
      _messages.add(AIMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, something went wrong. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
        error: e.toString(),
      ));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _getSuggestions(String context) async {
    AppLogger.debug('Getting AI suggestions');
    try {
      _suggestions = await _aiService.getSuggestions(context);
      AppLogger.info('Got ${_suggestions.length} suggestions');
      notifyListeners();
    } catch (e) {
      AppLogger.error('Get suggestions failed', e);
      _suggestions = [];
    }
  }

  void clearChat() {
    AppLogger.info('Clearing AI chat');
    _messages = [];
    _suggestions = [];
    _error = null;
    _aiService.clearHistory();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
