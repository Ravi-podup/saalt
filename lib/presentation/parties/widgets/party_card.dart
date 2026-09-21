import 'package:flutter/material.dart';
import 'package:saalt/presentation/parties/widgets/party_hero.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

class PartyCard extends StatelessWidget {
  const PartyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _partyWidget(
          boxBgColor: Color(0xffF43F5E).withValues(alpha: .1),
          boxBorderColor: Color(0xffF43F5E).withValues(alpha: .3),
          progress: .62,
          title: "Mastering Circular Layouts",
          subtitle:
              "Folding, insertion, and the pop removal in public. Nothing is too basic.",
          boxContentWidget: _liveWidget(),
          isProgressFull: false,
          status: "Live Demo",
        ),
        const SizedBox(height: 16),
        _partyWidget(
          boxBgColor: Color(0xffF43F5E).withValues(alpha: .1),
          boxBorderColor: Color(0xffF43F5E).withValues(alpha: .3),
          progress: .62,
          title: "Mastering Circular Layouts",
          subtitle:
              "Folding, insertion, and the pop removal in public. Nothing is too basic.",
          boxContentWidget: _liveWidget(),
          isProgressFull: false,
          status: "Live Demo",
        ),
        const SizedBox(height: 16),
        _partyWidget(
          boxBgColor: Color(0xffD7E9E8).withValues(alpha: .1),
          boxBorderColor: Color(0xffD7E9E8).withValues(alpha: .3),
          progress: .62,
          title: "Period and pelvic health",
          subtitle:
              "Folding, insertion, and the pop removal in public. Nothing is too basic.",
          boxContentWidget: _dateTitleWidget("21", Color(0xff67938C)),
          isProgressFull: true,
          status: "Completed",
        ),
        const SizedBox(height: 16),
        _partyWidget(
          boxBgColor: Color(0xff4E6FC3).withValues(alpha: .1),
          boxBorderColor: Color(0xff4E6FC3).withValues(alpha: .3),
          progress: .62,
          title: "Period and pelvic health",
          subtitle:
              "Folding, insertion, and the pop removal in public. Nothing is too basic.",
          boxContentWidget: _dateTitleWidget("21", Color(0xff4E6FC3)),
          isProgressFull: true,
          status: "Completed",
        ),
      ],
    );
  }

  Widget _dateTitleWidget(String title, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 25,
            height: 1.1,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          "SEP",
          style: TextStyle(
            color: color,
            fontSize: 9,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _liveWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.liveIcon, height: 18),
        const SizedBox(height: 2),
        Text(
          "LIVE",
          style: TextStyle(
            color: Color(0xffF43F5E),
            fontWeight: FontWeight.w900,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _partyWidget({
    required Color boxBgColor,
    required Color boxBorderColor,
    Widget? boxContentWidget,
    String? title,
    String? subtitle,
    double progress = 0,
    bool isProgressFull = false,
    String status = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: boxBorderColor),
                  color: boxBgColor,
                ),
                child: boxContentWidget,
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',

                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xff111827),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle ?? '',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff111827),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xffF9FAFB),
                ),
                child: Image.asset(
                  "assets/icons/more_vert_ic.png",
                  height: 20,
                  color: Color(0xff9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Image.asset(AppImages.happyUsersImg, height: 22),
              const SizedBox(width: 10),
              Text(
                "Joined by 1.2k+ users",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // _buttonsWidget("Pro"),
              _buttonsWidget(status),
            ],
          ),
          const SizedBox(height: 18),
          _progressWidget(progress, isProgressFull),
          const SizedBox(height: 18),
          Row(
            children: [
              Image.asset(AppImages.timeIcon, height: 14),
              const SizedBox(width: 8),
              Text(
                "Ends 11:43 pm",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Cta(
                color: AppColors.blackColor,
                title: "JOIN NOW",
                textColor: AppColors.whiteColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonsWidget(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          color: Color(0xff4B5563),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _progressWidget(double value, bool isProgressFull) {
    return LayoutBuilder(
      builder: (context, box) {
        return Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Container(
              height: 6,
              width: isProgressFull
                  ? null
                  : box.maxWidth * value.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                color: Color(0xff66AD79),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        );
      },
    );
  }
}
