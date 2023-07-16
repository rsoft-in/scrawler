import 'package:flutter/material.dart';

class ScrawlLabelChip extends StatelessWidget {
  final String label;
  const ScrawlLabelChip({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> labels = label.split(',').reversed.toList();

    return label.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: labels.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                  label: Text(
                labels[index],
                style: const TextStyle(fontSize: 10.0),
              )),
            ),
          )
        : Container();
  }
}
