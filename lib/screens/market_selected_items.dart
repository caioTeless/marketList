import 'package:flutter/material.dart';
import 'package:market_list/data/market_db_provider.dart';

import '../controller/market_controller.dart';

class MarketSelectedItems extends StatefulWidget {
  const MarketSelectedItems({super.key});

  @override
  State<MarketSelectedItems> createState() => _MarketSelectedItemsState();
}

class _MarketSelectedItemsState extends State<MarketSelectedItems> {
  final _marketListController = MarketController(MarketDbProvider());

  @override
  void initState() {
    super.initState();
    _getReadMarkedItems();
  }

  Future _getReadMarkedItems() async {
    await _marketListController.readAll(2);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _marketListController.length > 0
            ? Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Carrinho',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    Flexible(
                      child: ListView.builder(
                        itemCount: _marketListController.length,
                        itemBuilder: (ctx, index) {
                          final data = _marketListController.marketList[index];
                          return ListTile(
                            title: Text(
                              data.productName.toString(),
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w200),
                            ),
                            trailing: Text(
                              data.productAmount.toString(),
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w400),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Row(children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    )
                  ]),
                  Center(child: Text('Não existem itens')),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: () {
            _onDeleteAllData(true);
          },
        ),
      ),
    );
  }

  Future _onDeleteAllData(bool marked) async {
    await _marketListController.deleteAllData(marked);
    _getReadMarkedItems();
  }
}
