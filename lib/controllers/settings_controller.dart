import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/storeSettings.dart';

// تعريف متحكم isShowPrice كـ RxBool من GetX
RxBool isShowPrices = false.obs;

Future<bool> storeStatus() async {
  try {
    final response = await http.get(Uri.parse("https://nour-market.site/api/settings"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData["message"] == "successful") {
        final StoreSettings settings = StoreSettings.fromJson(jsonData["setting"]);
        return isStoreOpen(settings);
      }
    }
  } catch (e) {
    print("Error fetching store settings: $e");
  }
  return false;
}

Future<StoreSettings?> fetchStoreSettings() async {
  try {
    final response =
    await http.get(Uri.parse("https://nour-market.site/api/settings"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData["message"] == "successful") {
        return StoreSettings.fromJson(jsonData["setting"]);
      }
    }
  } catch (e) {
    print("Error fetching store settings: $e");
  }
  return null;
}

/// دالة تتحقق مما إذا كان المتجر مفتوحاً وفق الإعدادات
bool isStoreOpen(StoreSettings settings) {
  // 1. التحقق من حالة المتجر العامة
  if (settings.storeStatus.toLowerCase() != 'open') {
    print('Store status is not open');
    return false;
  }

  final now = DateTime.now();
  final dayName = getArabicDayName(now.weekday);

  // 2. التحقق من أيام العمل
  if (!settings.workingDays.contains(dayName)) {
    print('Today ($dayName) is not a working day');
    return false;
  }

  // 3. معالجة أوقات العمل
  final openingParts = settings.openingTime.split(":");
  final closingParts = settings.closingTime.split(":");

  // تحويل الأوقات مع التعامل مع القيم الناقصة
  int openHour = int.parse(openingParts[0]);
  int openMinute = int.parse(openingParts[1]);
  int openSecond = openingParts.length >= 3 ? int.parse(openingParts[2]) : 0;

  int closeHour = int.parse(closingParts[0]);
  int closeMinute = int.parse(closingParts[1]);
  int closeSecond = closingParts.length >= 3 ? int.parse(closingParts[2]) : 0;

  DateTime openingTime = DateTime(
    now.year,
    now.month,
    now.day,
    openHour,
    openMinute,
    openSecond,
  );

  DateTime closingTime = DateTime(
    now.year,
    now.month,
    now.day,
    closeHour,
    closeMinute,
    closeSecond,
  );

  // 4. التعامل مع الحالات التي تتجاوز منتصف الليل
  if (closingTime.isBefore(openingTime)) {
    closingTime = closingTime.add(Duration(days: 1));
  }

  // 5. التحقق النهائي من الوقت
  bool isOpen = now.isAfter(openingTime) && now.isBefore(closingTime);
  print('Store open time: $openingTime - $closingTime');
  print('Current time: $now');
  print('Is store open? $isOpen');

  return isOpen;
}

String getArabicDayName(int weekday) {
  const days = {
    1: "الإثنين",
    2: "الثلاثاء",
    3: "الأربعاء",
    4: "الخميس",
    5: "الجمعة",
    6: "السبت",
    7: "الأحد",
  };
  return days[weekday] ?? "";
}

void checkStoreAndPrice() async {
  bool storeOpen = await storeStatus();

  // التحقق من القيمة داخل متحكم isShowPrice
  if (isShowPrices.value) {
    if (storeOpen) {
      print('Store is open and prices should be shown.');
      // منطق عرض الأسعار هنا
    } else {
      print('Store is closed or prices should not be shown.');
      // منطق آخر هنا
    }
  } else {
    print('isShowPrice value is false or null');
  }
}