import 'package:flutter/material.dart';
import 'package:saalt/models/post.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// Timeline post: author, body, optional photo, reaction counts and actions.
class PostCard extends StatelessWidget {
  /// The ring around the author's disc, the ground behind their standing,
  /// and the colour the hashtags carry.
  static const _avatarRing = Color(0xFFFFEDD5);
  static const _badgeGround = Color(0xFFEFEFEF);
  static const _tagInk = Color(0xFFE97451);

  const PostCard({
    super.key,
    required this.post,
    this.isLiked = false,
    this.isSaved = false,
    this.onLike,
    this.onComment,
    this.onSave,
    this.onMenu,
    this.onTapImage,
  });

  final Post post;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onSave;
  final VoidCallback? onMenu;
  final VoidCallback? onTapImage;

  @override
  Widget build(BuildContext context) {
    // Liking adds to the count the post already carries.
    final helpful = post.helpfulCount + (isLiked ? 1 : 0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: .05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: _AuthorRow(post: post, onMenu: onMenu),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Text(
              post.body,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: Color(0xff2D2D2D),
              ),
            ),
          ),
          if (post.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final tag in post.tags)
                    Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: PostCard._tagInk,
                      ),
                    ),
                ],
              ),
            ),
          if (post.imageAsset != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Image.asset(post.imageAsset!),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Divider(
              height: 1,
              color: AppColors.blackColor.withValues(alpha: .05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: _MetaRow(helpful: helpful, comments: post.commentCount),
          ),
          _ActionRow(
            isLiked: isLiked,
            isSaved: isSaved,
            onLike: onLike,
            onComment: onComment,
            onSave: onSave,
          ),
        ],
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.post, this.onMenu});

  final Post post;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 46,
          width: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: post.avatarTint,
            shape: BoxShape.circle,
            border: Border.all(color: PostCard._avatarRing, width: 1.5),
          ),
          child: Text(
            post.initial,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: post.avatarAccent,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      post.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff2D2D2D),
                      ),
                    ),
                  ),
                  if (post.badge != null) ...[
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: PostCard._badgeGround,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post.badge!,
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.6,
                          color: Color(0xff555F70),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '${post.timeAgo} · ${post.group}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xff717171),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Image.asset("assets/icons/more_vert_ic.png", height: 28, width: 20),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.helpful, required this.comments});

  final int helpful;
  final int comments;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppImages.likeFillIcon, height: 20, width: 20),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            '$helpful found this helpful',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xff717171),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$comments comments',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xff717171),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.isLiked,
    required this.isSaved,
    this.onLike,
    this.onComment,
    this.onSave,
  });

  final bool isLiked;
  final bool isSaved;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          _Action(
            asset: AppImages.likeIcon,
            label: 'Like',
            isActive: isLiked,
            onTap: onLike,
          ),
          _Action(
            asset: AppImages.commentIcon,
            label: 'Comment',
            onTap: onComment,
          ),
          _Action(
            asset: AppImages.saveIcon,
            label: 'Save',
            isActive: isSaved,
            onTap: onSave,
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.asset,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final String asset;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.rose : AppColors.ink;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(asset, height: 14),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff2D2D2D),
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
