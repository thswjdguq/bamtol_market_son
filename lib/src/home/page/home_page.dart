import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar 섹션
      appBar: AppBar(
        backgroundColor: const Color(0xff212123),
        elevation: 0,
        leadingWidth: Get.width * 0.6,
        leading: Row(
          children: [
            const SizedBox(width: 20),
            const Text(
              '아라동',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            SvgPicture.asset(
              'assets/svg/icons/bottom_arrow.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
        // 오른쪽 액션 아이콘들
        actions: [
          SvgPicture.asset(
            'assets/svg/icons/search.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          SvgPicture.asset(
            'assets/svg/icons/list.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          SvgPicture.asset(
            'assets/svg/icons/bell.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 20),
        ],
      ),

      // Body 섹션 - 상품 리스트
      body: const _ProductList(),

      // FloatingActionButton 섹션 - 커스텀 글쓰기 버튼
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 16),
        child: GestureDetector(
          onTap: () {
            Get.toNamed('/product/write');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xffED7738),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svg/icons/plus.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '글쓰기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      backgroundColor: const Color(0xff212123),
    );
  }
}

// 상품 리스트 위젯
class _ProductList extends StatelessWidget {
  const _ProductList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _productOne(index);
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            color: const Color(0xff3C3C3E),
            height: 1,
            thickness: 0.5,
          ),
        );
      },
    );
  }

  // 개별 상품 아이템 위젯
  Widget _productOne(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 왼쪽 썸네일 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Container(
              color: const Color(0xff3C3C3E),
              child: Image.network(
                'https://cdn.kgmaeil.net/news/photo/202007/245825_49825_2217.jpg',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 오른쪽 텍스트 영역
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              // 첫 번째 줄: 제목
              Text(
                'Yaamj 상품$index 무료로 드려요 :)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              // 두 번째 줄: 위치 · 시간
              Text(
                '개발하는남자 · 2023.07.08',
                style: const TextStyle(color: Color(0xff878B93), fontSize: 12),
              ),
              const SizedBox(height: 4),
              // 세 번째 줄: 태그
              Row(
                children: [
                  const Text(
                    '나눔',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('🧡', style: TextStyle(fontSize: 15)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
