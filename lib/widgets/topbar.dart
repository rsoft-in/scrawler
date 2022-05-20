import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowTopBar extends StatefulWidget {
  final List<Widget>? naviChildren;
  const WindowTopBar({Key? key, this.naviChildren}) : super(key: key);

  @override
  State<WindowTopBar> createState() => _WindowTopBarState();
}

class _WindowTopBarState extends State<WindowTopBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: WindowTitleBarBox(
          child: Row(
            children: [
              Expanded(child: MoveWindow()),
              Row(
                children: widget.naviChildren ?? [],
              ),
              const WindowButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class WindowIconButtons extends StatefulWidget {
  final IconData icon;
  final Function ontap;
  const WindowIconButtons({Key? key, required this.icon, required this.ontap})
      : super(key: key);

  @override
  State<WindowIconButtons> createState() => _WindowIconButtonsState();
}

class _WindowIconButtonsState extends State<WindowIconButtons> {
  @override
  Widget build(BuildContext context) {
    // var brightness = MediaQuery.of(context).platformBrightness;
    // bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
    //     (brightness == Brightness.dark &&
    //         globals.themeMode == ThemeMode.system));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () => widget.ontap(),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              widget.icon,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: Colors.grey.shade100,
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: Colors.grey.shade100);

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WindowIconButtons(
          icon: Icons.minimize_rounded,
          ontap: () {
            appWindow.minimize();
          },
        ),
        WindowIconButtons(
          icon: Icons.check_box_outline_blank_rounded,
          ontap: () {
            appWindow.maximizeOrRestore();
          },
        ),
        WindowIconButtons(
          icon: Icons.close,
          ontap: () {
            appWindow.close();
          },
        ),
      ],
    );
  }
}
