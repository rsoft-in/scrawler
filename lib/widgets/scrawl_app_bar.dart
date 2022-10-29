import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:flutter/material.dart';

class ScrawlAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final String actionButtonTitle;
  final VoidCallback? onActionPressed;

  const ScrawlAppBar(
      {Key? key,
      required this.title,
      required this.actionButtonTitle,
      this.onActionPressed})
      : preferredSize = const Size.fromHeight(140.0),
        super(key: key);

  @override
  State<ScrawlAppBar> createState() => _ScrawlAppBarState();
}

class _ScrawlAppBarState extends State<ScrawlAppBar> {
  bool isDesktop = false;

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          // kHSpace,
          // Expanded(
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: kLabels['search'],
          //       prefixIcon: Icon(Icons.search_outlined),
          //     ),
          //   ),
          // ),
          // kHSpace,
          // Visibility(
          //   visible: isDesktop,
          //   child: ElevatedButton.icon(
          //     onPressed: widget.onActionPressed,
          //     icon: Icon(Icons.add_outlined),
          //     label: Text(widget.actionButtonTitle),
          //   ),
          // ),
          // Visibility(
          //   visible: !isDesktop,
          //   child: ElevatedButton(
          //     onPressed: widget.onActionPressed,
          //     child: Icon(Icons.add_outlined),
          //   ),
          // ),
        ],
      ),
    );
  }
}
