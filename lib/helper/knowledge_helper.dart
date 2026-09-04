import 'package:flutter/material.dart';
import 'package:saalt/models/article.dart';
import 'package:saalt/models/knowledge_section.dart';
import 'package:saalt/res/app_colors.dart';

class KnowledgeHelper {
  /// The choices on the knowledgebase landing screen, mirroring the dashboard
  /// areas they explain.
  static const sections = <KnowledgeSection>[
    KnowledgeSection(
      title: 'Community',
      subtitle: 'Groups, mentors, etiquette',
      icon: Icons.forum_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    KnowledgeSection(
      title: 'Products',
      subtitle: 'Sizing, fit and care',
      icon: Icons.shopping_bag_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    KnowledgeSection(
      title: 'Testimonials',
      subtitle: 'Watch real switch stories',
      icon: Icons.play_circle_fill_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
      isVideo: true,
    ),
    KnowledgeSection(
      title: 'TMI Parties',
      subtitle: 'Live webinars, explained',
      icon: Icons.celebration_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    KnowledgeSection(
      title: 'Saalt Show',
      subtitle: 'Episodes and their topics',
      icon: Icons.podcasts_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
  ];

  static const library = <Article>[
    // ---------- Community ----------
    Article(
      title: 'Finding the right group for your stage',
      excerpt:
          'First period, cup life, postpartum, perimenopause. Picking the '
          'group that matches where you are makes the feed useful instead of '
          'noisy.',
      section: 'Community',
      category: 'Getting started',
      minutes: 3,
      icon: Icons.groups_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    Article(
      title: 'What mentors actually do',
      excerpt:
          'Mentors are members who have been through it, not staff. Here is '
          'what they can help with and what to take to support instead.',
      section: 'Community',
      category: 'Mentors',
      minutes: 3,
      icon: Icons.volunteer_activism_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    Article(
      title: 'Posting without oversharing (or do)',
      excerpt:
          'There is no TMI filter here, but there is a line around other '
          'people. A short guide to what belongs in a post.',
      section: 'Community',
      category: 'Etiquette',
      minutes: 4,
      icon: Icons.edit_note_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    Article(
      title: 'Guidelines in plain language',
      excerpt:
          'No medical advice as fact, no product spam, no screenshots of '
          'other members. That is most of it.',
      section: 'Community',
      category: 'Etiquette',
      minutes: 2,
      icon: Icons.gavel_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),

    // ---------- Products ----------
    Article(
      title: 'Cup or disc: which one fits your body?',
      excerpt:
          'A cup seals inside the vaginal canal; a disc sits in the fornix '
          'behind the pubic bone. Here is how to tell which suits you.',
      section: 'Products',
      category: 'Cups & discs',
      minutes: 4,
      icon: Icons.compare_arrows_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
    Article(
      title: 'Finding your size on the first try',
      excerpt:
          'Size is about cervix height and flow, not age or birth history. '
          'A two-minute check tells you which to order.',
      section: 'Products',
      category: 'Sizing',
      minutes: 3,
      icon: Icons.straighten_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    Article(
      title: 'Leaks: the five usual causes',
      excerpt:
          'Almost every leak comes down to seal, placement, size, fullness '
          'or angle. Work through them in that order.',
      section: 'Products',
      category: 'Troubleshooting',
      minutes: 5,
      icon: Icons.troubleshoot_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
    ),
    Article(
      title: 'Removing a disc without the mess',
      excerpt:
          'Hook the rim, keep it level, and stay low. The technique takes '
          'one cycle to learn and then it is automatic.',
      section: 'Products',
      category: 'Cups & discs',
      minutes: 5,
      icon: Icons.pan_tool_alt_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
    ),
    Article(
      title: 'Which style for which day?',
      excerpt:
          'Thong for light days and leggings, brief for full coverage, '
          'CloudShort for overnight and postpartum.',
      section: 'Products',
      category: 'Underwear',
      minutes: 4,
      icon: Icons.calendar_today_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
    ),
    Article(
      title: 'Washing period underwear the right way',
      excerpt:
          'Cold rinse, mild detergent, no fabric softener, hang to dry. '
          'Softener is what kills absorbency.',
      section: 'Products',
      category: 'Care',
      minutes: 3,
      icon: Icons.local_laundry_service_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    Article(
      title: 'Sterilising between cycles',
      excerpt:
          'Boil for 5-10 minutes at the start and end of every period. '
          'Between changes, a rinse is enough.',
      section: 'Products',
      category: 'Care',
      minutes: 2,
      icon: Icons.local_fire_department_rounded,
      tint: AppColors.roseTint,
      accent: AppColors.rose,
    ),
    Article(
      title: 'One cup versus 2,400 tampons',
      excerpt:
          'A single cup lasts up to ten years. The arithmetic on waste and '
          'cost over a reproductive lifetime is stark.',
      section: 'Products',
      category: 'Sustainability',
      minutes: 4,
      icon: Icons.eco_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),

    // ---------- Testimonials: video only ----------
    Article(
      title: 'Three cycles to confident: Alina’s switch',
      excerpt:
          'What the first, second and third cycle actually felt like, and '
          'the adjustment that made it click.',
      section: 'Testimonials',
      category: 'Cup life',
      minutes: 6,
      isVideo: true,
      icon: Icons.play_arrow_rounded,
      tint: AppColors.apricotTint,
      accent: AppColors.apricot,
    ),
    Article(
      title: 'Postpartum, and the first thing that did not hurt',
      excerpt:
          'Nneka on week two, the CloudShort, and why nobody warned her '
          'about recovery.',
      section: 'Testimonials',
      category: 'Postpartum',
      minutes: 8,
      isVideo: true,
      icon: Icons.play_arrow_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
    ),
    Article(
      title: 'A marathon on day two',
      excerpt:
          'Jessica trains through her heaviest days and explains the kit '
          'that made that possible.',
      section: 'Testimonials',
      category: 'Sport',
      minutes: 5,
      isVideo: true,
      icon: Icons.play_arrow_rounded,
      tint: AppColors.sageTint,
      accent: AppColors.sage,
    ),
    Article(
      title: 'What I would tell my thirteen-year-old self',
      excerpt:
          'Dee on teaching her daughter about her cycle without inheriting '
          'the shame she grew up with.',
      section: 'Testimonials',
      category: 'Teens',
      minutes: 7,
      isVideo: true,
      icon: Icons.play_arrow_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),

    // ---------- TMI Parties ----------
    Article(
      title: 'What actually happens at a TMI party',
      excerpt:
          'A live hour with a host, a topic and a chat nobody moderates into '
          'politeness. Cameras optional.',
      section: 'TMI Parties',
      category: 'Getting started',
      minutes: 3,
      icon: Icons.celebration_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    Article(
      title: 'Joining your first webinar',
      excerpt:
          'Reserve a seat, arrive from the reminder, and ask anonymously if '
          'you would rather not be named.',
      section: 'TMI Parties',
      category: 'Getting started',
      minutes: 2,
      icon: Icons.event_available_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    Article(
      title: 'Hosting one for your own friends',
      excerpt:
          'Pick a topic, invite six people, and let the first awkward '
          'question do the work. We send the prompts.',
      section: 'TMI Parties',
      category: 'Hosting',
      minutes: 4,
      icon: Icons.record_voice_over_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),

    // ---------- Saalt Show ----------
    Article(
      title: 'What your flow is telling you',
      excerpt:
          'Colour, volume and clotting all carry signal. A guide to what is '
          'normal for you and what is worth a conversation.',
      section: 'Saalt Show',
      category: 'Body & health',
      minutes: 7,
      icon: Icons.favorite_rounded,
      tint: AppColors.lilacTint,
      accent: AppColors.lilac,
    ),
    Article(
      title: 'Heavy periods: when to see a doctor',
      excerpt:
          'Soaking through protection hourly, clots larger than a coin, or '
          'periods past seven days all deserve a check.',
      section: 'Saalt Show',
      category: 'Body & health',
      minutes: 6,
      icon: Icons.medical_information_rounded,
      tint: AppColors.periwinkleTint,
      accent: AppColors.periwinkle,
    ),
    Article(
      title: 'Perimenopause: the decade nobody warned you about',
      excerpt:
          'What changes, when it usually starts, and which symptoms are '
          'worth raising with a clinician.',
      section: 'Saalt Show',
      category: 'Body & health',
      minutes: 5,
      icon: Icons.timeline_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
    Article(
      title: 'Where to listen, and which episode first',
      excerpt:
          'The show runs in three formats. Start with the origin story, then '
          'follow whichever thread is yours.',
      section: 'Saalt Show',
      category: 'Getting started',
      minutes: 2,
      icon: Icons.headphones_rounded,
      tint: AppColors.tealTint,
      accent: AppColors.teal,
    ),
  ];

  static const faqs = <Faq>[
    Faq(
      question: 'Can I sleep with a cup or disc in?',
      answer:
          'Yes. Both are safe for up to 12 hours, which covers a full night. '
          'Empty and rinse it when you wake up.',
    ),
    Faq(
      question: 'Can it get lost inside me?',
      answer:
          'No. The vaginal canal is a closed space that ends at the cervix, '
          'so there is nowhere for it to go. If it sits high, bear down '
          'gently and reach again.',
    ),
    Faq(
      question: 'Can I use one with an IUD?',
      answer:
          'Many people do. Break the seal before removing so you are not '
          'pulling on the strings, and check with your provider first.',
    ),
    Faq(
      question: 'Should it hurt?',
      answer:
          'No. Discomfort usually means the size or the placement is off, '
          'not that cups are wrong for you. Try a lower position first.',
    ),
    Faq(
      question: 'How long does period underwear last?',
      answer:
          'Two to three years of regular wear. Skipping fabric softener and '
          'high heat is what extends it.',
    ),
  ];

  /// Knowledge filed under [section].
  static List<Article> itemsFor(String section) =>
      library.where((a) => a.section == section).toList();
}
