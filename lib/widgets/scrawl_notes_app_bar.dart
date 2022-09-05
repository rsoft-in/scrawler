import 'package:bnotes/common/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScrawlNotesAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  Widget child;
  VoidCallback? onColorPressed;
  VoidCallback? onTagPressed;
  VoidCallback? onActionPressed;
  VoidCallback onClosePressed;

  ScrawlNotesAppBar(
      {Key? key,
      required this.child,
      this.onColorPressed,
      this.onTagPressed,
      this.onActionPressed,
      required this.onClosePressed})
      : preferredSize = const Size.fromHeight(140.0),
        super(key: key);

  @override
  State<ScrawlNotesAppBar> createState() => _ScrawlNotesAppBarState();
}

class _ScrawlNotesAppBarState extends State<ScrawlNotesAppBar> {
  @override
  Widget build(BuildContext context) {
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
            child: widget.child,
          ),
          Spacer(),
          TextButton(
            onPressed: widget.onColorPressed,
            child: Icon(Icons.palette_outlined),
          ),
          kHSpace,
          TextButton(
            onPressed: widget.onTagPressed,
            child: Icon(Icons.sell_outlined),
          ),
          kHSpace,
          ElevatedButton(
            onPressed: widget.onActionPressed,
            child: Icon(Icons.check_outlined),
          ),
          kHSpace,
          IconButton(
            onPressed: widget.onClosePressed,
            icon: Icon(Icons.clear_outlined),
          ),
        ],
      ),
    );
  }
}
