import 'package:flutter/material.dart';
import 'package:flutter_gank/strings.dart';
import 'package:flutter_gank/sort/sort_details_fragment.dart';

class SortFragment extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SortFragmentState();
}

class _SortFragmentState extends State<SortFragment>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        TabBar(
          tabs: list.map<Widget>((tab) {
            return Tab(
              child: Text(
                tab,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          controller: _tabController,
          isScrollable: true,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: list.map((tab) {
              return SortDetailsFragment(tab);
            }).toList(),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: list.length, vsync: this);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
