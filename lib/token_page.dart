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
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return GetBuilder<Controller>(
        id: 'token',
        builder: (_) {
          return Column(children: [
            Expanded(
                child: GetBuilder<Controller>(
                    id: 'listview',
                    builder: (_) => ListView.builder(
                        key: Key('builder ${selected.toString()}'), //attention
                        itemCount: c.bindList.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            key: Key(index.toString()),
                            leading: const Icon(Icons.security),
                            title: Text('${c.bindList[index].name}'),
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
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.green),
                                    value: c.process.value,
                                  ))
                            ],
                            onExpansionChanged: (bool expanded) {
                              if (expanded) {
                                selected = index;
                                c.select(c.bindList[index].name,
                                    c.bindList[index].type);
                              } else {
                                selected = -1;
                              }
                            },
                          );
                        })))
          ]);
        });
  }
}
