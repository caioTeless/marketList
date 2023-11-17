import 'dart:convert';

class MarketList {
  int? productId;
  String? productName;
  int? productAmount;
  int? cMarked;
  bool? isSelected = false;
  
  MarketList({
    this.productId,
    required this.productName,
    required this.productAmount,
    this.cMarked,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'productName': productName,
      'productAmount': productAmount,
      'cMarked': cMarked
    };
    if (data['productId'] != null) data['productId'] = productId;
    return data;
  }

  factory MarketList.fromMap(Map<String, dynamic> map) {
    return MarketList(
      productId: map['productId'],
      productName: map['productName'],
      productAmount: map['productAmount'],
      cMarked: map['cMarked']
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketList.fromJson(String source) =>
      MarketList.fromMap(json.decode(source));
}
