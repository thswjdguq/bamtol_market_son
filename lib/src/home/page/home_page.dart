import 'dart:io';

import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends GetView<HomeController> {
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
            const AppFont(
              '아라동',
              color: Colors.white,
              size: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(width: 5),
            SvgPicture.asset(
              'assets/svg/icons/bottom_arrow.svg',
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
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          SvgPicture.asset(
            'assets/svg/icons/list.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          SvgPicture.asset(
            'assets/svg/icons/bell.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 20),
        ],
      ),

      // Body 섹션 - 상품 리스트 (Chapter 17)
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
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                const AppFont(
                  '글쓰기',
                  color: Colors.white,
                  size: 15,
                  fontWeight: FontWeight.w600,
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

// 상품 리스트 위젯 (Chapter 17)
class _ProductList extends GetView<HomeController> {
  const _ProductList();

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    // 스크롤 끝에 도달했을 때 loadMore 호출
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!controller.isLoading.value && controller.hasMore) {
          controller.loadMore();
        }
      }
    });

    return Obx(() {
      return ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        itemCount:
            controller.products.length + (controller.isLoading.value ? 1 : 0),
        itemBuilder: (context, index) {
          // 로딩 인디케이터
          if (index == controller.products.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffED7738)),
                ),
              ),
            );
          }

          final product = controller.products[index];
          return _productOne(product);
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
    });
  }

  // 개별 상품 아이템 위젯
  Widget _productOne(dynamic product) {
    final price = product.price ?? 0;
    final location = product.locationLabel;
    final date = _formatDate(product.createdAt);
    final isFree = product.isFree ?? false;
    // Chapter 20: 판매자 정보 추가
    final sellerName = product.sellerName ?? '판매자';
    final viewCount = product.viewCount ?? 0;
    final likeCount = (product.likers ?? []).length;

    return GestureDetector(
      onTap: () {
        // Chapter 20: 상품 상세 페이지로 이동
        Get.toNamed('/product/detail/${product.id}');
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 썸네일 이미지 (80x80)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 80,
              child: _buildProductImage(product),
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
                AppFont(
                  product.title,
                  color: Colors.white,
                  size: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 3),
                // 두 번째 줄: 위치 · 날짜
                AppFont(
                  '$location · $date',
                  color: const Color(0xff878B93),
                  size: 12,
                ),
                const SizedBox(height: 4),
                // 세 번째 줄: 가격 또는 나눔
                AppFont(
                  isFree ? '나눔' : _formatPrice(price),
                  color: Colors.white,
                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 3),
                // 네 번째 줄: 판매자 · 조회수 · 찜개수 (Chapter 20)
                AppFont(
                  '$sellerName · 조회 $viewCount · 💚 $likeCount',
                  color: const Color(0xff878B93),
                  size: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 상품 이미지 빌드
  Widget _buildProductImage(dynamic product) {
    // 썸네일 URL 또는 첫 이미지 URL 사용
    String? imageUrl = product.thumbnailUrl;

    // 썸네일이 없으면 imageUrls 첫 번째 사용
    if ((imageUrl == null || imageUrl.isEmpty) &&
        product.imageUrls != null &&
        product.imageUrls.isNotEmpty) {
      imageUrl = product.imageUrls[0];
    }

    // 이미지 URL이 있으면 처리
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // 네트워크 URL인지 로컬 파일 경로인지 구분
      final bool isNetworkUrl =
          imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

      if (isNetworkUrl) {
        // 네트워크 이미지
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // 이미지 로드 실패시 회색 배경
            return Container(
              color: const Color(0xff3C3C3E),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.grey[600],
                  size: 32,
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            // 로딩 중일 때
            return Container(
              color: const Color(0xff3C3C3E),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.grey[600],
                  size: 32,
                ),
              ),
            );
          },
        );
      } else {
        // 로컬 파일 이미지
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // 이미지 로드 실패시 회색 배경
            return Container(
              color: const Color(0xff3C3C3E),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.grey[600],
                  size: 32,
                ),
              ),
            );
          },
        );
      }
    }

    // URL이 없으면 플레이스홀더
    return Container(
      color: const Color(0xff3C3C3E),
      child: Center(
        child: Icon(Icons.image_outlined, color: Colors.grey[600], size: 32),
      ),
    );
  }

  // 날짜 포맷
  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  // 가격 포맷
  String _formatPrice(int price) {
    if (price == 0) {
      return '나눔';
    }
    return '₩${NumberFormat('#,###').format(price)}';
  }
}
