import 'package:get/get.dart';
import '../model/user_profile_model.dart';
import '../repository/mypage_repository.dart';

class MyPageController extends GetxController {
  final MyPageRepository _repository = MyPageRepository();
  Rx<UserProfileModel?> profile = Rx<UserProfileModel?>(null);
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading(true);
    try {
      final loaded = await _repository.getUserProfile();
      profile.value = loaded;
    } finally {
      isLoading(false);
    }
  }
}
