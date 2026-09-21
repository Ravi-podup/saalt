import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

class BestSeller {
  const BestSeller({
    required this.image,
    required this.title,
    required this.price,
    required this.swatches,
    this.chips = const [],
    this.moreLabel,
  });

  final String image;
  final String title;
  final String price;

  final List<({String icon, String label})> chips;

  /// The colours it comes in, and how many more there are. A shelf that
  /// shows every colour it has leaves [moreLabel] null.
  final List<Color> swatches;
  final String? moreLabel;
}

class BestSellers extends StatefulWidget {
  const BestSellers({super.key, this.onOpen, this.onBuy});

  final ValueChanged<BestSeller>? onOpen;
  final ValueChanged<BestSeller>? onBuy;

  @override
  State<BestSellers> createState() => _BestSellersState();
}

class _BestSellersState extends State<BestSellers> {
  static const _groups = ['Saalt Wear', 'Cup & Discs'];

  /// One shelf per tab.
  static const _shelves = <String, List<BestSeller>>{
    'Saalt Wear': [
      BestSeller(
        image: AppImages.seller1Img,
        title: 'Leakproof Cotton Sleep Short',
        price: '\$57.00',
        chips: [
          (icon: AppImages.doubleWaterDropIcon, label: 'HEAVY'),
          (icon: AppImages.waterDropIcon, label: 'REGULAR'),
        ],
        swatches: [
          Color(0xFF844646),
          Color(0xFFD2B48C),
          Color(0xFF919C84),
          Color(0xFFB5B8C6),
        ],
        moreLabel: '+2 More',
      ),
      BestSeller(
        image: AppImages.seller2Img,
        title: 'Leakproof Cotton Sleep Short',
        price: '\$31.00 – \$55.00',
        chips: [(icon: AppImages.tripeWaterDropIcon, label: 'SUPER')],
        swatches: [
          Color(0xFF1A1A1A),
          Color(0xFF2C3E50),
          Color(0xFFBDC3C7),
          Color(0xFFEBDEF0),
        ],
        moreLabel: '+4 More',
      ),
    ],
    'Cup & Discs': [
      BestSeller(
        image: AppImages.sellerCupImg,
        title: 'Saalt Disc',
        price: '\$36.00',
        swatches: [Color(0xFF9DC8DD), Color(0xFFA38C72)],
      ),
      BestSeller(
        image: AppImages.sellerCup1Img,
        title: 'Saalt Teen Cup',
        price: '\$32.00',
        swatches: [Color(0xFFBB5F78)],
      ),
    ],
  };

  String _group = _groups.first;

  @override
  Widget build(BuildContext context) {
    final shelf = _shelves[_group] ?? const <BestSeller>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              const Text(
                'Best Sellers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.4,
                  color: AppColors.inkDeep,
                ),
              ),
              const SizedBox(width: 10),
              Image.asset(
                AppImages.externalLinkIcon,
                height: 16,
                errorBuilder: (_, _, _) => const SizedBox(width: 16),
              ),
              const Spacer(),
              for (final group in _groups) ...[
                _GroupTab(
                  label: group,
                  isActive: group == _group,
                  onTap: () => setState(() => _group = group),
                ),
                const SizedBox(width: 12),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 375,
          child: ListView.separated(
            key: const Key('best-sellers'),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: shelf.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _Card(
              seller: shelf[index],
              onTap: () => widget.onOpen?.call(shelf[index]),
              onBuy: () => widget.onBuy?.call(shelf[index]),
            ),
          ),
        ),
      ],
    );
  }
}

/// Text tab with the rose underline the site uses, rather than a filled chip.
class _GroupTab extends StatelessWidget {
  const _GroupTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? const Color(0xFFC95878) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppColors.inkDeep : Color(0xff737373),
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.seller, this.onTap, this.onBuy});

  static const _imageHeight = 300.0;
  static const _width = 215.0;

  final BestSeller seller;
  final VoidCallback? onTap;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: seller.title,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: _width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: _imageHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        seller.image,
                        fit: BoxFit.fitWidth,
                        // errorBuilder: (_, _, _) =>
                        //     const ColoredBox(color: Color(0xFFE7E3DE)),
                      ),
                      const _Scrim(),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (seller.chips.isNotEmpty) ...[
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  for (final chip in seller.chips)
                                    _AbsorbencyPill(
                                      icon: chip.icon,
                                      label: chip.label,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                            Text(
                              seller.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffFAF7F2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seller.price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff2A2520),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _Swatches(
                          colours: seller.swatches,
                          moreLabel: seller.moreLabel,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _BuyButton(onTap: onBuy),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The wash the chips and the name sit on, so white type reads over any
/// photograph.
class _Scrim extends StatelessWidget {
  const _Scrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00000000), Color(0x40000000), Color(0xB3000000)],
          stops: [0.55, 0.80, 1.8],
        ),
      ),
    );
  }
}

class _AbsorbencyPill extends StatelessWidget {
  const _AbsorbencyPill({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            height: 9,
            color: Color(0xff64748B),
            errorBuilder: (_, _, _) => const SizedBox(width: 11),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Color(0xff373737).withValues(alpha: .9),
            ),
          ),
        ],
      ),
    );
  }
}

/// The colours it comes in. Shown as dots rather than named, because a name
/// per colour will not fit beside the price.
class _Swatches extends StatelessWidget {
  const _Swatches({required this.colours, this.moreLabel});

  final List<Color> colours;
  final String? moreLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final colour in colours) ...[
          Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
        ],
        if (moreLabel != null)
          Flexible(
            child: Text(
              moreLabel!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xff333333),
              ),
            ),
          ),
      ],
    );
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.inkDeep,
          border: Border.all(color: AppColors.whiteColor.withValues(alpha: .3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.boltIcon,
              height: 13,
              errorBuilder: (_, _, _) => const SizedBox(width: 13),
            ),
            const SizedBox(width: 5),
            const Text(
              'BUY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
