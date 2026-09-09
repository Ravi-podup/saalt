import 'package:flutter/material.dart';
import 'package:saalt/helper/shop_demo.dart';
import 'package:saalt/helper/tmi_helper.dart';
import 'package:saalt/helper/tracker_helper.dart';
import 'package:saalt/res/app_colors.dart';

/// What a notification is about, which decides how it is marked.
enum NotificationKind {
  session(
    'Sessions',
    Icons.sensors_rounded,
    AppColors.rose,
    AppColors.roseTint,
  ),
  order(
    'Orders',
    Icons.local_shipping_outlined,
    AppColors.periwinkle,
    AppColors.periwinkleTint,
  ),
  cycle(
    'Your cycle',
    Icons.water_drop_rounded,
    AppColors.teal,
    AppColors.tealTint,
  ),
  shop(
    'Shop',
    Icons.local_offer_outlined,
    AppColors.apricot,
    AppColors.apricotTint,
  ),
  community(
    'Community',
    Icons.forum_rounded,
    AppColors.lilac,
    AppColors.lilacTint,
  );

  const NotificationKind(this.label, this.icon, this.accent, this.tint);

  final String label;
  final IconData icon;
  final Color accent;
  final Color tint;
}

/// One notification.
class AppNotification {
  const AppNotification({
    required this.kind,
    required this.title,
    required this.body,
    required this.time,
    required this.group,
    this.isUnread = false,
  });

  final NotificationKind kind;
  final String title;
  final String body;

  /// Clock time as it reads in the list.
  final String time;

  /// Today, Yesterday or Earlier — stated rather than worked out from dates.
  final String group;

  final bool isUnread;
}

/// Fixed notifications for the design. The content is drawn from what the app
/// actually holds — the live session, the real orders, the tracker's own
/// prediction — so nothing here contradicts the rest of the screens.
class NotificationDemo {
  NotificationDemo._();

  static List<AppNotification> get all => [
    AppNotification(
      kind: NotificationKind.session,
      title: TmiHelper.live.isEmpty
          ? 'A TMI Party is starting soon'
          : '${TmiHelper.live.first.title} is live',
      body: 'The room is open — join whenever you are ready.',
      time: '9:02',
      group: 'Today',
      isUnread: true,
    ),
    AppNotification(
      kind: NotificationKind.cycle,
      title: TrackerHelper.statusLabel,
      body:
          'Worked out from your last '
          '${TrackerHelper.history.length} cycles.',
      time: '8:15',
      group: 'Today',
      isUnread: true,
    ),
    AppNotification(
      kind: NotificationKind.order,
      title: '${ShopDemo.orders.first.reference} is on its way',
      body: 'Arriving ${ShopDemo.deliveryEstimate}.',
      time: '7:40',
      group: 'Today',
      isUnread: true,
    ),
    const AppNotification(
      kind: NotificationKind.shop,
      title: 'Leakproof Comfort CloudShort is back in your size',
      body: 'One of your saved items is in stock again.',
      time: '18:20',
      group: 'Yesterday',
    ),
    const AppNotification(
      kind: NotificationKind.community,
      title: '3 replies to your post',
      body: 'People are answering your question about first cups.',
      time: '14:05',
      group: 'Yesterday',
    ),
    AppNotification(
      kind: NotificationKind.session,
      title: '${TmiHelper.upcoming.first.title} is open',
      body: 'Places are limited, and this one usually fills.',
      time: '11:30',
      group: 'Earlier',
    ),
    AppNotification(
      kind: NotificationKind.order,
      title: '${ShopDemo.orders[1].reference} was delivered',
      body: 'Left at your door. Tell us if anything is not right.',
      time: '16:45',
      group: 'Earlier',
    ),
  ];

  static const groups = ['Today', 'Yesterday', 'Earlier'];

  static int get unreadCount => all.where((n) => n.isUnread).length;

  static List<AppNotification> forGroup(String group) =>
      all.where((n) => n.group == group).toList();
}
