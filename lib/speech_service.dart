import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'ollama_service.dart';

class SpeechService {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  final OllamaService _ollamaService = OllamaService();

  // Start listening for speech
  Future<void> startListening(Function(String) onRecognizedSpeech) async {
    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      _speech.listen(onResult: (result) {
        // This will be called whenever speech is recognized
        String recognizedWords = result.recognizedWords;
        onRecognizedSpeech(recognizedWords);  // Call the callback with recognized words
        _callOllamaAPI(recognizedWords);  // Call Ollama API to process the recognized words
      });
    } else {
      print("Speech recognition not available");
    }
  }

  // Stop listening for speech
  void stopListening() {
    _speech.stop();
    _isListening = false;
  }

  bool get isListening => _isListening;

  // Call Ollama API with recognized speech
  Future<void> _callOllamaAPI(String query) async {
    try {
      String aiResponse = await _ollamaService.getAIResponse(query);
      print('Ollama API Response: $aiResponse');  // For debugging
    } catch (e) {
      print('Error calling Ollama API: $e');
    }
  }
}
