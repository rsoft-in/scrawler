import 'package:flutter/material.dart';

class ScrawlNavRailItem extends StatefulWidget {
  final int index;
  final String tooltip;
  final int selectedIndex;
  final IconData icon;
  final VoidCallback onTap;
  const ScrawlNavRailItem(
      {super.key,
      required this.index,
      required this.tooltip,
      required this.selectedIndex,
      required this.icon,
      required this.onTap});

  @override
  State<ScrawlNavRailItem> createState() => _ScrawlNavRailItemState();
}

class _ScrawlNavRailItemState extends State<ScrawlNavRailItem> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: Icon(
            widget.icon,
            size: 22.0,
          ),
        ),
      ),
    );
  }
}
