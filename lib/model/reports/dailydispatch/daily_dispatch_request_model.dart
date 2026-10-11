class DailyDispatchRequestModel {
  final String tenantCode;
  final int pageNumber;
  final int pageSize;

  final String globalSearch;
  final String vehicleNumber;
  final String vrnNumber;
  final String customerName;
  final String destination;
  final String materialName;
  final String status;

  final String fromDate;
  final String toDate;

  DailyDispatchRequestModel({
    required this.tenantCode,
    this.pageNumber = 1,
    this.pageSize = 20,
    this.globalSearch = '',
    this.vehicleNumber = '',
    this.vrnNumber = '',
    this.customerName = '',
    this.destination = '',
    this.materialName = '',
    this.status = '',
    this.fromDate = '',
    this.toDate = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'tenantCode': tenantCode,
      'pageNumber': pageNumber,
      'pageSize': pageSize,

      'globalSearch': globalSearch,
      'vehicleNumber': vehicleNumber,
      'vrnNumber': vrnNumber,
      'customerName': customerName,
      'destination': destination,
      'materialName': materialName,
      'status': status,

      'fromDate': fromDate,
      'toDate': toDate,
    };
  }
}