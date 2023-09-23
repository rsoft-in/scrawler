import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScrawlSearch extends StatefulWidget {
  TextEditingController? controller;
  final VoidCallback onSearch;
  final VoidCallback onClearSearch;
  ScrawlSearch(
      {Key? key,
      this.controller,
      required this.onSearch,
      required this.onClearSearch})
      : super(key: key);

  @override
  State<ScrawlSearch> createState() => _ScrawlSearchState();
}

class _ScrawlSearchState extends State<ScrawlSearch> {
  bool hasText = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search_outlined),
        suffixIcon: Visibility(
          visible: hasText,
          child: InkWell(
            onTap: () => setState(() {
              if (widget.controller != null) {
                widget.controller!.text = "";
                hasText = false;
              }
              widget.onClearSearch();
            }),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.clear_outlined,
                size: 16.0,
              ),
            ),
          ),
        ),
      ),
      onEditingComplete: () => widget.onSearch(),
      onChanged: (value) => setState(() {
        hasText = value.isNotEmpty;
      }),
    );
  }
}
