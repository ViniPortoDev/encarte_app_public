import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const FilterWidget({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
