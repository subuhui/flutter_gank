import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/strings.dart';
import 'package:flutter_gank/widget/item_view_details.dart';
import 'package:flutter_gank/bean/result.dart';
import 'package:flutter_gank/bean/details_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gank/widget/indicator_factory.dart';

class SortDetailsFragment extends StatefulWidget {
  final String type;

  SortDetailsFragment(this.type);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SortDetailsState();
  }
}

class _SortDetailsState extends State<SortDetailsFragment>
    with GankApi, AutomaticKeepAliveClientMixin {
  var _page = 1;
  List<DetailsItem> _data = [];
  RefreshController _refreshController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _data.isEmpty,
          child: SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            onRefresh: _refresh,
            controller: _refreshController,
            headerBuilder: buildDefaultHeader,
            footerBuilder: buildDefaultFooter,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ItemView(_data[index]);
              },
              itemCount: _data.length,
            ),
          ),
        ),
        Offstage(
          offstage: _data.isNotEmpty,
          child: Center(child: CupertinoActivityIndicator()),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData(_page, true);
    _refreshController = RefreshController();
  }

  Future _getData(int page, bool up) async {
    var data =
        await getCategoryData(widget.type == ALL ? 'all' : widget.type, page);
    if (up) {
      _data = ResultList<DetailsItem>.fromJson(
          data, (res) => DetailsItem.fromJson(res)).data;
    } else {
      _data.addAll(ResultList<DetailsItem>.fromJson(
          data, (res) => DetailsItem.fromJson(res)).data);
    }
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future _refresh(bool up) async {
    if (up) {
      _data.clear();
      _page = 1;
      await _getData(_page, up);
      _refreshController.sendBack(up, RefreshStatus.completed);
    } else {
      _page++;
      await _getData(_page, up);
      _refreshController.sendBack(up, RefreshStatus.idle);
    }
  }
}
