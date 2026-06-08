import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kartly_e_commerce/core/constants/app_colors.dart';
import 'package:kartly_e_commerce/modules/home/controllers/home_theme_controller.dart';

import '../../../core/controllers/currency_controller.dart';
import '../../../core/services/permission_service.dart';
import '../../account/controller/notifications_controller.dart';
import '../../category/controller/category_controller.dart';
import '../../product/controller/cart_controller.dart';
import '../../product/controller/for_you_controller.dart';
import '../../product/controller/top_sales_controller.dart';
import '../../product/view/flash_deals_section.dart';
import '../../product/view/for_you_section.dart';
import '../../product/view/new_product_section.dart';
import '../controller/banner_controller.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_widget.dart';
import '../widgets/category_navigation_widget.dart';
import '../widgets/category_banner_widget.dart';

import '../widgets/product_grid_widget.dart';
import '../widgets/delivery_bar_widget.dart';
import '../widgets/category_content_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ForYouController _forYouCtl = ForYouController.ensure();

  Future<void> _onRefresh() async {
    final futures = <Future<void>>[];

    if (Get.isRegistered<CurrencyController>()) {
      final curCtl = Get.find<CurrencyController>();
      futures.add(curCtl.fetchCurrencies(force: true));
    }

    if (Get.isRegistered<BannerController>()) {
      final c = Get.find<BannerController>();
      c.banners.clear();
      c.error.value = '';
      c.isLoading.value = true;
      futures.add(c.load());
    }

    if (Get.isRegistered<CategoryController>()) {
      final c = Get.find<CategoryController>();
      c.categories.clear();
      c.error.value = '';
      c.isLoading.value = true;
      futures.add(c.fetchCategories());
    }

    futures.add(FlashDealsSection.refreshSection());

    if (Get.isRegistered<TopSalesController>(tag: 'topSalesSection')) {
      final topSectionCtl = Get.find<TopSalesController>(
        tag: 'topSalesSection',
      );
      futures.add(topSectionCtl.refresh());
    }

    futures.add(NewProductSection.refreshSection());

    futures.add(ForYouSection.refreshSection());

    CartController cartCtl;
    if (Get.isRegistered<CartController>()) {
      cartCtl = Get.find<CartController>();
    } else {
      cartCtl = Get.put(CartController(Get.find()));
    }
    futures.add(cartCtl.loadCart());

    NotificationController notifCtl;
    if (Get.isRegistered<NotificationController>()) {
      notifCtl = Get.find<NotificationController>();
    } else {
      notifCtl = Get.put(NotificationController());
    }
    futures.add(notifCtl.refreshList());

    await Future.wait(futures);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Get.isRegistered<CurrencyController>()) {
        await Get.find<CurrencyController>().fetchCurrencies(force: true);
      }

      if (!Get.isRegistered<PermissionService>()) {
        await Get.putAsync<PermissionService>(() => PermissionService().init());
      }
      await PermissionService.I.requestOnceOnHome();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleScrollMetrics(ScrollMetrics metrics) {
    if (_forYouCtl.isLoadingMore.value || !_forYouCtl.hasMore.value) return;

    if (metrics.pixels >= metrics.maxScrollExtent - 200) {
      _forYouCtl.loadMoreRandom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instamartBackground,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _onRefresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification ||
                    notification is OverscrollNotification) {
                  _handleScrollMetrics(notification.metrics);
                }
                return false;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  GetBuilder<HomeThemeController>(
                    init: HomeThemeController(),
                    id: 'homeBackground',
                    builder: (controller) {
                      return TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: controller.currentCategory.primaryColor,
                          end: controller.currentCategory.primaryColor,
                        ),
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCubic,
                        builder: (context, color, child) {
                          return SliverAppBar(
                            backgroundColor: color,
                            pinned: true,
                            floating: true,
                            elevation: 0,
                            expandedHeight: 158.0,
                            toolbarHeight: 0,
                            flexibleSpace: const FlexibleSpaceBar(
                              background: SafeArea(
                                bottom: false,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: HeaderWidget(),
                                ),
                              ),
                            ),
                            bottom: const PreferredSize(
                              preferredSize: Size.fromHeight(110),
                              child: Column(
                                children: [
                                  SearchWidget(),
                                  SizedBox(height: 10),
                                  CategoryNavigationWidget(),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  ),
                  SliverToBoxAdapter(
                    child: GetBuilder<HomeThemeController>(
                      id: 'contentSection',
                      builder: (controller) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeInOutCubic,
                          switchOutCurve: Curves.easeInOutCubic,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.05, 0.0), // Slight horizontal slide to feel like navigating categories
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: ValueKey<String>(controller.currentCategory.label),
                            children: [
                              const SizedBox(height: 10),
                              CategoryBannerWidget(
                                category: controller.currentCategory.label,
                                primaryColor: controller.currentCategory.primaryColor,
                              ),
                              BestSellingWidget(
                                categoryName: controller.currentCategory.label,
                                primaryColor: controller.currentCategory.primaryColor,
                              ),
                              TrendingWidget(
                                categoryName: controller.currentCategory.label,
                                primaryColor: controller.currentCategory.primaryColor,
                              ),
                              RecommendedWidget(
                                categoryName: controller.currentCategory.label,
                                primaryColor: controller.currentCategory.primaryColor,
                              ),
                              OffersWidget(
                                categoryName: controller.currentCategory.label,
                                primaryColor: controller.currentCategory.primaryColor,
                              ),
                              const ProductGridWidget(),
                              const SizedBox(height: 120),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sticky Delivery Bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DeliveryBarWidget(),
          ),
        ],
      ),
    );
  }
}

