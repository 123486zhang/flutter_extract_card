
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

extension Json on PurchasedItem {

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['transactionId'] = this.transactionId;
    data['transactionDate'] = this.transactionDate?.millisecondsSinceEpoch;
    data['transactionReceipt'] = this.transactionReceipt;

//    data['purchaseToken'] = this.purchaseToken??"";
//    data['orderId'] = this.orderId??"";
//    /// android specific
//    data['dataAndroid'] = this.dataAndroid??"";
//    data['signatureAndroid'] = this.signatureAndroid??"";
//    data['isAcknowledgedAndroid'] = this.isAcknowledgedAndroid??"";
//    data['autoRenewingAndroid'] = this.autoRenewingAndroid??"";
//    data['purchaseStateAndroid'] = this.purchaseStateAndroid??"";
//    data['developerPayloadAndroid'] = this.developerPayloadAndroid??"";
//    data['originalJsonAndroid'] = this.originalJsonAndroid??"";
//    /// ios specific
//    data['originalTransactionDateIOS'] = this.originalTransactionDateIOS?.toIso8601String()??"";
//    data['originalTransactionIdentifierIOS'] = this.originalTransactionIdentifierIOS??"";
//    data['transactionStateIOS'] = this.transactionStateIOS.index;

    if (this.purchaseToken != null) data['purchaseToken'] = this.purchaseToken;
    if (this.orderId != null) data['orderId'] = this.orderId;
    /// android specific
    if (this.dataAndroid != null) data['dataAndroid'] = this.dataAndroid;
    if (this.signatureAndroid != null) data['signatureAndroid'] = this.signatureAndroid;
    if (this.isAcknowledgedAndroid != null) data['isAcknowledgedAndroid'] = this.isAcknowledgedAndroid;
    if (this.autoRenewingAndroid != null) data['autoRenewingAndroid'] = this.autoRenewingAndroid;
    if (this.purchaseStateAndroid != null) data['purchaseStateAndroid'] = this.purchaseStateAndroid;
    if (this.originalJsonAndroid != null) data['originalJsonAndroid'] = this.originalJsonAndroid;
    /// ios specific
    if (this.originalTransactionDateIOS != null) data['originalTransactionDateIOS'] = this.originalTransactionDateIOS?.millisecondsSinceEpoch;
    if (this.originalTransactionIdentifierIOS != null) data['originalTransactionIdentifierIOS'] = this.originalTransactionIdentifierIOS;
    if (this.transactionStateIOS != null) data['transactionStateIOS'] = this.transactionStateIOS.index;


//    'transactionId': transactionId,
//    'transactionDate': transactionDate?.toIso8601String(),
//    'transactionReceipt': transactionReceipt,
//    'purchaseToken': purchaseToken,
//    'orderId': orderId,
//    /// android specific
//    'dataAndroid': dataAndroid,
//    'signatureAndroid': signatureAndroid,
//    'isAcknowledgedAndroid': isAcknowledgedAndroid,
//    'autoRenewingAndroid': autoRenewingAndroid,
//    'purchaseStateAndroid': purchaseStateAndroid,
//    'developerPayloadAndroid': developerPayloadAndroid,
//    'originalJsonAndroid': originalJsonAndroid,
//    /// ios specific
//    'originalTransactionDateIOS': originalTransactionDateIOS?.toIso8601String(),
//    'originalTransactionIdentifierIOS': originalTransactionIdentifierIOS,
//    'transactionStateIOS': transactionStateIOS
//    print("data --- $data");
  return data;

  }
}