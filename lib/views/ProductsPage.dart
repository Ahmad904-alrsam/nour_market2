import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/controllers/fav_product_controller.dart';
import 'package:nour_market2/controllers/products_controller.dart';
import 'package:nour_market2/controllers/search_controller.dart';
import 'package:nour_market2/controllers/home_controller.dart';
import '../widgets/shimmer_grid.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_grid.dart';

class ProductsPage extends StatefulWidget {
  final int subcategoryId;
  final String subcategoryName;

  const ProductsPage({
    Key? key,
    required this.subcategoryId,
    required this.subcategoryName,
  }) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late ProductsController productsController;
  final HomeController homeController = Get.find<HomeController>();
  final FavProductController favController = Get.find<FavProductController>();
  final SearchControllerApi searchController = Get.find<SearchControllerApi>();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    productsController = Get.put(
      ProductsController(subcategoryId: widget.subcategoryId),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !productsController.isLoading.value) {
        productsController.loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.subcategoryName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onSubmitted: (value) {
                if (value.isEmpty) {
                  searchController.clearSearch();
                } else {
                  searchController.searchProducts(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                suffixIcon: Obx(() {
                  return IconButton(
                    icon: Icon(
                      searchController.isSearching.value
                          ? Icons.close
                          : Icons.search,
                    ),
                    onPressed: () {
                      if (searchController.isSearching.value) {
                        searchController.clearSearch();
                      }
                    },
                  );
                }),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (searchController.isSearching.value) {
          if (searchController.isLoading.value) {
            return const ShimmerGrid();
          }
          if (searchController.searchResults.isEmpty) {
            return const Center(
              child: Text("لا توجد نتائج بحث",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }
          return SearchGrid(
            searchController: searchController,
            homeController: homeController,
            favController: favController,
          );
        } else {
          if (productsController.isLoading.value &&
              productsController.products.isEmpty) {
            return const ShimmerGrid();
          }
          if (productsController.products.isEmpty) {
            return const Center(
              child: Text("لا توجد منتجات متاحة",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }
          return ProductGrid(
            controller: productsController,
            homeController: homeController,
            favController: favController,
            scrollController: _scrollController,
          );
        }
      }),
    );
  }
}
