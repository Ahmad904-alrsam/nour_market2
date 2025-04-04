import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/controllers/fav_product_controller.dart';
import 'package:nour_market2/controllers/home_controller.dart';
import 'package:nour_market2/controllers/products_controller.dart';
import 'package:nour_market2/models/product_model.dart';
import 'package:nour_market2/widgets/product_card_list_pro.dart';

class ProductGrid extends StatelessWidget {
  final ProductsController controller;
  final HomeController homeController;
  final FavProductController favController;
  final ScrollController scrollController;

  const ProductGrid({
    Key? key,
    required this.controller,
    required this.homeController,
    required this.favController,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 100 &&
            !controller.isLoading.value) {
          controller.loadMoreProducts();
        }
        return false;
      },
      child: GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.products.length +
            (controller.productsNextPageUrl != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.products.length) {
            return ProductCard(
              product: controller.products[index],
              homeController: homeController,
              favController: favController,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
