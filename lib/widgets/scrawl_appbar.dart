import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/widgets/scrawl_icon_button_outlined.dart';

class ScrawlAppBar extends StatefulWidget {
  final Widget middle;
  final Function onPressed;

  final Widget? trailing;
  const ScrawlAppBar(
      {super.key,
      required this.middle,
      required this.onPressed,
      this.trailing});

  @override
  State<ScrawlAppBar> createState() => _ScrawlAppBarState();
}

class _ScrawlAppBarState extends State<ScrawlAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScrawlOutlinedIconButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: () => widget.onPressed()),
            kHSpace,
            Expanded(child: widget.middle),
            kHSpace,
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }
}
