import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../services/ai_service.dart';

// Mock API Key - Should be from environment variable in production
const String _mockApiKey = String.fromEnvironment('AI_API_KEY', defaultValue: '');

final aiServiceProvider = Provider((ref) => AIService(apiKey: _mockApiKey));

class ChatState {
  final List<Content> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<Content>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  late final AIService _aiService;
  late final String _systemPrompt;

  @override
  ChatState build() {
    _aiService = ref.watch(aiServiceProvider);
    _systemPrompt = "You are Say Coach — a financial behavioral analyst...";
    return ChatState();
  }

  Future<void> sendMessage(String text) async {
    final userContent = Content.text(text);
    state = state.copyWith(
      messages: [...state.messages, userContent],
      isLoading: true,
      error: null,
    );

    final response = await _aiService.callAI(
      _systemPrompt,
      text,
      history: state.messages.sublist(0, state.messages.length - 1),
    );

    if (response.success) {
      final aiContent = Content.text(response.content);
      state = state.copyWith(
        messages: [...state.messages, aiContent],
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error,
      );
    }
  }

  void clearChat() {
    state = ChatState();
  }
}

// Example provider for a specific feature
final coachChatProvider = NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);
