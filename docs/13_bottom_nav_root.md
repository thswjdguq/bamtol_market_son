Chapter 13 — Root & Bottom Navigation
1. BottomNavController

Bottom Navigation 전용 컨트롤러로,
TabController + RxInt(menuIndex) 를 함께 관리한다.

class BottomNavController extends GetxController
    with GetTickerProviderStateMixin {

  late TabController tabController;
  RxInt menuIndex = 0.obs;

  @override
  void onInit() {
    tabController = TabController(length: 5, vsync: this);
    super.onInit();
  }

  void changeBottomNav(int index) {
    menuIndex(index);
    tabController.animateTo(index);
  }
}

2. Root 페이지 구조

Root 화면은 BottomNavigationBar + TabBarView 구조로 구성되었다.

Scaffold
 ├── body: TabBarView
 └── bottomNavigationBar: BottomNavigationBar


TabBarView
각 탭별 페이지 삽입

BottomNavigationBar
탭 선택 시 controller.changeBottomNav(index) 호출

3. 메뉴 구성

총 5개의 메뉴를 사용한다.

홈

동네생활

내 근처

채팅

나의 밤톨

각 메뉴는 On/Off 상태별 SVG 아이콘을 적용한다.

예:

BottomNavigationBarItem(
  icon: SvgPicture.asset('assets/svg/home_off.svg'),
  activeIcon: SvgPicture.asset('assets/svg/home_on.svg'),
  label: '홈',
)

4. 라우트

Root 화면은 /home 라우트에 매핑한다.

/home → Root()


Splash → Login → Home(Root) 로 이어지는 구조.   