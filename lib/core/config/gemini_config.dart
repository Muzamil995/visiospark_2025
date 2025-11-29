import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiConfig {
  static const String apiKey = 'AIzaSyD7iaROs_hXcZ52aYYJ-EDML5rCMOjEFJ0';

  static GenerativeModel? _model;

  static GenerativeModel get model {
    _model ??= GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
    );
    return _model!;
  }

  static const String systemPrompt = '''
You are a helpful AI assistant for our app. Be concise, friendly, and helpful.
Provide accurate information and admit when you don't know something.
Format your responses using markdown when appropriate.
''';

  static bool get isConfigured => apiKey != 'YOUR_GEMINI_API_KEY';
}
