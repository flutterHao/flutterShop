import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category.dart';

class ChildCategoryPro with ChangeNotifier {
  int childIndex = 0;
  List<BxMallSubDto> childCategoryList = [];
  String subId = "";
  String categoryId = "2c9f6c946cd22d7b016cd74220b70040";
  int page = 1;
  String noMoreText = "";

  void getChildCategoryList(List<BxMallSubDto> list, String id) {
    page = 1;
    noMoreText = "";

    BxMallSubDto all = new BxMallSubDto();
    childIndex = 0;
    categoryId = id;
    all.mallCategoryId = '';
    all.mallSubId = '';
    all.mallSubName = "全部";
    all.comments = "";
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  changeChildIndex(index, id) {
    page = 1;
    noMoreText = "";
    subId = id;
    childIndex = index;
    notifyListeners();
  }

  addPage() {
    page++;
  }

  changeNoMore(String text){
      noMoreText=text;
      notifyListeners();
  }
}
