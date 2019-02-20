import 'package:flutter/material.dart';
import 'package:flutter_gank/bean/details_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gank/widget/item_view_title.dart';
import 'package:flutter_gank/colors.dart';
import 'package:flutter_gank/utils/time_utils.dart';
import 'package:flutter_gank/details_activity.dart';

class ItemView extends StatefulWidget {
  final DetailsItem detailsItem;

  ItemView(this.detailsItem);

  @override
  State<StatefulWidget> createState() {
    return _ItemState();
  }
}

class _ItemState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("item_build");
    return Column(
      children: <Widget>[
        Offstage(
          offstage: !widget.detailsItem.isTitle,
          child: TitleView(widget.detailsItem.title),
        ),
        Container(
          decoration: BoxDecoration(
              color: BG,
              border: Border(
                  bottom: BorderSide(width: 0.1, color: Colors.black26))),
          child: GestureDetector(
              onTap: _onTap, child: Row(children: _itemDetails(context))),
        )
      ],
    );
  }

  List<Widget> _itemDetails(BuildContext context) {
    var widgets = <Widget>[
      Expanded(
        child: Container(
          margin:
              EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.detailsItem.desc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Icon(Icons.face, size: 20),
                    ),
                    Text(widget.detailsItem.who),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 5),
                      child: Icon(Icons.access_time, size: 20),
                    ),
                    Expanded(
                      child: Text(
                        formatDateStr(widget.detailsItem.publishedAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ];
    if (widget.detailsItem.images != null &&
        widget.detailsItem.images.isNotEmpty) {
      widgets.add(Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0),
        child: Offstage(
          offstage: false,
          child: Image(
            image: CachedNetworkImageProvider(
                widget.detailsItem.images[0].replaceAll("large", "thumbnail")),
          ),
        ),
      ));
    }
    return widgets;
  }

  //跳转界面
  _onTap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DetailsActivity(widget.detailsItem.url, widget.detailsItem.desc);
    }));
  }
}
