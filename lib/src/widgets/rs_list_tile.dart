import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class RSListTile extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onTap;
  const RSListTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.leading,
      this.trailing, this.onTap});

  @override
  State<RSListTile> createState() => _RSListTileState();
}

class _RSListTileState extends State<RSListTile> {
  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? CupertinoListTile(
            title: widget.title,
            subtitle: widget.subtitle,
            leading: widget.leading,
            trailing: widget.trailing,
            onTap: widget.onTap,
          )
        : ListTile(
            title: widget.title,
            subtitle: widget.subtitle,
            leading: widget.leading,
            trailing: widget.trailing,
            onTap: widget.onTap,
          );
  }
}
