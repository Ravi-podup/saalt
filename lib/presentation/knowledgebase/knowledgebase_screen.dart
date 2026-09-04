import 'package:flutter/material.dart';
import 'package:saalt/helper/knowledge_helper.dart';
import 'package:saalt/models/article.dart';
import 'package:saalt/models/knowledge_section.dart';
import 'package:saalt/presentation/knowledgebase/knowledge_section_screen.dart';
import 'package:saalt/presentation/knowledgebase/widgets/article_row.dart';
import 'package:saalt/presentation/knowledgebase/widgets/faq_tile.dart';
import 'package:saalt/presentation/knowledgebase/widgets/section_panel.dart';
import 'package:saalt/presentation/widgets/screen_header.dart';
import 'package:saalt/presentation/widgets/search_field.dart';
import 'package:saalt/res/app_colors.dart';

/// Step one of the knowledgebase: search everything, or pick a section. The
/// knowledge itself lives on [KnowledgeSectionScreen].
class KnowledgebaseScreen extends StatefulWidget {
  const KnowledgebaseScreen({super.key});

  @override
  State<KnowledgebaseScreen> createState() => _KnowledgebaseScreenState();
}

class _KnowledgebaseScreenState extends State<KnowledgebaseScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearching => _query.isNotEmpty;

  /// Search spans the whole library, not one section, which is the point of
  /// putting it on the landing screen.
  List<Article> get _matches =>
      KnowledgeHelper.library.where((a) => a.matches(_query)).toList();

  void _open(KnowledgeSection section) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KnowledgeSectionScreen(section: section),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final sections = KnowledgeHelper.sections;
    final matches = _matches;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Knowledgebase',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            SearchField(
              controller: _searchController,
              hintText: 'Search all guides and videos…',
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                key: const Key('kb-sections'),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                children: _isSearching
                    ? _searchResults(matches)
                    : _browse(sections),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _searchResults(List<Article> matches) => [
    if (matches.isEmpty)
      _NoResults(query: _query)
    else ...[
      _ResultCount(count: matches.length),
      const SizedBox(height: 12),
      for (final item in matches) ...[
        ArticleRow(article: item, onTap: () => _toast(item.title)),
        const SizedBox(height: 10),
      ],
    ],
  ];

  List<Widget> _browse(List<KnowledgeSection> sections) => [
    for (final section in sections) ...[
      SectionPanel(
        section: section,
        items: KnowledgeHelper.itemsFor(section.title),
        onTap: () => _open(section),
      ),
      const SizedBox(height: 12),
    ],
    const SizedBox(height: 14),
    const _SectionLabel('Quick answers'),
    const SizedBox(height: 12),
    for (final faq in KnowledgeHelper.faqs) ...[
      FaqTile(faq: faq),
      const SizedBox(height: 10),
    ],
  ];
}

class _ResultCount extends StatelessWidget {
  const _ResultCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        '$count ${count == 1 ? 'result' : 'results'} across the library',
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: AppColors.inkFaint,
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 34,
            color: AppColors.inkFaint,
          ),
          const SizedBox(height: 10),
          Text(
            'Nothing matches "$query"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: AppColors.hairline, height: 1)),
      ],
    );
  }
}
