import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/product/detail/controller/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[900],
                child: product.imageUrls.isNotEmpty
                    ? Image.network(
                        product.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.grey[600],
                            size: 64,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.grey[600],
                          size: 64,
                        ),
                      ),
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
                      product.isFree ? '나눔' : '₩${product.price}',
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
}
