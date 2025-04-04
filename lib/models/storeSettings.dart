class StoreSettings {
  final String storeStatus;
  final String openingTime; // بصيغة HH:mm:ss
  final String closingTime; // بصيغة HH:mm:ss
  final List<String> workingDays;
  final int isShowPrice; // 1 لإظهار السعر، 0 لإخفائه
  final int isShowCart;  // 1 لإظهار السلة، 0 لإخفائها

  StoreSettings({
    required this.storeStatus,
    required this.openingTime,
    required this.closingTime,
    required this.workingDays,
    required this.isShowPrice,
    required this.isShowCart,
  });

  factory StoreSettings.fromJson(Map<String, dynamic> json) {
    return StoreSettings(
      storeStatus: json['store_status'] as String,
      openingTime: json['opening_time'] as String,
      closingTime: json['closing_time'] as String,
      workingDays: List<String>.from(json['working_days']),
      isShowPrice: json['is_show_price'] as int,
      isShowCart: json['is_show_cart'] as int,
    );
  }
}
