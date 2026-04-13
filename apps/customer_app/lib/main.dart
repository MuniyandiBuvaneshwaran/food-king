import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/controllers/app_controller.dart';
import 'app/controllers/cart_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppController(), permanent: true);
  Get.put(CartController(), permanent: true);
  runApp(const FoodKingCustomerApp());
}

class FoodKingCustomerApp extends GetView<AppController> {
  const FoodKingCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'FoodKing Customer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: controller.themeMode.value,
        locale: controller.locale.value,
        fallbackLocale: const Locale('en'),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}
