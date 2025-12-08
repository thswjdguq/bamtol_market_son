import 'package:uuid/uuid.dart';

/// ProductModel
/// 상품 정보를 담는 데이터 모델
/// Chapter 15~20: 모든 필드 포함 (이미지, 지도, 가격, 찜하기, 조회수)
class ProductModel {
  final String id;
  final String title;
  final String? description;
  final int? price;
  final bool isFree;
  final bool isPriceSuggest;
  final String locationLabel;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String? thumbnailUrl;
  final List<String> imageUrls;
  final String? category;
  final String? condition;
  final String? sellerName; // Chapter 20: 판매자 이름
  final String? sellerId; // Chapter 20: 판매자 ID
  final int viewCount; // Chapter 20: 조회수
  final List<String> likers; // Chapter 20: 찜한 사용자 ID 목록

  ProductModel({
    String? id,
    required this.title,
    this.description,
    this.price,
    this.isFree = false,
    this.isPriceSuggest = false,
    required this.locationLabel,
    this.latitude = 33.4996,
    this.longitude = 126.5312,
    DateTime? createdAt,
    this.thumbnailUrl,
    List<String>? imageUrls,
    this.category,
    this.condition,
    this.sellerName,
    this.sellerId,
    this.viewCount = 0,
    List<String>? likers,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       imageUrls = imageUrls ?? [],
       likers = likers ?? [];

  /// toMap - 데이터 직렬화
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'isFree': isFree,
      'isPriceSuggest': isPriceSuggest,
      'locationLabel': locationLabel,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'thumbnailUrl': thumbnailUrl,
      'imageUrls': imageUrls,
      'category': category,
      'condition': condition,
      'sellerName': sellerName,
      'sellerId': sellerId,
      'viewCount': viewCount,
      'likers': likers,
    };
  }

  /// fromMap - 데이터 역직렬화
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      price: map['price'] as int?,
      isFree: map['isFree'] as bool? ?? false,
      isPriceSuggest: map['isPriceSuggest'] as bool? ?? false,
      locationLabel: map['locationLabel'] as String,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 33.4996,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 126.5312,
      createdAt: DateTime.parse(map['createdAt'] as String),
      thumbnailUrl: map['thumbnailUrl'] as String?,
      imageUrls: List<String>.from(map['imageUrls'] as List? ?? []),
      category: map['category'] as String?,
      condition: map['condition'] as String?,
      sellerName: map['sellerName'] as String?,
      sellerId: map['sellerId'] as String?,
      viewCount: map['viewCount'] as int? ?? 0,
      likers: List<String>.from(map['likers'] as List? ?? []),
    );
  }

  /// copyWith - ProductModel 복사
  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    int? price,
    bool? isFree,
    bool? isPriceSuggest,
    String? locationLabel,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    String? thumbnailUrl,
    List<String>? imageUrls,
    String? category,
    String? condition,
    String? sellerName,
    String? sellerId,
    int? viewCount,
    List<String>? likers,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      isPriceSuggest: isPriceSuggest ?? this.isPriceSuggest,
      locationLabel: locationLabel ?? this.locationLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      sellerName: sellerName ?? this.sellerName,
      sellerId: sellerId ?? this.sellerId,
      viewCount: viewCount ?? this.viewCount,
      likers: likers ?? this.likers,
    );
  }
}
