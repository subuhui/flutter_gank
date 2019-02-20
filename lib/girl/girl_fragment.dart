import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gank/strings.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/widget/item_view_details.dart';
import 'package:flutter_gank/bean/result.dart';
import 'package:flutter_gank/bean/details_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gank/widget/indicator_factory.dart';
import 'package:flutter_gank/photo_activity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gank/utils/event_bus.dart';

class GirlFragment extends StatefulWidget {
  @override
  _GirlFragmentState createState() => _GirlFragmentState();
}

class _GirlFragmentState extends State<GirlFragment>
    with GankApi, AutomaticKeepAliveClientMixin {
  var _page = 1;
  List<DetailsItem> _data = [];
  var _column = true;

  RefreshController _refreshController;
  ScrollController _scrollController;

  StreamSubscription<bool> dis;

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
            child: GridView.count(
                controller: _scrollController,
                //横轴的最大长度
                crossAxisCount: _column ? 1 : 2,
                //主轴间隔
                mainAxisSpacing: 2.0,
                //横轴间隔
                crossAxisSpacing: 2.0,
                childAspectRatio: 2 / (_column ? 2 : 3),
                children: _data.map<Widget>((item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return PhotoActivity([item.url], IMAGE);
                      }));
                    },
                    child: Container(
                      height: _column ? 200 : 0,
                      child: Image(
                          image: CachedNetworkImageProvider(item.url),
                          fit: BoxFit.cover),
                    ),
                  );
                }).toList()),
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
    _scrollController = ScrollController();
    dis = eventBus.on<bool>().listen((event) {
      _column = event;
      setState(() {});
    });
  }

  Future _getData(int page, bool up) async {
    var data = await getCategoryData(WELFARE, page);
    if (up) {
      _data = ResultList<DetailsItem>.fromJson(
          data, (res) => DetailsItem.fromJson(res)).data;
    } else {
      _data.addAll(ResultList<DetailsItem>.fromJson(
          data, (res) => DetailsItem.fromJson(res)).data);
    }
    setState(() {});
  }

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dis.cancel();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
