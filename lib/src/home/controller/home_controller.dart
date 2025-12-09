import 'package:bamtol_market_app/src/product/model/product_model.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// HomeController
/// 홈 화면의 상품 리스트와 페이지네이션 관리
/// Chapter 20: 조회수, 찜하기, 판매자 정보 포함
class HomeController extends GetxController {
  final LocalMockProductRepository _repository = LocalMockProductRepository();

  // ===== 상태 변수 =====
  RxList<ProductModel> products = RxList<ProductModel>();
  RxBool isLoading = RxBool(false);

  // 카테고리 관련
  final List<String> categories = [
    '전체',
    '전자기기',
    '의류',
    '가구',
    '도서',
    '스포츠/레저',
    '생활용품',
    '유아용품',
    '반려동물',
    '기타',
  ];
  RxString selectedCategory = RxString('전체');

  // 카테고리 아이콘 매핑
  IconData getCategoryIcon(String category) {
    switch (category) {
      case '전체':
        return Icons.apps;
      case '전자기기':
        return Icons.devices;
      case '의류':
        return Icons.checkroom;
      case '가구':
        return Icons.chair;
      case '도서':
        return Icons.menu_book;
      case '스포츠/레저':
        return Icons.sports_basketball;
      case '생활용품':
        return Icons.shopping_basket;
      case '유아용품':
        return Icons.child_care;
      case '반려동물':
        return Icons.pets;
      case '기타':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }

  // 검색 관련
  RxString searchQuery = RxString('');

  // 페이지네이션 관련
  late int offset = 0;
  late int limit = 10;
  late bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    // 더미 데이터 생성
    _repository.generateDummyData();
    // 초기 로드
    loadInitial();
  }

  /// 카테고리 변경
  void changeCategory(String category) {
    selectedCategory.value = category;
    loadInitial();
  }

  /// 검색어 변경
  void searchProducts(String query) {
    searchQuery.value = query;
    loadInitial();
  }

  /// 검색어 초기화
  void clearSearch() {
    searchQuery.value = '';
    loadInitial();
  }

  /// 초기 로드
  /// offset을 0으로 초기화하고 첫 페이지 데이터 로드
  Future<void> loadInitial() async {
    isLoading(true);
    offset = 0;
    products.clear();

    try {
      final loadedProducts = await _repository.getProducts(
        offset: offset,
        limit: limit,
        category: selectedCategory.value == '전체'
            ? null
            : selectedCategory.value,
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      products.assignAll(loadedProducts);

      // hasMore 계산: 로드한 데이터가 limit과 같으면 더 있을 수 있음
      hasMore = loadedProducts.length >= limit;

      offset += limit;
    } catch (e) {
      Get.snackbar(
        '오류',
        '데이터 로드에 실패했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  /// 더 로드 (무한 스크롤)
  /// 페이지네이션을 통해 다음 페이지 데이터 로드
  Future<void> loadMore() async {
    // 이미 로드 중이거나 더 이상의 데이터가 없으면 반환
    if (isLoading.value || !hasMore) {
      return;
    }

    isLoading(true);

    try {
      final loadedProducts = await _repository.getProducts(
        offset: offset,
        limit: limit,
        category: selectedCategory.value == '전체'
            ? null
            : selectedCategory.value,
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (loadedProducts.isEmpty) {
        hasMore = false;
      } else {
        products.addAll(loadedProducts);
        hasMore = loadedProducts.length >= limit;
        offset += limit;
      }
    } catch (e) {
      Get.snackbar(
        '오류',
        '추가 데이터 로드에 실패했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  /// 찜하기 토글 (Chapter 20)
  Future<void> toggleLike(String productId, String userId) async {
    try {
      await _repository.toggleLike(productId, userId);
      // 로컬 상태 업데이트
      await loadInitial();
    } catch (e) {
      Get.snackbar('오류', '찜하기 처리에 실패했습니다: $e');
    }
  }

  /// 조회수 증가 (Chapter 20)
  Future<void> incrementViewCount(String productId) async {
    try {
      await _repository.incrementViewCount(productId);
    } catch (e) {
      // 조회수 증가 실패해도 무시
    }
  }

  /// 새로운 상품이 등록되었을 때 호출
  /// 홈 화면으로 돌아올 때 최신 데이터 다시 로드
  Future<void> refreshList() async {
    await loadInitial();
  }

  /// 상품 총 개수
  int getProductCount() {
    return _repository.getProductCount();
  }
}
