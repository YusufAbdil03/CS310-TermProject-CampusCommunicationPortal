import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/bottom_nav_placeholder.dart';
import '../widgets/profile_avatar.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      timeAgo: '12 mins ago',
      text: 'Someone left AirPods at the library front desk.',
      reactions: '😂 2  😐 1',
    ),
    _ChatMessage(
      timeAgo: '10 mins ago',
      text: 'What time is the AI Club event today?',
    ),
    _ChatMessage(
      timeAgo: '3 mins ago',
      text: 'There is a lost kitty in FASS. Does it belong to someone?',
      reactions: '😂 6',
    ),
    _ChatMessage(
      timeAgo: '1 min ago',
      text: 'Can someone tell the Kurtköy shuttle to wait 1 minute please?',
    ),
    _ChatMessage(
      timeAgo: '1 min ago',
      text: 'I told the driver, run.',
    ),
    _ChatMessage(
      timeAgo: 'Just now',
      text: 'What is the phone number of Pizza Bulls?',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          timeAgo: 'Just now',
          text: text,
        ),
      );
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.primary, width: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Live Chat',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: ProfileAvatar(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Campus-wide help & updates',
            style: TextStyle(
              color: AppColors.subtitle,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _messages.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 18, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Anonymous ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const TextSpan(
                            text: '•• ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: message.timeAgo,
                            style: const TextStyle(
                              color: AppColors.subtitle,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    if (message.reactions != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        message.reactions!,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F0),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ask a quick question or share something helpful...',
                          hintStyle: TextStyle(
                            color: AppColors.subtitle,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _sendMessage,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const BottomNavPlaceholder(activeTab: BottomTab.anonym),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String timeAgo;
  final String text;
  final String? reactions;

  _ChatMessage({
    required this.timeAgo,
    required this.text,
    this.reactions,
  });
}