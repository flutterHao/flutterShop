class CategoryGoodsModel {
  String code;
  List<CategoryGoodData> data;
  String message;

  CategoryGoodsModel({this.code, this.data, this.message});

  CategoryGoodsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<CategoryGoodData>();
      json['data'].forEach((v) {
        data.add(new CategoryGoodData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CategoryGoodData {
  String goodsId;
  String goodsName;
  String image;
  double oriPrice;
  double presentPrice;

  CategoryGoodData(
      {this.goodsId,
      this.goodsName,
      this.image,
      this.oriPrice,
      this.presentPrice});

  CategoryGoodData.fromJson(Map<String, dynamic> json) {
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
    image = json['image'];
    oriPrice = json['oriPrice'];
    presentPrice = json['presentPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['image'] = this.image;
    data['oriPrice'] = this.oriPrice;
    data['presentPrice'] = this.presentPrice;
    return data;
  }
}
