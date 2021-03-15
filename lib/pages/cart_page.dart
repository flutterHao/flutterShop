import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/counter.dart';
import 'package:provide/provide.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Provide<Counter>(builder: (context, child, counter) {
      return Text('${counter.value}',
          style: Theme.of(context).textTheme.headline4);
    }));
  }
}
