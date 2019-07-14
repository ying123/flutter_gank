/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/30 下午10:13
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gank/activities/activity_photo.dart';
import 'package:flutter_gank/pages/page_girl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedPic extends StatefulWidget {
  final String url;

  final int index;

  final String placeholder;

  CachedPic({this.url, this.placeholder: "images/empty.png", this.index: 0});

  @override
  _CachedPicState createState() => new _CachedPicState();
}

class _CachedPicState extends State<CachedPic> {
  Future<bool> _onWillPop() {
//    if (showScale) {
//      _scaleImg.remove();
//      showScale = false;
//      return new Future.value(false);
//    } else {
//      return new Future.value(true);
//    }
    return Future.value(false);
  }

  Widget _buildGirlItem() {

    return new WillPopScope(
        child: new GestureDetector(
          child: CachedNetworkImage(

            placeholder: (c, s) => new Image.asset(
              widget.placeholder,
              fit: BoxFit.fill,
            ),
            height: 200.0,
            width: 200.0,
            imageUrl: widget.url,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (c) {
              return GankPhotoActivity(
                  urls: GirlPage.of(context).getPhotoListByIndex(widget.index),
                  initIndex: widget.index % 5);
            }));
          },
        ),
        onWillPop: _onWillPop);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGirlItem();
  }
}
