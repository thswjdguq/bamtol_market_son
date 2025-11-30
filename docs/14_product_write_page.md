Chapter 14 — 홈 화면 & 글쓰기(ProductWrite) 페이지 연결
1. 개요

본 챕터에서는 HomePage에서 글쓰기(ProductWritePage) 화면으로 이동하는 기능을 구현하기 위해 수정된 파일(main.dart, home_page.dart, product_write_page.dart) 내용을 정리한다.

핵심 구현 사항:

GetX 라우트(/product/write) 등록

홈 화면 FloatingActionButton → 글쓰기 페이지 이동

ProductWritePage 기본 UI 구성

2. main.dart — 라우트 등록 추가
변경 사항

ProductWritePage import 추가

GetPage에 /product/write 라우트 등록

코드
import 'package:bamtol_market_app/product/write/page/product_write_page.dart';
// ... 기타 import

class BamtolMarketApp extends StatelessWidget {
  const BamtolMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bamtol Market',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignupPage()),
        GetPage(name: '/product/write', page: () => const ProductWritePage()),
      ],
    );
  }
}

3. home_page.dart — FAB에서 글쓰기 페이지 이동
변경 사항

FloatingActionButton 클릭 시 GetX 라우트 이동 적용

반드시 /product/write 형태로 라우트 작성해야 정상 동작

코드
floatingActionButton: FloatingActionButton(
  onPressed: () => Get.toNamed('/product/write'),
  shape: const StadiumBorder(),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.add),
      SizedBox(width: 6),
      Text('글쓰기'),
    ],
  ),
),

4. product_write_page.dart — 글쓰기 페이지 기본 구성
변경 사항

ProductWritePage 기본 구조 생성

추후 상품명/가격/내용/이미지 업로드 UI 추가 예정

코드
class ProductWritePage extends StatelessWidget {
  const ProductWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글쓰기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Product Write Page (Mock UI)'),
          ],
        ),
      ),
    );
  }
}

5. 전체 흐름
HomePage
  └── FloatingActionButton 클릭
        → Get.toNamed('/product/write')
              → ProductWritePage 렌더링


모든 라우팅은 main.dart 내 GetPage 설정에 의해 정상적으로 처리된다.