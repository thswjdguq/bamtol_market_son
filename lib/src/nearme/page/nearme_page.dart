import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/components/app_font.dart';
import '../controller/nearme_controller.dart';

class NearMePage extends StatelessWidget {
  const NearMePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NearMeController>();

    return Scaffold(
      backgroundColor: const Color(0xff212123),
      appBar: AppBar(
        title: const AppFont(
          '내근처',
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
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.places.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Color(0xff3C3C3E), height: 24),
          itemBuilder: (context, index) {
            final place = controller.places[index];
            return Row(
              children: [
                const Icon(Icons.store, color: Color(0xff878B93), size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppFont(
                        place.name,
                        color: Colors.white,
                        size: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      AppFont(
                        '${place.address} · ${place.distance}km',
                        color: const Color(0xff878B93),
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
