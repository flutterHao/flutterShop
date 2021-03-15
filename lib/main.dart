import 'dart:developer';

// import 'package:fluro/fluro.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/provide/counter.dart';
import 'package:flutter_shop/provide/goods_detail_provide.dart';
import 'package:provide/provide.dart';
import './pages/index_pages.dart';
import './provide/counter.dart';
import 'routers/application.dart';
import 'routers/routers.dart';

// void main()=>runApp(
//   //颜色变灰
// //  ColorFiltered(colorFilter: ColorFilter.mode(Colors.white24, BlendMode.color),
// //  child: MyApp(),
// //  ),
// MyApp()
// );

void main() {
  var counter = new Counter();
  var childCategoryPro = new ChildCategoryPro();
  var categoryGoods = new CategoryGoodsListProvide();
  var detailGoods = new DetailGoodProvide();

  var providers = new Providers();
  providers..provide(Provider<Counter>.value(counter));
  providers.provide(Provider<ChildCategoryPro>.value(childCategoryPro));
  providers.provide(Provider<CategoryGoodsListProvide>.value(categoryGoods));
  providers.provide(Provider<DetailGoodProvide>.value(detailGoods));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = FluroRouter();
    Routers.configurePageRoutes(router);
    Application.router = router;
    return MaterialApp(
      onGenerateRoute: Application.router.generator,
      title: '百姓生活+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.red[900]),
      home: IndexPages(),
    );
  }
}
