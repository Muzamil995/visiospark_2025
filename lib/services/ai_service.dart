import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/config/gemini_config.dart';
import '../core/utils/logger.dart';
import '../models/ai_message_model.dart';

class AIService {
  ChatSession? _chatSession;
  final List<AIMessageModel> _history = [];

  List<AIMessageModel> get history => List.unmodifiable(_history);

  bool get isConfigured => GeminiConfig.isConfigured;

  void initSession() {
    if (!isConfigured) {
      AppLogger.warning('Gemini API key not configured');
      return;
    }

    AppLogger.info('Initializing AI chat session');
    _chatSession = GeminiConfig.model.startChat(
      history: [
        Content.text(GeminiConfig.systemPrompt),
      ],
    );
  }

  Future<AIMessageModel> sendMessage(String message) async {
    if (!isConfigured) {
      throw Exception('AI service not configured. Please add your Gemini API key.');
    }

    if (_chatSession == null) {
      initSession();
    }

    try {
      AppLogger.info('Sending message to AI');
      final userMessage = AIMessageModel.user(message);
      _history.add(userMessage);

      final response = await _chatSession!.sendMessage(Content.text(message));
      final responseText = response.text ?? 'Sorry, I could not generate a response.';

      final aiMessage = AIMessageModel.ai(responseText);
      _history.add(aiMessage);

      AppLogger.success('AI response received');
      return aiMessage;
    } catch (e) {
      AppLogger.error('AI service error', e);
      
      final errorMessage = AIMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, an error occurred. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
      _history.add(errorMessage);
      
      rethrow;
    }
  }

  Stream<String> sendMessageStream(String message) async* {
    if (!isConfigured) {
      throw Exception('AI service not configured');
    }

    if (_chatSession == null) {
      initSession();
    }

    try {
      AppLogger.info('Sending streaming message to AI');
      _history.add(AIMessageModel.user(message));

      final response = _chatSession!.sendMessageStream(Content.text(message));
      final buffer = StringBuffer();

      await for (final chunk in response) {
        final text = chunk.text ?? '';
        buffer.write(text);
        yield text;
      }

      _history.add(AIMessageModel.ai(buffer.toString()));
      AppLogger.success('AI stream completed');
    } catch (e) {
      AppLogger.error('AI stream error', e);
      rethrow;
    }
  }

  Future<String> generateContent(String prompt) async {
    if (!isConfigured) {
      throw Exception('AI service not configured');
    }

    try {
      AppLogger.debug('Generating AI content');
      final response = await GeminiConfig.model.generateContent([
        Content.text(prompt),
      ]);
      
      AppLogger.success('AI content generated');
      return response.text ?? 'No response generated';
    } catch (e) {
      AppLogger.error('Generate content error', e);
      rethrow;
    }
  }

  void clearHistory() {
    AppLogger.info('Clearing AI history');
    _history.clear();
    _chatSession = null;
    initSession();
  }

  Future<List<String>> getSuggestions(String context, {int count = 3}) async {
    if (!isConfigured) return [];

    try {
      AppLogger.debug('Getting AI suggestions');
      final prompt = '''
Based on this context: "$context"
Generate $count short, relevant follow-up questions or suggestions.
Return only the suggestions, one per line, without numbering.
''';

      final response = await generateContent(prompt);
      final suggestions = response
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .take(count)
          .toList();
      
      AppLogger.success('Got ${suggestions.length} suggestions');
      return suggestions;
    } catch (e) {
      AppLogger.error('Get suggestions error', e);
      return [];
    }
  }
}
