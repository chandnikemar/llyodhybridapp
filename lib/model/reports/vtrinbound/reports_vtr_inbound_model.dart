class ReportsVtrInboundRequestModel {
  final String fromDate;
  final String toDate;
  final String tenantCode;
  final int currentPage;
  final int rowSize;
  final String? globalSearch;
  final String? bulkDemandNumber;
  final String? challanNumber;
  final String? city;
  final int? doNumber;
  final String? ewayBillNo;
  final String? grnNumber;
  final String? invoiceNumber;
  final String? obdNumber;
  final String? orderNumber;
  final String? productCode;
  final String? productName;
  final String? tpNumber;
  final String? transactionCode;
  final String? transporterName;
  final String? vrn;

  ReportsVtrInboundRequestModel({
    required this.fromDate,
    required this.toDate,
    required this.tenantCode,
    this.currentPage = 1,
    this.rowSize = 15,
    this.globalSearch,
    this.bulkDemandNumber,
    this.challanNumber,
    this.city,
    this.doNumber,
    this.ewayBillNo,
    this.grnNumber,
    this.invoiceNumber,
    this.obdNumber,
    this.orderNumber,
    this.productCode,
    this.productName,
    this.tpNumber,
    this.transactionCode,
    this.transporterName,
    this.vrn,
  });

  Map<String, dynamic> toJson() {
    return {
      "FromDate": fromDate,
      "ToDate": toDate,
      "TenantCode": tenantCode,
      "currentPage": currentPage,
      "rowSize": rowSize,
      "GlobalSearch": globalSearch,
      "bulkDemandNumber": bulkDemandNumber,
      "challanNumber": challanNumber,
      "city": city,
      "doNumber": doNumber,
      "ewayBillNo": ewayBillNo,
      "grnNumber": grnNumber,
      "invoiceNumber": invoiceNumber,
      "obdNumber": obdNumber,
      "orderNumber": orderNumber,
      "productCode": productCode,
      "productName": productName,
      "tpNumber": tpNumber,
      "transactionCode": transactionCode,
      "transporterName": transporterName,
      "vrn": vrn,
    };
  }
}

class ReportsVtrInboundResponseModel {
  final int? vehicleTransactionId;
  final String? tenantCode;
  final String? vrn;
  final String? transactionCode;
  final String? tpNumber;
  final String? tpGenerationDate;
  final String? driverName;
  final String? dlNo;
  final String? gateInTime;
  final String? gateOutTime;
  final String? productName;
  final String? productCode;
  final String? transporterName;
  final String? bulkDemandNumber;
  final int? doNumber;
  final String? obdNumber;
  final String? challanNumber;
  final String? challanDate;
  final String? grnNumber;
  final String? receiverPlantCode;
  final String? senderPlantPlantCode;
  final String? ewayBillNo;
  final int? orderNumber;
  final double? expectedQuantity;
  final double? tareWeight;
  final String? twTime;
  final double? grossWeight;
  final String? gwTime;
  final double? netWeight;
  final double? productRate;
  final double? materialAmount;
  final String? plantTAT;
  final int? totalRecord;
  final int? totalPages;
  final String? eWayBillGenerationDateTime;

  ReportsVtrInboundResponseModel({
    this.vehicleTransactionId,
    this.tenantCode,
    this.vrn,
    this.transactionCode,
    this.tpNumber,
    this.tpGenerationDate,
    this.driverName,
    this.dlNo,
    this.gateInTime,
    this.gateOutTime,
    this.productName,
    this.productCode,
    this.transporterName,
    this.bulkDemandNumber,
    this.doNumber,
    this.obdNumber,
    this.challanNumber,
    this.challanDate,
    this.grnNumber,
    this.receiverPlantCode,
    this.senderPlantPlantCode,
    this.ewayBillNo,
    this.orderNumber,
    this.expectedQuantity,
    this.tareWeight,
    this.twTime,
    this.grossWeight,
    this.gwTime,
    this.netWeight,
    this.productRate,
    this.materialAmount,
    this.plantTAT,
    this.totalRecord,
    this.totalPages,
    this.eWayBillGenerationDateTime,
  });

  factory ReportsVtrInboundResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ReportsVtrInboundResponseModel(
      vehicleTransactionId:
      json['vehicleTransactionId'] as int?,

      tenantCode:
      json['tenantCode'] as String?,

      vrn:
      json['vrn'] as String?,

      transactionCode:
      json['transactionCode'] as String?,

      tpNumber:
      json['tpNumber'] as String?,

      tpGenerationDate:
      json['tpGenerationDate'] as String?,

      driverName:
      json['driverName'] as String?,

      dlNo:
      json['dlNo'] as String?,

      gateInTime:
      json['gateInTime'] as String?,

      gateOutTime:
      json['gateOutTime'] as String?,

      productName:
      json['productName'] as String?,

      productCode:
      json['productCode'] as String?,

      transporterName:
      json['transporterName'] as String?,

      bulkDemandNumber:
      json['bulkDemandNumber'] as String?,

      doNumber:
      json['doNumber'] as int?,

      obdNumber:
      json['obdNumber'] as String?,

      challanNumber:
      json['challanNumber'] as String?,

      challanDate:
      json['challanDate'] as String?,

      grnNumber:
      json['grnNumber'] as String?,

      receiverPlantCode:
      json['receiverPlantCode'] as String?,

      senderPlantPlantCode:
      json['senderPlantPlantCode'] as String?,

      ewayBillNo:
      json['ewayBillNo'] as String?,

      orderNumber:
      json['orderNumber'] as int?,

      expectedQuantity:
      (json['expectedQuantity'] as num?)?.toDouble(),

      tareWeight:
      (json['tareWeight'] as num?)?.toDouble(),

      twTime:
      json['twTime'] as String?,

      grossWeight:
      (json['grossWeight'] as num?)?.toDouble(),

      gwTime:
      json['gwTime'] as String?,

      netWeight:
      (json['netWeight'] as num?)?.toDouble(),

      productRate:
      (json['productRate'] as num?)?.toDouble(),

      materialAmount:
      (json['materialAmount'] as num?)?.toDouble(),

      plantTAT:
      json['plantTAT'] as String?,

      totalRecord:
      json['totalRecord'] as int?,

      totalPages:
      json['totalPages'] as int?,

      eWayBillGenerationDateTime:
      json['eWayBillGenerationDateTime'] as String?,
    );
  }
}