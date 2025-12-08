import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/btn.dart';
import 'package:bamtol_market_app/src/user/login/signup/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class RegionSelectPage extends GetView<SignupController> {
  const RegionSelectPage({super.key});

  // 지역 목록
  static const List<String> regions = ['아라동', '연동', '노형동', '삼도동'];

  // 지역별 좌표 (제주도)
  static final Map<String, LatLng> regionCoordinates = {
    '아라동': const LatLng(33.4734, 126.4836),
    '연동': const LatLng(33.4890, 126.4783),
    '노형동': const LatLng(33.4785, 126.4518),
    '삼도동': const LatLng(33.5102, 126.5219),
  };

  // 제주도 중심 좌표
  static const LatLng jejuCenter = LatLng(33.4996, 126.5312);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // 상단 제목
            const AppFont(
              '우리 동네 설정',
              fontWeight: FontWeight.bold,
              size: 24,
              align: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Flutter Map 위젯
            Obx(() {
              // 선택된 지역의 좌표 가져오기 (선택 안 되어 있으면 제주도 중심)
              final selectedRegion = controller.region.value;
              final center = selectedRegion.isNotEmpty
                  ? regionCoordinates[selectedRegion]!
                  : jejuCenter;

              return Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: selectedRegion.isNotEmpty ? 14 : 12,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.bamtol.market.app',
                      ),
                      // 모든 지역에 마커 표시
                      MarkerLayer(
                        markers: regions.map((region) {
                          final isSelected = selectedRegion == region;
                          final coordinate = regionCoordinates[region]!;

                          return Marker(
                            point: coordinate,
                            width: isSelected ? 50 : 40,
                            height: isSelected ? 50 : 40,
                            child: Column(
                              children: [
                                Container(
                                  width: isSelected ? 40 : 30,
                                  height: isSelected ? 40 : 30,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xffED7738)
                                        : Colors.grey.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(
                                      isSelected ? 20 : 15,
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: isSelected ? 3 : 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: isSelected ? 24 : 18,
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffED7738),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: AppFont(
                                      region,
                                      size: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            // 지역 선택 버튼들
            Expanded(
              child: ListView.builder(
                itemCount: regions.length,
                itemBuilder: (context, index) {
                  final region = regions[index];
                  return Obx(() {
                    final isSelected = controller.region.value == region;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          controller.setRegion(region);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xffED7738).withOpacity(0.2)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xffED7738)
                                  : Colors.grey.withOpacity(0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppFont(
                            region,
                            color: isSelected
                                ? const Color(0xffED7738)
                                : Colors.white,
                            size: 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
      // 하단 버튼
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Obx(() {
          final isActive = controller.region.value.isNotEmpty;

          return Btn(
            onTap: () async {
              if (!isActive) {
                Get.snackbar(
                  '알림',
                  '동네를 선택해주세요',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.grey[700],
                  colorText: Colors.white,
                );
                return;
              }
              final result = await controller.signup();
              if (result != null) {
                Get.offAllNamed('/home');
              }
            },
            padding: const EdgeInsets.symmetric(vertical: 17),
            color: isActive
                ? const Color(0xffED7738)
                : Colors.grey.withOpacity(0.9),
            child: const AppFont(
              '위치 저장하고 회원가입',
              align: TextAlign.center,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }
}
