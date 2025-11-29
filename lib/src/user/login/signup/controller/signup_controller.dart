import 'package:get/get.dart';

class SignupController extends GetxController {
  // 닉네임 상태
  RxString userNickName = ''.obs;

  // 닉네임 사용 가능 여부 (목업용)
  RxBool isPossibleUseNickName = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 닉네임 입력이 바뀔 때마다 0.5초 뒤에 검사
    debounce<String>(
      userNickName,
      checkDuplicationNickName,
      time: const Duration(milliseconds: 500),
    );
  }

  // 닉네임 변경
  void changeNickName(String nickName) {
    userNickName(nickName);
  }

  //  목업용 닉네임 검사 (DB 안 쓰고 규칙만 간단히 적용)
  void checkDuplicationNickName(String value) async {
    final nick = value.trim();

    if (nick.isEmpty) {
      isPossibleUseNickName(false);
      return;
    }

    // 예시 규칙: 2글자 이상이면 "사용 가능"이라고 가정
    if (nick.length >= 2) {
      isPossibleUseNickName(true);
    } else {
      isPossibleUseNickName(false);
    }

    // 원래는 여기서 _userRepository.checkDuplicationNickName() 호출했겠지만
    // 지금은 파이어베이스 / DB 안 쓰는 목업이라 이렇게만 처리
  }

  //  목업용 회원가입
  Future<String?> signup() async {
    if (!isPossibleUseNickName.value) {
      return null;
    }

    // 진짜 DB 저장 대신, 그냥 약간의 딜레이만 넣어서 "네트워크 느낌"만
    await Future.delayed(const Duration(milliseconds: 700));

    // 실제로는 아무데도 안 저장하고,
    // "회원가입 성공"이라고 가정해서 non-null 값만 리턴
    return 'mock_signup_success';
  }
}
