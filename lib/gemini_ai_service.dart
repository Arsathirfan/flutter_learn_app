import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {

  // final String baseUrl = "https://gemini-backend-eta.vercel.app/api/generate";

  final String baseUrl = "https://gemini-backend-eta.vercel.app/api/genkit";

  Future<String> generateText(String prompt) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"prompt": prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Gemini response structure
      return data["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      throw Exception("Failed: ${response.body}");
    }
  }
}
