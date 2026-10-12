import 'dart:convert';

String vehicleTransactionRequestToJson(VehicleTransactionRequestModel data) =>
    json.encode(data.toJson());

class VehicleTransactionRequestModel {
  final int cdoMasterId;
  final int currentPage;
  final int rowSize;
  final String tenantCode;
  final String transactionType;

  VehicleTransactionRequestModel({
    required this.cdoMasterId,
    required this.currentPage,
    required this.rowSize,
    required this.tenantCode,
    required this.transactionType,
  });

  factory VehicleTransactionRequestModel.fromJson(Map<String, dynamic> json) {
    return VehicleTransactionRequestModel(
      cdoMasterId: json['cdoMasterId'] is int
          ? json['cdoMasterId']
          : int.tryParse(json['cdoMasterId']?.toString() ?? '0') ?? 0,
      currentPage: json['CurrentPage'] is int
          ? json['CurrentPage']
          : int.tryParse(json['CurrentPage']?.toString() ?? '1') ?? 1,
      rowSize: json['rowSize'] is int
          ? json['rowSize']
          : int.tryParse(json['rowSize']?.toString() ?? '10') ?? 10,
      tenantCode: json['tenantCode']?.toString() ?? '',
      transactionType: json['TransactionType']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cdoMasterId': cdoMasterId,
      'CurrentPage': currentPage,
      'rowSize': rowSize,
      'tenantCode': tenantCode,
      'TransactionType': transactionType,
    };
  }
}
