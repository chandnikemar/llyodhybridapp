class CdoFilterRequestModel {
  final int cdoId;
  final String transactionType;
  final String tenantCode;
  final String? customerName;
  final String? materialName;
  final String? bdoNumber;
  final String? cdoNumber;
  final String? globalSearch;
  final String? mdoNumber;
  final String? stoNumber;
  final String? orderType;
  final bool? isActive;
  final String? status;

  final int currentPage;
  final int rowSize;
  final bool? isMultiVehicle;

  CdoFilterRequestModel({
    this.cdoId = 0,
    this.transactionType = '',
    required this.tenantCode,
    this.customerName,
    this.materialName,
    this.bdoNumber,
    this.cdoNumber,
    this.globalSearch,
    this.mdoNumber,
    this.stoNumber,
    this.orderType,
    this.isActive,
    this.status,
    required this.currentPage,
    this.rowSize = 15,
    this.isMultiVehicle,
  });

  Map<String, dynamic> toJson() {
    return {
      'CDOId': cdoId,
      'TransactionType': transactionType,
      'tenantCode': tenantCode,
      'customerName': customerName,
      'materialName': materialName,
      'bdoNumber': bdoNumber,
      'cdoNumber': cdoNumber,
      'GlobalSearch': globalSearch,
      'mdoNumber': mdoNumber,
      'stoNumber': stoNumber,
      'orderType': orderType,
      'isActive': isActive,
      'status': status,
      'currentPage': currentPage,
      'rowSize': rowSize,
      'isMultiVehicle': isMultiVehicle,
    };
  }
}
