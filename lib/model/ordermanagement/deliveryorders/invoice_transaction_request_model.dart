
class InvoiceFilterRequestModel {
  final int cdoMasterId;
  final String status;
  final String tenantCode;
  final int page;
  final int pageSize;

  InvoiceFilterRequestModel({
    this.cdoMasterId = 0,
    this.status = '',
    this.tenantCode = '',
    this.page = 1,
    this.pageSize = 15,
  });

  Map<String, dynamic> toJson() {
    return {
      'cdoMasterId': cdoMasterId,
      'status': status,
      'tenantCode': tenantCode,
      'page': page,
      'pageSize': pageSize,
    };
  }

  factory InvoiceFilterRequestModel.fromJson(Map<String, dynamic> json) {
    return InvoiceFilterRequestModel(
      cdoMasterId: json['cdoMasterId'] ?? 0,
      status: json['status'] ?? '',
      tenantCode: json['tenantCode'] ?? '',
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 15,
    );
  }
}
