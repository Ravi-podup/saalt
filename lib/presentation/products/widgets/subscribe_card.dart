import 'package:flutter/material.dart';
import 'package:saalt/presentation/widgets/star_rating.dart';
import 'package:saalt/res/app_colors.dart';
import 'package:saalt/res/app_images.dart';

/// The mailing list, asked for once at the foot of the shop: what you get,
/// where to put your address, and who else has signed up.
class SubscribeCard extends StatelessWidget {
  const SubscribeCard({super.key, this.onClaim});

  final VoidCallback? onClaim;

  static const _fieldGround = Color(0xFFF3F4F6);
  static const _iconGround = Color(0xFFF7DDE3);
  static const _bodyInk = Color(0xFF6B7280);
  static const _accent = Color(0xFFC95878);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xffC8C8C8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffC95878).withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.mail_rounded,
                  size: 18,
                  color: Color(0xffC95878),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Join 50,000+ subscribers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    // letterSpacing: -0.3,
                    color: AppColors.inkDeep,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Get your 10% discount code instantly in your inbox.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xff737373),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 13, color: AppColors.ink),
            cursorColor: AppColors.ink,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Color(0xffF3F3F3),
              hintText: 'Enter your email address',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xff777777),
              ),
              prefixIcon: const Icon(
                Icons.alternate_email_rounded,
                size: 17,
                color: _bodyInk,
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 42),
              contentPadding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
              border: _fieldBorder,
              enabledBorder: _fieldBorder,
              focusedBorder: _fieldBorder,
            ),
          ),
          const SizedBox(height: 12),
          _ClaimButton(onTap: onClaim),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'By subscribing, you agree to our Terms & Privacy Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Color(0xff6F6F71)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: const Divider(height: 1, color: AppColors.hairline),
          ),
          Row(
            children: [
              Image.asset(
                AppImages.happyUsersImg,
                height: 26,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text.rich(
                  TextSpan(
                    text: '800+ people',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xffC95878),
                    ),
                    children: [
                      TextSpan(
                        text: ' joined this week',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _bodyInk,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              const StarRating(rating: 4.5, size: 13),
              const SizedBox(width: 6),
              const Text(
                '4.9',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  OutlineInputBorder get _fieldBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Color(0xffD9D9D9)),
  );
}

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CLAIM MY 10% OFF',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 9),
              Icon(Icons.arrow_forward, size: 14, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
