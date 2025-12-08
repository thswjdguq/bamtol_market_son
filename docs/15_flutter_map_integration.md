# Chapter 15 — 상품 등록 페이지 구현 (이미지, 입력 필드, 지도)

## 1. 개요

본 챕터에서는 상품 등록 페이지(`ProductWritePage`)의 기본 UI와 기능을 구현한다. 사용자가 상품 정보를 입력하고 이미지를 선택하며, 거래 희망 장소를 지도에서 지정할 수 있다.

### 핵심 구현 사항
- **이미지 선택**: `image_picker` 패키지로 갤러리에서 최대 10장 선택
- **입력 필드**: 제목, 설명, 가격 입력
- **드롭다운**: 카테고리, 상품 상태, 거래 희망 장소 선택
- **Flutter Map**: 거래 희망 장소를 지도에서 확인 (표시/숨기기 토글)
- **체크박스**: 무료 나눔, 가격 제안 받기 기능

---

## 2. pubspec.yaml — 패키지 추가

### 필요한 패키지

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 상태 관리
  get: ^4.7.2
  
  # 이미지 선택
  image_picker: ^1.2.1
  
  # 지도
  flutter_map: ^8.2.2
  latlong2: ^0.9.1
  
  # UI
  flutter_svg: ^2.2.2
  google_fonts: ^6.3.2
```

### 설치 명령어
```bash
flutter pub get
```

---

## 3. ProductWriteController — 상태 관리

### 3.1 주요 상태 변수

```dart
class ProductWriteController extends GetxController {
  // LocalMockProductRepository 인스턴스
  final LocalMockProductRepository _repository = LocalMockProductRepository();
  
  // ===== 이미지 =====
  RxList<String> imageUrls = RxList<String>(); // 선택된 이미지 URL 리스트
  
  // ===== 텍스트 입력 =====
  RxString title = RxString('');
  RxString description = RxString('');
  RxString priceText = RxString('');
  
  // ===== 체크박스 =====
  RxBool isFree = RxBool(false);          // 무료 나눔
  RxBool isPriceSuggest = RxBool(false);  // 가격 제안 받기
  
  // ===== 드롭다운 =====
  RxString selectedCategory = RxString('');    // 카테고리
  RxString selectedCondition = RxString('');   // 상품 상태
  RxString locationLabel = RxString('아라동'); // 거래 희망 장소
  
  // ===== 지도 =====
  Rx<LatLng> selectedLocation = Rx<LatLng>(
    LatLng(33.4996, 126.5312), // 제주 중심 좌표
  );
  RxBool isMapVisible = RxBool(false); // 지도 표시/숨기기
  
  // ===== 상수 =====
  static const int maxImageCount = 10;
}
```

### 3.2 이미지 관리 메서드

```dart
/// 이미지 URL 리스트 업데이트 (이미지 피커에서 선택 시)
void setImages(List<String> urls) {
  final limitedUrls = urls.take(maxImageCount).toList();
  imageUrls.assignAll(limitedUrls);
}

/// 이미지 제거
void removeImage(int index) {
  if (index >= 0 && index < imageUrls.length) {
    imageUrls.removeAt(index);
  }
}

/// 이미지가 최대치에 도달했는지 확인
bool isMaxImageReached() {
  return imageUrls.length >= maxImageCount;
}
```

### 3.3 입력 필드 메서드

```dart
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
```

### 3.4 체크박스 로직

```dart
/// 무료 나눔 체크 토글
void toggleIsFree(bool value) {
  isFree(value);
  if (value) {
    priceText('0');              // 가격 자동으로 0 설정
    isPriceSuggest(false);       // 가격 제안 자동으로 false
  }
}

/// 가격 제안 받기 체크 토글
void toggleIsPriceSuggest(bool value) {
  if (!isFree.value) {  // 무료 나눔이 아닐 때만 활성화
    isPriceSuggest(value);
  }
}
```

### 3.5 드롭다운 메서드

```dart
void changeCategory(String value) {
  selectedCategory(value);
}

void changeCondition(String value) {
  selectedCondition(value);
}

void changeLocation(String value) {
  locationLabel(value);
}
```

### 3.6 지도 관련 메서드

```dart
/// 지도에서 위치 선택 (탭 시)
void updateMapLocation(LatLng location) {
  selectedLocation(location);
}

/// 지도 표시/숨기기 토글
void toggleMapVisibility() {
  isMapVisible(!isMapVisible.value);
}
```

---

## 4. ProductWritePage — UI 구현

### 4.1 페이지 구조

```dart
class ProductWritePage extends GetView<ProductWriteController> {
  const ProductWritePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212123),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),       // 이미지 선택
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(),     // 카테고리
                  const SizedBox(height: 20),
                  _buildTitleSection(),        // 제목
                  const SizedBox(height: 20),
                  _buildPriceSection(),        // 가격 + 체크박스
                  const SizedBox(height: 20),
                  _buildConditionSection(),    // 상품 상태
                  const SizedBox(height: 20),
                  _buildDescriptionSection(),  // 설명
                  const SizedBox(height: 20),
                  _buildLocationSection(),     // 거래 희망 장소 + 지도
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4.2 이미지 선택 섹션

```dart
Widget _buildImageSection(BuildContext context) {
  return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppFont('이미지', fontWeight: FontWeight.bold, size: 16),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemCount: controller.imageUrls.length + 1,
            itemBuilder: (context, index) {
              // + 버튼
              if (index == controller.imageUrls.length) {
                if (controller.isMaxImageReached()) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () => _pickImages(context),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.all(color: Colors.grey[700]!, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 32),
                    ),
                  ),
                );
              }
              
              // 선택된 이미지 썸네일
              return Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[900],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(controller.imageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 삭제 버튼
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(index),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(Icons.close, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppFont(
            '${controller.imageUrls.length}/${ProductWriteController.maxImageCount}',
            size: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  });
}

// 이미지 피커 메서드
Future<void> _pickImages(BuildContext context) async {
  try {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage(
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    
    if (pickedFiles.isNotEmpty) {
      final imageUrls = pickedFiles
          .map((file) => file.path)
          .toList();
      controller.setImages(imageUrls);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const AppFont('이미지 선택에 실패했습니다.'),
        backgroundColor: Colors.red[700],
      ),
    );
  }
}
```

### 4.3 가격 입력 + 체크박스

```dart
Widget _buildPriceSection() {
  return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppFont('가격', fontWeight: FontWeight.bold, size: 16),
        const SizedBox(height: 12),
        
        // 가격 입력 필드 (무료 나눔이면 비활성화)
        TextField(
          onChanged: controller.changePrice,
          enabled: !controller.isFree.value,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '가격을 입력해주세요.',
            filled: true,
           fillColor: controller.isFree.value
                ? Colors.grey[800]
                : Colors.grey[900],
            prefixText: controller.isFree.value ? '₩0 ' : '₩ ',
            // ... 테두리 스타일
          ),
        ),
        const SizedBox(height: 12),
        
        // 무료 나눔 체크박스
        Row(
          children: [
            Checkbox(
              value: controller.isFree.value,
              onChanged: (value) {
                if (value != null) {
                  controller.toggleIsFree(value);
                }
              },
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xffED7738);
                }
                return Colors.grey[700];
              }),
            ),
            const Expanded(child: AppFont('무료 나눔', color: Colors.white)),
          ],
        ),
        
        // 가격 제안 받기 체크박스
        Row(
          children: [
            Checkbox(
              value: controller.isPriceSuggest.value,
              onChanged: (value) {
                if (value != null) {
                  controller.toggleIsPriceSuggest(value);
                }
              },
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xffED7738);
                }
                return Colors.grey[700];
              }),
            ),
            Expanded(
              child: AppFont(
                '가격 제안 받기',
                color: controller.isFree.value ? Colors.grey : Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  });
}
```

### 4.4 거래 희망 장소 + Flutter Map

```dart
Widget _buildLocationSection() {
  return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppFont('거래 희망 장소', fontWeight: FontWeight.bold, size: 16),
        const SizedBox(height: 12),
        
        // 위치 드롭다운
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[700]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[900],
          ),
          child: DropdownButton<String>(
            value: controller.locationLabel.value,
            dropdownColor: Colors.grey[900],
            underline: const SizedBox(),
            isExpanded: true,
            items: ['아라동', '연동', '노형동', '삼도동'].map((location) {
              return DropdownMenuItem(
                value: location,
                child: AppFont(location, color: Colors.white),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.changeLocation(value);
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // 지도 표시/숨기기 버튼
        GestureDetector(
          onTap: () => controller.toggleMapVisibility(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffED7738)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[900],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppFont(
                  controller.isMapVisible.value ? '지도 숨기기' : '지도 표시하기',
                  color: const Color(0xffED7738),
                  fontWeight: FontWeight.bold,
                ),
                Icon(
                  controller.isMapVisible.value
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: const Color(0xffED7738),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Flutter Map 위젯 (토글되었을 때만 표시)
        if (controller.isMapVisible.value)
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: controller.selectedLocation.value,
                  initialZoom: 15,
                  onTap: (tapPosition, latLng) {
                    controller.updateMapLocation(latLng);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.selectedLocation.value,
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffED7738),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  });
}
```

---

## 5. 주요 기능

### 5.1 이미지 선택
- `image_picker` 패키지 사용
- `pickMultiImage()`로 여러 장 동시 선택
- 최대 10장 제한
- 파일 경로를 String으로 저장

### 5.2 무료 나눔 로직
```
무료 나눔 체크 시:
  - priceText = '0' (자동 설정)
  - 가격 입력 필드 비활성화
  - isPriceSuggest = false (자동으로 false)
  
무료 나눔 체크 해제 시:
  - 가격 입력 필드 활성화
  - isPriceSuggest 체크 가능
```

### 5.3 Flutter Map
- 같은 페이지에서 토글 방식으로 표시/숨기기
- 지도 탭 시 해당 위치로 마커 이동
- OpenStreetMap Germany 타일 사용

---

## 6. 동작 흐름

```
사용자: 상품 등록 페이지 진입
  ↓
1. 이미지 선택 (image_picker)
  ↓
2. 카테고리 선택 (드롭다운)
  ↓
3. 제목, 가격, 설명 입력
  ↓
4. 무료 나눔 체크 (선택)
  - 체크 시: 가격 0원으로 자동 설정, 가격 필드 비활성화
  ↓
5. 상품 상태 선택
  ↓
6. 거래 희망 장소 선택
  - 드롭다운으로 지역 선택
  - "지도 표시하기" 버튼 클릭으로 지도 확인 (선택)
  ↓
7. 완료 버튼 (Chapter 16에서 유효성 검사 추가)
```

---

## 7. Firebase 미사용 사항

GitHub 공식 코드와 달리 **Firebase를 사용하지 않음**:
- ❌ Firebase Storage 이미지 업로드 → 로컬 파일 경로 사용
- ❌ Cloud Firestore 데이터 저장 → `LocalMockProductRepository` 사용
- ❌ `photo_manager` 패키지 → `image_picker` 사용
- ❌ 별도 페이지 이동 → 같은 페이지에 모든 기능 통합

---

## 8. 참고사항

- **Chapter 15**: 기본 UI 및 입력 기능 구현
- **Chapter 16**: 유효성 검사 및 완료 버튼 활성화 로직 추가
- **Chapter 17**: 회원가입 지역 선택에도 Flutter Map 통합
