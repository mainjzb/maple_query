import 'dart:io';

import 'package:flutter/material.dart';

import 'character.dart';
import 'db.dart';
import 'detail_page.dart';

class MyButton2 extends StatefulWidget {
  Character c;
  final VoidCallback onLongPress;
  MyButton2({Key? key, required this.c, required this.onLongPress}) : super(key: key);

  @override
  State<MyButton2> createState() {
    return _MyButton2State();
  }
}

class _MyButton2State extends State<MyButton2> {
  File? imageFile;
  bool loading = false;

  _MyButton2State();

  Future<bool> update() async {
    final now = DateTime.now();
    DateTime todayAt6 = DateTime(now.year, now.month, now.day, 6, 0, 0);
    if(now.hour < 6){
      todayAt6 = todayAt6.subtract(const Duration(days: 1));
    }
    if (!widget.c.update!.isAfter(todayAt6)) {
      try {
        widget.c = await get(widget.c.name);
      } catch (e) {
        return true;
      }
      final db = await DB.getInstance();
      await db.update(widget.c);
      setState(() {
        imageFile = widget.c.imgFile;
      });
    }else{
      final file =await widget.c.getImageFile();
      setState(() {
        imageFile = file;
      });
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    imageFile = widget.c.imgFile;
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
              Text(widget.c.name, softWrap: false),
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
              Text(widget.c.name, softWrap: false),
            ],
          ),
        ),
      );
    }
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage(c: widget.c)),
        );
      },
      onLongPress: widget.onLongPress,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(widget.c.imgFile!),
            Text(widget.c.name, softWrap: false),
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