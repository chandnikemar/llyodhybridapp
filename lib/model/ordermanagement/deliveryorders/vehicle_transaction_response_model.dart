class VehicleTransactionResponseModel {
  final int? vehicleTransactionId;
  final int? cdoMasterId;
  final int? asnMsterId;
  final String? vrn;
  final String? tenantCode;
  final String? driverCode;
  final String? driverName;
  final String? driverMobileNo;
  final String? dlNo;
  final String? helperCode;
  final String? transporterCode;
  final String? transporterName;
  final double? tareWeight;
  final double? grossWeight;
  final double? netWeight;
  final String? customerVendorName;
  final String? customerLocationName;
  final int? doNumber;
  final String? materialName;
  final String? lrNo;
  final String? transactionCode;
  final String? jeepNumber;
  final String? transactionType;
  final String? vendorCode;
  final String? transactionStartTime;
  final String? transactionEndTime;
  final String? tpNumber;
  final String? status;
  final int? parentVehicleTransactionId;
  final bool? govtSyncStatus;
  final int? totalRecord;
  final int? totalPages;
  final String? remark;
  final String? deliveryReceived;
  final String? lrDate;
  final bool? isCancellation;
  final String? cancellationDate;
  final String? dcNumber;
  final String? obdNumber;
  final String? grnNumber;
  final String? pgiNo;
  final String? sapInvoiceNo;
  final double? totalNW;
  final String? orderType;
  final String? tpGenerationDate;
  final String? transitPassPDF;
  final String? currentTAT;
  final List<VehicleTransactionCDOMapping>? vehicleTransactionCDOMapping;
  final List<MilestonePlan>? milestonePlan;
  final List<dynamic>? productAllocation;
  final List<InvoiceTransaction>? invoiceTransaction;
  final List<dynamic>? ewayBill;
  final List<dynamic>? asnMaster;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  VehicleTransactionResponseModel({
    this.vehicleTransactionId,
    this.cdoMasterId,
    this.asnMsterId,
    this.vrn,
    this.tenantCode,
    this.driverCode,
    this.driverName,
    this.driverMobileNo,
    this.dlNo,
    this.helperCode,
    this.transporterCode,
    this.transporterName,
    this.tareWeight,
    this.grossWeight,
    this.netWeight,
    this.customerVendorName,
    this.customerLocationName,
    this.doNumber,
    this.materialName,
    this.lrNo,
    this.transactionCode,
    this.jeepNumber,
    this.transactionType,
    this.vendorCode,
    this.transactionStartTime,
    this.transactionEndTime,
    this.tpNumber,
    this.status,
    this.parentVehicleTransactionId,
    this.govtSyncStatus,
    this.totalRecord,
    this.totalPages,
    this.remark,
    this.deliveryReceived,
    this.lrDate,
    this.isCancellation,
    this.cancellationDate,
    this.dcNumber,
    this.obdNumber,
    this.grnNumber,
    this.pgiNo,
    this.sapInvoiceNo,
    this.totalNW,
    this.orderType,
    this.tpGenerationDate,
    this.transitPassPDF,
    this.currentTAT,
    this.vehicleTransactionCDOMapping,
    this.milestonePlan,
    this.productAllocation,
    this.invoiceTransaction,
    this.ewayBill,
    this.asnMaster,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory VehicleTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return VehicleTransactionResponseModel(
      vehicleTransactionId: json['vehicleTransactionId'],
      cdoMasterId: json['cdoMasterId'],
      asnMsterId: json['asnMsterId'],
      vrn: json['vrn'],
      tenantCode: json['tenantCode'],
      driverCode: json['driverCode'],
      driverName: json['driverName'],
      driverMobileNo: json['driverMobileNo'],
      dlNo: json['dlNo'],
      helperCode: json['helperCode'],
      transporterCode: json['transporterCode'],
      transporterName: json['transporterName'],
      tareWeight: (json['tareWeight'] as num?)?.toDouble(),
      grossWeight: (json['grossWeight'] as num?)?.toDouble(),
      netWeight: (json['netWeight'] as num?)?.toDouble(),
      customerVendorName: json['customerVendorName'],
      customerLocationName: json['customerLocationName'],
      doNumber: json['doNumber'],
      materialName: json['materialName'],
      lrNo: json['lrNo'],
      transactionCode: json['transactionCode'],
      jeepNumber: json['jeepNumber'],
      transactionType: json['transactionType'],
      vendorCode: json['vendorCode'],
      transactionStartTime: json['transactionStartTime'],
      transactionEndTime: json['transactionEndTime'],
      tpNumber: json['tpNumber'],
      status: json['status'],
      parentVehicleTransactionId: json['parentVehicleTransactionId'],
      govtSyncStatus: json['govtSyncStatus'],
      totalRecord: json['totalRecord'],
      totalPages: json['totalPages'],
      remark: json['remark'],
      deliveryReceived: json['deliveryReceived'],
      lrDate: json['lrDate'],
      isCancellation: json['isCancellation'],
      cancellationDate: json['cancellationDate'],
      dcNumber: json['dcNumber'],
      obdNumber: json['obdNumber'],
      grnNumber: json['grnNumber'],
      pgiNo: json['pgiNo'],
      sapInvoiceNo: json['sapInvoiceNo'],
      totalNW: (json['totalNW'] as num?)?.toDouble(),
      orderType: json['orderType'],
      tpGenerationDate: json['tpGenerationDate'],
      transitPassPDF: json['transitPassPDF'],
      currentTAT: json['currentTAT'],
      vehicleTransactionCDOMapping: json['vehicleTransactionCDOMapping'] != null
          ? (json['vehicleTransactionCDOMapping'] as List)
              .map((v) => VehicleTransactionCDOMapping.fromJson(v))
              .toList()
          : null,
      milestonePlan: json['milestonePlan'] != null
          ? (json['milestonePlan'] as List)
              .map((v) => MilestonePlan.fromJson(v))
              .toList()
          : null,
      productAllocation: json['productAllocation'] ?? [],
      invoiceTransaction: json['invoiceTransaction'] != null
          ? (json['invoiceTransaction'] as List)
              .map((v) => InvoiceTransaction.fromJson(v))
              .toList()
          : null,
      ewayBill: json['ewayBill'] ?? [],
      asnMaster: json['asnMaster'] ?? [],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }
}

class VehicleTransactionCDOMapping {
  final int? vtcdoMappingId;
  final int? vehicleTransactionId;
  final int? cdoId;
  final double? allocatedWeight;
  final CDOModel? cdo;
  final double? actualWeight;
  final String? uom;
  final double? documentQuantity;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  VehicleTransactionCDOMapping({
    this.vtcdoMappingId,
    this.vehicleTransactionId,
    this.cdoId,
    this.allocatedWeight,
    this.cdo,
    this.actualWeight,
    this.uom,
    this.documentQuantity,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory VehicleTransactionCDOMapping.fromJson(Map<String, dynamic> json) {
    return VehicleTransactionCDOMapping(
      vtcdoMappingId: json['vtcdoMappingId'],
      vehicleTransactionId: json['vehicleTransactionId'],
      cdoId: json['cdoId'],
      allocatedWeight: (json['allocatedWeight'] as num?)?.toDouble(),
      cdo: json['cdo'] != null ? CDOModel.fromJson(json['cdo']) : null,
      actualWeight: (json['actualWeight'] as num?)?.toDouble(),
      uom: json['uom'],
      documentQuantity: (json['documentQuantity'] as num?)?.toDouble(),
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }
}

class CDOModel {
  final int? cdoMasterId;
  final int? mdoDetailId;
  final int? cdoNumber;
  final String? materialCode;
  final double? quantity;
  final double? allocatedQuantity;
  final double? pendingAllocatedQuantity;
  final String? status;
  final bool? isActive;
  final String? locationName;
  final String? tenantCode;
  final String? locationCode;
  final String? transactionType;
  final String? publishedOn;
  final String? priority;
  final double? toleranceLimit;
  final bool? printDC;
  final int? dcCount;
  final bool? printEInvoice;
  final int? eiCount;
  final bool? printEWayBill;
  final int? ewCount;
  final bool? printTransportChallan;
  final int? tcCount;
  final double? distance;
  final double? freightAmount;
  final String? remarks;
  final bool? isEwayBillRequired;
  final double? dispatchQuantity;
  final double? doBalanceQty;
  final List<dynamic>? publishRule;
  final List<dynamic>? cdoDeliveryRouteSteps;
  final String? createdBy;
  final String? createdDate;

  CDOModel({
    this.cdoMasterId,
    this.mdoDetailId,
    this.cdoNumber,
    this.materialCode,
    this.quantity,
    this.allocatedQuantity,
    this.pendingAllocatedQuantity,
    this.status,
    this.isActive,
    this.locationName,
    this.tenantCode,
    this.locationCode,
    this.transactionType,
    this.publishedOn,
    this.priority,
    this.toleranceLimit,
    this.printDC,
    this.dcCount,
    this.printEInvoice,
    this.eiCount,
    this.printEWayBill,
    this.ewCount,
    this.printTransportChallan,
    this.tcCount,
    this.distance,
    this.freightAmount,
    this.remarks,
    this.isEwayBillRequired,
    this.dispatchQuantity,
    this.doBalanceQty,
    this.publishRule,
    this.cdoDeliveryRouteSteps,
    this.createdBy,
    this.createdDate,
  });

  factory CDOModel.fromJson(Map<String, dynamic> json) {
    return CDOModel(
      cdoMasterId: json['cdoMasterId'],
      mdoDetailId: json['mdoDetailId'],
      cdoNumber: json['cdoNumber'],
      materialCode: json['materialCode'],
      quantity: (json['quantity'] as num?)?.toDouble(),
      allocatedQuantity: (json['allocatedQuantity'] as num?)?.toDouble(),
      pendingAllocatedQuantity:
          (json['pendingAllocatedQuantity'] as num?)?.toDouble(),
      status: json['status'],
      isActive: json['isActive'],
      locationName: json['locationName'],
      tenantCode: json['tenantCode'],
      locationCode: json['locationCode'],
      transactionType: json['transactionType'],
      publishedOn: json['publishedOn'],
      priority: json['priority'],
      toleranceLimit: (json['toleranceLimit'] as num?)?.toDouble(),
      printDC: json['printDC'],
      dcCount: json['dcCount'],
      printEInvoice: json['printEInvoice'],
      eiCount: json['eiCount'],
      printEWayBill: json['printEWayBill'],
      ewCount: json['ewCount'],
      printTransportChallan: json['printTransportChallan'],
      tcCount: json['tcCount'],
      distance: (json['distance'] as num?)?.toDouble(),
      freightAmount: (json['freightAmount'] as num?)?.toDouble(),
      remarks: json['remarks'],
      isEwayBillRequired: json['isEwayBillRequired'],
      dispatchQuantity: (json['dispatchQuantity'] as num?)?.toDouble(),
      doBalanceQty: (json['doBalanceQty'] as num?)?.toDouble(),
      publishRule: json['publishRule'] ?? [],
      cdoDeliveryRouteSteps: json['cdoDeliveryRouteSteps'] ?? [],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
    );
  }
}

class MilestonePlan {
  final int? milestonePlanId;
  final int? vehicleTransactionId;
  final String? transactionCode;
  final String? milestoneCode;
  final String? milestoneName;
  final String? locationCode;
  final String? status;
  final int? sequence;
  final String? lane;
  final String? completionTime;
  final bool? isOptional;
  final String? remark;
  final String? imagePath;
  final List<MilestoneDetail>? milestoneDetails;
  final bool? isActive;

  MilestonePlan({
    this.milestonePlanId,
    this.vehicleTransactionId,
    this.transactionCode,
    this.milestoneCode,
    this.milestoneName,
    this.locationCode,
    this.status,
    this.sequence,
    this.lane,
    this.completionTime,
    this.isOptional,
    this.remark,
    this.imagePath,
    this.milestoneDetails,
    this.isActive,
  });

  factory MilestonePlan.fromJson(Map<String, dynamic> json) {
    return MilestonePlan(
      milestonePlanId: json['milestonePlanId'],
      vehicleTransactionId: json['vehicleTransactionId'],
      transactionCode: json['transactionCode'],
      milestoneCode: json['milestoneCode'],
      milestoneName: json['milestoneName'],
      locationCode: json['locationCode'],
      status: json['status'],
      sequence: json['sequence'],
      lane: json['lane'],
      completionTime: json['completionTime'],
      isOptional: json['isOptional'],
      remark: json['remark'],
      imagePath: json['imagePath'],
      milestoneDetails: json['milestoneDetails'] != null
          ? (json['milestoneDetails'] as List)
              .map((v) => MilestoneDetail.fromJson(v))
              .toList()
          : [],
      isActive: json['isActive'],
    );
  }
}

class MilestoneDetail {
  final int? milestoneDetailsId;
  final int? milestonePlanId;
  final String? detailKey;
  final String? value;
  final String? status;
  final bool? isActive;

  MilestoneDetail({
    this.milestoneDetailsId,
    this.milestonePlanId,
    this.detailKey,
    this.value,
    this.status,
    this.isActive,
  });

  factory MilestoneDetail.fromJson(Map<String, dynamic> json) {
    return MilestoneDetail(
      milestoneDetailsId: json['milestoneDetailsId'],
      milestonePlanId: json['milestonePlanId'],
      detailKey: json['detailKey'],
      value: json['value'],
      status: json['status'],
      isActive: json['isActive'],
    );
  }
}

class InvoiceTransaction {
  final int? invoicingId;
  final String? invoiceNumber;
  final String? generationDateTime;
  final String? acknowledgementNo;
  final String? acknowledgementDateTime;
  final String? eWayBillNo;
  final String? eWayBillDateTime;
  final String? irn;
  final int? vehicleTransactionId;
  final int? mdoMasterId;
  final bool? isActive;
  final String? ewayBillExpDate;
  final String? status;
  final double? totalNetAmount;
  final double? totalTaxAmount;
  final String? vrn;
  final String? cdoNumber;
  final String? customerName;
  final String? vehicleTransactionCode;
  final String? tenantCode;
  final List<dynamic>? invoiceTransactionAmount;

  InvoiceTransaction({
    this.invoicingId,
    this.invoiceNumber,
    this.generationDateTime,
    this.acknowledgementNo,
    this.acknowledgementDateTime,
    this.eWayBillNo,
    this.eWayBillDateTime,
    this.irn,
    this.vehicleTransactionId,
    this.mdoMasterId,
    this.isActive,
    this.ewayBillExpDate,
    this.status,
    this.totalNetAmount,
    this.totalTaxAmount,
    this.vrn,
    this.cdoNumber,
    this.customerName,
    this.vehicleTransactionCode,
    this.tenantCode,
    this.invoiceTransactionAmount,
  });

  factory InvoiceTransaction.fromJson(Map<String, dynamic> json) {
    return InvoiceTransaction(
      invoicingId: json['invoicingId'],
      invoiceNumber: json['invoiceNumber'],
      generationDateTime: json['generationDateTime'],
      acknowledgementNo: json['acknowledgementNo'],
      acknowledgementDateTime: json['acknowledgementDateTime'],
      eWayBillNo: json['eWayBillNo'],
      eWayBillDateTime: json['eWayBillDateTime'],
      irn: json['irn'],
      vehicleTransactionId: json['vehicleTransactionId'],
      mdoMasterId: json['mdoMasterId'],
      isActive: json['isActive'],
      ewayBillExpDate: json['ewayBillExpDate'],
      status: json['status'],
      totalNetAmount: (json['totalNetAmount'] as num?)?.toDouble(),
      totalTaxAmount: (json['totalTaxAmount'] as num?)?.toDouble(),
      vrn: json['vrn'],
      cdoNumber: json['cdoNumber'],
      customerName: json['customerName'],
      vehicleTransactionCode: json['vehicleTransactionCode'],
      tenantCode: json['tenantCode'],
      invoiceTransactionAmount: json['invoiceTransactionAmount'] ?? [],
    );
  }
}
