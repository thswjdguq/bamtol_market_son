import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  RxBool isLogined = false.obs;

  void authCheck() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    isLogined(false);
  }

  void logout() {
    isLogined(false);
  }
}
