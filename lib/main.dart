import 'package:bamtol_market_app/firebase_options.dart';
import 'package:bamtol_market_app/src/app.dart';
import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/common/controller/data_load_controller.dart';
import 'package:bamtol_market_app/src/home/page/home_page.dart';
import 'package:bamtol_market_app/src/home/controller/home_controller.dart';
import 'package:bamtol_market_app/src/splash/controller/splash_controller.dart';
import 'package:bamtol_market_app/src/user/login/page/login_page.dart';
import 'package:bamtol_market_app/src/user/login/controller/login_controller.dart';
import 'package:bamtol_market_app/src/user/login/signup/controller/signup_controller.dart';
import 'package:bamtol_market_app/src/user/login/signup/page/signup_page.dart';
import 'package:bamtol_market_app/src/user/login/signup/page/region_select_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/common/controller/bottom_nav_controller.dart';
import 'package:bamtol_market_app/src/root.dart';
import 'package:bamtol_market_app/src/product/write/page/product_write_page.dart';
import 'package:bamtol_market_app/src/product/write/controller/product_write_controller.dart';
import 'package:bamtol_market_app/src/product/detail/page/product_detail_page.dart';
import 'package:bamtol_market_app/src/product/detail/controller/product_detail_controller.dart';
import 'package:bamtol_market_app/src/community/controller/community_controller.dart';
import 'package:bamtol_market_app/src/nearme/controller/nearme_controller.dart';
import 'package:bamtol_market_app/src/chat/controller/chat_controller.dart';
import 'package:bamtol_market_app/src/mypage/controller/mypage_controller.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '당근마켓 클론코딩',
      initialRoute: '/',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xff212123),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xff212123),
      ),

      initialBinding: BindingsBuilder(() {
        Get.put(SplashController());
        Get.put(DataLoadController());
        Get.put(AuthenticationController());
        Get.put(LoginController());
        Get.put(SignupController());
        Get.put(BottomNavController());
        Get.put(ProductWriteController());
        Get.put(HomeController());
        // ProductDetailController는 페이지별 바인딩으로 이동
        Get.put(CommunityController());
        Get.put(NearMeController());
        Get.put(ChatController());
        Get.put(MyPageController());
      }),

      getPages: [
        GetPage(name: '/', page: () => const App()),
        GetPage(name: '/home', page: () => const Root()),
        GetPage(name: '/only-home', page: () => const HomePage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignupPage()),
        GetPage(name: '/region-select', page: () => const RegionSelectPage()),
        GetPage(name: '/product/write', page: () => ProductWritePage()),
        // Chapter 20: 상품 상세 페이지 - 페이지별 바인딩 추가
        GetPage(
          name: '/product/detail/:id',
          page: () => const ProductDetailPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ProductDetailController());
          }),
        ),
      ],
    );
  }
}
