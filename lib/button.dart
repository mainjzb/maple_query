import 'dart:io';

import 'package:flutter/material.dart';

import 'character.dart';
import 'db.dart';
import 'detail_page.dart';

class MyButton2 extends StatefulWidget {
  final Character oc;
  final VoidCallback onLongPress;
  const MyButton2({Key? key, required this.oc, required this.onLongPress})
      : super(key: key);

  @override
  State<MyButton2> createState() => _MyButton2State();
}

class _MyButton2State extends State<MyButton2> {
  File? imageFile;
  bool loading = false;
  late Character c;

  _MyButton2State();

  Future<bool> update() async {
    final now = DateTime.now();
    DateTime todayAt6 = DateTime(now.year, now.month, now.day, 6, 0, 0);
    if (now.hour < 6) {
      todayAt6 = todayAt6.subtract(const Duration(days: 1));
    }
    if (!c.update!.isAfter(todayAt6)) {
      try {
        c = await get(c.name);
      } catch (e) {
        return true;
      }
      final db = await DB.getInstance();
      await db.update(c);
      setState(() {
        imageFile = c.imgFile;
      });
    } else {
      final file = await c.getImageFile();
      setState(() {
        imageFile = file;
      });
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    c = widget.oc;
    imageFile = c.imgFile;
    if (imageFile == null) {
      setState(() {
        loading = true;
      });
      update().then((value) {
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return OutlinedButton(
        onPressed: () {},
        onLongPress: widget.onLongPress,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Text(c.name, softWrap: false),
            ],
          ),
        ),
      );
    }
    if (imageFile == null) {
      return OutlinedButton(
        onPressed: () async {
          setState(() {
            loading = true;
          });
          update().then((value) {
            setState(() {
              loading = false;
            });
          });
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sync_problem, size: 60),
              Text(c.name, softWrap: false),
            ],
          ),
        ),
      );
    }
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage(c: c)),
        );
      },
      onLongPress: widget.onLongPress,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(c.imgFile!),
            Text(c.name, softWrap: false),
          ],
        ),
      ),
    );
  }
}
/*
class MyButton extends StatelessWidget {
  Character c;
  final VoidCallback onLongPress;
  bool fail = false;

  MyButton({
    super.key,
    required this.c,
    required this.onLongPress,
  });

  update() async {
    final now = DateTime.now();
    DateTime todayAt6 = DateTime(now.year, now.month, now.day, 6, 0, 0);
    if (c.update!.isAfter(todayAt6)) {
      try {
        c = await get(c.name);
      } catch (e) {
        // todo
      }
      final db = await DB.getInstance();
      await db.update(c);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fail) {
      return OutlinedButton(
        onPressed: () async {
          await update();
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sync_problem, size: 60),
              Text(c.name, softWrap: false),
            ],
          ),
        ),
      );
    }
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage(c: c)),
        );
      },
      onLongPress: onLongPress,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(c.imgFile!),
            Text(c.name, softWrap: false),
          ],
        ),
      ),
    );
  }
}
*/