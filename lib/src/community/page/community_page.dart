import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/components/app_font.dart';
import '../controller/community_controller.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommunityController>();

    return Scaffold(
      backgroundColor: const Color(0xff212123),
      appBar: AppBar(
        title: const AppFont(
          '동네생활',
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
        if (controller.posts.isEmpty) {
          return const Center(
            child: AppFont('게시글이 없습니다', color: Color(0xff878B93), size: 16),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.posts.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Color(0xff3C3C3E), height: 24),
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppFont(
                  post.title,
                  color: Colors.white,
                  size: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 6),
                AppFont(post.content, color: const Color(0xff878B93), size: 14),
                const SizedBox(height: 12),
                Row(
                  children: [
                    AppFont(
                      post.authorName,
                      color: const Color(0xff878B93),
                      size: 12,
                    ),
                    const SizedBox(width: 8),
                    AppFont(
                      '댓글 ${post.commentCount}',
                      color: const Color(0xff878B93),
                      size: 12,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
