import 'package:bamtol_market_app/src/product/model/product_model.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:get/get.dart';

/// ProductDetailController
/// 상품 상세 페이지의 상태 관리 (Chapter 20)
/// 찜하기, 조회수, 판매자 정보 등을 관리합니다.
class ProductDetailController extends GetxController {
  final LocalMockProductRepository _repository = LocalMockProductRepository();

  late Rx<ProductModel> product = Rx<ProductModel>(
    ProductModel(title: '로딩 중...', locationLabel: ''),
  );

  RxBool isLiked = RxBool(false);
  RxInt likeCount = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    // 라우트에서 전달받은 상품 ID로 상품 정보 로드
    final String? productId = Get.parameters['id'];
    if (productId != null) {
      loadProduct(productId);
    }
  }

  /// 상품 정보 로드
  Future<void> loadProduct(String productId) async {
    try {
      // 조회수 증가
      await _repository.incrementViewCount(productId);

      final loadedProduct = _repository.getProductById(productId);
      if (loadedProduct != null) {
        product(loadedProduct);
        likeCount(loadedProduct.likers.length);
        // 현재 사용자가 찜했는지 확인 (목업: current_user_123)
        isLiked(loadedProduct.likers.contains('current_user_123'));
      }
    } catch (e) {
      Get.snackbar('오류', '상품 정보를 불러올 수 없습니다.');
    }
  }

  /// 찜하기 토글 (Chapter 20)
  Future<void> toggleLike() async {
    try {
      await _repository.toggleLike(product.value.id, 'current_user_123');

      // 상품 정보 새로고침
      await loadProduct(product.value.id);
    } catch (e) {
      Get.snackbar('오류', '찜하기 처리에 실패했습니다.');
    }
  }

  /// 채팅 시작
  void startChat() {
    Get.snackbar('채팅', '판매자와 채팅을 시작합니다.');
    // 실제 구현 시: Get.toNamed('/chat/$productId')
  }

  /// 공유하기
  void share() {
    Get.snackbar('공유', '상품을 공유했습니다.');
  }
}
