import 'package:flutter/material.dart';
import 'package:saalt/models/post.dart';
import 'package:saalt/res/app_colors.dart';

/// Timeline post: author, body, optional photo, reaction counts and actions.
class PostCard extends StatelessWidget {
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
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 8, 0),
            child: _AuthorRow(post: post, onMenu: onMenu),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Text(
              post.body,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: AppColors.ink,
              ),
            ),
          ),
          if (post.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final tag in post.tags)
                    Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: post.avatarAccent,
                      ),
                    ),
                ],
              ),
            ),
          if (post.imageAsset != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: _PostImage(
                asset: post.imageAsset!,
                isVideo: post.isVideo,
                onTap: onTapImage,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: _MetaRow(
              helpful: helpful,
              comments: post.commentCount,
              isLiked: isLiked,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Divider(height: 1, color: AppColors.hairline),
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
          height: 42,
          width: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: post.avatarTint,
            shape: BoxShape.circle,
          ),
          child: Text(
            post.initial,
            style: TextStyle(
              fontSize: 16,
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
                children: [
                  Flexible(
                    child: Text(
                      post.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  if (post.badge != null) ...[
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: post.avatarTint,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        post.badge!,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                          color: post.avatarAccent,
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
                  color: AppColors.inkFaint,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onMenu,
          visualDensity: VisualDensity.compact,
          icon: const Icon(
            Icons.more_horiz_rounded,
            size: 20,
            color: AppColors.inkFaint,
          ),
        ),
      ],
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({required this.asset, this.isVideo = false, this.onTap});

  final String asset;
  final bool isVideo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                asset,
                fit: BoxFit.cover,
                // A missing photo should not tear a hole in the timeline.
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: AppColors.hairline,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 26,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
              ),
              if (isVideo)
                Center(
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 30,
                      color: Colors.white,
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

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.helpful,
    required this.comments,
    required this.isLiked,
  });

  final int helpful;
  final int comments;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 19,
          width: 19,
          decoration: BoxDecoration(
            color: isLiked ? AppColors.rose : AppColors.roseTint,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite_rounded,
            size: 10,
            color: isLiked ? Colors.white : AppColors.rose,
          ),
        ),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            '$helpful found this helpful',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$comments comments',
          style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
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
            icon: isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            label: 'Like',
            isActive: isLiked,
            onTap: onLike,
          ),
          _Action(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Comment',
            onTap: onComment,
          ),
          _Action(
            icon: isSaved
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
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
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.rose : AppColors.inkMuted;

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
                Icon(icon, size: 17, color: color),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: color,
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
