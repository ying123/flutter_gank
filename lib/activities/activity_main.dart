/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/21 下午10:19
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_gank/App.dart';
import 'package:flutter_gank/constant/colors.dart';
import 'package:flutter_gank/constant/strings.dart';
import 'package:flutter_gank/pages/page_girl.dart';
import 'package:flutter_gank/pages/page_home.dart';
import 'package:flutter_gank/pages/page_like.dart';
import 'package:flutter_gank/pages/page_setting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gank/pages/page_gank.dart';
import 'package:flutter_gank/utils/utils_db.dart';
import 'package:flutter_gank/widget/search_bar.dart';
import 'package:residemenu/residemenu.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => new _MainActivityState();
}

class _MainActivityState extends State<MainActivity>
    with TickerProviderStateMixin, DbUtils {
  MenuController _menuController;

  int selectIndex = 0;

  int _lastClickTime = 0;

  final GlobalKey<ScaffoldState> _scffoldKey = new GlobalKey();

  final PageController _pageController = PageController(initialPage: 0);

  //打开RResideMenu按钮
  _buildLeading() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: new Icon(Icons.menu,
          color: App.of(context).night ? NIGHT_TEXT : Colors.white),
      onTap: () {
        _menuController.openMenu(true);
      },
    );
  }

  Widget _buildBody() {
    return RefreshConfiguration(
      maxOverScrollExtent: double.infinity,
      maxUnderScrollExtent:
          TargetPlatform.android == defaultTargetPlatform ? 0.0 : 100.0,
//      enableScrollWhenTwoLevel: false,
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          new HomePage(
            leading: _buildLeading(),
          ),
          GankPage(
            leading: _buildLeading(),
          ),
          new GirlPage(
            leading: _buildLeading(),
          ),
          new LikePage(
            leading: _buildLeading(),
          ),
          new SettingPage(
            leading: _buildLeading(),
          )
        ],
      ),
      springDescription:
          SpringDescription(mass: 3.0, stiffness: 400.0, damping: 16.5),
      headerBuilder: () => WaterDropHeader(),
      footerBuilder: () => CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Row(
              children: <Widget>[Icon(Icons.arrow_upward), Text("上拉加载")],
              mainAxisAlignment: MainAxisAlignment.center,
            );
          } else if (mode == LoadStatus.loading) {
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitCubeGrid(
                  size: 18.0,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  width: 15.0,
                ),
                Text("别急,马上来了!")
              ],
            );
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败,点击重新加载!");
          } else {
            body = Text("一我是有底线的一");
          }
          return Container(
            height: 60.0,
            child: Center(
              child: body,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData iconName, Function callback) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        child: new ResideMenuItem(
            title: title,
            titleStyle: new TextStyle(
                inherit: true, color: Colors.white, fontSize: 14.0),
            icon: new Icon(
              iconName,
              color: Colors.white,
            )),
        onTap: callback,
        enableFeedback: true,
      ),
    );
  }

  Widget _buildMiddleMenu() {
    return new MenuScaffold(
        itemExtent: 50.0,
        header: new Container(
          margin: new EdgeInsets.only(bottom: 20.0),
          child: new CircleAvatar(
            backgroundImage: new AssetImage('images/gank.jpg'),
            radius: 40.0,
          ),
        ),
        children: <Widget>[
          _buildMenuItem(STRING_HOME, Icons.apps, () {
            setState(() {
              selectIndex = 0;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_GANK, Icons.explore, () {
            setState(() {
              selectIndex = 1;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_GIRL, Icons.insert_photo, () {
            setState(() {
              selectIndex = 2;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_LIKE, Icons.favorite, () {
            setState(() {
              selectIndex = 3;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
          _buildMenuItem(STRING_SETTING, Icons.settings, () {
            setState(() {
              selectIndex = 4;
            });
            _pageController.jumpToPage(selectIndex);
            _menuController.closeMenu();
          }),
        ]);
  }

  Future<bool> _doubleExit() {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      _scffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text('再点多一次就退出程序!!!')));
      return new Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
            key: _scffoldKey,
            body: new ResideMenu.scaffold(
              enableFade: true,
              enable3dRotate: true,
              controller: _menuController,
              leftScaffold: _buildMiddleMenu(),
              child: new Scaffold(
                body: _buildBody(),
              ),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(colors: <Color>[
                Theme.of(context).primaryColor,
                const Color(0xff666666)
              ], begin: Alignment.topLeft)),
            )),
        onWillPop: _doubleExit);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    close();
    _menuController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _menuController = MenuController(vsync: this);
  }
}
