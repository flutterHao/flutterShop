import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_goods.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<CategoryGoodData> goodsList=[];
  getGoodsList(List<CategoryGoodData> list) {
    goodsList = list;
    notifyListeners();

  }

    getMoreGoods(List<CategoryGoodData> list) {
     goodsList.addAll(list);
    notifyListeners();
  }
}


