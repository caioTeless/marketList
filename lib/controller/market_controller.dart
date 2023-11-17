import 'package:market_list/data/market_db_provider.dart';
import '../model/market_list.dart';

class MarketController {
  final MarketDbProvider serviceDbProvider;

  int? productId;
  String? productName;
  int? productAmount;
  int? cMarked;
  List<MarketList> marketList = [];
  List<MarketList> marketListMarked = [];
  List<MarketList> marketListWithoutMarked = [];
  bool loading = false; 

  int get length => marketList.isEmpty ? 0 : marketList.length;

  MarketController(this.serviceDbProvider);

  void setProductName(String? name) => productName = name;
  void setProductAmount(String? amount) => productAmount = int.tryParse(amount!);

  Future readAll(int typeRead) async {
    loading = true;
    if(typeRead == 0){ //normal
      marketList = await serviceDbProvider.readAll();
    }else if(typeRead == 1){ //without marked
      marketListWithoutMarked = await serviceDbProvider.readAllWithoutMarked();
      marketList = await serviceDbProvider.readAllWithoutMarked();
    }else if(typeRead == 2) { //marked
      marketList = await serviceDbProvider.readAllMarked();
    }
    
    loading= false;
    return marketList;
  }


  Future save() async {
    var item = MarketList(
      productId: productId,
      productName: productName,
      productAmount: productAmount,
      cMarked: cMarked == 0 ? 0 : cMarked,
    );
    if(productId != null){
      await serviceDbProvider.update(item);
    }else {
      await serviceDbProvider.insert(item);
    }
  }

  Future readById(int id) async{
    await serviceDbProvider.readById(id);
  }

  Future delete(MarketList item) async{
    loading = true;
    await serviceDbProvider.delete(item);
    loading = false;
  }

  Future deleteAllData(bool marked) async{
    loading = true;
    await serviceDbProvider.deleteAll(marked);
    loading = false;
  }

  Future setProductMarked(int productId) async{
    loading = true;
    await serviceDbProvider.setProductMarked(productId);
    loading = false;
  }

  Future setAllProductsMarked() async{
    loading = true;
    await serviceDbProvider.setAllProductsMarked();
    loading = false;
  }

  Future undoAllProductsMarked() async{
    loading = true;
    await serviceDbProvider.undoAllProductsMarked();
    loading = false;
  }

}
