import 'package:flutter/material.dart';

enum ToastPosition { top, center, bottom }

class AppToast {
  static void show(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.bottom,
    Color backgroundColor = Colors.black54,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AppToastWidget(
        message: message,
        position: position,
        backgroundColor: backgroundColor,
        textColor: textColor,
        duration: duration,
        onDismissed: () {
          overlayEntry?.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _AppToastWidget extends StatefulWidget {
  const _AppToastWidget({
    required this.message,
    required this.position,
    required this.backgroundColor,
    required this.textColor,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final ToastPosition position;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_AppToastWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<_AppToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: _getSlideOffset(widget.position),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInCirc,
          ),
        );

    _controller.forward();
    _startTimer();
  }

  Offset _getSlideOffset(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
        return const Offset(0.0, -0.5);
      case ToastPosition.center:
        return Offset.zero;
      case ToastPosition.bottom:
        return const Offset(0.0, 0.5);
    }
  }

  void _startTimer() async {
    await Future.delayed(widget.duration);
    if (mounted) {
      _controller.reverse().then((_) {
        widget.onDismissed();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position == ToastPosition.top
          ? MediaQuery.of(context).padding.top + 16
          : null,
      bottom: widget.position == ToastPosition.bottom
          ? MediaQuery.of(context).padding.bottom + 16
          : null,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Align(
              alignment: _getAlignment(widget.position),
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: widget.position == ToastPosition.center
                      ? MediaQuery.of(context).size.height * 0.4
                      : 0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.message,
                  style: TextStyle(color: widget.textColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
      case ToastPosition.bottom:
        return Alignment.center;
      case ToastPosition.center:
        return Alignment.topCenter;
    }
  }
}
