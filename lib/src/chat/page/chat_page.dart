import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/components/app_font.dart';
import '../controller/chat_controller.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: const Color(0xff212123),
      appBar: AppBar(
        title: const AppFont(
          '채팅',
          color: Colors.white,
          size: 18,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xff212123),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffED7738)),
          );
        }
        if (controller.chatRooms.isEmpty) {
          return const Center(
            child: AppFont('채팅이 없습니다', color: Color(0xff878B93), size: 16),
          );
        }
        return ListView.separated(
          itemCount: controller.chatRooms.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Color(0xff3C3C3E), height: 1),
          itemBuilder: (context, index) {
            final chat = controller.chatRooms[index];
            return ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: const Color(0xffED7738),
                child: AppFont(
                  chat.partnerName[0],
                  color: Colors.white,
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: AppFont(
                chat.partnerName,
                color: Colors.white,
                size: 16,
                fontWeight: FontWeight.bold,
              ),
              subtitle: AppFont(
                chat.lastMessage,
                color: const Color(0xff878B93),
                size: 14,
              ),
              trailing: chat.unreadCount > 0
                  ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xffED7738),
                        shape: BoxShape.circle,
                      ),
                      child: AppFont(
                        '${chat.unreadCount}',
                        color: Colors.white,
                        size: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            );
          },
        );
      }),
    );
  }
}
