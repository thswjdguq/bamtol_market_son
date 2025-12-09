import '../model/community_post_model.dart';

class CommunityRepository {
  final List<CommunityPostModel> _posts = [];

  CommunityRepository() {
    final now = DateTime.now();
    _posts.addAll([
      CommunityPostModel(
        id: 'p1',
        title: '제주 맛집 추천해주세요!',
        content: '고기국수 맛있는 곳?',
        category: '질문',
        authorName: '여행러버',
        authorLocation: '아라동',
        createdAt: now.subtract(const Duration(hours: 2)),
        commentCount: 12,
        likeCount: 8,
      ),
      CommunityPostModel(
        id: 'p2',
        title: '한라산 등산 다녀왔어요',
        content: '날씨 좋았어요!',
        category: '일상',
        authorName: '산을좋아해',
        authorLocation: '연동',
        createdAt: now.subtract(const Duration(hours: 5)),
        commentCount: 23,
        likeCount: 45,
      ),
      CommunityPostModel(
        id: 'p3',
        title: '고양이 찾아요',
        content: '흰색 고양이',
        category: '분실/실종',
        authorName: '고양이집사',
        authorLocation: '노형동',
        createdAt: now.subtract(const Duration(hours: 8)),
        commentCount: 15,
        likeCount: 20,
      ),
    ]);
  }

  Future<List<CommunityPostModel>> getPosts({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category == null || category == '전체') return List.from(_posts);
    return _posts.where((p) => p.category == category).toList();
  }
}
