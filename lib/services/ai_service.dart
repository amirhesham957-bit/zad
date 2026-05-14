import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:math';

class AIResponse {
  final bool success;
  final String content;
  final String? error;

  AIResponse({required this.success, required this.content, this.error});
}

class AIService {
  final String apiKey;
  late final GenerativeModel _model;

  AIService({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<AIResponse> callAI(
    String systemPrompt,
    String userMessage, {
    List<Content>? history,
  }) async {
    int attempts = 0;
    const maxAttempts = 3;

    while (attempts < maxAttempts) {
      try {
        final content = [
          Content.text('SYSTEM: $systemPrompt'),
          ...?history,
          Content.text(userMessage),
        ];

        final response = await _model.generateContent(
          content,
        ).timeout(const Duration(seconds: 30));

        if (response.text != null) {
          return AIResponse(success: true, content: response.text!);
        } else {
          throw Exception('Empty response from AI');
        }
      } on TimeoutException {
        return AIResponse(success: false, content: '', error: 'Request timed out after 30 seconds');
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          return AIResponse(success: false, content: '', error: 'Failed after $maxAttempts attempts: $e');
        }
        final backoff = pow(2, attempts - 1) * 1000;
        await Future.delayed(Duration(milliseconds: backoff.toInt()));
      }
    }

    return AIResponse(success: false, content: '', error: 'Unknown error occurred');
  }

  Future<AIResponse> parseSplitExpense(String input) async {
    const systemPrompt = 'Analyze financial messages to extract expense details in JSON format.';
    final userMessage = '''
    Extract details from: "$input"
    Return ONLY a JSON object with:
    {
      "description": "string",
      "amount": number,
      "category": "string"
    }
    ''';
    return callAI(systemPrompt, userMessage);
  }
}
