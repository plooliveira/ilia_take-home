import 'package:flutter/material.dart';

/// A custom AppBar that implements PreferredSizeWidget to be used in Scaffolds.
/// It provides two factory constructors to build different AppBar styles
/// for mobile and large screen layouts.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget _child;

  const CustomAppBar._({super.key, required Widget child}) : _child = child;

  /// Factory for creating a standard mobile AppBar.
  ///
  /// It is centered, has no elevation, and uses the app's default styling.
  factory CustomAppBar.mobile({
    Key? key,
    required String title,
    List<Widget>? actions,
  }) {
    final appBar = AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      actions: actions,
    );
    return CustomAppBar._(key: key, child: appBar);
  }

  /// Factory for creating a custom AppBar for large screens.
  ///
  /// This AppBar's content is centered and constrained by [maxWidth],
  /// aligning it with the body content.
  factory CustomAppBar.largeScreen({
    Key? key,
    required String title,
    List<Widget>? actions,
    double maxWidth = 800,
  }) {
    final customBar = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                if (actions != null) ...actions,
              ],
            ),
          ),
        ),
      ),
    );
    return CustomAppBar._(key: key, child: customBar);
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
