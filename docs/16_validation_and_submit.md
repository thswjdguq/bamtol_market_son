# Chapter 16 — 상품 등록 유효성 검사 및 완료 버튼

## 1. 개요

본 챕터에서는 상품 등록 폼의 **유효성 검사** 로직을 구현하고, 모든 필수 항목이 입력되었을 때만 **완료 버튼**이 활성화되도록 한다.

### 핵심 구현 사항
- 실시간 유효성 검사 (Debounce 적용)
- 완료 버튼 활성화/비활성화 (색상 변경)
- 필수 항목: 제목, 가격 (무료 나눔 제외), 카테고리, 상품 상태
- 무료 나눔 체크 시 가격 검사 생략

---

## 2. ProductWriteController — 유효성 검사 로직

### 2.1 유효성 검사 관련 변수

```dart
class ProductWriteController extends GetxController {
  // 유효성 검사 결과
  RxBool isPossibleSubmit = RxBool(false);
  
  // 상수
  static const int minTitleLength = 1;
  static const int minPriceValue = 0;
}
```

### 2.2 onInit() — Debounce 설정

```dart
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
    selectedCategory,
    (_) => _validateForm(),
    time: const Duration(milliseconds: 100),
  );
  debounce(
    selectedCondition,
    (_) => _validateForm(),
    time: const Duration(milliseconds: 100),
  );
}
```

**Debounce 사용 이유**:
- 사용자가 입력할 때마다 즉시 검사하면 성능 저하
- 100ms 지연 후 검사하여 최적화
- GetX의 `debounce()` 함수 활용

### 2.3 유효성 검사 메서드

```dart
/// 폼 유효성 검사 (isPossibleSubmit 업데이트)
void _validateForm() {
  final bool isValid = _isFormValid();
  isPossibleSubmit(isValid);
}

/// 폼이 유효한지 판단
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
  
  // 5. 위치는 기본값('아라동')이 있으므로 검사 불필요
  
  return true;
}
```

### 2.4 유효성 검사 메시지 (선택사항)

```dart
/// 현재 유효성 검사 상태 반환 (에러 메시지용)
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
```

---

## 3. ProductWritePage — 완료 버튼 UI

### 3.1 AppBar 완료 버튼

```dart
appBar: AppBar(
  backgroundColor: const Color(0xff212123),
  elevation: 0,
  title: const AppFont('상품 등록', fontWeight: FontWeight.bold, size: 18),
  centerTitle: true,
  leading: GestureDetector(
    onTap: () => Get.back(),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SvgPicture.asset(
        'assets/svg/icons/close.svg',
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    ),
  ),
  actions: [
    // ===== 완료 버튼 (유효성 검사에 따라 활성/비활성) =====
    Obx(() {
      final isActive = controller.isPossibleSubmit.value;
      return GestureDetector(
        onTap: isActive ? () => controller.submit() : null,
        child: IgnorePointer(
          ignoring: !isActive,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: AppFont(
                '완료',
                color: isActive ? const Color(0xffED7738) : Colors.grey,
                fontWeight: FontWeight.bold,
                size: 16,
              ),
            ),
          ),
        ),
      );
    }),
  ],
),
```

**핵심 로직**:
- `Obx()`로 `isPossibleSubmit` 실시간 감지
- 활성화 시: 주황색 (`#ED7738`)
- 비활성화 시: 회색, 클릭 불가 (`IgnorePointer`)

---

## 4. 유효성 검사 조건 요약

| 항목 | 필수 여부 | 조건 |
|------|----------|------|
| 이미지 | 선택 | 없어도 등록 가능 |
| 제목 | 필수 | 공백 제거 후 1글자 이상 |
| 카테고리 | 필수 | 드롭다운에서 선택 |
| 가격 | 조건부 | 무료 나눔이 아니면 필수, 0원 이상 |
| 상품 상태 | 필수 | 드롭다운에서 선택 |
| 설명 | 선택 | 없어도 등록 가능 |
| 위치 | 자동 | 기본값 '아라동' |

---

## 5. 동작 흐름

```
앱 시작: 완료 버튼 비활성화 (회색)
  ↓
사용자: 제목 입력 ("맥북 판매")
  ↓
Debounce 100ms 후 _validateForm() 실행
  - 제목 O, 카테고리 X → isPossibleSubmit = false
  - 완료 버튼 여전히 회색
  ↓
사용자: 카테고리 선택 ("전자기기")
  ↓
Debounce 100ms 후 _validateForm() 실행
  - 제목 O, 카테고리 O, 가격 X → isPossibleSubmit = false
  - 완료 버튼 여전히 회색
  ↓
사용자: 가격 입력 ("100000")
  ↓
Debounce 100ms 후 _validateForm() 실행
  - 제목 O, 카테고리 O, 가격 O, 상태 X → isPossibleSubmit = false
  ↓
사용자: 상품 상태 선택 ("거의 새 상품")
  ↓
Debounce 100ms 후 _validateForm() 실행
  - 모든 필수 항목 O → isPossibleSubmit = true
  - 완료 버튼 주황색으로 변경 (활성화)
  ↓
사용자: 완료 버튼 클릭
  ↓
controller.submit() 실행 (Chapter 17에서 구현)
```

---

## 6. 무료나눔 특별 처리

### 6.1 무료 나눔 체크 전

```dart
// 가격 필드: 활성화
// 가격 검사: 필수 (비어있으면 isPossibleSubmit = false)
```

### 6.2 무료 나눔 체크 시

```dart
void toggleIsFree(bool value) {
  isFree(value);
  if (value) {
    priceText('0');              // 가격 자동으로 0 설정
    isPriceSuggest(false);       // 가격 제안 자동으로 false
  }
  _validateForm();  // 유효성 재검사
}

// _isFormValid()에서:
if (!isFree.value) {
  // 가격 검사 실행
} else {
  // 가격 검사 건너뜀 (무료 나눔이므로)
}
```

**결과**:
- 무료 나눔 체크 시 가격 검사를 건너뜀
- 가격 필드가 비어있어도 유효성 검사 통과 가능

---

## 7. Debounce의 장점

### Before (Debounce 없음)
```
사용자가 "맥북" 입력:
  'ㅁ' → _validateForm() 실행
  '마' → _validateForm() 실행
  '맥' → _validateForm() 실행
  '맥ㅂ' → _validateForm() 실행
  '맥부' → _validateForm() 실행
  '맥북' → _validateForm() 실행
총 6번 실행
```

### After (Debounce 100ms)
```
사용자가 "맥북" 입력:
  '맥북' 입력 완료 후 100ms 대기
  → _validateForm() 실행 (1번만)
```

**성능 향상**: 불필요한 검사 제거

---

## 8. submit() 메서드 (Chapter 17에서 상세 구현)

Chapter 16에서는 유효성 검사만 구현하고, 실제 제출 로직은 Chapter 17에서 다룹니다.

```dart
Future<bool> submit() async {
  // 유효성 검사
  if (!_isFormValid()) {
    return false;
  }
  
  // 실제 저장 로직 (Chapter 17에서 구현)
  // ...
  
  return true;
}
```

---

## 9. 완료 버튼 시각적 피드백

| 상태 | 색상 | 클릭 가능 |
|------|------|----------|
| 필수 항목 미입력 | 회색 (`Colors.grey`) | ❌ |
| 모든 필수 항목 입력 | 주황색 (`#ED7738`) | ✅ |

**사용자 경험**:
- 입력 진행 상황을 색상으로 즉시 확인
- 완료 버튼 색상만 보고 등록 가능 여부 판단
- 클릭해도 반응 없음 (IgnorePointer)

---

## 10. GitHub 공식 코드와의 차이

### GitHub 공식 코드
- `product.value.stream.listen()`으로 검사
- 이미지 필수 (`selectedImages.isNotEmpty`)
- 설명 선택사항

### 현재 프로젝트
- `debounce()`로 각 필드 개별 감지
- 이미지 선택사항
- 설명 선택사항
- 더 세밀한 제어

---

## 11. 참고사항

- **Chapter 15**: 기본 UI 및 입력 기능
- **Chapter 16**: 유효성 검사 및 완료 버튼 활성화
- **Chapter 17**: 실제 상품 등록 및 저장 로직
