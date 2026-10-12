import 'dart:convert';

class VrnOutBoundModel {
  final int? vehicleTransactionId;
  final String? tenantCode;
  final String? vrn;
  final String? transactionCode;
  final String? passNo;
  final String? tpDateTime;
  final String? driverName;
  final String? gateInTime;
  final String? gateOutTime;
  final String? productName;
  final String? productCode;
  final String? transporterName;
  final int? doNumber;
  final int? orderNumber;
  final double? expectedQuantity;
  final double? tareWeight;
  final double? grossWeight;
  final double? netWeight;
  final String? plantTAT;
  final String? receiverPlantName;
  final String? orderType;
  final double? totalNetAmount;
  final int? totalRecord;
  final int? totalPages;

  const VrnOutBoundModel({
  this.vehicleTransactionId,
  this.tenantCode,
  this.vrn,
  this.transactionCode,
  this.passNo,
  this.tpDateTime,
  this.driverName,
  this.gateInTime,
  this.gateOutTime,
  this.productName,
  this.productCode,
  this.transporterName,
  this.doNumber,
  this.orderNumber,
  this.expectedQuantity,
  this.tareWeight,
  this.grossWeight,
  this.netWeight,
  this.plantTAT,
  this.receiverPlantName,
  this.orderType,
  this.totalNetAmount,
  this.totalRecord,
  this.totalPages,
  });

  factory VrnOutBoundModel.fromJson(
  Map<String, dynamic> json,
  ) {
  return VrnOutBoundModel(
  vehicleTransactionId:
  _toInt(json['vehicleTransactionId']),
  tenantCode:
  json['tenantCode']?.toString(),
  vrn:
  json['vrn']?.toString(),
  transactionCode:
  json['transactionCode']?.toString(),
  passNo:
  json['passNo']?.toString(),
  tpDateTime:
  json['tpDateTime']?.toString(),
  driverName:
  json['driverName']?.toString(),
  gateInTime:
  json['gateInTime']?.toString(),
  gateOutTime:
  json['gateOutTime']?.toString(),
  productName:
  json['productName']?.toString(),
  productCode:
  json['productCode']?.toString(),
  transporterName:
  json['transporterName']?.toString(),
  doNumber:
  _toInt(json['doNumber']),
  orderNumber:
  _toInt(json['orderNumber']),
  expectedQuantity:
  _toDouble(json['expectedQuantity']),
  tareWeight:
  _toDouble(json['tareWeight']),
  grossWeight:
  _toDouble(json['grossWeight']),
  netWeight:
  _toDouble(json['netWeight']),
  plantTAT:
  json['plantTAT']?.toString(),
  receiverPlantName:
  json['receiverPlantName']?.toString(),
  orderType:
  json['orderType']?.toString(),
  totalNetAmount:
  _toDouble(json['totalNetAmount']),
  totalRecord:
  _toInt(json['totalRecord']),
  totalPages:
  _toInt(json['totalPages']),
  );
  }

  static int? _toInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  return int.tryParse(
  value.toString(),
  );
  }

  static double? _toDouble(dynamic value) {
  if (value == null) return null;

  if (value is double) return value;

  if (value is int) {
  return value.toDouble();
  }

  return double.tryParse(
  value.toString(),
  );
  }
  }
// ===========================================================================
// STATIC JSON
// ===========================================================================
//
// Later remove this and replace _loadData() with your API call.
//
// ===========================================================================

const String _staticJson = '''
[
  {
    "vehicleTransactionId": 415483,
    "tenantCode": "LIMS",
    "vrn": "MH33T6519",
    "transactionCode": "O260871014083",
    "passNo": "ML020202000101323193",
    "tpDateTime": "2026-08-11T15:30:08.7380328",
    "driverName": "BAIGUN MANDAL",
    "dlNo": "JH1720080002436",
    "gateInTime": "2026-08-11T14:56:49.0741366",
    "gateOutTime": "2026-08-11T15:30:23.8335818",
    "productName": "FINES (62% TO 65% FE )",
    "productCode": "1500000039",
    "transporterName": "THRIVENI TRANSPORT AND LOGISTICS PRIVATE LIMITED",
    "bulkDemandNumber": "ML02020200016908",
    "doNumber": 809891738,
    "isMultiVehicle": false,
    "obdNumber": "2020527031",
    "challanNumber": "DC2040184247",
    "grnNumber": null,
    "receiverPlantCode": "2051",
    "senderPlantPlantCode": "2040",
    "invoiceNumber": null,
    "invoiceAckNo": null,
    "ewayBillNo": "202263055841",
    "buyerParty": null,
    "shipToParty": null,
    "city": null,
    "orderNumber": 5800002921,
    "expectedQuantity": 55.0000,
    "tareWeight": 18.30,
    "twTime": "2026-08-11T14:56:51.5649939",
    "grossWeight": 64.44,
    "gwTime": "2026-08-11T15:28:49.1545906",
    "lrDate": null,
    "netWeight": 46.14,
    "productRate": 1021.0000,
    "materialAmount": 47108.94,
    "taxAmount": 0.00,
    "plantTAT": "0:34",
    "incoTerm1": null,
    "incoTerm2": null,
    "receiverPlantName": "Lloyds Metals and Energy Limited IOGU",
    "orderType": "STO",
    "totalNetAmount": 47108.94,
    "totalRecord": 519,
    "totalPages": 0,
    "l1_Destination": "Lloyds Metals and Energy Limited IOGU",
    "invoiceDocNumber": null,
    "poDate": null,
    "invoiceDate": null,
    "salesContractNumber": null,
    "salesContractDate": null,
    "salesContractQuantity": null,
    "lrNo": "2040184247",
    "poNumber": null,
    "pgiNumber": "4901482582",
    "inboundGRN": null
  },
  {
    "vehicleTransactionId": 415468,
    "tenantCode": "LIMS",
    "vrn": "MH33T6577",
    "transactionCode": "O260837014072",
    "passNo": "ML020202000101323192",
    "tpDateTime": "2026-08-11T15:26:29.218138",
    "driverName": "YODHA",
    "dlNo": "MH3420100014820",
    "gateInTime": "2026-08-11T14:45:13.9928136",
    "gateOutTime": "2026-08-11T15:26:39.1966834",
    "productName": "FINES (62% TO 65% FE )",
    "productCode": "1500000039",
    "transporterName": "THRIVENI TRANSPORT AND LOGISTICS PRIVATE LIMITED",
    "bulkDemandNumber": "ML02020200016908",
    "doNumber": 809891738,
    "isMultiVehicle": false,
    "obdNumber": "2020527029",
    "challanNumber": "DC2040184236",
    "grnNumber": null,
    "receiverPlantCode": "2051",
    "senderPlantPlantCode": "2040",
    "invoiceNumber": null,
    "invoiceAckNo": null,
    "ewayBillNo": "282263051210",
    "buyerParty": null,
    "shipToParty": null,
    "city": null,
    "orderNumber": 5800002921,
    "expectedQuantity": 55.0000,
    "tareWeight": 17.42,
    "twTime": "2026-08-11T14:45:16.4303856",
    "grossWeight": 64.42,
    "gwTime": "2026-08-11T15:25:54.9000824",
    "lrDate": null,
    "netWeight": 47.00,
    "productRate": 1021.0000,
    "materialAmount": 47987.00,
    "taxAmount": 0.00,
    "plantTAT": "0:41",
    "incoTerm1": null,
    "incoTerm2": null,
    "receiverPlantName": "Lloyds Metals and Energy Limited IOGU",
    "orderType": "STO",
    "totalNetAmount": 47987.00,
    "totalRecord": 0,
    "totalPages": 0,
    "l1_Destination": "Lloyds Metals and Energy Limited IOGU",
    "invoiceDocNumber": null,
    "poDate": null,
    "invoiceDate": null,
    "salesContractNumber": null,
    "salesContractDate": null,
    "salesContractQuantity": null,
    "lrNo": "2040184236",
    "poNumber": null,
    "pgiNumber": "4901482578",
    "inboundGRN": null
  }
]
''';
List<VrnOutBoundModel> getStaticVrnOutBoundData() {
  final List<dynamic> decoded = jsonDecode(_staticJson) as List<dynamic>;

  return decoded
      .map(
        (json) => VrnOutBoundModel.fromJson(json as Map<String, dynamic>),
  )
      .toList();
}