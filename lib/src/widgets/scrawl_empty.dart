import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrawler/src/helpers/constants.dart';

class EmptyWidget extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback? onTap;
  const EmptyWidget(
      {super.key, required this.text, required this.width, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'images/undraw_random-thoughts_goca.svg',
            width: width,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(text),
          ),
          kVSpace,
          FilledButton.tonal(
            onPressed: onTap,
            child: Text('add'.tr()),
          ),
        ],
      ),
    );
  }
}
