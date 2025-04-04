import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('الإشعارات', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.primaryColor),
            onPressed: () => Get.find<NotificationController>().fetchNotifications(),
          ),
        ],
      ),
      body: _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return _buildShimmerLoader();
        }
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }
        return RefreshIndicator(
          onRefresh: () async => controller.fetchNotifications(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _NotificationCard(notification: notification);
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, index) => const ShimmerNotificationItem(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('لا توجد إشعارات جديدة', style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 8),
          Text('سيظهر هنا أي إشعارات جديدة تتلقاها',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
        key: Key(notification.id.toString()),
    direction: DismissDirection.endToStart,
    background: _buildDismissBackground(),
    confirmDismiss: (_) => _showDeleteConfirmation(context),
    onDismissed: (_) => _handleDismiss(),
    child: InkWell(
    onTap: _handleTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
    decoration: BoxDecoration(
    color: notification.isUnread
    ? theme.primaryColor.withOpacity(0.05)
        : Colors.transparent,
    border: Border.all(
    color: theme.dividerColor.withOpacity(0.1),
    ),
        ),
    child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    _buildNotificationIcon(),
    const SizedBox(width: 16),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    _buildHeader(theme),
    const SizedBox(height: 8),
    Text(notification.body,
    style: theme.textTheme.bodyMedium),
    if (notification.data != null)
    const SizedBox(height: 8),
    _buildTimestamp(theme),
    ],
    ),
    ),
    _buildUnreadIndicator(),
    ],
    ),
    ),
    ),
    ),
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _getIconColor().withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(_getIconByType(), color: _getIconColor(), size: 24),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(notification.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: notification.isUnread
                    ? FontWeight.bold
                    : FontWeight.w600,
                color: notification.isUnread
                    ? theme.primaryColor
                    : theme.textTheme.titleMedium?.color,
              )),
        ),
        if (notification.type == NotificationType.promotion)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('عرض خاص',
                style: TextStyle(color: Colors.green, fontSize: 12)),
          ),
      ],
    );
  }



  Widget _buildTimestamp(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 14,
            color: theme.textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(timeago.format(notification.timestamp, locale: 'ar'),
            style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildUnreadIndicator() {
    return Visibility(
      visible: notification.isUnread,
      child: Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(left: 8),
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.promotion:
        return Colors.green;
      case NotificationType.system:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconByType() {
    switch (notification.type) {
      case NotificationType.order:
        return Icons.shopping_basket;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.system:
        return Icons.info_outline;
      default:
        return Icons.notifications_none;
    }
  }

  Widget _buildDismissBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_forever, color: Colors.white),
          Text('حذف', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الإشعار؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('حذف', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _handleDismiss() {
    final controller = Get.find<NotificationController>();
    controller.deleteNotification(notification.id.toString());

  }

  void _handleTap() {
    Get.find<NotificationController>().markAsRead(notification.id);
    if (notification.data?['route'] != null) {
      Get.toNamed(notification.data!['route']);
    }
  }
}

class ShimmerNotificationItem extends StatelessWidget {
  const ShimmerNotificationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}