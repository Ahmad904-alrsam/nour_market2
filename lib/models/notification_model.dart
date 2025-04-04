import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsResponse {
  final String message;
  final PaginatedNotifications notifications;
  final String body;

  NotificationsResponse({
    required this.message,
    required this.notifications,
    required this.body,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      message: json['message'] as String,
      notifications: PaginatedNotifications.fromJson(json['notifications']),
      body: json['body'] as String,
    );
  }
}

class PaginatedNotifications {
  final int currentPage;
  final List<NotificationModel> data;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  PaginatedNotifications({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory PaginatedNotifications.fromJson(Map<String, dynamic> json) {
    return PaginatedNotifications(
      currentPage: json['current_page'] as int,
      data: (json['data'] as List).map((i) => NotificationModel.fromJson(i)).toList(),
      firstPageUrl: json['first_page_url'] as String,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int,
      lastPageUrl: json['last_page_url'] as String,
      links: (json['links'] as List).map((i) => PageLink.fromJson(i)).toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: json['per_page'] as int,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] as int?,
      total: json['total'] as int,
    );
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    required this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );
  }
}

enum NotificationType { order, promotion, system, other }
enum NotificationStatus { unread, read }

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Pivot pivot;
  final NotificationType type;
  final NotificationStatus status;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
    required this.type,
    required this.status,
    this.data,
  });

  DateTime get timestamp => createdAt;
  bool get isUnread => status == NotificationStatus.unread;

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Pivot? pivot,
    NotificationType? type,
    NotificationStatus? status,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pivot: pivot ?? this.pivot,
      type: type ?? this.type,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      isActive: (json['is_active'] as int) == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pivot: Pivot.fromJson(json['pivot']),
      type: _parseNotificationType(json['type'] ?? 'other'),
      status: json['status'] == 'read'
          ? NotificationStatus.read
          : NotificationStatus.unread,
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
    );
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return NotificationType.order;
      case 'promotion':
        return NotificationType.promotion;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.other;
    }
  }

  // Add this method to handle RemoteMessage
  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      id: message.messageId.hashCode, // You might want to handle the ID differently
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      pivot: Pivot(userId: 0, notificationId: 0, id: 0), // Dummy pivot, adjust as needed
      type: NotificationType.other,
      status: NotificationStatus.unread,
      data: message.data,
    );
  }
}

class Pivot {
  final int userId;
  final int notificationId;
  final int id;

  Pivot({
    required this.userId,
    required this.notificationId,
    required this.id,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      userId: json['user_id'] as int,
      notificationId: json['notification_id'] as int,
      id: json['id'] as int,
    );
  }
}