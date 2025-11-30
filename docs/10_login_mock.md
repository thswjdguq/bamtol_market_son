Chapter 10 — 로그인(Mock) 기능 구현
1. 목표

Firebase 없이 로그인 기능을 목업(Mock) 으로 구현한다.
Google / Apple 로그인은 실제 인증 절차 없이, 딜레이 후 홈 화면으로 이동하는 방식으로 처리한다.

2. LoginController

목업 로그인 처리 전용 컨트롤러.

class LoginController extends GetxController {
  void googleLogin() async {
    await Future.delayed(Duration(milliseconds: 700));
    Get.offNamed('/home');
  }

    void appleLogin() async {
    await Future.delayed(Duration(milliseconds: 700));
    Get.offNamed('/home');
  }
}

3. LoginPage (UI)

UI에서 Google/Apple 로그인 버튼을 눌렀을 때
controller.googleLogin(), controller.appleLogin() 메서드를 호출한다.

Btn(
  onTap: controller.googleLogin,
  child: Row(
    children: [
      Image.asset('assets/images/google.png'),
      SizedBox(width: 30),
      AppFont('Google로 계속하기'),
    ],
  ),
)

Btn(
  onTap: controller.appleLogin,
  child: Row(
    children: [
      Image.asset('assets/images/apple.png'),
      SizedBox(width: 30),
      AppFont('Apple로 계속하기'),
    ],
  ),
)

4. AuthenticationController

앱 전체의 로그인 상태를 Mock 데이터로 관리한다.

class AuthenticationController extends GetxController {
  RxBool isLogined = false.obs;

  void authCheck() async {
    await Future.delayed(Duration(milliseconds: 1000));
    isLogined(false); // 항상 false → Splash 이후 Login으로 이동
  }

  void login() => isLogined(true);
  void logout() => isLogined(false);
}

5. 라우팅 구조

로그인이 구현된 라우트 흐름은 다음과 같다.

/splash  → 로그인 상태 체크
/login   → LoginPage
/home    → HomePage


Splash → 항상 isLogined(false) → LoginPage로 이동