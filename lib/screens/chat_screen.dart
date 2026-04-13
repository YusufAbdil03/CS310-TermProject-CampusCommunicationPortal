import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_spacing.dart';
import '../widgets/profile_avatar.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  List<ChatMessage> messages = [
    ChatMessage(text: "Hey, did you find a good spot for the CS group study session?", isMe: true, time: "14:20"),
    ChatMessage(text: "Hi! Yes, I found a room in the library. Second floor, room 204.", isMe: false, time: "14:22"),
    ChatMessage(text: "Perfect, what time? Also, did you review the final project scope?", isMe: true, time: "14:25"),
    ChatMessage(text: "We booked it for 2 PM. And yes, I'm working on the scope now.", isMe: false, time: "14:30"),
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(
          ChatMessage(
            text: _msgController.text.trim(),
            isMe: true,
            time: "Now",
          ),
        );
        _msgController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const ProfileAvatar(),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Campus User', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Online', style: AppTextStyles.subtitle.copyWith(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // MESSAGES
          Expanded(
            child: ListView.builder(
              padding: AppSpacing.pagePadding,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!msg.isMe) ...[
                        const ProfileAvatar(),
                        const SizedBox(width: 8),
                      ],

                      // Mesasage bubble
                      Flexible(
                        child: Column(
                          crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: msg.isMe ? AppColors.primary : const Color(0xFFF0F2F0),
                                borderRadius: BorderRadius.circular(16).copyWith(
                                  bottomRight: msg.isMe ? const Radius.circular(0) : const Radius.circular(16),
                                  bottomLeft: msg.isMe ? const Radius.circular(16) : const Radius.circular(0),
                                ),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  color: msg.isMe ? Colors.white : AppColors.primary,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              msg.time,
                              style: const TextStyle(fontSize: 11, color: AppColors.subtitle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // MESSAGE WRITING PLACE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.subtitle),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F0),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: AppTextStyles.subtitle,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
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