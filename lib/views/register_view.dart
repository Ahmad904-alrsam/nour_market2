import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    controller.setStateAddress(); // جلب العناوين عند فتح الصفحة

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // الخلفية المرسومة باستخدام CustomPainter
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: BackgroundPainter(),
            ),
      
            // المحتوى الرئيسي
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                    padding:
                EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
      
                    // الأيقونة والعنوان
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.teal,
                      child: Image.asset('assets/images/photo_2025-02-04_16-43-45-removebg-preview.png')
                    ),
                    SizedBox(height: 10),
                    Text(
                      "إنشاء حساب",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
      
                    SizedBox(height: 40),
      
                    // إدخال الاسم الكامل
                    buildTextField("الاسم الكامل", controller.setFullName),
      
                    SizedBox(height: 15),
      
                    // إدخال رقم الهاتف
                    buildTextField(
                      "رقم الهاتف",
                      controller.setPhoneNumber,
                      keyboardType: TextInputType.phone,
                    ),
      
                    SizedBox(height: 15),
      
                    // اختيار العنوان والمنطقة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            "العنوان",
                            controller.selectedAddress,
                            controller.addressList,
                            controller.setSelectedAddress,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildDropdown(
                            "المنطقة",
                            controller.selectedRegion,
                            controller.regionList,
                            controller.setSelectedRegion,
                          ),
                        ),
                      ],
                    ),
      
                    SizedBox(height: 30),
      
                    // زر إنشاء الحساب
                    ElevatedButton(
                      onPressed: controller.registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "إنشاء حساب",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            )
          ],
        ),
      ),
    );
  }

  // **دالة لإنشاء حقل إدخال (TextField)**
  Widget buildTextField(String hint, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // **دالة لإنشاء قائمة منسدلة (Dropdown)**
  Widget _buildDropdown(String hint, RxString selectedValue, List<String> items,
      Function(String) onChanged) {
    return Obx(
          () => DropdownButtonFormField<String>(
        value: selectedValue.value.isEmpty ? null : selectedValue.value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        hint: Text(hint),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // إعداد فرشاة الرسم بلون teal مع شفافية 30%
    final Paint paint = Paint()
      ..color = Colors.teal.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // رسم الشكل العلوي المنحني
    final Path topPath = Path();
    topPath.moveTo(0, 0);
    topPath.lineTo(0, size.height * 0.25);
    topPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.35,
      size.width,
      size.height * 0.25,
    );
    topPath.lineTo(size.width, 0);
    topPath.close();

    // رسم الشكل السفلي المنحني
    final Path bottomPath = Path();
    bottomPath.moveTo(0, size.height);
    bottomPath.lineTo(0, size.height * 0.83);
    bottomPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.73,
      size.width,
      size.height * 0.83,
    );
    bottomPath.lineTo(size.width, size.height);
    bottomPath.close();

    // رسم المسارين بنفس الفرشاة (teal مع شفافية)
    canvas.drawPath(topPath, paint);
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
