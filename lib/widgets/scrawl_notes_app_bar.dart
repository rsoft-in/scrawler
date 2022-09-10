import 'package:bnotes/common/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScrawlNotesAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  String title;
  TextEditingController titleController;
  VoidCallback? onColorPressed;
  VoidCallback? onTagPressed;
  VoidCallback? onActionPressed;

  ScrawlNotesAppBar(
      {Key? key,
      required this.title,
      required this.titleController,
      this.onColorPressed,
      this.onTagPressed,
      this.onActionPressed})
      : preferredSize = const Size.fromHeight(140.0),
        super(key: key);

  @override
  State<ScrawlNotesAppBar> createState() => _ScrawlNotesAppBarState();
}

class _ScrawlNotesAppBarState extends State<ScrawlNotesAppBar> {
  bool isTitleEditing = false;
  FocusNode focusNode = FocusNode();

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
          Visibility(
            visible: !isTitleEditing,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isTitleEditing,
            child: TextButton(
              onPressed: () {
                isTitleEditing = true;
                setState(() {});
                focusNode.requestFocus();
              },
              child: Icon(Icons.create_outlined),
            ),
          ),
          Visibility(
            visible: isTitleEditing,
            child: Expanded(
              child: TextField(
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Enter title here',
                ),
                onSubmitted: (value) {
                  isTitleEditing = false;
                  widget.title = value.toString();
                  widget.titleController.text = value.toString();
                  setState(() {});
                },
              ),
            ),
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
        ],
      ),
    );
  }
}
