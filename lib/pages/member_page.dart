import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/counter.dart';
import 'package:provide/provide.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Number(), MyButton()]),
    );
  }
}

class Number extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Provide<Counter>(
      builder: (context, child, counter) {
        return Text('${counter.value}',
            style: Theme.of(context).textTheme.headline4);
      },
    ));
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Provide<Counter>(
      builder: (context, child, counter) {
        return RaisedButton(
          onPressed: () {
            counter.increment();
          },
          child: Text('点击${counter.value}次'),
        );
      },
    ));
  }
}
