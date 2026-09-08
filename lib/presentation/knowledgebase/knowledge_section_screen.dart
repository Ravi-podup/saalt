import 'package:flutter/material.dart';
import 'package:saalt/helper/knowledge_helper.dart';
import 'package:saalt/models/article.dart';
import 'package:saalt/models/knowledge_section.dart';
import 'package:saalt/presentation/knowledgebase/widgets/article_row.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/presentation/widgets/search_field.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/router/app_route_paths.dart';

/// Step two: the knowledge filed under one section.
class KnowledgeSectionScreen extends StatefulWidget {
  const KnowledgeSectionScreen({super.key, required this.section});

  static const kSection = 'section';

  static Future open(
    BuildContext context, {
    required KnowledgeSection section,
  }) {
    return context.push(
      AppRoutePaths.knowledgeSectionScreen,
      extra: {kSection: section},
    );
  }

  final KnowledgeSection section;

  @override
  State<KnowledgeSectionScreen> createState() => _KnowledgeSectionScreenState();
}

class _KnowledgeSectionScreenState extends State<KnowledgeSectionScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  late final List<Article> _items = KnowledgeHelper.itemsFor(
    widget.section.title,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Article> get _visible => _items.where((a) => a.matches(_query)).toList();

  void _toast(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final items = _visible;
    final unit = section.isVideo ? 'videos' : 'guides';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: section.title,
              subtitle: '${_items.length} $unit · ${section.subtitle}',
              onBack: () => context.pop(),
            ),
            SearchField(
              controller: _searchController,
              hintText: section.isVideo
                  ? 'Search videos…'
                  : 'Search ${section.title.toLowerCase()} guides…',
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? _EmptyState(query: _query, unit: unit)
                  : ListView.separated(
                      key: const Key('kb-section-list'),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => ArticleRow(
                        article: items[index],
                        onTap: () => _toast(items[index].title),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, required this.unit});

  final String query;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 34,
              color: AppColors.inkFaint,
            ),
            const SizedBox(height: 10),
            Text(
              query.isEmpty ? 'No $unit here yet' : 'No $unit match "$query"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
