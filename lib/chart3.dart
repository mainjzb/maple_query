import 'dart:math';

import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

import 'character.dart';

String toTB(int value){
  if(value>1000000000000 ){
    return "${(value/1.0/1000000000000).toStringAsFixed(1)}T";
  }
  else if( value>1000000000 ){
    return "${(value/1.0/1000000000).toStringAsFixed(1)}B";
  }else if(value>1000000){
    return "${(value/1.0/1000000000).toStringAsFixed(1)}M";
  }
  return (value/1.0/1000000000).toString();
}

class CC extends StatelessWidget {
  final History history;
  const CC(this.history, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var max = 1;
    for (final i in history.list) {
      if(i.exp>max ){
        max =i.exp;
      }
    }

    List<DChartBarDataCustom> list = [];
    for (final i in history.list) {
      var day= i.day.substring(5);
      if(day[0]=='0'){
        day = day.substring(1);
      }
      list.add(DChartBarDataCustom(
        value: i.exp.toDouble(),
        label: day,
        showValue: true,
        valueCustom: Column(children: [Text(toTB(i.exp))]),
      ));
    }
    if(list.isEmpty){
      list.add(DChartBarDataCustom(
        value: 0,
        label: "0",
        showValue: true,
      ));
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartBarCustom(
        max: max/1.0,
        showDomainLine: true,
        showMeasureLine: true,
        showDomainLabel: true,
        //showMeasureLabel: true,
        spaceBetweenItem: 6,
        listData: list,
      ),
    );
  }
}
