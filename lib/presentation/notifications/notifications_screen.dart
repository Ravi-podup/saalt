import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/helper/notification_demo.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/router/app_route_paths.dart';

/// Notifications, grouped by when they landed. A static screen: the list is
/// stated, and the controls are live to the touch without acting.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.notificationsScreen);
  }

  @override
  Widget build(BuildContext context) {
    final unread = NotificationDemo.unreadCount;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Notifications',
              subtitle: unread == 0 ? 'All caught up' : '$unread new',
              onBack: () => context.pop(),
              trailing: _MarkAllRead(onTap: () {}),
            ),
            Expanded(
              child: ListView(
                key: const Key('notifications-body'),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                children: [
                  for (final group in NotificationDemo.groups) ...[
                    if (NotificationDemo.forGroup(group).isNotEmpty) ...[
                      _GroupLabel(group),
                      for (final item in NotificationDemo.forGroup(group))
                        _NotificationRow(item: item),
                      const SizedBox(height: 18),
                    ],
                  ],
                  const _Footnote(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: AppColors.inkFaint,
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        // Unread carries a soft wash, which is quieter than a dot alone and
        // survives being read at arm's length.
        color: item.isUnread ? AppColors.surface : AppColors.canvas,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: item.isUnread ? AppColors.rose : AppColors.hairline,
                width: item.isUnread ? 1.3 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: item.kind.tint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.kind.icon,
                    size: 18,
                    color: item.kind.accent,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.3,
                                fontWeight: item.isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                letterSpacing: -0.2,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.time,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkFaint,
                            ),
                          ),
                          if (item.isUnread) ...[
                            const SizedBox(width: 6),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 7,
                              width: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.rose,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: const TextStyle(
                          fontSize: 11.5,
                          height: 1.45,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        item.kind.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: item.kind.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarkAllRead extends StatelessWidget {
  const _MarkAllRead({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            'Mark all read',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.rose,
            ),
          ),
        ),
      ),
    );
  }
}

class _Footnote extends StatelessWidget {
  const _Footnote();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 13, color: AppColors.inkFaint),
        SizedBox(width: 7),
        Expanded(
          child: Text(
            'Push notifications are set up in your phone settings. Nothing '
            'is scheduled from the app yet.',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.4,
              color: AppColors.inkFaint,
            ),
          ),
        ),
      ],
    );
  }
}
