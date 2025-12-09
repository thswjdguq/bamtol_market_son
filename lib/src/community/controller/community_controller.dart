import 'package:get/get.dart';
import '../model/community_post_model.dart';
import '../repository/community_repository.dart';

class CommunityController extends GetxController {
  final CommunityRepository _repository = CommunityRepository();
  RxList<CommunityPostModel> posts = RxList<CommunityPostModel>();
  RxBool isLoading = RxBool(false);
  RxString selectedCategory = RxString('전체');
  final List<String> categories = ['전체', '질문', '일상', '분실/실종', '맛집'];

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  Future<void> loadPosts() async {
    isLoading(true);
    try {
      final loaded = await _repository.getPosts(
        category: selectedCategory.value == '전체'
            ? null
            : selectedCategory.value,
      );
      posts.assignAll(loaded);
    } finally {
      isLoading(false);
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    loadPosts();
  }
}
