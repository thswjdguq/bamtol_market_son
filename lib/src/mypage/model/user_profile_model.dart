class UserProfileModel {
  final String id;
  final String name;
  final String location;
  final int sellCount;
  final int buyCount;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.location,
    this.sellCount = 0,
    this.buyCount = 0,
  });
}
