import 'package:flutter/material.dart';
import 'package:scrawler/src/helpers/constants.dart';

class FilterButton extends StatefulWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;
  const FilterButton(
      {super.key,
      required this.label,
      required this.index,
      required this.selectedIndex,
      required this.onTap});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: widget.index == widget.selectedIndex
              ? kPrimaryColor.withAlpha(100)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontWeight: widget.index == widget.selectedIndex
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
