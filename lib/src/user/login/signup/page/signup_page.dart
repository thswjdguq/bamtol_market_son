import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/btn.dart';
import '../controller/signup_controller.dart'; // 🔥 상대 경로 import
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends GetWidget<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 99,
              height: 116,
              child: Image.asset('assets/images/logo_simbol.png'),
            ),
            const SizedBox(height: 35),
            Obx(
              () => TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '닉네임',
                  // 닉네임이 비어있으면 에러 X, 값 있고 불가능할 때만 에러
                  errorText:
                      controller.userNickName.value.isEmpty ||
                          controller.isPossibleUseNickName.value
                      ? null
                      : '사용할 수 없는 닉네임입니다.',
                  hintStyle: const TextStyle(color: Color(0xff6D7179)),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff6D7179)),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff6D7179)),
                  ),
                ),
                onChanged: controller.changeNickName,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Obx(() {
          final isActive =
              controller.userNickName.value.isNotEmpty &&
              controller.isPossibleUseNickName.value;

          return Btn(
            onTap: () async {
              if (!isActive) return;
              final result = await controller.signup();
              if (result != null) {
                Get.offNamed('/');
              }
            },
            padding: const EdgeInsets.symmetric(vertical: 17),
            color: isActive
                ? const Color(0xffED7738)
                : Colors.grey.withOpacity(0.9),
            child: const AppFont(
              '회원가입',
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
