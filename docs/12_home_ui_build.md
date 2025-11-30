Chapter 12 — 홈 화면 UI 구현
1. AppBar 구성

홈 화면 AppBar는 지역 표시와 주요 액션 버튼들로 구성하였다.

leadingWidth: Get.width * 0.6

텍스트: '아라동 ▼'

우측 아이콘: 검색 / 메뉴 / 알림

예시 구조:

AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leadingWidth: Get.width * 0.6,
  leading: Row(
    children: [
      SizedBox(width: 16),
      AppFont('아라동 ▼', size: 18, weight: FontWeight.bold),
    ],
  ),
  actions: [
    Icon(Icons.search),
    SizedBox(width: 16),
    Icon(Icons.menu),
    SizedBox(width: 16),
    Icon(Icons.notifications_none),
    SizedBox(width: 16),
  ],
)

2. 상품 리스트 구현

상품 목록은 ListView.separated 로 구성하였다.

● 각 상품 UI 구조

왼쪽: 상품 이미지 (100×100)

ClipRRect 로 라운드 처리

이미지 로딩 실패 시 placeholder 표시

오른쪽:

상품 제목

지역 + 날짜

"나눔" 태그 표시

● 이미지 구조 예시
ClipRRect(
  borderRadius: BorderRadius.circular(7),
  child: SizedBox(
    width: 100,
    height: 100,
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[800],
          child: Icon(Icons.image_not_supported),
        );
      },
    ),
  ),
)

● 전체 ListView 예시
ListView.separated(
  itemCount: products.length,
  separatorBuilder: (_, __) => SizedBox(height: 18),
  itemBuilder: (_, index) {
    final item = products[index];
    return Row(
      children: [
        ProductImage(item.image),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFont(item.title, size: 16, weight: FontWeight.w600),
              SizedBox(height: 6),
              AppFont('${item.region} · ${item.date}', size: 13, color: Colors.grey),
              SizedBox(height: 6),
              AppFont('나눔', size: 12, color: Colors.green),
            ],
          ),
        ),
      ],
    );
  },
)

3. FloatingActionButton

우측 하단에 pill 스타일 FAB 구성.

역할: 글쓰기 이동

라우트: Get.toNamed('/product/write')

예시:

FloatingActionButton(
  onPressed: () => Get.toNamed('/product/write'),
  shape: StadiumBorder(),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.add),
      SizedBox(width: 6),
      AppFont('글쓰기'),
    ],
  ),
)