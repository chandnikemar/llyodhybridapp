class ReportsVtrOutboundRequestModel {
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
  final String? inboundGRN;
  final String? invoiceNumber;
  final String? obdNumber;
  final String? orderNumber;
  final String? orderType;
  final String? passNo;
  final String? pgiNumber;
  final String? productCode;
  final String? productName;
  final String? transactionCode;
  final String? transporterName;
  final String? vrn;

  ReportsVtrOutboundRequestModel({
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
    this.inboundGRN,
    this.invoiceNumber,
    this.obdNumber,
    this.orderNumber,
    this.orderType,
    this.passNo,
    this.pgiNumber,
    this.productCode,
    this.productName,
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
      "GlobalSearch": globalSearch ?? "",
      "bulkDemandNumber": bulkDemandNumber ?? "",
      "challanNumber": challanNumber ?? "",
      "city": city ?? "",
      "doNumber": doNumber ?? 0,
      "ewayBillNo": ewayBillNo ?? "",
      "grnNumber": grnNumber ?? "",
      "inboundGRN": inboundGRN ?? "",
      "invoiceNumber": invoiceNumber ?? "",
      "obdNumber": obdNumber ?? "",
      "orderNumber": orderNumber ?? "",
      "orderType": orderType ?? "",
      "passNo": passNo ?? "",
      "pgiNumber": pgiNumber ?? "",
      "productCode": productCode ?? "",
      "productName": productName ?? "",
      "transactionCode": transactionCode ?? "",
      "transporterName": transporterName ?? "",
      "vrn": vrn ?? "",
    };
  }
}

class ReportsVtrOutboundResponseModel {
  final int? vehicleTransactionId;
  final String? tenantCode;
  final String? vrn;
  final String? transactionCode;
  final String? passNo;
  final String? tpDateTime;
  final String? driverName;
  final String? dlNo;
  final String? gateInTime;
  final String? gateOutTime;
  final String? productName;
  final String? productCode;
  final String? transporterName;
  final String? bulkDemandNumber;
  final int? doNumber;
  final bool? isMultiVehicle;
  final String? obdNumber;
  final String? challanNumber;
  final String? grnNumber;
  final String? receiverPlantCode;
  final String? senderPlantPlantCode;
  final String? invoiceNumber;
  final String? invoiceAckNo;
  final String? ewayBillNo;
  final String? buyerParty;
  final String? shipToParty;
  final String? city;
  final int? orderNumber;
  final double? expectedQuantity;
  final double? tareWeight;
  final String? twTime;
  final double? grossWeight;
  final String? gwTime;
  final String? lrDate;
  final double? netWeight;
  final double? productRate;
  final double? materialAmount;
  final double? taxAmount;
  final String? plantTAT;
  final String? incoTerm1;
  final String? incoTerm2;
  final String? receiverPlantName;
  final String? orderType;
  final double? totalNetAmount;
  final int? totalRecord;
  final int? totalPages;
  final String? l1Destination;
  final String? invoiceDocNumber;
  final String? poDate;
  final String? invoiceDate;
  final String? salesContractNumber;
  final String? salesContractDate;
  final double? salesContractQuantity;
  final String? lrNo;
  final String? poNumber;
  final String? pgiNumber;
  final String? inboundGRN;

  ReportsVtrOutboundResponseModel({
    this.vehicleTransactionId,
    this.tenantCode,
    this.vrn,
    this.transactionCode,
    this.passNo,
    this.tpDateTime,
    this.driverName,
    this.dlNo,
    this.gateInTime,
    this.gateOutTime,
    this.productName,
    this.productCode,
    this.transporterName,
    this.bulkDemandNumber,
    this.doNumber,
    this.isMultiVehicle,
    this.obdNumber,
    this.challanNumber,
    this.grnNumber,
    this.receiverPlantCode,
    this.senderPlantPlantCode,
    this.invoiceNumber,
    this.invoiceAckNo,
    this.ewayBillNo,
    this.buyerParty,
    this.shipToParty,
    this.city,
    this.orderNumber,
    this.expectedQuantity,
    this.tareWeight,
    this.twTime,
    this.grossWeight,
    this.gwTime,
    this.lrDate,
    this.netWeight,
    this.productRate,
    this.materialAmount,
    this.taxAmount,
    this.plantTAT,
    this.incoTerm1,
    this.incoTerm2,
    this.receiverPlantName,
    this.orderType,
    this.totalNetAmount,
    this.totalRecord,
    this.totalPages,
    this.l1Destination,
    this.invoiceDocNumber,
    this.poDate,
    this.invoiceDate,
    this.salesContractNumber,
    this.salesContractDate,
    this.salesContractQuantity,
    this.lrNo,
    this.poNumber,
    this.pgiNumber,
    this.inboundGRN,
  });

  factory ReportsVtrOutboundResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportsVtrOutboundResponseModel(
      vehicleTransactionId: json['vehicleTransactionId'] as int? ?? 0,
      tenantCode: json['tenantCode'] as String? ?? "",
      vrn: json['vrn'] as String? ?? "",
      transactionCode: json['transactionCode'] as String? ?? "",
      passNo: json['passNo'] as String? ?? "",
      tpDateTime: json['tpDateTime'] as String? ?? "",
      driverName: json['driverName'] as String? ?? "",
      dlNo: json['dlNo'] as String? ?? "",
      gateInTime: json['gateInTime'] as String? ?? "",
      gateOutTime: json['gateOutTime'] as String? ?? "",
      productName: json['productName'] as String? ?? "",
      productCode: json['productCode'] as String? ?? "",
      transporterName: json['transporterName'] as String? ?? "",
      bulkDemandNumber: json['bulkDemandNumber'] as String? ?? "",
      doNumber: json['doNumber'] as int? ?? 0,
      isMultiVehicle: json['isMultiVehicle'] as bool? ?? false,
      obdNumber: json['obdNumber'] as String? ?? "",
      challanNumber: json['challanNumber'] as String? ?? "",
      grnNumber: json['grnNumber'] as String? ?? "",
      receiverPlantCode: json['receiverPlantCode'] as String? ?? "",
      senderPlantPlantCode: json['senderPlantPlantCode'] as String? ?? "",
      invoiceNumber: json['invoiceNumber'] as String? ?? "",
      invoiceAckNo: json['invoiceAckNo'] as String? ?? "",
      ewayBillNo: json['ewayBillNo'] as String? ?? "",
      buyerParty: json['buyerParty'] as String? ?? "",
      shipToParty: json['shipToParty'] as String? ?? "",
      city: json['city'] as String? ?? "",
      orderNumber: json['orderNumber'] as int? ?? 0,
      expectedQuantity: (json['expectedQuantity'] as num?)?.toDouble() ?? 0.0,
      tareWeight: (json['tareWeight'] as num?)?.toDouble() ?? 0.0,
      twTime: json['twTime'] as String? ?? "",
      grossWeight: (json['grossWeight'] as num?)?.toDouble() ?? 0.0,
      gwTime: json['gwTime'] as String? ?? "",
      lrDate: json['lrDate'] as String? ?? "",
      netWeight: (json['netWeight'] as num?)?.toDouble() ?? 0.0,
      productRate: (json['productRate'] as num?)?.toDouble() ?? 0.0,
      materialAmount: (json['materialAmount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      plantTAT: json['plantTAT'] as String? ?? "",
      incoTerm1: json['incoTerm1'] as String? ?? "",
      incoTerm2: json['incoTerm2'] as String? ?? "",
      receiverPlantName: json['receiverPlantName'] as String? ?? "",
      orderType: json['orderType'] as String? ?? "",
      totalNetAmount: (json['totalNetAmount'] as num?)?.toDouble() ?? 0.0,
      totalRecord: json['totalRecord'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      l1Destination: json['l1_Destination'] as String? ?? "",
      invoiceDocNumber: json['invoiceDocNumber'] as String? ?? "",
      poDate: json['poDate'] as String? ?? "",
      invoiceDate: json['invoiceDate'] as String? ?? "",
      salesContractNumber: json['salesContractNumber'] as String? ?? "",
      salesContractDate: json['salesContractDate'] as String? ?? "",
      salesContractQuantity: (json['salesContractQuantity'] as num?)?.toDouble() ?? 0.0,
      lrNo: json['lrNo'] as String? ?? "",
      poNumber: json['poNumber'] as String? ?? "",
      pgiNumber: json['pgiNumber'] as String? ?? "",
      inboundGRN: json['inboundGRN'] as String? ?? "",
    );
  }
}