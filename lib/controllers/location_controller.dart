// controllers/location_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class LocationController extends GetxController {
  // القوائم التي سيتم ملؤها من الـ API
  var governorates = <String>[].obs;
  var regions = <Region>[].obs;
  var districts = <District>[].obs;
  var isLoading = true.obs;
  RxDouble deliveryCost = 0.0.obs;


  // القيم المختارة لكل Dropdown
  var selectedGovernorate = ''.obs;
  var selectedRegion = ''.obs;
  var selectedDistrict = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  // جلب البيانات من الـ API
  Future<void> fetchLocations() async {
    final url = 'https://nour-market.site/api/settings'; // استبدل بعنوان API الفعلي
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        governorates.value = List<String>.from(data['governorates']);
        regions.value = (data['regions'] as List)
            .map((regionJson) => Region.fromJson(regionJson))
            .toList();
        districts.value = (data['districts'] as List)
            .map((districtJson) => District.fromJson(districtJson))
            .toList();

        // تعيين تكلفة التوصيل إذا كانت موجودة في البيانات
        if (data.containsKey('deliveryCost')) {
          deliveryCost.value = double.tryParse(data['deliveryCost'].toString()) ?? 2000;
        } else {
          deliveryCost.value = 2000;
        }

        // تعيين القيم الافتراضية
        if (governorates.isNotEmpty) {
          selectedGovernorate.value = governorates[0];
        }
        updateSelectedRegion();
        updateSelectedDistrict();
      } else {
        Get.snackbar('خطأ', 'فشل تحميل البيانات');
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  List<Region> get filteredRegions {
    return regions
        .where((region) => region.governorateName == selectedGovernorate.value)
        .toList();
  }

  // تصفية الأحياء بناءً على المنطقة المختارة
  List<District> get filteredDistricts {
    return districts
        .where((district) => district.regionName == selectedRegion.value)
        .toList();
  }


   void updateSelectedRegion() {
    if (filteredRegions.isNotEmpty) {
      selectedRegion.value = filteredRegions[0].name;
    } else {
      selectedRegion.value = '';
    }
  }

  // تحديث الحي المختار بعد تغيير المنطقة
  void updateSelectedDistrict() {
    if (filteredDistricts.isNotEmpty) {
      selectedDistrict.value = filteredDistricts[0].name;
    } else {
      selectedDistrict.value = '';
    }
  }
}

