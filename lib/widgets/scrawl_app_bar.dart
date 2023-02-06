import 'package:flutter/material.dart';

class ScrawlAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final VoidCallback? onActionPressed;

  const ScrawlAppBar({Key? key, required this.title, this.onActionPressed})
      : preferredSize = const Size.fromHeight(140.0),
        super(key: key);

  @override
  State<ScrawlAppBar> createState() => _ScrawlAppBarState();
}

class _ScrawlAppBarState extends State<ScrawlAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
