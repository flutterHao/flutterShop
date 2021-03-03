import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/routers/application.dart';

import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  bool get wantKeepAlive => false;

  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  void initState() {
    getHttpPageContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fromData = {'lot': '115.1212', 'lat': '45.1231'};
    super.build(context);
    // MediaQueryData mediaQuery = MediaQuery.of(context);
    // print('设备高-----------:${ScreenUtil.screenHeight}');
    // print('设备宽-----------:${ScreenUtil.screenWidth}');
    // print('像素密度-----------:${ScreenUtil.pixelRatio}');
    return Container(
      color: Colors.black,
      child: Scaffold(       
        appBar: AppBar(title: Text('Homepage'),
        // backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
        ),
        body: FutureBuilder(
          future: request('homePageContent', formData: fromData),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              var data = json.decode(snapShot.data.toString());
              var datas = data['data'];
              List<Map> swiperDataList = (datas['slides'] as List).cast();
              List<Map> navigatorList = (datas['category'] as List).cast();
              String adPicture = datas['advertesPicture']['PICTURE_ADDRESS'];
              String leaderImage = datas['shopInfo']['leaderImage'];
              String leaderPhone = datas['shopInfo']['leaderPhone'];
              List<Map> recommendList = (datas['recommend'] as List).cast();
              String floorPic = datas['floor1Pic']['PICTURE_ADDRESS'];
              List<Map> floorList = (datas['floor1'] as List).cast();
              String floorPic2 = datas['floor2Pic']['PICTURE_ADDRESS'];
              List<Map> floorList2 = (datas['floor2'] as List).cast();
              String floorPic3 = datas['floor3Pic']['PICTURE_ADDRESS'];
              List<Map> floorList3 = (datas['floor3'] as List).cast();

              return EasyRefresh(
                refreshFooter: ClassicsFooter(
                   key:_footerKey,
                    bgColor:Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText: '没有更多了',
                    moreInfo: '加载中',
                    loadReadyText:'上拉加载....',  
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    SwiperDiy(
                      swiperDataList: swiperDataList,
                    ),
                    TopNavigator(navigatorList: navigatorList),
                    AdPicture(
                      adPicture: adPicture,
                    ),
                    LeaderPhone(
                      leaderImage: leaderImage,
                      leaderPhone: leaderPhone,
                    ),
                    Recommend(recommendList: recommendList),
                    FloorTitle(
                      floorPic: floorPic,
                    ),
                    FloorContent(floorList: floorList),
                    FloorTitle(
                      floorPic: floorPic2,
                    ),
                    FloorContent(floorList: floorList2),
                    FloorTitle(
                      floorPic: floorPic3,
                    ),
                    FloorContent(floorList: floorList3),
                    _hotGoodsList(),
                  ],
                )),
                loadMore: () async {
                  print('开始加载更多');
                  var formPage = {'page': page};
                  await request('homePageBelowConten', formData: formPage)
                      .then((val) {
                    var data = json.decode(val.toString());
                   if(data['data']!=null){
                      List<Map> newGoodsList = (data['data'] as List).cast();
                      setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                   }
                    
                  });
                },
              );
            } else {
              return Center(
                child: Text('正在获取数据！'),
              );
            }
          },
        ),
      ),
    );
  }

  //火爆专区标题
  Widget hotTitle = Container(
    alignment: Alignment.center,
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Text(
      '火爆专区',
      style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(30)),
    ),
  );

  //火爆专区子项
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> wrapList = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
          },
          child: Container(
              width: ScreenUtil().setWidth(372),
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.only(bottom: 3.0),
              child: Column(
                children: <Widget>[
                  Image.network(val['image']),
                  Text(
                    val['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(26), color: Colors.blue),
                  ),
                  Row(children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ])
                ],
              )),
        );
      }).toList();

      return Wrap(
        children: wrapList,
      );
    } else {
      return Text(' ');
    }
  }

  Widget _hotGoodsList() {
    return Column(
      children: <Widget>[
        hotTitle,
        _wrapList(),
      ],
    );
  }
}

//首页滑动图片
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print("缩放比例${ScreenUtil().scaleWidth}");
    return Container(
      height: ScreenUtil().setHeight(330),
      width: ScreenUtil().setWidth(750),
      // padding: EdgeInsets.all(10),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Swiper(
        itemBuilder: (context, index) {
          return Image.network(
            swiperDataList[index]['image'],
            fit: BoxFit.cover,
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//类别导航
class TopNavigator extends StatelessWidget {
  final textStyle = TextStyle(fontSize: ScreenUtil().setSp(25));

  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUi(context, item) {
    return InkWell(
      onTap: () {
        print(item['mallCategoryName']);
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(80),
          ),
          Text(item['mallCategoryName'], style: textStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if(navigatorList.length>10){
    //   navigatorList.removeRange(10, navigatorList.length);
    // }
    return Container(
      // color: Color.fromARGB(222,222,222,222),
      height: ScreenUtil().setHeight(420),
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        physics:NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUi(context, item);
        }).toList(),
      ),
    );
  }
}

class AdPicture extends StatelessWidget {
  final String adPicture;
  AdPicture({Key key, this.adPicture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(   
      padding: EdgeInsets.only(left:10,right:10),
      child: Image.network("$adPicture"),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderPhone;
  final String leaderImage;
  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchUrl,
        child: Image.network('$leaderImage'),
      ),
    );
  }

  void _launchUrl() async {
    String url = 'tel:' + leaderPhone;
    //  String url='http://jspang.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url___不能访问！';
    }
  }
}

class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);

  Widget _recommendTitle() {
    return Container(
      height: ScreenUtil().setHeight(70),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(5, 10, 0, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _recommandItem(index) {
    return Container(
      width: ScreenUtil().setWidth(375),
      height: ScreenUtil().setHeight(300),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 0.25)),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(children: <Widget>[
          Image.network(recommendList[index]['image']),
          Text('￥${recommendList[index]['mallPrice']}'),
          Text(
            '￥${recommendList[index]['price']}',
            style: TextStyle(
                decoration: TextDecoration.lineThrough, color: Colors.black12),
          )
        ]),
      ),
    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(500),
      width: ScreenUtil().setWidth(750),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (comtext, index) {
          return _recommandItem(index);
        },
        itemCount: recommendList.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(570),
      child: Column(
        children: <Widget>[
          _recommendTitle(),
          _recommendList(),
        ],
      ),
    );
  }
}

class FloorTitle extends StatelessWidget {
  final String floorPic;

  const FloorTitle({Key key, this.floorPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Image.network('$floorPic'),
    );
  }
}

class FloorContent extends StatelessWidget {
  final List floorList;

  const FloorContent({Key key, this.floorList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstFloor(), _otherFloor()],
      ),
    );
  }

  Widget _firstFloor() {
    return Row(
      children: <Widget>[
        _goodsItem(floorList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorList[1]),
            _goodsItem(floorList[2])
          ],
        ),
      ],
    );
  }

  Widget _otherFloor() {
    return Row(
      children: <Widget>[_goodsItem(floorList[3]), _goodsItem(floorList[4])],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375.0),
      child: InkWell(
        onTap: () {
          print("点击了图片");
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}
