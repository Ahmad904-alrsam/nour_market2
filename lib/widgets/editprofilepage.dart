import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class EditProfilePage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تعبئة الحقول بالبيانات الحالية
    final user = userController.user.value;
    _nameController.text = user.name ?? '';
    _phoneController.text = user.phone ?? '';
    _cityController.text = user.city ?? '';
    _detailsController.text = user.detailsLocation ?? '';
    _governorateController.text = user.governorate ?? '';
    _districtController.text = user.district ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الملف الشخصي'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [Obx(() {
              return Center(
                child: GestureDetector(
                  onTap: () => userController.pickImage(), // النقر على أي جزء من الصورة يفتح المعرض
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userController.profileImage.value != null
                            ? FileImage(userController.profileImage.value!) // صورة المستخدم المختارة
                            : const AssetImage('assets/images/default_avatar.png') as ImageProvider, // الصورة الافتراضية
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white), // أيقونة الكاميرا
                          onPressed: () => userController.pickImage(), // يمكن إزالة هذا إذا كان النقر على الصورة كافٍ
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
              SizedBox(height: 15),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الاسم مطلوب';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'رقم الهاتف مطلوب';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'رقم الهاتف غير صالح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'المدينة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'المدينة مطلوبة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(
                  labelText: 'تفاصيل العنوان',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'التفاصيل مطلوبة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _governorateController,
                decoration: InputDecoration(
                  labelText: 'المحافظة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'المحافظة مطلوبة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(
                  labelText: 'المنطقة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'المنطقة مطلوبة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              Obx(() {
                return userController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'حفظ التغييرات',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // استخدام الدالة الخاصة بتحديث بيانات المستخدم مع الصورة
      await userController.updateUserWithImage(
        name: _nameController.text,
        phone: _phoneController.text,
        city: _cityController.text,
        detailsLocation: _detailsController.text,
        governorate: _governorateController.text,
        district: _districtController.text,
      );
    }
  }
}
