class CommunityPostModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String authorName;
  final String authorLocation;
  final DateTime createdAt;
  final int commentCount;
  final int likeCount;

  CommunityPostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.authorName,
    required this.authorLocation,
    required this.createdAt,
    this.commentCount = 0,
    this.likeCount = 0,
  });
}
