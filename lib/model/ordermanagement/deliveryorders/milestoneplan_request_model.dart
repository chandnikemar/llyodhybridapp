
class MilestonePlanRequestModel {
  final String transactionCode;

  MilestonePlanRequestModel({
    required this.transactionCode,
  });

  factory MilestonePlanRequestModel.fromJson(Map<String, dynamic> json) {
    return MilestonePlanRequestModel(
      transactionCode: json['transactionCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionCode': transactionCode,
    };
  }
}
