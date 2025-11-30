    # Chapter 13 — Root & Bottom Navigation Bar

## 1. BottomNavController
- menuIndex: RxInt
- TabController 연동
- changeBottomNav로 탭 이동

## 2. Root 페이지
Scaffold(
  body: TabBarView(...)
  bottomNavigationBar: BottomNavigationBar(...)
)

## 3. BottomNavigationBar
5개 메뉴:
- 홈
- 동네생활
- 내 근처
- 채팅
- 나의 밤톨

Icon(active/off) SVG 적용.

## 4. 라우트 연결
