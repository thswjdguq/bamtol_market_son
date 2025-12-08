# Chapter 17 — 상품 등록 완료 및 회원가입 지도 통합

## 1. 개요

본 챕터에서는 두 가지 주요 기능을 완성한다:
1. **상품 등록 완료**: 유효성 검사가 통과된 상품을 저장소에 저장하고 홈으로 이동
2. **회원가입 지역 선택**: 정적 지도 이미지를 Flutter Map으로 교체하여 시각적 개선

---

## Part 1: 상품 등록 완료

### 1.1 ProductWriteController — submit() 메서드

```dart
/// 상품 등록 (제출)
Future<bool> submit() async {
  // 유효성 검사 (Chapter 16)
  if (!_isFormValid()) {
    return false;
  }
  
  isLoading(true);
  
  try {
    // 가격 계산
    final int price = isFree.value ? 0 : (int.tryParse(priceText.value) ?? 0);
    
    // ProductModel 생성
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
      sellerName: '나(현재 사용자)',  // 목업 데이터
      sellerId: 'current_user_123',
      viewCount: 0,
      likers: [],
    );
    
    // Repository를 통해 저장 (LocalMockProductRepository)
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
```

### 1.2 LocalMockProductRepository — addProduct()

```dart
/// 상품 추가 (최신순으로 맨 앞에 삽입)
Future<void> addProduct(ProductModel product) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _products.insert(0, product);  // 맨 앞에 삽입 (최신순)
}
```

**동작**:
- 새 상품을 목록 맨 앞에 추가
- 홈 화면에서 최신 상품이 가장 위에 표시됨

### 1.3 동작 흐름

```
사용자: 완료 버튼 클릭
  ↓
controller.submit() 실행
  ↓
1. _isFormValid() 검사
  - 통과하면 계속, 실패하면 return false
  ↓
2. isLoading(true) → 로딩 시작
  ↓
3. ProductModel 생성
  - 입력된 모든 데이터 포함
  - 이미지가 있으면 첫 번째를 썸네일로 설정
  ↓
4. _repository.addProduct(product)
  - 목업 저장소에 상품 추가 (맨 앞에 삽입)
  ↓
5. HomeController.loadInitial()
  - 홈 화면 데이터 새로고침
  ↓
6. Get.offAllNamed('/home')
  - 홈 화면으로 이동 (뒤로 가기 불가)
  ↓
7. isLoading(false) → 로딩 종료
```

---

## Part 2: 회원가입 지역 선택 Flutter Map 통합

### 2.1 Before vs After

#### Before (정적 이미지)

```dart
// 정적 OpenStreetMap 타일 이미지
Image.network(
  'https://tile.openstreetmap.org/13/6546/3226.png',
  fit: BoxFit.cover,
)
```

**문제점**:
- ❌ 제주도 전체를 제대로 표현하지 못함
- ❌ 사용자가 위치를 파악하기 어려움
- ❌ 확대/축소/이동 불가능

#### After (Flutter Map)

```dart
// Import 추가
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong2.dart';

// 지역별 좌표 정의
static final Map<String, LatLng> regionCoordinates = {
  '아라동': const LatLng(33.4734, 126.4836),
  '연동': const LatLng(33.4890, 126.4783),
  '노형동': const LatLng(33.4785, 126.4518),
  '삼도동': const LatLng(33.5102, 126.5219),
};

// 제주도 중심 좌표
static const LatLng jejuCenter = LatLng(33.4996, 126.5312);
```

### 2.2 RegionSelectPage — Flutter Map 구현

```dart
class RegionSelectPage extends GetView<SignupController> {
  const RegionSelectPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const AppFont(
              '우리 동네 설정',
              fontWeight: FontWeight.bold,
              size: 24,
              align: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // ===== Flutter Map 위젯 =====
            Obx(() {
              // 선택된 지역의 좌표 가져오기
              final selectedRegion = controller.region.value;
              final center = selectedRegion.isNotEmpty
                  ? regionCoordinates[selectedRegion]!
                  : jejuCenter;
              
              return Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: selectedRegion.isNotEmpty ? 14 : 12,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.bamtol.market.app',
                      ),
                      // 모든 지역에 마커 표시
                      MarkerLayer(
                        markers: regions.map((region) {
                          final isSelected = selectedRegion == region;
                          final coordinate = regionCoordinates[region]!;
                          
                          return Marker(
                            point: coordinate,
                            width: isSelected ? 50 : 40,
                            height: isSelected ? 50 : 40,
                            child: Column(
                              children: [
                                Container(
                                  width: isSelected ? 40 : 30,
                                  height: isSelected ? 40 : 30,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xffED7738)
                                        : Colors.grey.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(
                                      isSelected ? 20 : 15,
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: isSelected ? 3 : 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: isSelected ? 24 : 18,
                                  ),
                                ),
                                // 선택된 지역에만 라벨 표시
                                if (isSelected)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffED7738),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: AppFont(
                                      region,
                                      size: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 30),
            // 지역 선택 버튼들...
          ],
        ),
      ),
    );
  }
}
```

### 2.3 마커 동작

| 상태 | 크기 | 색상 | 테두리 | 라벨 |
|------|------|------|--------|------|
| 선택됨 | 40x40px | 주황색 (#ED7738) | 3px, 흰색 | 표시 |
| 선택 안 됨 | 30x30px | 반투명 회색 | 2px, 흰색 | 숨김 |

### 2.4 동적 지도 중심 및 줌

```
지역 선택 전:
  - 중심: jejuCenter (제주도 중심)
  - 줌: 12 (제주도 전체 보임)
  
특정 지역 선택 시:
  - 중심: 선택된 지역 좌표
  - 줌: 14 (해당 지역 확대)
```

### 2.5 동작 흐름

```
초기 상태: 지역 선택 안 됨
  ↓
지도: 제주도 중심 표시 (줌 레벨 12)
마커: 4개 지역 모두 회색으로 표시
  ↓
사용자: '연동' 버튼 클릭
  ↓
controller.setRegion('연동')
  ↓
Obx() 재빌드 트리거
  ↓
지도: 연동 좌표로 자동 이동 (줌 레벨 14)
연동 마커: 주황색, 40x40px, '연동' 라벨 표시
다른 마커: 회색, 30x30px 유지
  ↓
사용자: 지도 확대/축소/이동 가능
  ↓
사용자: "위치 저장하고 회원가입" 버튼 클릭
  ↓
controller.signup() 실행
  ↓
홈 화면으로 이동
```

---

## 3. 제주도 지역 좌표

| 지역 | 위도 | 경도 |
|------|------|------|
| 아라동 | 33.4734 | 126.4836 |
| 연동 | 33.4890 | 126.4783 |
| 노형동 | 33.4785 | 126.4518 |
| 삼도동 | 33.5102 | 126.5219 |
| 제주 중심 | 33.4996 | 126.5312 |

---

## 4. 개선 효과

### 상품 등록
- ✅ 입력한 상품이 즉시 홈 화면 맨 위에 표시
- ✅ LocalMockProductRepository로 간편한 데이터 관리
- ✅ Firebase 없이도 완전한 CRUD 기능

### 회원가입 지도
- ✅ 제주도 전체를 명확하게 표시
- ✅ 4개 지역의 정확한 위치를 마커로 표시
- ✅ 선택된 지역을 시각적으로 강조 (색상, 크기, 라벨)
- ✅ 자유로운 확대/축소/이동 가능
- ✅ 선택 시 자동으로 해당 위치로 이동

---

## 5. Firebase 미사용 사항

### GitHub 공식 코드
- Firebase Storage로 이미지 업로드
- Cloud Firestore에 상품 저장
- CupertinoAlertDialog로 완료 메시지

### 현재 프로젝트
- 로컬 파일 경로 사용 (이미지)
- LocalMockProductRepository 사용 (데이터)
- Get.offAllNamed()로 즉시 홈 이동 (별도 다이얼로그 없음)

**간소화된 구현**:
- 학습 목적에 적합
- Firebase 설정 불필요
- 빠른 프로토타이핑 가능

---

## 6. 상품 등록과 회원가입의 일관성

이제 **상품 등록**과 **회원가입 지역 선택**이 모두 동일한 Flutter Map을 사용:
- ✅ 같은 제주도 좌표 시스템 공유
- ✅ 같은 지도 타일 제공자 사용 (OpenStreetMap)
- ✅ 일관된 사용자 경험 제공
- ✅ 코드 재사용성 향상

---

## 7. 참고사항

- **Chapter 15**: 기본 UI 및 입력 기능
- **Chapter 16**: 유효성 검사 및 완료 버튼
- **Chapter 17**: 상품 등록 완료 + 회원가입 지도 개선
- **Chapter 20**: 추가 기능 (찜하기, 조회수, 페이지네이션 등)
