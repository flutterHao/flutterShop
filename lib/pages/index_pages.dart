import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/pages/cart_page.dart';
import 'package:flutter_shop/pages/category_page.dart';
import 'package:flutter_shop/pages/home_page.dart';
import 'package:flutter_shop/pages/member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPages extends StatefulWidget  {
  @override
  _IndexPagesState createState() => _IndexPagesState();
}

class _IndexPagesState extends State<IndexPages> /*with SingleTickerProviderStateMixin*/ {
  int currentIndex = 0;
  var currentPage;

  final List<Widget> pagesList = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];

  final List<BottomNavigationBarItem> bottomList = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          // color: Colors.blue,
        ),
        title: Text('首页')),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.search,
          // color: Colors.blue,
        ),
        title: Text('分类')),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.shopping_cart,
          // color: Colors.blue,
        ),
        title: Text('购物车')),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.people,
          // color: Colors.blue,
        ),
        title: Text('会员中心')),
  ];

  @override
  void initState() {
    currentPage = pagesList[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,height: 1334,width:750,allowFontScaling: false);
    return Container(
      child: Scaffold(      
        backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,            
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
                currentPage = pagesList[index];
              });
            },
            items: bottomList),
            // body: currentPage,
       body: IndexedStack(
        index: currentIndex,
        children: pagesList
      ),      
      ),
    );
  }
}
