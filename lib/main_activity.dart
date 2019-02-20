import 'package:flutter/material.dart';
import 'package:flutter_gank/strings.dart';
import 'package:flutter_gank/home/home_fragment.dart';
import 'package:flutter_gank/sort/sort_fragment.dart';
import 'package:flutter_gank/girl/girl_fragment.dart';
import 'package:flutter_gank/utils/event_bus.dart';
import 'package:flutter_gank/utils/time_utils.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/bean/result.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("app_build");
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with GankApi {
  var titles = [HOME, SORT, GIRL];
  var title = HOME;
  int _currentPageIndex = 0;
  var _pageController = new PageController(initialPage: 0);
  var _selectGird = false;

  List<String> _data = [];
  List<String> list = [];

  var _isShow = false;

  String _selectDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print("main_build");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
        actions: <Widget>[
          Offstage(
              offstage: _currentPageIndex == 1,
              child: _toolbarIcon(_currentPageIndex))
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: _pageChange,
        controller: _pageController,
        children: <Widget>[HomeFragment(), SortFragment(), GirlFragment()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text(HOME)),
          BottomNavigationBarItem(
              icon: new Icon(Icons.sort), title: new Text(SORT)),
          BottomNavigationBarItem(
              icon: new Icon(Icons.collections), title: new Text(GIRL))
        ],
        currentIndex: _currentPageIndex,
        onTap: onTap,
      ),
    );
  }

  IconButton _toolbarIcon(int index) {
    if (index == 0) {
      return IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () {
            dialog(context);
          });
    } else {
      return IconButton(
          icon: Icon(_selectGird ? Icons.grid_on : Icons.grid_off),
          onPressed: () {
            setState(() {
              _selectGird = !_selectGird;
            });
            eventBus.fire(!_selectGird);
          });
    }
  }

  // bottomnaviagtionbar 和 pageview 的联动
  void onTap(int index) {
    // pageview的跳转
    _pageController.jumpToPage(index);
  }

  void _pageChange(int index) {
    setState(() {
      if (_currentPageIndex != index) {
        _currentPageIndex = index;
        title = titles[index];
      }
    });
  }

  Future _getData() async {
    var data = await getHistoryDateData();
    _data = ResultList<String>.fromJson(data, (res) => res).data;
    setState(() {});
  }

  void onSelectedItemChanged(int value) {
    _selectDate = _data[value];
  }

  Future<Null> dialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            height: 270,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 220,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 40,
                    onSelectedItemChanged: onSelectedItemChanged,
                    useMagnifier: true,
                    perspective: 0.01,
                    physics: FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                        builder: (BuildContext context, int index) {
                          return Text(
                            formatDateStr(_data[index]),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          );
                        },
                        childCount: _data.length),
                  ),
                ),
                MaterialButton(
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width - 50,
                  onPressed: () {
                    eventBus.fire(_selectDate);
                    Navigator.pop(context);
                  },
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  child: Text("确定"),
                ),
              ],
            ),
          );
        });
  }
}
