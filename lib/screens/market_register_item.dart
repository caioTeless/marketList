import 'package:flutter/material.dart';
import 'package:market_list/controller/market_controller.dart';
import 'package:market_list/data/market_db_provider.dart';
import 'package:market_list/widgets/elevated_button_widget.dart';
import '../model/market_list.dart';
import '../widgets/input_form_field_widget.dart';

class MarketRegisterItem extends StatefulWidget {
  final MarketList? marketList;

  const MarketRegisterItem({
    super.key,
    this.marketList,
  });

  @override
  State<MarketRegisterItem> createState() => _MarketRegisterItemState();
}

class _MarketRegisterItemState extends State<MarketRegisterItem> {
  final _marketListController = MarketController(MarketDbProvider());
  final _productNameController = TextEditingController();
  final _productAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final isSelected = <bool>[false, false];
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _populateController();
  }

  void _populateController() {
    int? id = widget.marketList?.productId ?? 0;
    if (id > 0) {
      _marketListController.productId = id;
      _productNameController.text = widget.marketList?.productName ?? '';
      _productAmountController.text =
          widget.marketList?.productAmount.toString() ?? '';
      _isButtonDisabled = false;
    } else {
      _isButtonDisabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputFormFieldWidget(
                        hintText: 'Nome',
                        controller: _productNameController,
                        onSaved: _marketListController.setProductName,
                      ),
                      const SizedBox(height: 10),
                      InputFormFieldWidget(
                        hintText: 'Total',
                        controller: _productAmountController,
                        onSaved: _marketListController.setProductAmount,
                        isKeyboardNumber: true,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButtonWidget(
                            icon: Icons.save,
                            onPressed: () {
                              _onSave(context);
                            },
                          ),
                          ElevatedButtonWidget(
                            icon: Icons.delete,
                            onPressed: _isButtonDisabled
                                ? null
                                : () {
                                    _onDelete(widget.marketList!);
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _onSave(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _marketListController.cMarked = 0;
      await _marketListController.save();
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future _onDelete(MarketList marketList) async {
    await _marketListController.delete(marketList);
    _productNameController.clear();
    _productAmountController.clear();

    setState(() {});
  }
}
