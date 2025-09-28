import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  final _promptController = TextEditingController();
  bool _isLoading = false;
  String? _imageUrl;

  void _handleGenerateImage() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a prompt.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _imageUrl = null;
    });

    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'image-alpha-001', // Use the image generation model
      );

      final prompt = _promptController.text;

      // Generate image
      final response = await model.generateContent([Content.text(prompt)]);

      // In Firebase AI Flutter package, the URL is often returned in `response.text`
      final url = response.text?.trim();

      if (url != null && url.startsWith('http')) {
        setState(() {
          _imageUrl = url;
        });
      } else {
        throw Exception('No valid image URL returned.');
      }
    } catch (e) {

      print(e);

      setState(() {
        _imageUrl = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Image Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter a prompt for the image',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _isLoading ? null : _handleGenerateImage,
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text('Generate Image'),
            ),
            const SizedBox(height: 24),
            if (_imageUrl != null)
              Expanded(
                child: Image.network(
                  _imageUrl!,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
