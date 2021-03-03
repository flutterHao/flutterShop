import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/detail_goods.dart';

Handler detailhandler=Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>>prams){
    String goodsId=prams['id'].first;
    print("商品ID---------"+goodsId);
    return DetailGoodsPage(goodsId);
  }
);