import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart' as app_auth;
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_spacing.dart';
import '../widgets/bottom_nav_placeholder.dart';
import '../widgets/profile_avatar.dart';
import 'chat_screen.dart';
import 'other_user_profile_screen.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  String _getChatRoomId(String a, String b) {
    return a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.uid ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
        title: Text('Messages', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'), // KENDİ PROFİLİNE GİT
              child: const ProfileAvatar(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.pagePadding,
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF0F2F0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextFormField(
                controller: _searchController,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search for students or clubs...',
                  hintStyle: AppTextStyles.subtitle,
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = "");
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allUsers = userSnapshot.data?.docs ?? [];

                final availableUsers = allUsers.where((doc) {
                  final data = doc.data() as Map<String, dynamic>? ?? {};
                  if (doc.id == currentUserId) return false;
                  if (data['isDmEnabled'] == false) return false;
                  return true;
                }).toList();

                if (_searchQuery.isNotEmpty) {
                  final searchResults = availableUsers.where((doc) {
                    final data = doc.data() as Map<String, dynamic>? ?? {};
                    final fullName = (data['fullName'] ?? data['name'] ?? '').toString().toLowerCase();
                    return fullName.contains(_searchQuery);
                  }).toList();

                  if (searchResults.isEmpty) {
                    return Center(child: Text('No match for "$_searchQuery"', style: const TextStyle(color: AppColors.subtitle)));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: searchResults.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).dividerColor),
                    itemBuilder: (context, index) {
                      final userData = searchResults[index].data() as Map<String, dynamic>? ?? {};
                      final String otherUserId = searchResults[index].id;
                      final String fullName = userData['fullName'] ?? userData['name'] ?? 'Unknown';

                      return _buildUserTile(context, otherUserId, fullName, isDarkMode, subtitle: 'Tap to start messaging');
                    },
                  );
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getRecentChats(availableUsers, currentUserId),
                  builder: (context, chatSnapshot) {
                    if (chatSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final recentChats = chatSnapshot.data ?? [];

                    if (recentChats.isEmpty) {
                      return const Center(
                        child: Text(
                          'No recent messages.\nSearch above to start chatting!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.subtitle),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: recentChats.length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).dividerColor),
                      itemBuilder: (context, index) {
                        final chat = recentChats[index];
                        return _buildUserTile(
                          context,
                          chat['userId'],
                          chat['fullName'],
                          isDarkMode,
                          subtitle: chat['lastMessage'],
                          time: chat['time'],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const BottomNavPlaceholder(activeTab: BottomTab.messages),
        ],
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, String otherUserId, String fullName, bool isDarkMode, {required String subtitle, DateTime? time}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      leading: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtherUserProfileScreen(userId: otherUserId))),
        child: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      title: Text(
        fullName,
        style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : AppColors.primary),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
      ),
      trailing: time != null
          ? Text(
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
          style: const TextStyle(color: AppColors.subtitle, fontSize: 12)
      )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(otherUserId: otherUserId, otherUserName: fullName)),
        ).then((_) => setState(() {}));
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getRecentChats(List<DocumentSnapshot> availableUsers, String currentUserId) async {
    List<Map<String, dynamic>> activeChats = [];

    for (var doc in availableUsers) {
      String otherUserId = doc.id;
      String roomId = _getChatRoomId(currentUserId, otherUserId);

      try {
        var messagesSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .doc(roomId)
            .collection('messages')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

        if (messagesSnapshot.docs.isNotEmpty) {
          var lastMsgData = messagesSnapshot.docs.first.data();
          String text = lastMsgData['text'] ?? 'Sent a message';

          var createdAtData = lastMsgData['createdAt'];
          DateTime? ts;
          if (createdAtData is Timestamp) {
            ts = createdAtData.toDate();
          } else if (createdAtData is String) {
            ts = DateTime.tryParse(createdAtData);
          }

          final userData = doc.data() as Map<String, dynamic>? ?? {};
          final String displayName = userData['fullName'] ?? userData['name'] ?? 'Unknown';

          activeChats.add({
            'userId': otherUserId,
            'fullName': displayName,
            'lastMessage': text,
            'timestamp': ts?.millisecondsSinceEpoch ?? 0,
            'time': ts,
          });
        }
      } catch (e) {}
    }

    activeChats.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    return activeChats;
  }
}