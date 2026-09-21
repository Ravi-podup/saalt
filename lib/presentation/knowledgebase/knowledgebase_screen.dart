import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saalt/presentation/parties/tmi_parties_screen.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';
import 'package:saalt/router/app_route_paths.dart';

class TrustSection {
  const TrustSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.ground,
    required this.ink,
    this.guides = const [],
    this.isVideo = false,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String count;
  final Color ground;
  final Color ink;

  final List<({String title, String minutes})> guides;

  final bool isVideo;
}

class KnowledgebaseScreen extends StatefulWidget {
  const KnowledgebaseScreen({super.key});

  static Future open(BuildContext context) {
    return context.push(AppRoutePaths.knowledgebaseScreen);
  }

  @override
  State<KnowledgebaseScreen> createState() => _KnowledgebaseScreenState();
}

class _KnowledgebaseScreenState extends State<KnowledgebaseScreen> {
  static const _filters = ['All Topics', 'Products', 'Community', 'Shipping'];

  static const _sections = <TrustSection>[
    TrustSection(
      icon: AppImages.chatDoubleIcon,
      title: 'The Collective',
      subtitle: 'Groups, mentors, etiquette',
      count: '4 guides',
      ground: Color(0xFFF9E6EA),
      ink: Color(0xFFCC5555),
      guides: [
        (title: 'Finding the right group for your stage', minutes: '3m'),
        (title: 'What mentors actually do', minutes: '3m'),
      ],
    ),
    TrustSection(
      icon: AppImages.cupDoubleIcon,
      title: 'Products',
      subtitle: 'Sizing, fit and care',
      count: '8 guides',
      ground: Color(0xFFD3EAE9),
      ink: Color(0xFF065F46),
      guides: [
        (title: 'Choosing between a cup and a disc', minutes: '4m'),
        (title: 'Washing and storing your cup', minutes: '2m'),
      ],
    ),
    TrustSection(
      icon: AppImages.videoPlayIcon,
      title: 'Testimonials',
      subtitle: 'Watch real switch stories',
      count: '4 videos',
      ground: Color(0xFFFBD4C2),
      ink: Color(0xFF92400E),
      isVideo: true,
      guides: [
        (title: 'Three cycles in: what changed', minutes: '5m'),
        (title: 'Switching after a baby', minutes: '6m'),
      ],
    ),
    TrustSection(
      icon: AppImages.videoPeopleIcon,
      title: 'TMI Parties',
      subtitle: 'Live sessions, explained',
      count: '3 guides',
      ground: Color(0xFFC6C9D2),
      ink: Color(0xFF6B21A8),
      guides: [
        (title: 'What happens in a live room', minutes: '3m'),
        (title: 'Asking a question anonymously', minutes: '2m'),
      ],
    ),
    TrustSection(
      icon: AppImages.shippingIcon,
      title: 'Shipping & Returns',
      subtitle: 'Tracking, exchanges, refunds',
      count: '5 guides',
      ground: Color(0xFFCCE2EB),
      ink: Color(0xFF207192),
      guides: [
        (title: 'Where your order is', minutes: '2m'),
        (title: 'Starting an exchange', minutes: '3m'),
      ],
    ),
  ];

  static const _questions = <({String question, String answer})>[
    (
      question: 'How do I know which size is right for me?',
      answer:
          'Size follows your flow, not your body size. Regular suits most '
          'people, Small is for lighter days or anyone new to a cup, and '
          'Teen is shorter and softer. The fit quiz in the shop walks you '
          'through it in about a minute.',
    ),
    (
      question: "What's the difference between a cup and a disc?",
      answer:
          'A cup seals against the vaginal wall with light suction. A disc '
          'sits further back, tucked behind the pubic bone. Discs hold more '
          'and can be worn during sex; most people find cups easier to '
          'remove while they are learning.',
    ),
    (
      question: 'How do I join The Collective groups?',
      answer:
          'Open The Saalt Collective, pick the group that matches where you '
          'are, and tap join. Some are open to everyone, some are '
          'mentor-led. Nothing you post there appears on your shop profile.',
    ),
    (
      question: 'What happens during a live TMI Party?',
      answer:
          'A 45-minute room hosted by the Saalt Care Team. Cameras stay off, '
          'questions can be asked anonymously, and a recording goes up '
          'afterwards unless the session is marked off the record.',
    ),
  ];

  String _filter = _filters.first;

  int _openSection = 0;

  int? _openQuestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: () => context.pop()),
            Expanded(
              child: ListView(
                key: const Key('trust-center-body'),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                children: [
                  const _SearchBox(),
                  const SizedBox(height: 14),
                  _FilterBar(
                    filters: _filters,
                    selected: _filter,
                    onSelect: (f) => setState(() => _filter = f),
                  ),
                  const SizedBox(height: 14),
                  for (var i = 0; i < _sections.length; i++) ...[
                    _SectionCard(
                      section: _sections[i],
                      isOpen: i == _openSection,
                      onTap: () => setState(
                        () => _openSection = i == _openSection ? -1 : i,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 14),
                  const _FaqHeading(),
                  const SizedBox(height: 25),
                  for (var i = 0; i < _questions.length; i++) ...[
                    _QuestionTile(
                      question: _questions[i].question,
                      answer: _questions[i].answer,
                      isOpen: i == _openQuestion,
                      onTap: () => setState(
                        () => _openQuestion = i == _openQuestion ? null : i,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Row(
        children: [
          BackButtonWidget(onTap: () => Navigator.pop(context)),
          const Expanded(
            child: Text(
              'Trust Center',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.inkDeep,
              ),
            ),
          ),
          Image.asset(
            AppImages.profilePictureCircleImage,
            height: 40,
            width: 40,
          ),
        ],
      ),
    );
  }
}

/// A real field, so it behaves like one under the thumb. Nothing is wired to
/// it: the library on this screen is fixed.
class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 13, color: AppColors.ink),
      cursorColor: AppColors.ink,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        hintText: 'Search all guides and videos...',
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkFaint),
        prefixIcon: Image.asset(AppImages.searchIcon, height: 14),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
        border: _border(Color(0xffD9D9D9)),
        enabledBorder: _border(Color(0xffD9D9D9)),
        focusedBorder: _border(Color(0xffD9D9D9)),
      ),
    );
  }

  OutlineInputBorder _border(Color colour) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: colour),
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
      height: 36,
      child: ListView.separated(
        key: const Key('trust-center-filters'),
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
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? Colors.white : Color(0xff4B5563),
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

/// A section, closed to its header or opened onto a couple of its guides.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.section,
    required this.isOpen,
    required this.onTap,
  });

  final TrustSection section;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: section.ground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(section.icon, height: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                section.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                  color: AppColors.inkDeep,
                                ),
                              ),
                            ),
                            if (section.isVideo) ...[
                              const SizedBox(width: 6),
                              const _VideoTag(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          section.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CountPill(label: section.count, ink: section.ink),
                  const SizedBox(width: 6),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: section.ink,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final guide in section.guides) ...[
                    _GuideRow(title: guide.title, minutes: guide.minutes),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    '2 more  →',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: section.ink,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.label, required this.ink});

  final String label;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: ink),
      ),
    );
  }
}

class _VideoTag extends StatelessWidget {
  const _VideoTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow_rounded, size: 10, color: Color(0xFF92400E)),
          SizedBox(width: 2),
          Text(
            'VIDEO',
            style: TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({required this.title, required this.minutes});

  final String title;
  final String minutes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AppImages.fileIcon,
          height: 15,
          errorBuilder: (_, _, _) => const SizedBox(width: 15),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xff374151),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          minutes,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xff9CA3AF),
          ),
        ),
      ],
    );
  }
}

class _FaqHeading extends StatelessWidget {
  const _FaqHeading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: AppColors.blackColor.withValues(alpha: .05),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.help_outline_rounded,
                size: 12,
                color: Color(0xFFCC5555),
              ),
              SizedBox(width: 5),
              Text(
                'Frequently Asked',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCC5555),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.3,
            color: AppColors.inkDeep,
          ),
        ),
      ],
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    required this.question,
    required this.answer,
    required this.isOpen,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.inkDeep,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Color(0xff9CA3AF),
                  ),
                ],
              ),
              // The answer only exists while the row is open, so the list
              // stays a list of questions until one is asked.
              if (isOpen) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.hairline),
                const SizedBox(height: 12),
                Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.55,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6B7280),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
