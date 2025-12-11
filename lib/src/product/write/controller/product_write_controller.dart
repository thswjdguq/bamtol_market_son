import 'package:bamtol_market_app/src/product/model/product_model.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:bamtol_market_app/src/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

/// ProductWriteController
/// 상품 등록 화면의 모든 상태 관리
/// Chapter 20까지 모든 기능 포함 (이미지, 지도, 체크박스, 유효성 검사)
class ProductWriteController extends GetxController {
  final LocalMockProductRepository _repository = LocalMockProductRepository();

  // ===== 상태 변수 (Chapter 15) - 이미지 =====
  RxList<String> imageUrls = RxList<String>();

  // ===== 상태 변수 (Chapter 15) - 텍스트 입력 =====
  RxString title = RxString('');
  RxString description = RxString('');
  RxString priceText = RxString('');

  // ===== 상태 변수 (Chapter 15·16) - 체크박스 로직 =====
  /// 무료 나눔 여부 - true면 가격 필드 비활성화, price = 0
  RxBool isFree = RxBool(false);

  /// 가격 제안 받기 - 가격 필드와 함께 토글됨
  RxBool isPriceSuggest = RxBool(false);

  // ===== 상태 변수 (Chapter 15) - 위치/지도 =====
  /// 위치 라벨 - 자동으로 좌표 기반으로 생성
  RxString locationLabel = RxString('지도에서 선택한 위치');

  /// flutter_map 위치 선택 (lat, lng)
  Rx<LatLng> selectedLocation = Rx<LatLng>(
    LatLng(33.4996, 126.5312), // 기본값: 제주 아라동
  );

  /// 지도 표시/숨기기 상태 - 기본값 true (항상 표시)
  RxBool isMapVisible = RxBool(true);

  // ===== 상태 변수 (Chapter 15) - 드롭다운 =====
  RxString selectedCategory = RxString('');
  RxString selectedCondition = RxString('');

  // ===== 상태 변수 (Chapter 16) - 유효성 검사 =====
  RxBool isPossibleSubmit = RxBool(false);

  // ===== 로딩 상태 =====
  RxBool isLoading = RxBool(false);

  // ===== 상수 =====
  static const int maxImageCount = 10;
  static const int minTitleLength = 1;
  static const int minPriceValue = 0;

  @override
  void onInit() {
    super.onInit();
    // 모든 입력값이 변경될 때마다 유효성 검사 실행 (Debounce 적용)
    debounce(
      imageUrls,
      (_) => _validateForm(),
      time: const Duration(milliseconds: 100),
    );
    debounce(
      title,
      (_) => _validateForm(),
      time: const Duration(milliseconds: 100),
    );
    debounce(
      priceText,
      (_) => _validateForm(),
      time: const Duration(milliseconds: 100),
    );
    debounce(
      isFree,
      (_) => _validateForm(),
      time: const Duration(milliseconds: 100),
    );
    debounce(
      isPriceSuggest,
      (_) => _validateForm(),
      time: const Duration(milliseconds: 100),
    );
    debounce(
      selectedCategory,
      (_) => _validateForm(),
      time: const Duration(milliseconds: 100),
    );
    debounce(
      selectedCondition,
      (_) => _validateForm(),
      time: const Duration(milliseconds: 100),
    );
    debounce(
      selectedLocation,
      (_) => _validateForm(),
      time: const Duration(milliseconds: 100),
    );
  }

  // ===== Chapter 15: 이미지 관리 메서드 =====

  /// 이미지 추가
  void addImage(String imageUrl) {
    if (imageUrls.length < maxImageCount) {
      imageUrls.add(imageUrl);
      _validateForm();
    }
  }

  /// 이미지 제거
  void removeImage(int index) {
    if (index >= 0 && index < imageUrls.length) {
      imageUrls.removeAt(index);
      _validateForm();
    }
  }

  /// 이미지 URL 리스트 업데이트 (이미지 피커에서 여러 장 선택 시)
  void setImages(List<String> urls) {
    final limitedUrls = urls.take(maxImageCount).toList();
    imageUrls.assignAll(limitedUrls);
    _validateForm();
  }

  /// 이미지가 최대치에 도달했는지 확인
  bool isMaxImageReached() {
    return imageUrls.length >= maxImageCount;
  }

  // ===== Chapter 15: 텍스트 입력 메서드 =====

  void changeTitle(String value) {
    title(value);
  }

  void changeDescription(String value) {
    description(value);
  }

  void changePrice(String value) {
    // 숫자만 허용
    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    priceText(numericValue);
  }

  // ===== Chapter 15·16: 체크박스 로직 =====

  /// 무료 나눔 체크 토글
  /// true일 때 가격 필드는 자동으로 0이 되고 비활성화됨
  void toggleIsFree(bool value) {
    isFree(value);
    if (value) {
      priceText('0');
      isPriceSuggest(false); // 무료 나눔 선택 시 가격 제안은 자동으로 false
    }
    _validateForm();
  }

  /// 가격 제안 받기 체크 토글
  /// 이 옵션은 가격이 정해지지 않은 상태일 때만 활성화 가능
  void toggleIsPriceSuggest(bool value) {
    if (!isFree.value) {
      isPriceSuggest(value);
      _validateForm();
    }
  }

  // ===== Chapter 15: 위치/지도 관련 메서드 =====

  void changeLocation(String value) {
    locationLabel(value);
  }

  /// 지도에서 위치 선택 (LatLng 업데이트)
  void updateMapLocation(LatLng location) {
    selectedLocation(location);
    // locationLabel 자동 업데이트
    locationLabel(
      '지도 위치 (${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)})',
    );
  }

  /// 지도 표시 토글
  void toggleMapVisibility() {
    isMapVisible(!isMapVisible.value);
  }

  // ===== Chapter 15: 드롭다운 관련 메서드 =====

  void changeCategory(String value) {
    selectedCategory(value);
  }

  void changeCondition(String value) {
    selectedCondition(value);
  }

  // ===== Chapter 16: 유효성 검사 =====

  /// 폼 유효성 검사
  /// isPossibleSubmit 업데이트
  void _validateForm() {
    final bool isValid = _isFormValid();
    isPossibleSubmit(isValid);
  }

  /// 폼이 유효한지 판단
  /// Chapter 16: 필수 항목 검사 (이미지는 선택사항)
  bool _isFormValid() {
    // 1. 제목 필수 (공백 제거 후 1글자 이상)
    if (title.value.trim().isEmpty) {
      return false;
    }

    // 2. 무료 나눔이 아닐 경우 가격 필수
    if (!isFree.value) {
      if (priceText.value.isEmpty) {
        return false;
      }
      final price = int.tryParse(priceText.value);
      if (price == null || price < minPriceValue) {
        return false;
      }
    }

    // 3. 카테고리 필수
    if (selectedCategory.value.isEmpty) {
      return false;
    }

    // 4. 상품 상태 필수
    if (selectedCondition.value.isEmpty) {
      return false;
    }

    // 5. 위치는 기본값이 있으므로 검사 불필요

    return true;
  }

  /// 현재 유효성 검사 상태 반환 (검사 메시지용)
  String getValidationMessage() {
    if (title.value.trim().isEmpty) {
      return '상품명을 입력해주세요.';
    }
    if (!isFree.value && priceText.value.isEmpty) {
      return '가격을 입력해주세요.';
    }
    if (priceText.value.isNotEmpty) {
      final price = int.tryParse(priceText.value);
      if (price == null || price < minPriceValue) {
        return '올바른 가격을 입력해주세요.';
      }
    }
    if (selectedCategory.value.isEmpty) {
      return '카테고리를 선택해주세요.';
    }
    if (selectedCondition.value.isEmpty) {
      return '상품 상태를 선택해주세요.';
    }
    return '';
  }

  // ===== Chapter 15·17: 상품 등록 =====

  /// 상품 등록 (제출)
  /// Chapter 15: 폼 데이터를 ProductModel로 변환하여 저장
  /// Chapter 16: 유효성 검사 후 진행
  /// Chapter 17: 등록 후 홈으로 이동 (loadInitial 트리거)
  Future<bool> submit() async {
    // 유효성 검사 (Chapter 16)
    if (!_isFormValid()) {
      // GetX 라우트 진행 중엔 snackbar 사용 불가 → 스킵
      return false;
    }

    isLoading(true);

    try {
      // 가격 계산
      final int price = isFree.value ? 0 : (int.tryParse(priceText.value) ?? 0);

      // ProductModel 생성 (Chapter 20: 판매자 정보 추가)
      final product = ProductModel(
        title: title.value.trim(),
        description: description.value.trim(),
        price: price,
        isFree: isFree.value,
        isPriceSuggest: isPriceSuggest.value,
        locationLabel: locationLabel.value,
        latitude: selectedLocation.value.latitude,
        longitude: selectedLocation.value.longitude,
        thumbnailUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
        imageUrls: imageUrls.toList(),
        category: selectedCategory.value,
        condition: selectedCondition.value,
        // Chapter 20: 판매자 정보 설정 (목업)
        sellerName: '나(현재 사용자)',
        sellerId: 'current_user_123',
        viewCount: 0,
        likers: [],
      );

      // Repository를 통해 저장 (목업 데이터베이스)
      await _repository.addProduct(product);

      // HomeController 초기화하여 새 상품 로드
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.loadInitial();
      }

      // 홈으로 이동
      Get.offAllNamed('/home');

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading(false);
    }
  }

  // ===== 초기화 =====

  /// 폼 초기화 (등록 후 또는 취소 시)
  void resetForm() {
    imageUrls.clear();
    title('');
    description('');
    priceText('');
    isFree(false);
    isPriceSuggest(false);
    locationLabel('지도에서 선택한 위치');
    selectedLocation(LatLng(33.4996, 126.5312));
    selectedCategory('');
    selectedCondition('');
    isMapVisible(true); // 지도 항상 표시
    isPossibleSubmit(false);
  }
}
