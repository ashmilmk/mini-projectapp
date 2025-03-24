import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicalAssistantChatbot extends StatefulWidget {
  const MedicalAssistantChatbot({super.key});

  @override
  _MedicalAssistantChatbotState createState() =>
      _MedicalAssistantChatbotState();
}

class _MedicalAssistantChatbotState extends State<MedicalAssistantChatbot> {
  final List<String> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _sendMessage(String message) async {
    setState(() {
      _messages.add(message);
      _textController.clear();
    });

    // Get the response from the Anthropic Claude API
    String response = await _getResponse(message);
    if (response.isNotEmpty) {
      setState(() {
        _messages.add(response);
      });
    }
  }

  Future<String> _getResponse(String message) async {
    const apiKey = 'YOUR_ANTHROPIC_API_KEY';
    final url = Uri.parse('https://api.anthropic.com/v1/complete');
    final headers = {
      'Content-Type': 'application/json',
      'X-API-Key': apiKey,
    };
    final body = json.encode({
      'model': 'gpt-3.5-turbo',
      'prompt': message,
      'max_tokens': 100,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final chatbotResponse = data['choices'][0]['text'].trim();
        return chatbotResponse;
      } else {
        return 'Failed to get a response from the AI model.';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Assistant Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _sendMessage(_textController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
