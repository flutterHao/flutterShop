import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/model/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_goods.dart';
// import 'package:flutter_shop/pages/detail_goods.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import 'package:provide/provide.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List categoryList = [];
  var listIndex = 0;
  List<CategoryGoodData> goodList = [];

  @override
  void initState() {
    _getCategory();
    _getGoodsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  _getCategory();
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Row(children: <Widget>[
        _categoryListView(),
        Column(
          children: <Widget>[ChildCategory(), CategoryGoodsList()],
        ),
      ]),
    );
  }

  //用 . 点形式进行输入,减少字符串输入错误的问题
  void _getCategory() {
    request('getCategory').then((val) {
      var data = json.decode(val);
      CategoryModel categoryModel = CategoryModel.fromJson(data);
      // categoryModel.data.forEach((item)=>print(item.mallCategoryName));
      setState(() {
        categoryList = categoryModel.data;
      });
      Provide.value<ChildCategoryPro>(context).getChildCategoryList(
          categoryList[0].bxMallSubDto, categoryList[0].mallCategoryId);
    });
  }

  void _getGoodsData({String categoryId}) async {
    var data = {
      'categoryId':
          categoryId == null ? '2c9f6c946cd22d7b016cd74220b70040' : categoryId,
      'categorySubId': "",
      'page': 1
    };
    await request('getMallGoods', formData: data).then((val) {
      var data = jsonDecode(val);
      CategoryGoodsModel categoryGoodsModel = CategoryGoodsModel.fromJson(data);
      goodList = categoryGoodsModel.data;
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodList);
    });
  }

  Widget _categoryListView() {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _categoryItem(index);
        },
        itemCount: categoryList.length,
      ),
    );
  }

  //左侧大类
  Widget _categoryItem(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        //重新绘制界面
        setState(() {
          listIndex = index;
        });
        var categoryId = categoryList[index].mallCategoryId;
        var childCategoryList = categoryList[index].bxMallSubDto;
        Provide.value<ChildCategoryPro>(context)
            .getChildCategoryList(childCategoryList, categoryId);
        _getGoodsData(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(95),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 236, 236, 1) : Colors.white,
        ),
        child: Text(categoryList[index].mallCategoryName.toString(),
            style: TextStyle(
                color: isClick ? Colors.blue : Colors.black,
                fontSize: ScreenUtil().setSp(26))),
      ),
    );
  }
}

class ChildCategory extends StatefulWidget {
  @override
  _ChildCategoryState createState() => _ChildCategoryState();
}

class _ChildCategoryState extends State<ChildCategory> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategoryPro>(builder: (context, child, childcategory) {
      return Container(
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(570),
        color: Colors.white,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childcategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _childCateItem(
                  index, childcategory.childCategoryList[index]);
            }),
      );
    });
  }

  Widget _childCateItem(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategoryPro>(context).childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        Provide.value<ChildCategoryPro>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsData(item.mallSubId);
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Text(item.mallSubName,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(26),
                color: isClick ? Colors.blue : Colors.black)),
      ),
    );
  }

  void _getGoodsData(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategoryPro>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request('getMallGoods', formData: data).then((val) {
      var data = jsonDecode(val);
      CategoryGoodsModel categoryGoodsModel = CategoryGoodsModel.fromJson(data);
      if (categoryGoodsModel.data != null) {
        Provide.value<CategoryGoodsListProvide>(context)
            .getGoodsList(categoryGoodsModel.data);
      } else {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      }
    });
  }
}

class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
      ScrollController _scrollController=new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data) {
       try{
         //点击大类小类，跳到第一页
          if(Provide.value<ChildCategoryPro>(context).page==1){
            _scrollController.jumpTo(0.0);
        }
       }catch(e){
          print(e);
       }
        if (data.goodsList.length > 0) {
          return Expanded(
              child: Container(
            width: ScreenUtil().setWidth(570),
            child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.blue,
                  showMore: true,
                  noMoreText:
                      Provide.value<ChildCategoryPro>(context).noMoreText,
                      loadText: "上拉加载",
                loadingText: "加载中...",
                  loadReadyText: '上拉加载....',
                  
                ),
                child: ListView.builder(
                  controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: data.goodsList.length,
                    itemBuilder: (context, index) {
                      return _goodItem(data.goodsList, index);
                    }),
                   loadMore: ()async{
                       _getMoreGoods();
                    },
                    ),
          ));
        } else {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Text("暂时没有该商品")],
            ),
          );
        }
      },
    );
  }

  Widget _goodItem(List list, int index) {   
    return InkWell(
      onTap:(){
        String goodsId=list[index].goodsId;
        Application.router.navigateTo(context, '/detail?id=$goodsId');
      },
      child:Container(
        width: ScreenUtil().setWidth(570),
        child: Row(children: <Widget>[
          _itemImage(list, index),
          Column(
            children: <Widget>[
              _itemGoodTitle(list, index),
              _itemPrice(list, index),
            ],
          ),
        ])),       
    );
  }

  Widget _itemImage(List list, int indext) {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(200),
      child: Image.network(
        list[indext].image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _itemGoodTitle(List list, int index) {
    return Container(
      padding: EdgeInsets.all(10),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.blue),
      ),
    );
  }

  Widget _itemPrice(List list, int index) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 10),
      width: ScreenUtil().setWidth(370),
      child: Row(children: <Widget>[
        Text(
          '￥${list[index].presentPrice}',
          style:
              TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(30)),
        ),
        Text('￥${list[index].oriPrice}',
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
            )),
      ]),
    );
  }

   void _getMoreGoods() async {
     Provide.value<ChildCategoryPro>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategoryPro>(context).categoryId,
      'categorySubId': Provide.value<ChildCategoryPro>(context).subId,
      'page':  Provide.value<ChildCategoryPro>(context).page,
    };
    
    await request('getMallGoods', formData: data).then((val) {
      var data = jsonDecode(val);
      CategoryGoodsModel categoryGoodsModel = CategoryGoodsModel.fromJson(data);
      if (categoryGoodsModel.data != null) {
        Provide.value<CategoryGoodsListProvide>(context)
            .getMoreGoods(categoryGoodsModel.data);
      } else {        
        Provide.value<ChildCategoryPro>(context).changeNoMore("没有更多商品了...");
        Fluttertoast.showToast(
          msg: "没有更多商品了",
          toastLength: Toast.LENGTH_SHORT,
          gravity:ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          // backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    });
  }
}
