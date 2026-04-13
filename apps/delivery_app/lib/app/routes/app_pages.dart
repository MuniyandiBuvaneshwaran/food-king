import 'package:get/get.dart';

import '../modules/auth/login_screen.dart';
import '../modules/home/home_screen.dart';
import '../modules/map/map_navigation_screen.dart';
import '../modules/orders/delivery_confirmation_screen.dart';
import '../modules/orders/order_detail_screen.dart';
import '../modules/orders/order_history_screen.dart';
import '../modules/profile/profile_screen.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.login, page: LoginScreen.new),
    GetPage(name: AppRoutes.home, page: HomeScreen.new),
    GetPage(name: AppRoutes.orderDetail, page: OrderDetailScreen.new),
    GetPage(name: AppRoutes.map, page: MapNavigationScreen.new),
    GetPage(name: AppRoutes.deliveryConfirmation, page: DeliveryConfirmationScreen.new),
    GetPage(name: AppRoutes.orderHistory, page: OrderHistoryScreen.new),
    GetPage(name: AppRoutes.profile, page: ProfileScreen.new),
  ];
}
