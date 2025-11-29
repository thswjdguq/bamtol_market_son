import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  // 🔥 구글 로그인 (목업)
  Future<void> googleLogin() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500)); // 가짜 로딩
    isLoading.value = false;

    // 로그인 성공했다고 가정
    Get.offAllNamed('/home');
  }

  // 🔥 애플 로그인 (목업)
  Future<void> appleLogin() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500)); // 가짜 로딩
    isLoading.value = false;

    // 로그인 성공했다고 가정
    Get.offAllNamed('/home');
  }
}
