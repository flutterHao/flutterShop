import 'package:flutter/material.dart';
import '../provide/goods_detail_provide.dart';
import 'package:provide/provide.dart';

class DetailGoodsPage extends StatelessWidget {
  final String goodId;
  DetailGoodsPage(this.goodId);
  @override
  Widget build(BuildContext context) {
    _getGoodDetailInfo(context);
    return Container(
      child: Center(
        child: Text("商品ID：$goodId"),
      ),
    );
  }

  void _getGoodDetailInfo(BuildContext context) async {
    await Provide.value<DetailGoodProvide>(context).getGoodInfo(goodId);
    print("加载成功---goodDetailInfo");
  }
}
