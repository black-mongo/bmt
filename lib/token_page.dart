import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'controller.dart';
import 'loading.dart';

class TokenPage extends StatefulWidget {
  const TokenPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return TokenPageState();
  }
}

class TokenPageState extends State<TokenPage> {
  int selected = -1;
  Map _checkBoxs = {};
  bool _showCheckbox = false;
  final Controller c = Get.find();
  void _setCheckBoxs(String index, bool value) {
    if (_checkBoxs[index] != null) {
      _checkBoxs[index] = value;
    } else {
      _checkBoxs[index] = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
        id: 'token',
        builder: (_) {
          return _showCheckbox
              ? Column(children: [
                  Row(
                    children: [
                      TextButton(
                        child: Text("btn_delete".tr),
                        onPressed: () {
                          c.deleteBindList(_checkBoxs);
                          setState(() {
                            _showCheckbox = false;
                          });
                        },
                      )
                    ],
                  ),
                  _list()
                ])
              : Column(children: [_list()]);
        });
  }

  Widget _list() {
    return Expanded(
        child: GetBuilder<Controller>(
            id: 'listview',
            builder: (_) => ListView.builder(
                key: Key('builder ${selected.toString()}'), //attention
                itemCount: c.bindList.length,
                itemBuilder: (context, index) {
                  var name = c.bindList[index].name;
                  return TextButton(
                      onPressed: () {},
                      onLongPress: () {
                        setState(() {
                          _showCheckbox = true;
                          _checkBoxs = {};
                          _setCheckBoxs(name, true);
                        });
                        debugPrint("on Long Press");
                      },
                      child: ExpansionTile(
                        key: Key(index.toString()),
                        leading: _showCheckbox
                            ? Checkbox(
                                value: _checkBoxs[name] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _setCheckBoxs(name, value!);
                                  });
                                })
                            : const Icon(Icons.security),
                        title: Text('$name'),
                        initiallyExpanded: selected == index,
                        trailing: const Icon(Icons.expand_more),
                        children: <Widget>[
                          ListTile(title: Obx(() {
                            var token = c.tokens[c.bindList[index].name];
                            return token == null
                                ? const Loading()
                                : Center(child: Text('${token}'));
                          })),
                          Obx(() => LinearProgressIndicator(
                                backgroundColor: Colors.grey[200],
                                valueColor:
                                    const AlwaysStoppedAnimation(Colors.green),
                                value: c.process.value,
                              ))
                        ],
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            selected = index;
                            c.select(
                                c.bindList[index].name, c.bindList[index].type);
                          } else {
                            selected = -1;
                          }
                        },
                      ));
                })));
  }
}
