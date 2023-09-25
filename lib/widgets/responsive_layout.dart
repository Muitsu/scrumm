import 'package:flutter/material.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileView;
  final Widget tabletView;
  final Widget webView;

  const ResponsiveLayout(
      {super.key,
      required this.mobileView,
      required this.tabletView,
      required this.webView});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 850) {
        return widget.mobileView;
      } else if (constraints.maxWidth < 1328) {
        return widget.tabletView;
      } else {
        return widget.webView;
      }
    });
  }
}
