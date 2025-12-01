import 'package:flutter/material.dart';
import 'speech_service.dart';
import 'ollama_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpeechRecognitionScreen(),
    );
  }
}

class SpeechRecognitionScreen extends StatefulWidget {
  @override
  _SpeechRecognitionScreenState createState() =>
      _SpeechRecognitionScreenState();
}

class _SpeechRecognitionScreenState extends State<SpeechRecognitionScreen> {
  final SpeechService _speechService = SpeechService();
  final OllamaService _ollamaService = OllamaService();
  String _response = "";
  String _recognizedWords = "";

  // Start or stop listening based on the state
  void _startStopListening() {
    if (_speechService.isListening) {
      _speechService.stopListening();
    } else {
      _speechService.startListening(_updateRecognizedWords);
    }
  }

  // Callback function to update the recognized speech
  void _updateRecognizedWords(String recognizedWords) {
    setState(() {
      _recognizedWords = recognizedWords;
    });
    _getAIResponse(recognizedWords);
  }

  // Call Ollama API to get response for recognized speech
  void _getAIResponse(String query) async {
    try {
      String aiResponse = await _ollamaService.getAIResponse(query);
      setState(() {
        _response = aiResponse;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Speech App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _startStopListening,
              child: Text(_speechService.isListening
                  ? 'Stop Listening'
                  : 'Start Listening'),
            ),
            SizedBox(height: 20),
            Text(
              'Recognized Words: $_recognizedWords',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'AI Response: $_response',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
