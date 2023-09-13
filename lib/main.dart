import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  var childWidget = const [
    HomePage(),
    Text('selectedIndex: 1'),
    Text('selectedIndex: 2'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //row 做为 body 布局
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
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
            child: Center(
              child: childWidget[_selectedIndex],
            ),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("maple_query");
            }
            return Text("maple_query ${snapshot.data?.version}");
          },
        ),
      ),
      body: const MyGridView(),
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
