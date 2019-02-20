import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Widget buildDefaultHeader(BuildContext context, int mode) {
  return new ClassicIndicator(
    failedText: '刷新失败!',
    completeText: '刷新完成!',
    releaseText: '释放可以刷新',
    idleText: '下拉刷新哦!',
    failedIcon: new Icon(Icons.clear, color: Colors.black),
    completeIcon: new Icon(Icons.done, color: Colors.black),
    idleIcon: new Icon(Icons.arrow_downward, color: Colors.black),
    releaseIcon: new Icon(Icons.arrow_upward, color: Colors.black),
    refreshingText: '正在刷新...',
    textStyle: Theme.of(context).textTheme.body2,
    mode: mode,
  );
}

Widget buildDefaultFooter(BuildContext context, int mode) {
  return new ClassicIndicator(
      mode: mode,
      idleIcon: new Icon(Icons.arrow_upward, color: Colors.black),
      textStyle: Theme.of(context).textTheme.body2,
      refreshingText: '正在加载中...',
      idleText: '上拉加载',
      completeText: '加载完成',
      failedText: '网络异常',
      noDataText: '没有更多数据');
}
