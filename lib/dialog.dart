import 'package:flutter/material.dart';
import 'character.dart';
import 'button.dart';

class MyFormDialog extends StatefulWidget {
  final List<Widget> buttons;

  MyFormDialog({super.key, required this.buttons});

  @override
  _MyFormDialogState createState() => _MyFormDialogState();
}

class _MyFormDialogState extends State<MyFormDialog> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  bool isOpen = false;

  Text errorText = const Text("");

  Future<void> submit() async {
    final navigator = Navigator.of(context);
    try {
      setState(() {
        _isLoading = true;
        errorText = const Text("");
      });

      final form = _formKey.currentState;
      if (!form!.validate()) {
        setState(() => _isLoading = false);
        return;
      }
      form.save();

      final character = await get(_name.trim());
      if (isOpen) {
        navigator.pop(character);
      }
    } on UnableFindException {
      if (!isOpen) {
        return;
      }
      setState(() {
        _isLoading = false;
        errorText =
            const Text("不存在此角色", style: TextStyle(color: Colors.redAccent));
      });
    } catch (e) {
      if (!isOpen) {
        return;
      }
      setState(() {
        errorText =
            const Text("网络错误", style: TextStyle(color: Colors.redAccent));
        _isLoading = false;
      });
    }

    if (!isOpen) {
      return;
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    isOpen = true;
  }

  @override
  void dispose() {
    isOpen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('新角色'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '角色名',
                  icon: Icon(Icons.account_box),
                ),
                onSaved: (value) {
                  _name = value!;
                },
                onFieldSubmitted: (value) {
                  submit();
                },
                validator: (String? value) {
                  value = value?.trim();
                  if (value == null || value.length < 4) {
                    return '请输入正确的名字';
                  }
                  for (var i = 0; i < widget.buttons.length - 1; i++) {
                    var b = widget.buttons[i] as MyButton2;
                    if (b.c.name.toLowerCase() == value.toLowerCase()) {
                      return '角色已经添加';
                    }
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        errorText,
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  submit();
                },
                child: const Text("添加"),
              ),
      ],
    );
  }
}
