import 'dart:convert';
import 'package:http/http.dart' as http;

class OllamaService {
  final String apiUrl = 'http://localhost:11434/api/generate'; // Replace with actual Ollama API endpoint

  Future<String> getAIResponse(String query) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer f9583cfdc70e47a483dff8337ed5ac07.2KKEcl1JsAiHaD4ciiy3ZwM6', // Replace with your Ollama API key
      },
      body: jsonEncode({
        'query': query,
        // Other parameters if required by Ollama API
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response']; // Assuming the API response has a 'response' key
    } else {
      throw Exception('Failed to load AI response');
    }
  }
}
