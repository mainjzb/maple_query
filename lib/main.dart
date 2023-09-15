import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'nx_news.dart';

import 'dialog.dart';
import 'character.dart';
import 'button.dart';
import 'db.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'maple_query',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: const HomePage(),
      home: const MyApp2(),
    );
  }
}

class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  var _selectedIndex = 0;
  late List<Widget> childWidget = const [
    HomePage(
      MyGridView(),
      //key: UniqueKey(),
    ),
    HomePage(
      NewsListScreen(),
      //key: UniqueKey(),
    ),
    PageDetails(title: '123'),
  ];

  final PageController _controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    // childWidget = const [
    //   PageDetails(title: '首页'),
    //   PageDetails(title: '消息'),
    //   PageDetails(title: '我的'),
    // ];
    //_controller = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //row Scaffold(做为 body 布局
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                _controller.jumpToPage(index);
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                selectedIcon: Icon(Icons.favorite),
                label: Text('First'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book),
                selectedIcon: Icon(Icons.book),
                label: Text('Second'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star),
                selectedIcon: Icon(Icons.star),
                label: Text('Third'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          //Expanded 占满剩下屏幕空间
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              // 设置控制器
              controller: _controller,
              // 设置子项集
              children: childWidget,
              // 添加页面滑动改变后，去改变索引变量刷新页面来更新底部导航
              onPageChanged: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage2 extends StatelessWidget {
  final Widget w;
  const HomePage2(this.w, {super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settins) {
        WidgetBuilder builder;
        switch (settins.name) {
          default:
            builder = (context) => Scaffold(body: w);
            break;
        }
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final Widget w;
  const HomePage(this.w, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settins) {
        WidgetBuilder builder;
        switch (settins.name) {
          default:
            builder = (context) => Scaffold(body: widget.w);
            break;
        }
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}

class MyGridView extends StatefulWidget {
  const MyGridView({Key? key}) : super(key: key);

  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  List<Widget> buttons = [];

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      key: Key("gridView${buttons.length}"),
      maxCrossAxisExtent: 180,
      padding: const EdgeInsets.all(8),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: buttons,
    );
  }

  @override
  initState() {
    super.initState();
    buttons.add(OutlinedButton(
      onPressed: () async {
        var c = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyFormDialog(
              buttons: buttons,
            );
          },
        );
        //print(name);
        if (c != null) {
          final db = await DB.getInstance();
          await db.add(c);
          addButton(c);
        }
      },
      child: const Center(
        child: Icon(Icons.add, size: 80),
      ),
    ));

    DB.getInstance().then((db) async {
      final cs = await db.getAllName();
      for (final c in cs) {
        addButton(c);
      }
    });
  }

  Future<void> addButton(Character char) async {
    buttons.insert(
      buttons.length - 1,
      MyButton2(
        onLongPress: () => delete(char.name),
        oc: char,
      ),
    );
    setState(() {});
  }

  delete(String name) async {
    final db = await DB.getInstance();
    db.delete(name);
    for (var i = 0; i < buttons.length - 1; i++) {
      var b = buttons[i] as MyButton2;
      if (b.oc.name == name) {
        buttons.removeAt(i);
        break;
      }
    }
    setState(() {});
  }
}

class PageDetails extends StatefulWidget {
  const PageDetails({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PageDetails> createState() => _PageDetailsState();
}

/// 这里混入了 AutomaticKeepAliveClientMixin
class _PageDetailsState extends State<PageDetails>
    with AutomaticKeepAliveClientMixin {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 这里的打印可以记录一下，后面会用到
    print('PageDetails build title:${widget.title}');
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          count += 1;
          setState(() {});
        },
        child: Center(
          child: Text('${widget.title} count:$count'),
        ),
      ),
    );
  }

  // 设置 true 期望保持页面状态
  @override
  bool get wantKeepAlive => true;
}
