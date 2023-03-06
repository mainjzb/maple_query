import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

import 'character.dart';
import 'info.dart';

String toTB(int value){
  if(value>1000000000000 ){
    return "${(value/1.0/1000000000000).toStringAsFixed(1)}T";
  }
  else if( value>1000000000 ){
    return "${(value/1.0/1000000000).toStringAsFixed(1)}B";
  }else if(value>1000000){
    return "${(value/1.0/1000000000).toStringAsFixed(1)}M";
  }
  return (value).toString();
}

class CC extends StatelessWidget {
  final History history;
  const CC(this.history, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> list = [];
    for ( var i=1;i<history.list.length;i++ ) {
      final prev = history.list[i-1];
      final curr = history.list[i];
      final diffExp = expDiff(curr.level,curr.exp,prev.level,prev.exp);
      list.add({'domain':curr.day.substring(5),'measure':diffExp});
    }
    if(list.isEmpty){

    }

    return AspectRatio(
      aspectRatio: 9 / 9,
      child: DChartBar(
        data: [
          {
            'id': 'Bar',
            'data': list,
          },
        ],
        domainLabelPaddingToAxisLine: 8,
        axisLineTick: 2,
        axisLinePointTick: 2,
        axisLinePointWidth: 0,
        axisLineColor: Colors.green,
        verticalDirection: false,
        measureLabelPaddingToAxisLine: 0,
        showMeasureLine: false,
        measureLabelColor:Colors.transparent,
        barColor: (barData, index, id) => Colors.green.shade300,
        // barColor: (barData, index, id) => barData['measure'] >= 4
        //     ? Colors.green.shade300
        //     : Colors.green.shade700,
        barValue: (barData, index) {
          var value =  barData['measure'];
          if(value>1000000000000 ){
            return "${(value/1.0/1000000000000).toStringAsFixed(1)}T";
          }
          else if( value>1000000000 ){
            return "${(value/1.0/1000000000).toStringAsFixed(0)}B";
          }else if(value>1000000){
            return "${(value/1.0/1000000000).toStringAsFixed(1)}M";
          }
          return (value).toString();
        },
        showBarValue: true,
        barValueFontSize:12,
        barValuePosition: BarValuePosition.outside,
      ),
    );
  }
}
