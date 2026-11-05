import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';

// Ek chhota sa model messages store karne ke liye
class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class AskKalaScreen extends StatefulWidget {
  const AskKalaScreen({super.key});

  @override
  State<AskKalaScreen> createState() => _AskKalaScreenState();
}

class _AskKalaScreenState extends State<AskKalaScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [
    ChatMessage(
      text: "Hello! I am Kala, your AI art assistant. Looking for a specific mood, colour, or need help tracking an order?",
      isUser: false,
    ),
  ];

  bool isLoading = false;

  Future<void> sendMessage() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    // 1. User ka message screen par add karo
    setState(() {
      messages.add(ChatMessage(text: query, isUser: true));
      isLoading = true;
      _controller.clear();
    });

    // Scroll ko sabse niche bhejo
    _scrollToBottom();

    try {
      // 2. API ko call karo
      final response = await ApiService.askKala(query);

      // 3. AI ka jawab screen par add karo
      setState(() {
        messages.add(ChatMessage(text: response['answer'], isUser: false));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        messages.add(
          ChatMessage(
            text: "Sorry, I am facing a network error. Please try again.",
            isUser: false,
          ),
        );
        isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Thoda delay taaki naya message render ho jaye, phir scroll kare
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EFE6),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFFa84d3f), size: 20),
            const SizedBox(width: 8),
            Text(
              'Ask Kala',
              style: GoogleFonts.cormorantGaramond(
                color: const Color(0xFF2B2028),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2B2028)),
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? const Color(0xFFa84d3f)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: msg.isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                        bottomRight: msg.isUser
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg.text,
                      style: GoogleFonts.manrope(
                        color: msg.isUser
                            ? Colors.white
                            : const Color(0xFF2B2028),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Typing Indicator (Jab AI soch raha ho)
          if (isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kala is thinking...",
                  style: GoogleFonts.manrope(
                    color: Colors.black54,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          // Text Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.manrope(),
                      decoration: InputDecoration(
                        hintText: 'Ask about art or orders...',
                        hintStyle: GoogleFonts.manrope(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5EFE6),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (_) => sendMessage(), // Keyboard se enter dabane par bhi send ho
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFa84d3f),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: isLoading ? null : sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
