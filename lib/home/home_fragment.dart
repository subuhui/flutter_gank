import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gank/strings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gank/photo_activity.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/bean/result.dart';
import 'package:flutter_gank/bean/details_item.dart';
import 'package:flutter_gank/widget/indicator_factory.dart';
import 'package:flutter_gank/widget/item_view_details.dart';
import 'package:flutter_gank/utils/event_bus.dart';

class HomeFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with GankApi, AutomaticKeepAliveClientMixin {
  var _imageUrl = "";
  List<DetailsItem> _data = [];
  var _title = "";
  RefreshController _refreshController;

  StreamSubscription<String> dis;

  String _date = "";

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _getData();
    dis = eventBus.on<String>().listen((event) {
      _date = event;
      _getData(replace: true);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("home_didChangeDependencies");
  }

  @override
  void didUpdateWidget(HomeFragment oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("home_didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    print("home_build");
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _data.isEmpty,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: _refresh,
            onOffsetChange: null,
            controller: _refreshController,
            headerBuilder: buildDefaultHeader,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _imageBanner(context);
                } else {
                  return ItemView(_data[index - 1]);
                }
              },
              itemCount: _data.length + 1,
            ),
          ),
        ),
        Offstage(
          offstage: _data.isNotEmpty,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        )
      ],
    );
  }

  Widget _imageBanner(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PhotoActivity([_imageUrl], IMAGE);
          }));
        },
        child: Image(
            image: CachedNetworkImageProvider(_imageUrl),
            height: 200,
            fit: BoxFit.cover));
  }

  Future _getData({bool replace = false}) async {
    var data;
    if (replace) {
      _data.clear();
      data = await getSpecialDayData(_date);
    } else {
      data = await getTodayData();
    }
    print(
        'data${Result<Map<String, dynamic>>.fromJson(data, (res) => res).results}');
    var map = Result<Map<String, dynamic>>.fromJson(data, (res) => res).results;
    _imageUrl = DetailsItem.fromJson((map[WELFARE] as List)[0]).url;
    map.remove(WELFARE);
    String title = "";
    map.forEach((k, v) {
      (v as List).forEach((f) {
        DetailsItem detailsItem = DetailsItem.fromJson(f);
        detailsItem.title = k;
        if (title == k) {
          detailsItem.isTitle = false;
        } else {
          detailsItem.isTitle = true;
          title = k;
        }
        _data.add(detailsItem);
        print(detailsItem.toJson().toString());
      });
    });
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future _refresh(bool b) async {
    print("+++++++++++++++++++${b}");
    _data.clear();
    if (_date.isNotEmpty) {
      await _getData(replace: true);
    } else {
      await _getData();
    }
    _refreshController.sendBack(true, RefreshStatus.completed);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dis.cancel();
  }
}
