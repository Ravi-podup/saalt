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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSend => _controller.text.trim().isNotEmpty;

  void _send() {
    widget.onSend?.call(_controller.text.trim());
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.roseTint,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ASK CHERIE',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.rose,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Got a question? We’re listening.',
            style: TextStyle(
              fontSize: 17,
              height: 1.2,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'First-cycle nerves, perimenopause, the thing you have been '
            'meaning to ask a friend. One gets answered every week.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            maxLines: 3,
            minLines: 2,
            style: const TextStyle(fontSize: 13, color: AppColors.ink),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              hintText: 'Enter your question',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.inkFaint,
              ),
              contentPadding: const EdgeInsets.all(13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: _canSend ? AppColors.ink : AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: _canSend ? _send : null,
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Text(
                    'Send to Cherie',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _canSend ? Colors.white : AppColors.inkFaint,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
