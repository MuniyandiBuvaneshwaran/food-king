import 'package:get/get.dart';

import '../modules/addresses/addresses_screen.dart';
import '../modules/auth/forgot_password_screen.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/otp_screen.dart';
import '../modules/auth/register_screen.dart';
import '../modules/cart/cart_screen.dart';
import '../modules/chat/chat_screen.dart';
import '../modules/checkout/checkout_screen.dart';
import '../modules/home/home_screen.dart';
import '../modules/menu/item_detail_screen.dart';
import '../modules/menu/menu_screen.dart';
import '../modules/notifications/notifications_screen.dart';
import '../modules/onboarding/onboarding_screen.dart';
import '../modules/orders/order_history_screen.dart';
import '../modules/orders/order_tracking_screen.dart';
import '../modules/profile/profile_screen.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/wallet/wallet_screen.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.splash, page: SplashScreen.new),
    GetPage(name: AppRoutes.onboarding, page: OnboardingScreen.new),
    GetPage(name: AppRoutes.login, page: LoginScreen.new),
    GetPage(name: AppRoutes.register, page: RegisterScreen.new),
    GetPage(name: AppRoutes.otp, page: OtpScreen.new),
    GetPage(name: AppRoutes.forgotPassword, page: ForgotPasswordScreen.new),
    GetPage(name: AppRoutes.home, page: HomeScreen.new),
    GetPage(name: AppRoutes.menu, page: MenuScreen.new),
    GetPage(name: AppRoutes.itemDetail, page: ItemDetailScreen.new),
    GetPage(name: AppRoutes.cart, page: CartScreen.new),
    GetPage(name: AppRoutes.checkout, page: CheckoutScreen.new),
    GetPage(name: AppRoutes.orderTracking, page: OrderTrackingScreen.new),
    GetPage(name: AppRoutes.orderHistory, page: OrderHistoryScreen.new),
    GetPage(name: AppRoutes.profile, page: ProfileScreen.new),
    GetPage(name: AppRoutes.addresses, page: AddressesScreen.new),
    GetPage(name: AppRoutes.notifications, page: NotificationsScreen.new),
    GetPage(name: AppRoutes.chat, page: ChatScreen.new),
    GetPage(name: AppRoutes.wallet, page: WalletScreen.new),
  ];
}
