class Configuration {
  int? configurationId;
  int? checkProductsDone;
  int? checkRememberPassword;
  int? checkEditRemoveProducts;
  int? checkRemoveSelectedItems;

  Configuration({
    this.configurationId,
    this.checkProductsDone,
    this.checkRememberPassword,
    this.checkEditRemoveProducts,
    this.checkRemoveSelectedItems,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'checkProductsDone': checkProductsDone,
      'checkRememberPassword': checkRememberPassword,
      'checkEditRemoveProducts': checkEditRemoveProducts,
      'checkRemoveSelectedItems': checkRemoveSelectedItems
    };
    if (map['configurationId'] != null) {
      map['configurationId'] = configurationId;
    }
    return map;
  }

  factory Configuration.fromMap(Map<String, dynamic> map) {
    return Configuration(
      configurationId: map['configurationId'],
      checkProductsDone: map['checkProductsDone'],
      checkRememberPassword: map['checkRememberPassword'],
      checkEditRemoveProducts: map['checkEditRemoveProducts'],
      checkRemoveSelectedItems: map['checkRemoveSelectedItems'],
    );
  }
}
