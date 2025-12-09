import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/components/app_font.dart';
import '../controller/mypage_controller.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyPageController>();

    return Scaffold(
      backgroundColor: const Color(0xff212123),
      appBar: AppBar(
        title: const AppFont(
          '나의 밤톨',
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
        final user = controller.profile.value;
        if (user == null) {
          return const Center(
            child: AppFont(
              '프로필을 불러올 수 없습니다',
              color: Color(0xff878B93),
              size: 16,
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 프로필
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: const Color(0xffED7738),
                    child: AppFont(
                      user.name[0],
                      color: Colors.white,
                      size: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppFont(
                          user.name,
                          color: Colors.white,
                          size: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        AppFont(
                          user.location,
                          color: const Color(0xff878B93),
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // 거래 통계
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff3C3C3E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const AppFont(
                            '판매',
                            color: Color(0xff878B93),
                            size: 14,
                          ),
                          const SizedBox(height: 8),
                          AppFont(
                            '${user.sellCount}건',
                            color: Colors.white,
                            size: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff3C3C3E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const AppFont(
                            '구매',
                            color: Color(0xff878B93),
                            size: 14,
                          ),
                          const SizedBox(height: 8),
                          AppFont(
                            '${user.buyCount}건',
                            color: Colors.white,
                            size: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
