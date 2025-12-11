import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/controller/data_load_controller.dart';
import 'package:bamtol_market_app/src/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    // 데이터 로드
    Get.find<DataLoadController>().loadData();
    // 약간의 딜레이 (스플래시 화면 표시 시간)
    await Future.delayed(const Duration(seconds: 2));
    // InitStartPage로 이동
    if (mounted) {
      Get.offNamed('/start');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: _SplashView()));
  }
}

class _SplashView extends GetView<SplashController> {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 99,
                height: 116,
                child: Image.asset('assets/images/logo_simbol.png'),
              ),
              const SizedBox(height: 40),
              const AppFont(
                '당신 근처의 밤톨마켓',
                fontWeight: FontWeight.bold,
                size: 20,
              ),
              const SizedBox(height: 15),
              AppFont(
                '중고 거래부터 동네 정보까지, \n지금 내 동네를 선택하고 시작해보세요!',
                align: TextAlign.center,
                size: 18,
                color: Colors.white.withOpacity(0.6),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              const Text('데이터 로딩 중...', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
