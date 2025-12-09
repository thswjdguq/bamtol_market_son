import 'dart:io';

import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/product/detail/controller/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212123),
      appBar: AppBar(
        backgroundColor: const Color(0xff212123),
        elevation: 0,
        title: const AppFont('상품 상세', fontWeight: FontWeight.bold, size: 18),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              'assets/svg/icons/close.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final product = controller.product.value;

        // 로딩 중인 경우
        if (product.title == '로딩 중...') {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffED7738)),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[900],
                child: _buildProductImage(product),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFont(
                      product.title,
                      color: Colors.white,
                      size: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    AppFont(
                      '${product.locationLabel} · 조회 ${product.viewCount}',
                      color: const Color(0xff878B93),
                      size: 12,
                    ),
                    const SizedBox(height: 16),
                    AppFont(
                      product.isFree ? '나눔' : _formatPrice(product.price ?? 0),
                      color: Colors.white,
                      size: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey[800], height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[800],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppFont(
                                product.sellerName ?? '판매자',
                                color: Colors.white,
                                size: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              AppFont(
                                '신뢰도 ⭐⭐⭐⭐',
                                color: const Color(0xff878B93),
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey[800], height: 1),
                    const SizedBox(height: 16),
                    AppFont(
                      '상품 설명',
                      color: Colors.white,
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 8),
                    AppFont(
                      product.description ?? '설명이 없습니다.',
                      color: const Color(0xff878B93),
                      size: 13,
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey[800], height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppFont(
                          '카테고리',
                          color: Color(0xff878B93),
                          size: 13,
                        ),
                        AppFont(
                          product.category ?? '-',
                          color: Colors.white,
                          size: 13,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppFont('상태', color: Color(0xff878B93), size: 13),
                        AppFont(
                          product.condition ?? '-',
                          color: Colors.white,
                          size: 13,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        color: const Color(0xff212123),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Obx(
              () => GestureDetector(
                onTap: () => controller.toggleLike(),
                child: Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      controller.isLiked.value
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: controller.isLiked.value
                          ? Colors.red
                          : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.startChat(),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xffED7738),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: AppFont(
                      '채팅하기',
                      color: Colors.white,
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => controller.share(),
              child: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(Icons.share, color: Colors.grey[600], size: 20),
                ),
              ),
            ),
          ],
        ),
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
                  size: 64,
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
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xffED7738),
                  ),
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
                  size: 64,
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
        child: Icon(Icons.image_outlined, color: Colors.grey[600], size: 64),
      ),
    );
  }

  // 가격 포맷
  String _formatPrice(int price) {
    if (price == 0) {
      return '나눔';
    }
    return '₩${NumberFormat('#,###').format(price)}';
  }
}
