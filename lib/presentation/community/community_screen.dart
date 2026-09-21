import 'package:flutter/material.dart';
import 'package:saalt/helper/community_helper.dart';
import 'package:saalt/models/post.dart';
import 'package:saalt/presentation/community/widgets/post_card.dart';
import 'package:saalt/presentation/community/widgets/stories_row.dart';
import 'package:saalt/presentation/widgets/app_bottom_nav.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/res/app_images.dart';
import 'package:saalt/router/app_route_paths.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.communityScreen);
  }

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  static const _filters = ['All', 'Text', 'Photos', 'Videos'];

  static const _storytellers = [
    Storyteller(
      name: 'Jenny',
      imageAsset: AppImages.storyJennyImg,
      isOnline: true,
    ),
    Storyteller(name: 'Micky', imageAsset: AppImages.storyMickyImg),
    Storyteller(name: 'Amelia', imageAsset: AppImages.storyAmeliaImg),
  ];

  String _filter = 'All';
  final _liked = <String>{};
  final _saved = <String>{};

  /// The chips above the timeline are a design element: picking one marks
  /// it, but the two posts below stay put.
  List<Post> get _visible => CommunityHelper.timeline;

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
      body: SafeArea(
        // bottom: false,
        child: Column(
          children: [
            // Pinned: brand row stays; everything below it scrolls.
            _CommunityHeader(
              onBack: () => context.pop(),
              onSearch: () => _toast('Search the Collective'),
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHead(
                          title: 'Active Now',
                          action: 'View All',
                          onAction: () => _toast('Everyone online'),
                        ),
                        const SizedBox(height: 18),
                        StoriesRow(
                          people: _storytellers,
                          onAdd: () => _toast('Add a story'),
                          onOpen: (p) => _toast("\${p.name}'s story"),
                        ),
                      ],
                    );
                  }
                  if (index == 1) {
                    return _Composer();
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
      bottomNavigationBar: const AppBottomNav(
        selected: 'Saalt',
        items: BottomNavItem.collective,
      ),
    );
  }
}

/// Brand row: back on the left, the section name centred, actions opposite.
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
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Row(
        children: [
          _BackButton(onTap: onBack),
          const Expanded(
            child: Text(
              'Community',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.ink,
              ),
            ),
          ),
          _ImageButton(asset: AppImages.searchButtonIcon, onTap: onSearch),
          const SizedBox(width: 6),
          _ImageButton(
            asset: AppImages.notificationButtonIcon,
            onTap: onNotifications,
          ),
          const SizedBox(width: 6),
          _ImageButton(
            asset: AppImages.profilePictureCircleImage,
            onTap: onProfile,
          ),
        ],
      ),
    );
  }
}

/// The one header control with no artwork of its own, drawn to match the
/// others: a white disc on the beige page.
class _BackButton extends StatelessWidget {
  const _BackButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            height: 40,
            width: 40,
            child: Icon(
              Icons.arrow_back_rounded,
              size: 19,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageButton extends StatelessWidget {
  const _ImageButton({required this.asset, this.onTap});

  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Image.asset(asset, height: 44, width: 44),
    );
  }
}

/// A run-in heading with its own link, the way the timeline announces a
/// section.
class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.2,
              color: Color(0xff2D2D2D),
            ),
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Text(
              action!,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xffC95878),
              ),
            ),
          ),
      ],
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
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? Colors.white : Color(0xff2D2D2D),
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
            border: Border.all(color: Color(0xffD9D9D9), width: 2),
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xffF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/icons/profile_ic.png", height: 20),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Text(
                  "What's on your mind today?",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff9CA3AF),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Image.asset("assets/icons/share_ic.png", height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
