
---

# 📘 **[개발자 문서] Chapter 12 — 홈 UI 구현**  
📄 `docs/12_home_ui_build.md`

```markdown
# Chapter 12 — 홈 화면 UI 구현

## 1. AppBar
-왼쪽: '아라동 ▼'
-오른쪽: 검색, 리스트, 알림 아이콘
-leadingWidth: Get.width * 0.6

## 2. 상품 리스트 UI
`_ProductList` + `ListView.separated` 구성:

항목 구성:
- 왼쪽: 100×100 이미지
- 오른쪽: 제목 / 서브 정보 / 나눔 태그

## 3. 이미지 로딩
Image.network → errorBuilder / placeholder 적용

## 4. FloatingActionButton (글쓰기 버튼)
우측 하단 pill 형태:
- plus.svg 아이콘
- '글쓰기' 텍스트
- /product/write 로 이동

## 5. 전체 테마
다크 UI 기반, AppBar~Body까지 색감 통일.

## 6. 결과
당근마켓 앱과 유사한 홈 UI 완성.
