import 'package:flutter/material.dart';
import 'package:saalt/helper/date_labels.dart';
import 'package:saalt/models/tmi_party.dart';
import 'package:saalt/presentation/parties/widgets/party_cover.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

class PartyHero extends StatelessWidget {
  const PartyHero({super.key, required this.party, required this.onAction});

  final TmiParty party;

  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 336,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PartyCover(party: party, iconSize: 72),
            const _Scrim(),
            Positioned(
              top: 14,
              left: 14,
              child: Row(
                children: [
                  const LivePill(),
                  const SizedBox(width: 8),
                  CoverPill(
                    label: '${DateLabels.duration(party.minutes)} Session',
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      children: [
                        Image.asset(
                          AppImages.groupNavIcon,
                          height: 14,
                          color: AppColors.whiteColor,
                        ),
                        const SizedBox(width: 9),
                        Text.rich(
                          TextSpan(
                            text: "Hosted by ",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                            ),
                            children: [
                              TextSpan(
                                text: "Saalt Care Team",
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          AppImages.dateIcon,
                          height: 14,
                          color: AppColors.whiteColor,
                        ),
                        const SizedBox(width: 9),
                        Text(
                          "10:45 pm – 11:45 pm • Ends soon",
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Cta(title: "JOIN THE ROOM", onTap: onAction),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "438 in the room",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Scrim extends StatelessWidget {
  const _Scrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0x33000000), Color(0xD9000000)],
          stops: [0, 0.38, 1],
        ),
      ),
    );
  }
}

class Cta extends StatelessWidget {
  const Cta({this.onTap, this.title, this.color, this.textColor});

  final VoidCallback? onTap;
  final String? title;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: color ?? AppColors.whiteColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.joinIcon, height: 20, color: textColor),
          const SizedBox(width: 3),
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: textColor ?? AppColors.inkDeep,
            ),
          ),
        ],
      ),
    );
  }
}
