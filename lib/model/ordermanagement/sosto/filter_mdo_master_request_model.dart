class FilterMdoMasterRequest {
  final String status;
  final String tenantCode;
  final int currentPage;
  final int rowSize;
  final String filter;
  final int mdoNumber;
  final String? bdoNumber;
  final String? productName;
  final String? division;
  final String? customerReference;
  final String? orderType;
  final String? senderPlantName;
  final String? soldToPartyName;

  FilterMdoMasterRequest({
    required this.status,
    required this.tenantCode,
    required this.currentPage,
    required this.rowSize,
    this.filter = '',
    this.mdoNumber = 0,
    this.bdoNumber,
    this.productName,
    this.division,
    this.customerReference,
    this.orderType,
    this.senderPlantName,
    this.soldToPartyName,
  });

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "tenantCode": tenantCode,
      "currentPage": currentPage,
      "rowSize": rowSize,
      "filter": filter,
      "mdoNumber": mdoNumber,
      "bdoNumber": bdoNumber,
      "productName": productName,
      "division": division,
      "customerReference": customerReference,
      "orderType": orderType,
      "senderPlantName": senderPlantName,
      "soldToPartyName": soldToPartyName,
    };
  }
}