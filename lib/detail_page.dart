import 'package:flutter/material.dart';
import 'package:maple_query/chart3.dart';

import 'character.dart';
import 'info.dart';

class SecondPage extends StatelessWidget {
  final Character c;

  const SecondPage({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    final l = c.history.list;
    final nextLevel =  (((l[l.length-1].level+1) / 5).ceil()) * 5;
    final oneDayExpect = calcOneDay(l).toStringAsFixed(1);

    List<Widget> list = [
      Column(children: [
        Image.file(c.imgFile!, scale: 0.6),
        Text(c.name),
      ]),
      Text('等级：${c.level}-${c.expPercent}% (排名${c.serverRank})'),
      Text('职业：${c.className} (排名:${c.serverClassRank})')
    ];

    if (c.achievementPoints != null && c.achievementPoints != 0) {
      list.addAll([
        const SizedBox(height: 30),
        Text('成就值：${c.achievementPoints} (排名${c.achievementRank})'),
        Text('联盟等级：${c.legionLevel} (排名${c.legionRank})'),
        Text('联盟战斗力：${c.legionPower! ~/ 1000000}m (每日${c.legionCoinPerDay}币)'),
        Text('联盟币上限：'),
        const SizedBox(height: 30),
        Text('参照最近1天到达$nextLevel还有$oneDayExpect天'),
        //BarChartSample3(),
      ]);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > screenHeight) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Second Page'),
        ),
        body: Center(
          child: Row(children: [
            Flexible(
              flex: 20,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: list,
                ),
              ),
            ),
            Flexible(
              flex: 60,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000, // 设置最大宽度为 400 像素
                    maxHeight: 1000, // 设置最大高度为 300 像素
                  ),
                  child: CC(c.history),
                ),
              ),
            ),
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
            Flexible(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000, // 设置最大宽度为 400 像素
                    maxHeight: 1000, // 设置最大高度为 300 像素
                  ),
                  child: CC(c.history),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncrementIntent extends Intent {
  const IncrementIntent();
}
