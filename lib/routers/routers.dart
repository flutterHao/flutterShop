import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'routers_handler.dart';

class Routers {
  static String root = '/';
  static String detailPage = '/detail';
  static void configurePageRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> prams) {
      return Text("没有找到页面");
    });
    router.define(detailPage, handler: detailhandler);
  }
}
