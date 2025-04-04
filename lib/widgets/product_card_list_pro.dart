import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nour_market2/controllers/fav_product_controller.dart';
import 'package:nour_market2/controllers/home_controller.dart';
import 'package:nour_market2/controllers/cart_controller.dart';
import 'package:nour_market2/controllers/productdetail_controller.dart';
import 'package:nour_market2/models/Recommended.dart';
import 'package:nour_market2/models/product_model.dart';
import 'package:nour_market2/views/product_detailPage.dart';

class ProductCard extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final ProductDetailController controller =
  Get.put(ProductDetailController());


  final RxDouble userWeight = 0.0.obs;
  final RxDouble userUnitPrice = 0.0.obs;

  final Product product;
  final HomeController homeController;
  final FavProductController favController;

  ProductCard({
    Key? key,
    required this.product,
    required this.homeController,
    required this.favController,

  }) : super(key: key);

  Widget _buildProductImage() {
    return Positioned.fill(
      child: product.image != null
          ? CachedNetworkImage(
        imageUrl: product.image!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.error, color: Colors.red),
        ),
      )
          : Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${product.price} ",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Obx(
                        () => Icon(
                      homeController.favoriteProductIds.contains(product.id)
                          ? Icons.shopping_cart
                          : Icons.add_shopping_cart,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    cartController.addProduct(
                      product,
                      initialQuantity: controller.quantity.value,
                      note: controller.userNote.value,
                      alternativeOption:
                      controller.selectedAlternativeOption.value,
                      weight: userWeight.value,
                      userQuantityPrice: userUnitPrice.value,
                    );
                    Get.snackbar('تمت الإضافة', 'تم إضافة المنتج إلى السلة',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black87,
                        colorText: Colors.white);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: GetBuilder<FavProductController>(
        builder: (favCtrl) {
          bool isFav = favCtrl.isFavorite(product);
          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.grey[600],
              size: 16.w,
            ),
            onPressed: () => favCtrl.toggleFavorite(product),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailPage(productId: product.id)),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            _buildProductImage(),
            _buildFavoriteButton(),
            _buildProductDetails(),
          ],
        ),
      ),
    );
  }
}
