import 'package:flutter/material.dart';
import 'character.dart';
import 'button.dart';

class MyFormDialog extends StatefulWidget {
  final List<Widget> buttons;

  const MyFormDialog({super.key, required this.buttons});

  @override
  _MyFormDialogState createState() => _MyFormDialogState();
}

class _MyFormDialogState extends State<MyFormDialog> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  // bool _formFailed = false;

  Text t = const Text("");

  void submit() async {
    final navigator = Navigator.of(context);
    try {
      setState(() {
        _isLoading = true;
        t = const Text("");
      });
      final form = _formKey.currentState;
      if (!form!.validate()) {
        return;
      }
      form.save();
      var c = await get(_name);
      navigator.pop(c);
    } catch (e) {
      print(e);
      setState(() {
        t = const Text("网络错误", style: TextStyle(color: Colors.redAccent));
      });
    } finally {
      setState(() => _isLoading = false);
    }
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
        t,
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: submit,
                child: const Text("添加"),
              ),
      ],
    );
  }
}
