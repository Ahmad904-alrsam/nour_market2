import 'package:flutter/material.dart';
import 'package:nour_market2/controllers/fav_product_controller.dart';
import 'package:nour_market2/controllers/home_controller.dart';
import 'package:nour_market2/controllers/search_controller.dart';
import 'package:nour_market2/widgets/product_card_list_pro.dart';

class SearchGrid extends StatelessWidget {
  final SearchControllerApi searchController;
  final HomeController homeController;
  final FavProductController favController;

  const SearchGrid({
    Key? key,
    required this.searchController,
    required this.homeController,
    required this.favController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: searchController.searchResults.length,
      itemBuilder: (context, index) => ProductCard(
        product: searchController.searchResults[index],
        homeController: homeController,
        favController: favController,
      ),
    );
  }
}
