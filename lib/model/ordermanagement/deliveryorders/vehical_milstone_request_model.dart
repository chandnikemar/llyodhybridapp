
// String vehicleMilestoneRequestToJson(VehicleMilestoneRequestModel data) =>
//     json.encode(data.toJson());

class VehicleMilestoneRequestModel {
  final String tenantCode;
  final String transactionCode;

  VehicleMilestoneRequestModel({
    required this.tenantCode,
    required this.transactionCode,
  });

  factory VehicleMilestoneRequestModel.fromJson(Map<String, dynamic> json) {
    return VehicleMilestoneRequestModel(
      tenantCode: json['tenantCode']?.toString() ??
          json['TenantCode']?.toString() ??
          '',
      transactionCode: json['transactionCode']?.toString() ??
          json['TransactionCode']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantCode': tenantCode,
      'transactionCode': transactionCode,
    };
  }
}
