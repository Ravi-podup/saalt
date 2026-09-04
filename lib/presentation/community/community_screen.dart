import 'package:flutter/material.dart';
import 'package:saalt/helper/community_helper.dart';
import 'package:saalt/models/post.dart';
import 'package:saalt/presentation/community/widgets/post_card.dart';
import 'package:saalt/presentation/community/widgets/stories_row.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';
import 'package:saalt/res/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  static const _filters = ['All', 'Text', 'Photos', 'Videos', 'Groups'];

  /// Groups the viewer follows, used by the Groups filter.
  static const _joined = {'Cup life', 'Postpartum'};

  static const _storytellers = [
    Storyteller(
      name: 'Priya',
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    Storyteller(
      name: 'Kayla',
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    Storyteller(
      name: 'Dee',
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    Storyteller(
      name: 'Renee',
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
    Storyteller(
      name: 'Tomi',
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
      hasUnseen: false,
    ),
    Storyteller(
      name: 'Sam',
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
      hasUnseen: false,
    ),
  ];

  String _filter = 'All';
  final _liked = <String>{};
  final _saved = <String>{};

  List<Post> get _visible => switch (_filter) {
    'Text' =>
      CommunityHelper.timeline.where((p) => p.imageAsset == null).toList(),
    'Photos' =>
      CommunityHelper.timeline
          .where((p) => p.imageAsset != null && !p.isVideo)
          .toList(),
    'Videos' => CommunityHelper.timeline.where((p) => p.isVideo).toList(),
    'Groups' =>
      CommunityHelper.timeline.where((p) => _joined.contains(p.group)).toList(),
    _ => CommunityHelper.timeline,
  };

  void _toast(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(milliseconds: 1300),
      ),
    );
  }

  void _toggle(Set<String> set, String id) {
    setState(() => set.contains(id) ? set.remove(id) : set.add(id));
  }

  @override
  Widget build(BuildContext context) {
    final posts = _visible;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Pinned: brand row stays; everything below it scrolls.
            _CommunityHeader(
              onBack: () => Navigator.of(context).maybePop(),
              onSearch: () => _toast('Search the community'),
              onNotifications: () => _toast('No new notifications'),
              onProfile: () => _toast('Profile'),
            ),
            Expanded(
              child: ListView.separated(
                key: const Key('community-timeline'),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                itemCount: posts.length + 3,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return StoriesRow(
                      people: _storytellers,
                      onAdd: () => _toast('Add a story'),
                      onOpen: (p) => _toast("\${p.name}'s story"),
                    );
                  }
                  if (index == 1) {
                    return _Composer(onTap: () => _toast('New post'));
                  }
                  if (index == 2) {
                    return _FilterBar(
                      filters: _filters,
                      selected: _filter,
                      onSelect: (f) => setState(() => _filter = f),
                    );
                  }
                  final post = posts[index - 3];
                  return PostCard(
                    post: post,
                    isLiked: _liked.contains(post.id),
                    isSaved: _saved.contains(post.id),
                    onLike: () => _toggle(_liked, post.id),
                    onSave: () => _toggle(_saved, post.id),
                    onComment: () =>
                        _toast('${post.commentCount} comments on this post'),
                    onMenu: () => _toast('Report or mute'),
                    onTapImage: () => _toast('Photo from ${post.author}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        selected: 'Home',
        items: [
          BottomNavItem.home(),
          const BottomNavItem(label: 'Groups', icon: Icons.groups_rounded),
          const BottomNavItem(
            label: 'Chat',
            icon: Icons.chat_bubble_rounded,
            badgeCount: 3,
          ),
          const BottomNavItem(label: 'Events', icon: Icons.event_rounded),
          const BottomNavItem(label: 'You', icon: Icons.person_rounded),
        ],
      ),
    );
  }
}

/// Brand row: wordmark and section name on the left, actions on the right.
class _CommunityHeader extends StatelessWidget {
  const _CommunityHeader({
    this.onBack,
    this.onSearch,
    this.onNotifications,
    this.onProfile,
  });

  final VoidCallback? onBack;
  final VoidCallback? onSearch;
  final VoidCallback? onNotifications;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            visualDensity: VisualDensity.compact,
            tooltip: 'Back',
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 20,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            'Community',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.ink,
            ),
          ),
          const Spacer(),
          _HeaderAction(
            icon: Icons.search_rounded,
            onTap: onSearch,
            tooltip: 'Search',
          ),
          _HeaderAction(
            icon: Icons.notifications_none_rounded,
            showDot: true,
            onTap: onNotifications,
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 4),
          _ProfileAvatar(onTap: onProfile),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    this.showDot = false,
    this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final bool showDot;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 21, color: AppColors.ink),
              if (showDot)
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: AppColors.rose,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.canvas, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Profile',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          height: 34,
          width: 34,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        key: const Key('community-filters'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = filter == selected;
          return Material(
            color: isActive ? AppColors.ink : AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () => onSelect(filter),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive ? AppColors.ink : AppColors.hairline,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.inkMuted,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Prompt at the top of the timeline.
class _Composer extends StatelessWidget {
  const _Composer({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.periwinkleTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 19,
                  color: AppColors.periwinkle,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Text(
                  "What's on your mind today?",
                  style: TextStyle(fontSize: 13, color: AppColors.inkFaint),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 34,
                width: 34,
                decoration: const BoxDecoration(
                  color: AppColors.rose,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
