import 'package:bnotes/helpers/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

class SearchTexfield extends StatefulWidget {
  SearchTexfield({
    Key key,
    this.searchController,
    this.onSearch,
    this.onClearSearch,
  }) : super(key: key);
  final TextEditingController searchController;
  final Function onSearch;
  final Function onClearSearch;
  @override
  State<StatefulWidget> createState() {
    return _SearchTextfieldState();
  }
}

class _SearchTextfieldState extends State<SearchTexfield> {
  bool _showClearButton = false;
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(() {
      setState(() {
        _showClearButton = widget.searchController.text.length > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            MyFlutterApp.search,
            color: Colors.grey,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: widget.searchController,
              decoration: InputDecoration.collapsed(
                hintText: 'Search',
              ),
              onEditingComplete: () => widget.onSearch(),
            ),
          ),
          Visibility(
            visible: _showClearButton,
            child: InkWell(
                onTap: () => widget.onClearSearch(),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(MyFlutterApp.clear),
                )),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(MyFlutterApp.person),
            ),
          ),
        ],
      ),
    );
  }
}
