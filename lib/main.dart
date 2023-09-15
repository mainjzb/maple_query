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
      home: const SideBarScaffold(),
    );
  }
}

class BarItem {
  final Widget child;
  final String title;
  final Icon icon;

  const BarItem(this.child, this.title, this.icon);
}

class SideBarScaffold extends StatefulWidget {
  const SideBarScaffold({super.key});

  @override
  State<SideBarScaffold> createState() => _SideBarScaffoldState();
}

class _SideBarScaffoldState extends State<SideBarScaffold> {
  var _selectedIndex = 0;

  final List<BarItem> childWidget = const [
    BarItem(NavigatorWrap(MyGridView()), "query", Icon(Icons.favorite)),
    BarItem(NavigatorWrap(NewsListScreen()), "news", Icon(Icons.message)),
    BarItem(PageDetails(title: '123'), "test", Icon(Icons.book)),
  ];

  final PageController _controller = PageController(initialPage: 0);

  void onTap(index) {
    setState(() {
      _selectedIndex = index;
      _controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final mainWidget = PageView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: _controller,
      children: childWidget.map((e) => e.child).toList(),
    );

    if (screenWidth < screenHeight) {
      final items = childWidget
          .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.title))
          .toList();
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: onTap,
          items: items,
        ),
        body: mainWidget,
      );
    }
    final items = childWidget
        .map((e) =>
            NavigationRailDestination(icon: e.icon, label: Text(e.title)))
        .toList();
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: onTap,
            labelType: NavigationRailLabelType.all,
            destinations: items,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: mainWidget),
        ],
      ),
    );
  }
}

class NavigatorWrap extends StatefulWidget {
  final Widget w;
  const NavigatorWrap(this.w, {super.key});

  @override
  State<NavigatorWrap> createState() => _NavigatorWrapState();
}

class _NavigatorWrapState extends State<NavigatorWrap>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
