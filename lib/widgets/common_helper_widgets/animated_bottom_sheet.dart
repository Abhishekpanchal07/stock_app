/* import 'package:flutter/material.dart';

class AnimatedBottomSheetContent extends StatefulWidget {
  final String title;
  final String description;
  final String content;
  // final VoidCallback onConfirm;
  // final VoidCallback onCancel;
  final Widget istButton;
  final Widget secondButton;


  const AnimatedBottomSheetContent({super.key, 
    required this.title,
    required this.description,
    required this.content,
    // required this.onConfirm,
    // required this.onCancel,
    required this.istButton,
    required this.secondButton,
  });

  @override
  State<AnimatedBottomSheetContent> createState() =>
      _AnimatedBottomSheetContentState();
}

class _AnimatedBottomSheetContentState extends State<AnimatedBottomSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 16),
              Text(
                widget.content,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 32), 

              widget.istButton,
             /*  CustomButton(
                text: widget.istButtontext,
                onPressed: widget.onConfirm,
                buttonColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.transparent,
              ), */
              const SizedBox(height: 12), 
              widget.secondButton
             /*  CustomButton(
                text: widget.istButtontext,
                onPressed: widget.onCancel,
                buttonColor: Colors.transparent,
                textColor: Colors.white,
                borderColor: Colors.white30,
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
 */

import 'package:beyond_stock_app/widgets/common_helper_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AnimatedBottomSheetContent extends StatefulWidget {
  final String title;
  final String description;
  final String content;
  final Widget istButton;
  final CustomButton secondButton;

  const AnimatedBottomSheetContent({
    super.key,
    required this.title,
    required this.description,
    required this.content,
    required this.istButton,
    required this.secondButton,
  });

  @override
  State<AnimatedBottomSheetContent> createState() =>
      _AnimatedBottomSheetContentState();
}

class _AnimatedBottomSheetContentState extends State<AnimatedBottomSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  bool _canPop = true; // Prevent double pop

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 500), // smooth reverse
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  Future<void> _animateAndPop() async {
    if (!_canPop) return;
    _canPop = false;

    await _controller.reverse();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, s) async {
        if (!didPop) {
          await _animateAndPop();
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.content,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  widget.istButton,
                  const SizedBox(height: 12),
                  CustomButton(
                    text: widget.secondButton.text,
                    buttonColor: widget.secondButton.buttonColor,
                    textColor: widget.secondButton.textColor,
                    borderColor: widget.secondButton.borderColor,
                    onPressed: _animateAndPop,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
