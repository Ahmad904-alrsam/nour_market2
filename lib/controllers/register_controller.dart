import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../services/register_provider.dart';

class RegisterController extends GetxController {
  final RegisterProvider api = RegisterProvider();

  var fullName = ''.obs;
  var phoneNumber = ''.obs;
  var selectedAddress = ''.obs;
  var selectedRegion = ''.obs;

  var addressList = <String>[].obs;
  var regionList = ["المنطقة 1", "المنطقة 2", "المنطقة 3"].obs;

  // دوال تحديث الحقول
  void setFullName(String name) => fullName.value = name;
  void setPhoneNumber(String phone) => phoneNumber.value = phone;
  void setSelectedAddress(String address) => selectedAddress.value = address;
  void setSelectedRegion(String region) => selectedRegion.value = region;

  // جلب قائمة العناوين باستخدام البيانات الوهمية
  Future<void> setStateAddress() async {
    try {
      var response = await api.fetchAddresses();
      if (response.statusCode == 200) {
        List<dynamic> data = response.body;
        addressList.value = data.map((item) => item['name'].toString()).toList();
      } else {
        Get.snackbar("خطأ", "لم يتمكن التطبيق من تحميل العناوين");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر");
    }
  }

  // إرسال بيانات التسجيل باستخدام البيانات الوهمية
  Future<void> registerUser() async {
    if (fullName.value.isEmpty ||
        phoneNumber.value.isEmpty ||
        selectedAddress.value.isEmpty ||
        selectedRegion.value.isEmpty) {
      Get.snackbar("تنبيه", "يرجى ملء جميع الحقول");
      return;
    }

    try {
      var response = await api.registerUser({
        "full_name": fullName.value,
        "phone": phoneNumber.value,
        "address": selectedAddress.value,
        "region": selectedRegion.value,
      });

      if (response.statusCode == 201) {
        Get.snackbar("نجاح", response.body["message"]);
        Get.offNamed(Routes.HOME);
      } else {
        Get.snackbar("خطأ", "فشل التسجيل، حاول مجددًا");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالسيرفر");
    }
  }
}
