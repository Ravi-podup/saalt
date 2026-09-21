import 'package:flutter/material.dart';
import 'package:saalt/res/app_colors.dart';

/// "Ask Cherie" prompt. One question a week gets answered on the show.
class AskCard extends StatefulWidget {
  const AskCard({super.key, this.onSend});

  final ValueChanged<String>? onSend;

  @override
  State<AskCard> createState() => _AskCardState();
}

class _AskCardState extends State<AskCard> {
  final _controller = TextEditingController();

  static const _border = Color(0xFFC8C8C8);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
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
                  borderRadius: BorderRadius.circular(12),
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
                  'Got a questions? We’re listening',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: AppColors.inkDeep,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "First-cycle nerves, perimenopause, the thing you've been "
            'meaning to ask a friend. One gets answered every week.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: Color(0xff737373),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller,
            maxLines: 5,
            minLines: 5,
            style: const TextStyle(fontSize: 13, color: AppColors.ink),
            cursorColor: AppColors.ink,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF3F3F3),
              hintText: 'Ask your question',
              hintStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xff777777),
              ),
              contentPadding: const EdgeInsets.all(16),
              border: _fieldBorder,
              enabledBorder: _fieldBorder,
              focusedBorder: _fieldBorder,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.inkDeep,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Color(0xffC9A96E).withValues(alpha: .3),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SEND TO CHERIE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    // letterSpacing: 0.6,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 9),
                Icon(Icons.arrow_forward, size: 15, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder get _fieldBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Color(0xffF3F3F3)),
  );
}
