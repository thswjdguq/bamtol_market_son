import '../model/place_model.dart';

class PlaceRepository {
  final List<PlaceModel> _places = [
    PlaceModel(
      id: '1',
      name: '제주 고기국수',
      category: '맛집',
      address: '아라동 123',
      distance: 0.3,
    ),
    PlaceModel(
      id: '2',
      name: '카페 오션뷰',
      category: '카페',
      address: '연동 45',
      distance: 0.5,
    ),
    PlaceModel(
      id: '3',
      name: '밝은 내과',
      category: '병원',
      address: '노형동 67',
      distance: 0.8,
    ),
  ];

  Future<List<PlaceModel>> getPlaces({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category == null || category == '전체') return List.from(_places);
    return _places.where((p) => p.category == category).toList();
  }
}
