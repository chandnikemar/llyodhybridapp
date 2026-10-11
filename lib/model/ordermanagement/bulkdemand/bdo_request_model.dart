class BdoRequestModel {
  final String orderType;
  final String companyCode;
  final String tenantCode;
  final String soldToParty;
  final String senderPlant;
  final String status;
  final String purchaseGroup;
  final String purchaseOrganization;
  final String receiverPlant;
  final String bdoNumber;
  final String transportMode;
  final String type;
  final int currentPage;
  final int rowSize;

  BdoRequestModel({
    this.orderType = '',
    this.companyCode = '',
    required this.tenantCode,
    this.soldToParty = '',
    this.senderPlant = '',
    required this.status,
    this.purchaseGroup = '',
    this.purchaseOrganization = '',
    this.receiverPlant = '',
    this.bdoNumber = '',
    this.transportMode = '',
    this.type = '',
    required this.currentPage,
    this.rowSize = 15,
  });

  Map<String, dynamic> toJson() {
    return {
      'OrderType': orderType,
      'CompanyCode': companyCode,
      'tenantCode': tenantCode,
      'SoldToParty': soldToParty,
      'SenderPlant': senderPlant,
      'Status': status,
      'PurchaseGroup': purchaseGroup,
      'PurchaseOrganization': purchaseOrganization,
      'ReceiverPlant': receiverPlant,
      'bdoNumber': bdoNumber,
      'transportMode': transportMode,
      'type': type,
      'currentPage': currentPage,
      'rowSize': rowSize,
    };
  }
}