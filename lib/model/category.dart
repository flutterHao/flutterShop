class CategoryModel {
  String code;
  List<Data> data;
  String message;

  CategoryModel({this.code, this.data, this.message});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  List<BxMallSubDto> bxMallSubDto;
  String image;
  String mallCategoryId;
  String mallCategoryName;

  Data(
      {this.bxMallSubDto,
      this.image,
      this.mallCategoryId,
      this.mallCategoryName});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['bxMallSubDto'] != null) {
      bxMallSubDto = new List<BxMallSubDto>();
      json['bxMallSubDto'].forEach((v) {
        bxMallSubDto.add(new BxMallSubDto.fromJson(v));
      });
    }
    image = json['image'];
    mallCategoryId = json['mallCategoryId'];
    mallCategoryName = json['mallCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bxMallSubDto != null) {
      data['bxMallSubDto'] = this.bxMallSubDto.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
    data['mallCategoryId'] = this.mallCategoryId;
    data['mallCategoryName'] = this.mallCategoryName;
    return data;
  }
}

class BxMallSubDto {
  String mallCategoryId;
  String mallSubId;
  String mallSubName;
  String comments;

  BxMallSubDto(
      {this.mallCategoryId, this.mallSubId, this.mallSubName, this.comments});

  BxMallSubDto.fromJson(Map<String, dynamic> json) {
    mallCategoryId = json['mallCategoryId'];
    mallSubId = json['mallSubId'];
    mallSubName = json['mallSubName'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mallCategoryId'] = this.mallCategoryId;
    data['mallSubId'] = this.mallSubId;
    data['mallSubName'] = this.mallSubName;
    data['comments'] = this.comments;
    return data;
  }
}
