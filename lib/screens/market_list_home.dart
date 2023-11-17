import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_list/controller/market_controller.dart';
import 'package:market_list/data/market_db_provider.dart';
import 'package:market_list/routes/market_list_routes.dart';
import 'package:market_list/screens/market_login_screen.dart';
import 'package:market_list/widgets/icon_button_widget.dart';
import '../helpers/text_button_name.dart';
import '../model/market_list.dart';

class MarketListHome extends StatefulWidget {
  const MarketListHome({
    super.key,
  });

  @override
  State<MarketListHome> createState() => _MarketListHomeState();
}

class _MarketListHomeState extends State<MarketListHome> {
  final _marketListController = MarketController(MarketDbProvider());
  bool _getActionSnackBar = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future _initialize() async {
    await _marketListController.readAll(1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //    UserCredential) as UserCredential;
    //var getToken = _onGetToken(FirebaseAuth.instance.currentUser);
   // if (FirebaseAuth.instance.currentUser != null &&
      //  arguments.user?.uid != '' ) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
            child: RefreshIndicator(
              onRefresh: _initialize,
              child: Column(
                children: [
                  const SizedBox(height: 8),
              //    Text('${arguments.user?.email}!'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButtonWidget(
                        icon: Icons.add,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(
                                  MarketListRoutes.MARKET_LIST_REGISTER_ITEM)
                              .then((_) => _initialize());
                        },
                        tooltip: tooltipAddNewITem,
                        textButton: registerTextButton,
                      ),
                      IconButtonWidget(
                        icon: Icons.clear,
                        onPressed: () {
                          _onDeleteSelectedItems(
                              _marketListController.marketList);
                          if (_getActionSnackBar == true) {
                            const snackBar = SnackBar(
                              content: Text('Item removido com sucesso'),
                              duration: Duration(seconds: 1),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Selecione o item a ser removido'),
                              duration: Duration(seconds: 1),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        tooltip: tooltipClearSelectedItem,
                        textButton: clearSelectedItems,
                      ),
                      IconButtonWidget(
                        icon: Icons.clear_all,
                        onPressed: () {
                          _onDeleteAllData(false);
                          const snackBar = SnackBar(
                            content: Text('Itens removidos com sucesso'),
                            duration: Duration(seconds: 1),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        tooltip: tooltipClearAllData,
                        textButton: clearAllData,
                      ),
                      if (_marketListController.length > 0)
                        IconButtonWidget(
                          icon: Icons.shopping_cart,
                          onPressed: () {
                            _onMarkedAllItems();
                            Navigator.of(context).pushNamed(
                                MarketListRoutes.MARKET_LIST_SELECTED_ITEM);
                            const snackBar = SnackBar(
                              content: Text('Itens incluídos no carrinho'),
                              duration: Duration(seconds: 1),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          tooltip: toolTipSendAllToCart,
                          textButton: sendToCartShopp,
                        ),
                      IconButtonWidget(
                        icon: Icons.shopping_bag,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              MarketListRoutes.MARKET_LIST_SELECTED_ITEM);
                        },
                        tooltip: toolTipGoToCart,
                        textButton: viewCart,
                      ),
                    ],
                  ),
                  Flexible(
                    child: !_marketListController.loading
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                              itemCount: _marketListController.length,
                              itemBuilder: (ctx, index) {
                                final data =
                                    _marketListController.marketList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Dismissible(
                                    key: Key(data.productId.toString()),
                                    onDismissed: (_) {
                                      _onMarketItem(data.productId!);
                                      const snackBar = SnackBar(
                                        content: Text(
                                            'Item enviado para o carrinho'),
                                        duration: Duration(seconds: 1),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: Card(
                                      elevation: 3,
                                      child: CheckboxListTile(
                                        title: Text(data.productName.toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400)),
                                        secondary: Text(
                                          data.productAmount.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        value: data.isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            data.isSelected = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const CircularProgressIndicator(),
                  )
                ],
              ),
            ),
          ),
        ),
      );
   // } else {
  //    return const MarketListLoginScreen();
 //   }
  }

  _onDelete(MarketList marketList) {
    _marketListController.delete(marketList);
    _initialize();
  }

  Future _onGetToken (User? user) async{
    var idToken = await user!.getIdToken(true);
    return idToken;
  }

  Future _onDeleteAllData(bool marked) async {
    await _marketListController.deleteAllData(marked);
    _initialize();
  }

  Future _onDeleteSelectedItems(List<MarketList> items) async {
    for (int i = 0; i < items.length; i++) {
      if (items[i].isSelected == true) {
        _getActionSnackBar = true;
        await _onDelete(items[i]);
      } else {
        _getActionSnackBar = false;
      }
    }
  }

  Future _onMarketItem(int productId) async {
    await _marketListController.setProductMarked(productId);
    _initialize();
  }

  Future _onMarkedAllItems() async {
    await _marketListController.setAllProductsMarked();
    _initialize();
  }

  Future _undoAllProductsMarked() async {
    await _marketListController.undoAllProductsMarked();
    _initialize();
  }
}
