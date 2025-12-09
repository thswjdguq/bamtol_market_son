import 'package:get/get.dart';
import '../model/place_model.dart';
import '../repository/place_repository.dart';

class NearMeController extends GetxController {
  final PlaceRepository _repository = PlaceRepository();
  RxList<PlaceModel> places = RxList<PlaceModel>();
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    isLoading(true);
    try {
      final loaded = await _repository.getPlaces();
      places.assignAll(loaded);
    } finally {
      isLoading(false);
    }
  }
}
