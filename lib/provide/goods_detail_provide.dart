import 'dart:convert';
import 'package:flutter_shop/service/service_method.dart';
import '../model/goods_detail_info.dart';
import 'package:flutter/material.dart';

class DetailGoodProvide with ChangeNotifier{
  GoodDetailModel goodDetailInfo;

  getGoodInfo(String id) async{
    var formData={'goodId':id};
    request('getGoodDetailById',formData:formData).then((val){
      var responseData=jsonDecode(val);
        goodDetailInfo=GoodDetailModel.fromJson(responseData);       
        notifyListeners();
    });
  }
}