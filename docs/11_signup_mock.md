Chapter 11 — 회원가입(Mock) 기능 구현
1. 목표

DB 또는 Firebase 없이 닉네임 중복 체크 + 회원가입 전체 흐름을 목업(Mock) 으로 구현한다.

닉네임은 2자 이상이면 사용 가능한 것으로 처리

회원가입 요청은 딜레이 후 항상 성공값 반환

2. SignupController

닉네임 검증 + debounce(500ms) 적용 + 회원가입 Mock 처리.

class SignupController extends GetxController {
  RxString userNickName = ''.obs;
  RxBool isPossibleUseNickName = false.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(
      userNickName,
      checkDuplicationNickName,
      time: Duration(milliseconds: 500),
    );
  }

  void checkDuplicationNickName(String value) {
    isPossibleUseNickName(value.trim().length >= 2);
  }

  Future<String?> signup() async {
    await Future.delayed(Duration(milliseconds: 700));
    return 'mock_signup_success';
  }
}

3. SignupPage (UI 구현 요소)
● TextField 입력

입력 시 controller.userNickName(value) 로 상태 업데이트

500ms debounce 후 닉네임 검증 실행

● 닉네임 중복 체크 표시

isPossibleUseNickName 값에 따라

가능: 초록색 표시

불가능: 빨간색 에러 메시지 표시

● "회원가입" 버튼 활성화

isPossibleUseNickName == true 일 때만 활성화

버튼 클릭 → controller.signup() 실행 → 성공 시 다음 라우트 이동

4. 라우팅

회원가입 화면은 다음 라우트를 사용한다:

/signup/:uid


예시:

/signup/12345


소셜 로그인 후 Firebase 유저 ID 대신
목업 uid를 전달받는 구조 유지

:uid 를 SignUpPage로 넘겨 UI에서 사용 가능