import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/location_controller.dart';
import '../controllers/register_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/backgroundPainter.dart';

class RegisterView extends StatelessWidget {
  final RegisterController controller =
  Get.put(RegisterController(), permanent: true);
  final LocationController locationController =
  Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              CustomPaint(
                size: MediaQuery
                    .of(context)
                    .size,
                painter: BackgroundPainter(),
              ),
              Center(
                child: SingleChildScrollView(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: Colors.teal,
                          child: Image.asset(
                            'assets/images/photo_2025-02-04_16-43-45-removebg-preview.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "إنشاء حساب",
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Cairo'),
                        ),
                        SizedBox(height: 40.h),
                        buildTextField("الاسم الكامل ",
                            controller.nameController,
                            icon: Icons.person),
                        SizedBox(height: 15.h),
                        buildTextField("رقم الهاتف ",
                            controller.phoneController,
                            keyboardType: TextInputType.phone,
                            icon: Icons.phone),
                        SizedBox(height: 15.h),
                        // قائمة المحافظات والمناطق مع رموز تعبيرية
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                    () =>
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                            Icons.location_city, size: 24.sp),
                                        labelText: 'المحافظة ',
                                        labelStyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Cairo'),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 14.h),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.r),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      value: locationController
                                          .selectedGovernorate.value,
                                      items: locationController.governorates
                                          .map(
                                            (gov) =>
                                            DropdownMenuItem(
                                              value: gov,
                                              child: Text(gov,
                                                  style: TextStyle(
                                                      fontFamily: 'Cairo',fontSize: 14)),
                                            ),
                                      )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          locationController.selectedGovernorate
                                              .value =
                                              value;
                                          locationController
                                              .updateSelectedRegion();
                                          locationController
                                              .updateSelectedDistrict();
                                        }
                                      },
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                    () =>
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                            Icons.map, size: 24.sp),
                                        labelText: 'المنطقة ',
                                        labelStyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Cairo'),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 14.h),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.r),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      value: locationController.selectedRegion
                                          .value,
                                      items: locationController.filteredRegions
                                          .map(
                                            (region) =>
                                            DropdownMenuItem(
                                              value: region.name,
                                              child: Text(region.name,
                                                  style: TextStyle(
                                                      fontFamily: 'Cairo',fontSize: 14)),
                                            ),
                                      )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          locationController.selectedRegion
                                              .value =
                                              value;
                                          locationController
                                              .updateSelectedDistrict();
                                        }
                                      },
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                    () =>
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                            Icons.home, size: 24.sp),
                                        labelText: 'الحي ',
                                        labelStyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Cairo'),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 14.h),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.r),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      value: locationController.selectedDistrict
                                          .value,
                                      items: locationController
                                          .filteredDistricts
                                          .map(
                                            (district) =>
                                            DropdownMenuItem(
                                              value: district.name,
                                              child: Text(district.name,
                                                  style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                  fontSize: 14)),
                                            ),
                                      )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          locationController.selectedDistrict
                                              .value =
                                              value;
                                        }
                                      },
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        buildTextField("تفاصيل الموقع ",
                            controller.detailsController,
                            icon: Icons.location_on),
                        SizedBox(height: 30.h),
                        ElevatedButton(
                          onPressed: () async {
                            // عرض مؤشر التحميل
                            Get.dialog(
                              Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            // استدعاء دالة التسجيل وانتظار النتيجة
                            final success = await controller.register(); // تأكد إن الدالة بتعيد نتيجة نجاح التسجيل

                            // إغلاق الـ dialog بعد انتهاء العملية
                            if (Get.isDialogOpen ?? false) {
                              Get.back();
                            }

                            // التنقل للصفحة الرئيسية فقط إذا كانت العملية ناجحة
                            if (success) {
                              Get.offNamed(Routes.HOME);
                            } else {
                              // تعامل مع الخطأ مثلاً بعرض رسالة تنبيه
                              Get.snackbar("خطأ", "فشل إنشاء الحساب");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            minimumSize: Size(double.infinity, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "إنشاء حساب",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontFamily: 'Cairo'
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        textAlign: TextAlign.right, // لضبط الكتابة من اليمين لليسار
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14.sp, fontFamily: 'Cairo'),
        validator: (value) {
          if (value?.trim().isEmpty ?? true) {
            return 'رجاءً أدخل $hint';
          }
          if (hint.contains("رقم الهاتف")) {
            if (!RegExp(r'^\d+$').hasMatch(value!)) {
              return 'الرجاء إدخال رقم هاتف صحيح';
            }
            if (value.length < 10) {
              return 'رقم الهاتف يجب أن يكون على الأقل 10 أرقام';
            }
            // شرط التأكد من أن الرقم يبدأ بـ "09"
            if (!value.startsWith("09")) {
              return 'يجب أن يبدأ رقم الهاتف بـ 09';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, size: 24.sp) : null,
          labelText: hint,
          labelStyle: TextStyle(
              color: Colors.grey[700], fontSize: 12.sp, fontFamily: 'Cairo'),
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey[400], fontFamily: 'Cairo', fontSize: 12.sp),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(
              color: Colors.red, fontSize: 10.sp, fontFamily: 'Cairo'),
        ),
      ),
    );
  }
}