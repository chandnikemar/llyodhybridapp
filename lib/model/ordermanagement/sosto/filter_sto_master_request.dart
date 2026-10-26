import 'dart:convert';

class FilterStoMasterRequest {
  final String companyCode;
  final String soldToParty;
  final String senderPlant;
  final String status;
  final String purchaseOrganization;
  final String receiverPlant;
  final String tenantCode;
  final int currentPage;
  final int rowSize;
  final int? stoNumber;
  final String? bdoNumber;
  final String? orderType;
  final String? senderPlantName;

  FilterStoMasterRequest({
    required this.companyCode,
    required this.soldToParty,
    required this.senderPlant,
    required this.status,
    required this.purchaseOrganization,
    required this.receiverPlant,
    required this.tenantCode,
    required this.currentPage,
    required this.rowSize,
    required this.stoNumber,
    this.bdoNumber,
    this.orderType,
    this.senderPlantName,
  });

  FilterStoMasterRequest copyWith({
    String? companyCode,
    String? soldToParty,
    String? senderPlant,
    String? status,
    String? purchaseOrganization,
    String? receiverPlant,
    String? tenantCode,
    int? currentPage,
    int? rowSize,
    int? stoNumber,
    String? bdoNumber,
    String? orderType,
    String? senderPlantName,
  }) {
    return FilterStoMasterRequest(
      companyCode: companyCode ?? this.companyCode,
      soldToParty: soldToParty ?? this.soldToParty,
      senderPlant: senderPlant ?? this.senderPlant,
      status: status ?? this.status,
      purchaseOrganization: purchaseOrganization ?? this.purchaseOrganization,
      receiverPlant: receiverPlant ?? this.receiverPlant,
      tenantCode: tenantCode ?? this.tenantCode,
      currentPage: currentPage ?? this.currentPage,
      rowSize: rowSize ?? this.rowSize,
      stoNumber: stoNumber ?? this.stoNumber,
      bdoNumber: bdoNumber ?? this.bdoNumber,
      orderType: orderType ?? this.orderType,
      senderPlantName: senderPlantName ?? this.senderPlantName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CompanyCode': companyCode,
      'SoldToParty': soldToParty,
      'SenderPlant': senderPlant,
      'Status': status,
      'PurchaseOrganization': purchaseOrganization,
      'ReceiverPlant': receiverPlant,
      'tenantCode': tenantCode,
      'currentPage': currentPage,
      'rowSize': rowSize,
      'stoNumber': stoNumber,
      'bdoNumber': bdoNumber,
      'orderType': orderType,
      'senderPlantName': senderPlantName,
    };
  }

  factory FilterStoMasterRequest.fromMap(Map<String, dynamic> map) {
    return FilterStoMasterRequest(
      companyCode: map['CompanyCode'] ?? '',
      soldToParty: map['SoldToParty'] ?? '',
      senderPlant: map['SenderPlant'] ?? '',
      status: map['Status'] ?? '',
      purchaseOrganization: map['PurchaseOrganization'] ?? '',
      receiverPlant: map['ReceiverPlant'] ?? '',
      tenantCode: map['tenantCode'] ?? '',
      currentPage: map['currentPage']?.toInt() ?? 0,
      rowSize: map['rowSize']?.toInt() ?? 0,
      stoNumber: map['stoNumber']?.toInt() ?? 0,
      bdoNumber: map['bdoNumber'],
      orderType: map['orderType'],
      senderPlantName: map['senderPlantName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterStoMasterRequest.fromJson(String source) =>
      FilterStoMasterRequest.fromMap(json.decode(source));
}