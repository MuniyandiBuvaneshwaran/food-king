import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final _pages = const [
    (
      icon: Icons.restaurant_menu_rounded,
      title: 'Explore Top Restaurants',
      subtitle: 'Discover meals, offers, and best-rated places around you.'
    ),
    (
      icon: Icons.shopping_cart_checkout_rounded,
      title: 'Fast & Flexible Checkout',
      subtitle: 'Apply coupons, schedule delivery, and pay your way.'
    ),
    (
      icon: Icons.route_rounded,
      title: 'Live Order Tracking',
      subtitle: 'Track every status from kitchen to doorstep in real-time.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    final currentPage = 0.obs;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: _pages.length,
                  onPageChanged: (value) => currentPage.value = value,
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(item.icon, size: 56),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: currentPage.value == index ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: currentPage.value == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Get Started',
                icon: Icons.login_rounded,
                onPressed: () => Get.offNamed(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
