import 'dart:io';
import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/product/write/controller/product_write_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// ProductWritePage
/// 상품 등록 화면 (Chapter 15, 16, 17)
/// - 이미지 첨부, 상품 정보 입력
/// - 체크박스 기능 (무료 나눔, 가격 제안 받기)
/// - flutter_map을 이용한 위치 선택
/// - 완료 버튼 유효성 검사 (Chapter 16)
class ProductWritePage extends GetView<ProductWriteController> {
  const ProductWritePage({super.key});

  // ===== 이미지 피커 메서드 =====
  Future<void> _pickImages(BuildContext context) async {
    try {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        final imageUrls = pickedFiles
            .map((file) => file.path) // 실제 앱에서는 업로드 후 URL 사용
            .toList();
        controller.setImages(imageUrls);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const AppFont('이미지 선택에 실패했습니다.'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212123),
      appBar: AppBar(
        backgroundColor: const Color(0xff212123),
        elevation: 0,
        title: const AppFont('상품 등록', fontWeight: FontWeight.bold, size: 18),
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
        actions: [
          // ===== 완료 버튼 (Chapter 16: 유효성 검사에 따라 활성/비활성) =====
          Obx(() {
            final isActive = controller.isPossibleSubmit.value;
            return GestureDetector(
              onTap: isActive ? () => controller.submit() : null,
              child: IgnorePointer(
                ignoring: !isActive,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: AppFont(
                      '완료',
                      color: isActive ? const Color(0xffED7738) : Colors.grey,
                      fontWeight: FontWeight.bold,
                      size: 16,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 이미지 섹션 (Chapter 15) =====
            _buildImageSection(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== 카테고리 섹션 (Chapter 15) =====
                  _buildCategorySection(),
                  const SizedBox(height: 20),

                  // ===== 제목 입력 (Chapter 15) =====
                  _buildTitleSection(),
                  const SizedBox(height: 20),

                  // ===== 가격 입력 + 체크박스 (Chapter 15·16) =====
                  _buildPriceSection(),
                  const SizedBox(height: 20),

                  // ===== 상품 상태 (Chapter 15) =====
                  _buildConditionSection(),
                  const SizedBox(height: 20),

                  // ===== 설명 입력 (Chapter 15) =====
                  _buildDescriptionSection(),
                  const SizedBox(height: 20),

                  // ===== 거래 희망 장소 + 지도 (Chapter 15) =====
                  _buildLocationSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 이미지 섹션 (Chapter 15) =====
  Widget _buildImageSection(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppFont('이미지', fontWeight: FontWeight.bold, size: 16),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemCount: controller.imageUrls.length + 1,
              itemBuilder: (context, index) {
                // + 버튼
                if (index == controller.imageUrls.length) {
                  if (controller.isMaxImageReached()) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () => _pickImages(context),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border.all(color: Colors.grey[700]!, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.white, size: 32),
                      ),
                    ),
                  );
                }

                // 선택된 이미지 썸네일
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[900],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(controller.imageUrls[index]),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // 삭제 버튼
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => controller.removeImage(index),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppFont(
              '${controller.imageUrls.length}/${ProductWriteController.maxImageCount}',
              size: 12,
              color: Colors.grey,
            ),
          ),
        ],
      );
    });
  }

  // ===== 카테고리 섹션 (Chapter 15) =====
  Widget _buildCategorySection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppFont('카테고리', fontWeight: FontWeight.bold, size: 16),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[900],
            ),
            child: DropdownButton<String>(
              value: controller.selectedCategory.value.isEmpty
                  ? null
                  : controller.selectedCategory.value,
              hint: const AppFont('카테고리 선택', color: Colors.grey),
              dropdownColor: Colors.grey[900],
              underline: const SizedBox(),
              isExpanded: true,
              items: ['전자기기', '의류', '도서', '생활용품', '스포츠', '기타'].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: AppFont(category, color: Colors.white),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.changeCategory(value);
                }
              },
            ),
          ),
        ],
      );
    });
  }

  // ===== 제목 입력 섹션 (Chapter 15) =====
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppFont('제목', fontWeight: FontWeight.bold, size: 16),
        const SizedBox(height: 12),
        TextField(
          onChanged: controller.changeTitle,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          decoration: InputDecoration(
            hintText: '상품명을 입력해주세요.',
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffED7738)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ===== 가격 입력 + 체크박스 섹션 (Chapter 15·16) =====
  Widget _buildPriceSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppFont('가격', fontWeight: FontWeight.bold, size: 16),
          const SizedBox(height: 12),

          // 가격 입력 필드 (무료 나눔이면 비활성화)
          TextField(
            onChanged: controller.changePrice,
            enabled: !controller.isFree.value,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            maxLines: 1,
            decoration: InputDecoration(
              hintText: '가격을 입력해주세요.',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: controller.isFree.value
                  ? Colors.grey[800]
                  : Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xffED7738)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[800]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              prefixText: controller.isFree.value ? '₩0 ' : '₩ ',
              prefixStyle: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),

          // ===== 체크박스: 무료 나눔 (Chapter 15·16) =====
          Row(
            children: [
              Checkbox(
                value: controller.isFree.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.toggleIsFree(value);
                  }
                },
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xffED7738);
                  }
                  return Colors.grey[700];
                }),
              ),
              const Expanded(child: AppFont('무료 나눔', color: Colors.white)),
            ],
          ),

          // ===== 체크박스: 가격 제안 받기 (Chapter 15·16) =====
          Row(
            children: [
              Checkbox(
                value: controller.isPriceSuggest.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.toggleIsPriceSuggest(value);
                  }
                },
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xffED7738);
                  }
                  return Colors.grey[700];
                }),
              ),
              Expanded(
                child: AppFont(
                  '가격 제안 받기',
                  color: controller.isFree.value ? Colors.grey : Colors.white,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  // ===== 상품 상태 섹션 (Chapter 15) =====
  Widget _buildConditionSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppFont('상품 상태', fontWeight: FontWeight.bold, size: 16),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[900],
            ),
            child: DropdownButton<String>(
              value: controller.selectedCondition.value.isEmpty
                  ? null
                  : controller.selectedCondition.value,
              hint: const AppFont('상태 선택', color: Colors.grey),
              dropdownColor: Colors.grey[900],
              underline: const SizedBox(),
              isExpanded: true,
              items: ['새 상품', '거의 새 상품', '사용감 있음', '많이 사용함'].map((condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: AppFont(condition, color: Colors.white),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.changeCondition(value);
                }
              },
            ),
          ),
        ],
      );
    });
  }

  // ===== 설명 입력 섹션 (Chapter 15) =====
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppFont('설명', fontWeight: FontWeight.bold, size: 16),
        const SizedBox(height: 12),
        TextField(
          onChanged: controller.changeDescription,
          style: const TextStyle(color: Colors.white),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: '상품 설명을 입력해주세요.',
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffED7738)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ===== 거래 희망 장소 + flutter_map 섹션 (Chapter 15) =====
  Widget _buildLocationSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppFont('거래 희망 장소', fontWeight: FontWeight.bold, size: 16),
          const SizedBox(height: 12),

          // 선택된 위치 표시
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[900],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xffED7738),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppFont(
                    '지도에서 선택한 위치 (위도: ${controller.selectedLocation.value.latitude.toStringAsFixed(4)}, 경도: ${controller.selectedLocation.value.longitude.toStringAsFixed(4)})',
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const AppFont(
            '지도를 클릭하여 원하는 거래 위치를 선택해주세요',
            color: Color(0xff878B93),
            size: 12,
          ),
          const SizedBox(height: 12),

          // flutter_map 지도 위젯 (Chapter 15) - 항상 표시
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[900],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: controller.selectedLocation.value,
                  initialZoom: 15,
                  onTap: (tapPosition, latLng) {
                    controller.updateMapLocation(latLng);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.selectedLocation.value,
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffED7738),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
