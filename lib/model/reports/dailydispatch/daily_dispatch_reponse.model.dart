class DailyDispatchResponseModel {
  final String doNo;
  final String bdoNo;
  final String soNo;
  final String buyerName;
  final String destination;
  final String materialName;
  final double demandQty;
  final int todayTrips;
  final int cummTrips;
  final double todayQuantity;
  final double cummQuantity;
  final double balanceQty;
  final String customerReference;

  DailyDispatchResponseModel({
    required this.doNo,
    required this.bdoNo,
    required this.soNo,
    required this.buyerName,
    required this.destination,
    required this.materialName,
    required this.demandQty,
    required this.todayTrips,
    required this.cummTrips,
    required this.todayQuantity,
    required this.cummQuantity,
    required this.balanceQty,
    required this.customerReference,
  });

  factory DailyDispatchResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DailyDispatchResponseModel(
      doNo: json['doNo']?.toString() ?? '',
      bdoNo: json['bdoNo']?.toString() ?? '',
      soNo: json['soNo']?.toString() ?? '',
      buyerName: json['buyerName']?.toString() ?? '',
      destination: json['destination']?.toString() ?? '',
      materialName: json['materialName']?.toString() ?? '',
      demandQty: (json['demandQty'] as num?)?.toDouble() ?? 0.0,
      todayTrips: (json['todayTrips'] as num?)?.toInt() ?? 0,
      cummTrips: (json['cummTrips'] as num?)?.toInt() ?? 0,
      todayQuantity:
      (json['todayQuantity'] as num?)?.toDouble() ?? 0.0,
      cummQuantity:
      (json['cummQuantity'] as num?)?.toDouble() ?? 0.0,
      balanceQty:
      (json['balanceQty'] as num?)?.toDouble() ?? 0.0,
      customerReference:
      json['customerReference']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doNo': doNo,
      'bdoNo': bdoNo,
      'soNo': soNo,
      'buyerName': buyerName,
      'destination': destination,
      'materialName': materialName,
      'demandQty': demandQty,
      'todayTrips': todayTrips,
      'cummTrips': cummTrips,
      'todayQuantity': todayQuantity,
      'cummQuantity': cummQuantity,
      'balanceQty': balanceQty,
      'customerReference': customerReference,
    };
  }
}