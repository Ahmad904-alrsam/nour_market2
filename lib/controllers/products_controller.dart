import 'package:get/get.dart';
import '../models/product.dart';
import '../services/product_provider.dart';

class ProductsController extends GetxController {
  final int subcategoryId;
  ProductsController({required this.subcategoryId});

  var isLoading = true.obs;
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      final response = await ApiService().fetchProducts(subcategoryId);

      // تحقق إذا كانت البيانات غير فارغة
      if (response.statusCode == 200 && response.body != null) {
        if (response.body is List) {
          // تحويل البيانات الحقيقية إلى كائنات Product
          products.value = (response.body as List)
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();
          print("Fetched products: ${products.length}");
        } else {
          print("Error: response.body is not a List");
        }
      } else {
        print("Error: Invalid response with status ${response.statusCode}");
      }

      // إذا كانت البيانات فارغة، عرض بيانات وهمية
      if (products.isEmpty) {
        print("No products found, displaying fake data...");
        products.value = [
          Product(
            id: 1,
            title: "هاتف ذكي",
            price: 299.99,
            imageUrl: "https://via.placeholder.com/150",
            subcategoryId: subcategoryId,
            unit:"قطعة", // تأكد من تمرير القيمة المطلوبة
          ),
          Product(
            id: 2,
            title: "لابتوب احترافي",
            price: 899.99,
            imageUrl: "https://via.placeholder.com/150",
            subcategoryId: subcategoryId,
            unit: "فرط", // تعديل الوحدة حسب الحاجة
          ),
          Product(
            id: 3,
            title: "سماعة رأس بلوتوث",
            price: 49.99,
            imageUrl: "https://via.placeholder.com/150",
            subcategoryId: subcategoryId,
            unit: "قطعة", // أو "فرط" إذا كان المنتج يباع بهذه الوحدة
          ),
        ];
      }

    } catch (e) {
      print("Error fetching products: $e");
      // عرض بيانات وهمية عند حدوث خطأ
      products.value = [
        Product(id: 1, title: "هاتف ذكي", price: 299.99, imageUrl: "https://via.placeholder.com/150", subcategoryId: subcategoryId,unit: "فرط"),
        Product(id: 2, title: "لابتوب احترافي", price: 899.99, imageUrl: "https://via.placeholder.com/150", subcategoryId: subcategoryId,unit: "فرط"),
        Product(id: 3, title: "سماعة رأس بلوتوث", price: 49.99, imageUrl: "https://via.placeholder.com/150", subcategoryId: subcategoryId,unit: "فرط"),
      ];
    } finally {
      isLoading(false);
    }
  }

}
