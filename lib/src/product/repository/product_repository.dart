import 'package:bamtol_market_app/src/product/model/product_model.dart';

/// LocalMockProductRepository
/// Firebase 대신 메모리 기반 목업 저장소
/// Chapter 20까지 모든 기능 지원 (페이징, 찜하기, 조회수)
class LocalMockProductRepository {
  static final LocalMockProductRepository _instance =
      LocalMockProductRepository._internal();

  factory LocalMockProductRepository() {
    return _instance;
  }

  LocalMockProductRepository._internal();

  final List<ProductModel> _products = [];

  /// 더미 데이터 생성 (Chapter 20 수준)
  void generateDummyData() {
    if (_products.isNotEmpty) return;

    final dummyProducts = [
      ProductModel(
        title: 'AirPods Pro 미개봉',
        description: '새 상품이며 미개봉 상태입니다. 최신 버전입니다.',
        price: 350000,
        locationLabel: '아라동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1606841837239-c5a1a4a07af7?w=500&auto=format&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1606841837239-c5a1a4a07af7?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=800&auto=format&fit=crop',
        ],
        category: '전자기기',
        condition: '새 상품',
        sellerName: '개발하는남자',
        sellerId: 'seller_1',
        viewCount: 245,
      ),
      ProductModel(
        title: 'MacBook Pro 13인치',
        description: '2022년형, 약간의 사용감이 있습니다. A급 상태입니다.',
        price: 1200000,
        locationLabel: '아라동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&auto=format&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop',
        ],
        category: '전자기기',
        condition: '사용감 있음',
        sellerName: '기술애호가',
        sellerId: 'seller_2',
        viewCount: 512,
      ),
      ProductModel(
        title: '아이폰 14 Pro Max 골드',
        description: '거의 새 상품 상태입니다. 필름 붙은 상태로 거의 사용하지 않았습니다.',
        price: 1000000,
        locationLabel: '연동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&auto=format&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800&auto=format&fit=crop',
        ],
        category: '전자기기',
        condition: '거의 새 상품',
        sellerName: '핸드폰판매자',
        sellerId: 'seller_3',
        viewCount: 789,
      ),
      ProductModel(
        title: '무선 충전기 5개 세트',
        description: '나눔입니다. 사용하지 않아서 새로 드립니다.',
        price: 0,
        isFree: true,
        locationLabel: '노형동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500&auto=format&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=800&auto=format&fit=crop',
        ],
        category: '전자기기',
        condition: '거의 새 상품',
        sellerName: '따뜻한마음',
        sellerId: 'seller_4',
        viewCount: 156,
      ),
      ProductModel(
        title: '가죽 가방',
        description: '고급 이탈리아 가죽 사용, 상태 좋습니다. 명품입니다.',
        price: 150000,
        locationLabel: '삼도동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=500&auto=format&fit=crop',
        imageUrls: [
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&auto=format&fit=crop',
        ],
        category: '의류',
        condition: '거의 새 상품',
        sellerName: '패션전문가',
        sellerId: 'seller_5',
        viewCount: 334,
      ),
      ProductModel(
        title: '책장',
        description: '화이트 우드 컬러, 깨끗합니다. 이사로 인해 판매합니다.',
        price: 80000,
        locationLabel: '아라동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1594620302200-9a762244a156?w=500&auto=format&fit=crop',
        category: '가구',
        condition: '사용감 있음',
        sellerName: '가구판매자',
        sellerId: 'seller_6',
        viewCount: 123,
      ),
      ProductModel(
        title: '플러터 완벽 가이드',
        description: '거의 읽지 않은 상태입니다. 개발 공부에 좋은 책입니다.',
        price: 25000,
        locationLabel: '아라동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500&auto=format&fit=crop',
        category: '도서',
        condition: '거의 새 상품',
        sellerName: '책좋아하는분',
        sellerId: 'seller_7',
        viewCount: 89,
      ),
      ProductModel(
        title: '스탠드 조명',
        description: 'LED 스탠드, 밝기 조절 가능합니다. 새로 산 거 거의 안 쓴 거',
        price: 35000,
        locationLabel: '연동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=500&auto=format&fit=crop',
        category: '가구',
        condition: '새 상품',
        sellerName: '조명판매점',
        sellerId: 'seller_8',
        viewCount: 267,
      ),
      ProductModel(
        title: '런닝화',
        description: 'Nike Air Zoom, 거의 새 상품입니다. 운동화 프리미엄급입니다.',
        price: 90000,
        locationLabel: '노형동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop',
        category: '의류',
        condition: '거의 새 상품',
        sellerName: '스포츠용품점',
        sellerId: 'seller_9',
        viewCount: 445,
      ),
      ProductModel(
        title: '캠핑 텐트',
        description: '4인용 텐트, 사용감 있습니다. 야외활동에 좋습니다.',
        price: 120000,
        locationLabel: '삼도동',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=500&auto=format&fit=crop',
        category: '기타',
        condition: '사용감 있음',
        sellerName: '캠핑매니아',
        sellerId: 'seller_10',
        viewCount: 198,
      ),
    ];

    _products.addAll(dummyProducts);
  }

  /// 상품 추가 (최신순으로 맨 앞에 삽입)
  Future<void> addProduct(ProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _products.insert(0, product);
  }

  /// 상품 목록 조회 (페이지네이션)
  Future<List<ProductModel>> getProducts({
    int offset = 0,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final int endIndex = offset + limit;
    if (offset >= _products.length) {
      return [];
    }

    final int actualEndIndex = endIndex > _products.length
        ? _products.length
        : endIndex;

    return _products.sublist(offset, actualEndIndex);
  }

  /// 전체 상품 개수
  int getProductCount() {
    return _products.length;
  }

  /// 특정 상품 조회
  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 상품 업데이트 (찜하기 등)
  Future<void> updateProduct(String id, ProductModel updatedProduct) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _products.indexWhere((product) => product.id == id);
    if (index != -1) {
      _products[index] = updatedProduct;
    }
  }

  /// 상품 삭제
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _products.removeWhere((product) => product.id == id);
  }

  /// 찜하기 토글 (Chapter 20)
  Future<void> toggleLike(String productId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final product = getProductById(productId);
    if (product != null) {
      final updatedLikers = List<String>.from(product.likers);
      if (updatedLikers.contains(userId)) {
        updatedLikers.remove(userId);
      } else {
        updatedLikers.add(userId);
      }

      final updated = product.copyWith(likers: updatedLikers);
      await updateProduct(productId, updated);
    }
  }

  /// 조회수 증가 (Chapter 20)
  Future<void> incrementViewCount(String productId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final product = getProductById(productId);
    if (product != null) {
      final updated = product.copyWith(viewCount: product.viewCount + 1);
      await updateProduct(productId, updated);
    }
  }
}
