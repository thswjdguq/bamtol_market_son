import '../model/user_profile_model.dart';

class MyPageRepository {
  final UserProfileModel _user = UserProfileModel(
    id: 'user_1',
    name: '밤톨러버',
    location: '아라동',
    sellCount: 15,
    buyCount: 8,
  );

  Future<UserProfileModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _user;
  }
}
