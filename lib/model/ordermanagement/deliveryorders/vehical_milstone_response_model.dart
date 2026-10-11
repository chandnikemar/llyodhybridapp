
class VehicleMilestoneResponse {
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
  final List<MilestonePlanV>? milestonePlan;
  final List<dynamic>? productAllocation;
  final List<InvoiceTransaction>? invoiceTransaction;
  final List<dynamic>? ewayBill;
  final List<dynamic>? asnMaster;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  VehicleMilestoneResponse({
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

  factory VehicleMilestoneResponse.fromJson(Map<String, dynamic> json) {
    return VehicleMilestoneResponse(
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
      vehicleTransactionCDOMapping:
          (json['vehicleTransactionCDOMapping'] as List?)
              ?.map((v) => VehicleTransactionCDOMapping.fromJson(v))
              .toList(),
      milestonePlan: (json['milestonePlan'] as List?)
          ?.map((v) => MilestonePlanV.fromJson(v))
          .toList(),
      productAllocation: json['productAllocation'] ?? [],
      invoiceTransaction: (json['invoiceTransaction'] as List?)
          ?.map((v) => InvoiceTransaction.fromJson(v))
          .toList(),
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
  final Cdo? cdo;
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
      cdo: json['cdo'] != null ? Cdo.fromJson(json['cdo']) : null,
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

class Cdo {
  final int? cdoMasterId;
  final int? mdoDetailId;
  final int? stoDetailId;
  final int? bulkDemandOrderId;
  final String? bdoNumber;
  final int? cdoNumber;
  final String? materialCode;
  final double? quantity;
  final double? allocatedQuantity;
  final double? pendingAllocatedQuantity;
  final String? actualPickupDate;
  final String? actualDropDate;
  final String? status;
  final bool? isActive;
  final String? locationName;
  final String? plantCode;
  final String? tenantName;
  final String? tenantCode;
  final String? city;
  final String? stoDestination;
  final String? stoSource;
  final String? stoSourceCode;
  final String? mdoNumber;
  final String? stoNumber;
  final String? locationCode;
  final int? transactionCoolingTime;
  final String? transactionType;
  final String? customerCode;
  final String? customerName;
  final String? materialName;
  final String? uom;
  final String? customerLocation;
  final String? publishedOn;
  final String? priority;
  final bool? isMultiVehicle;
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
  final int? totalRecord;
  final int? totalPages;
  final String? driverName;
  final double? dispatchQuantity;
  final String? salesContractNumber;
  final String? salesContractQuantity;
  final String? customerReference;
  final String? contractValidFromDate;
  final String? contractValidTillDate;
  final String? l1Destination;
  final double? doBalanceQty;
  final List<dynamic>? publishRule;
  final List<dynamic>? cdoDeliveryRouteSteps;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  Cdo({
    this.cdoMasterId,
    this.mdoDetailId,
    this.stoDetailId,
    this.bulkDemandOrderId,
    this.bdoNumber,
    this.cdoNumber,
    this.materialCode,
    this.quantity,
    this.allocatedQuantity,
    this.pendingAllocatedQuantity,
    this.actualPickupDate,
    this.actualDropDate,
    this.status,
    this.isActive,
    this.locationName,
    this.plantCode,
    this.tenantName,
    this.tenantCode,
    this.city,
    this.stoDestination,
    this.stoSource,
    this.stoSourceCode,
    this.mdoNumber,
    this.stoNumber,
    this.locationCode,
    this.transactionCoolingTime,
    this.transactionType,
    this.customerCode,
    this.customerName,
    this.materialName,
    this.uom,
    this.customerLocation,
    this.publishedOn,
    this.priority,
    this.isMultiVehicle,
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
    this.totalRecord,
    this.totalPages,
    this.driverName,
    this.dispatchQuantity,
    this.salesContractNumber,
    this.salesContractQuantity,
    this.customerReference,
    this.contractValidFromDate,
    this.contractValidTillDate,
    this.l1Destination,
    this.doBalanceQty,
    this.publishRule,
    this.cdoDeliveryRouteSteps,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory Cdo.fromJson(Map<String, dynamic> json) {
    return Cdo(
      cdoMasterId: json['cdoMasterId'],
      mdoDetailId: json['mdoDetailId'],
      stoDetailId: json['stoDetailId'],
      bulkDemandOrderId: json['bulkDemandOrderId'],
      bdoNumber: json['bdoNumber'],
      cdoNumber: json['cdoNumber'],
      materialCode: json['materialCode'],
      quantity: (json['quantity'] as num?)?.toDouble(),
      allocatedQuantity: (json['allocatedQuantity'] as num?)?.toDouble(),
      pendingAllocatedQuantity:
          (json['pendingAllocatedQuantity'] as num?)?.toDouble(),
      actualPickupDate: json['actualPickupDate'],
      actualDropDate: json['actualDropDate'],
      status: json['status'],
      isActive: json['isActive'],
      locationName: json['locationName'],
      plantCode: json['plantCode'],
      tenantName: json['tenantName'],
      tenantCode: json['tenantCode'],
      city: json['city'],
      stoDestination: json['stoDestination'],
      stoSource: json['stoSource'],
      stoSourceCode: json['stoSourceCode'],
      mdoNumber: json['mdoNumber'],
      stoNumber: json['stoNumber'],
      locationCode: json['locationCode'],
      transactionCoolingTime: json['transactionCoolingTime'],
      transactionType: json['transactionType'],
      customerCode: json['customerCode'],
      customerName: json['customerName'],
      materialName: json['materialName'],
      uom: json['uom'],
      customerLocation: json['customerLocation'],
      publishedOn: json['publishedOn'],
      priority: json['priority'],
      isMultiVehicle: json['isMultiVehicle'],
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
      totalRecord: json['totalRecord'],
      totalPages: json['totalPages'],
      driverName: json['driverName'],
      dispatchQuantity: (json['dispatchQuantity'] as num?)?.toDouble(),
      salesContractNumber: json['salesContractNumber'],
      salesContractQuantity: json['salesContractQuantity'],
      customerReference: json['customerReference'],
      contractValidFromDate: json['contractValidFromDate'],
      contractValidTillDate: json['contractValidTillDate'],
      l1Destination: json['l1Destination'],
      doBalanceQty: (json['doBalanceQty'] as num?)?.toDouble(),
      publishRule: json['publishRule'] ?? [],
      cdoDeliveryRouteSteps: json['cdoDeliveryRouteSteps'] ?? [],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }
}

class MilestonePlanV {
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
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  MilestonePlanV({
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
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory MilestonePlanV.fromJson(Map<String, dynamic> json) {
    return MilestonePlanV(
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
      milestoneDetails: (json['milestoneDetails'] as List?)
          ?.map((v) => MilestoneDetail.fromJson(v))
          .toList(),
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
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
  final String? signedInvoice;
  final String? signedQRCode;
  final String? invoiceingJson;
  final String? eWayBillJson;
  final double? totalNetAmount;
  final double? totalTaxAmount;
  final String? vrn;
  final String? sapInvoiceNo;
  final String? soNumber;
  final String? cdoNumber;
  final String? customerName;
  final String? vehicleTransactionCode;
  final int? totalRecord;
  final int? totalPages;
  final String? cancelledBy;
  final String? cancelledDateTime;
  final String? invoicePdf;
  final String? ewayBillPdf;
  final String? ewayBillPath;
  final String? invoicePath;
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
    this.signedInvoice,
    this.signedQRCode,
    this.invoiceingJson,
    this.eWayBillJson,
    this.totalNetAmount,
    this.totalTaxAmount,
    this.vrn,
    this.sapInvoiceNo,
    this.soNumber,
    this.cdoNumber,
    this.customerName,
    this.vehicleTransactionCode,
    this.totalRecord,
    this.totalPages,
    this.cancelledBy,
    this.cancelledDateTime,
    this.invoicePdf,
    this.ewayBillPdf,
    this.ewayBillPath,
    this.invoicePath,
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
      signedInvoice: json['signedInvoice'],
      signedQRCode: json['signedQRCode'],
      invoiceingJson: json['invoiceingJson'],
      eWayBillJson: json['eWayBillJson'],
      totalNetAmount: (json['totalNetAmount'] as num?)?.toDouble(),
      totalTaxAmount: (json['totalTaxAmount'] as num?)?.toDouble(),
      vrn: json['vrn'],
      sapInvoiceNo: json['sapInvoiceNo'],
      soNumber: json['soNumber'],
      cdoNumber: json['cdoNumber'],
      customerName: json['customerName'],
      vehicleTransactionCode: json['vehicleTransactionCode'],
      totalRecord: json['totalRecord'],
      totalPages: json['totalPages'],
      cancelledBy: json['cancelledBy'],
      cancelledDateTime: json['cancelledDateTime'],
      invoicePdf: json['invoicePdf'],
      ewayBillPdf: json['ewayBillPdf'],
      ewayBillPath: json['ewayBillPath'],
      invoicePath: json['invoicePath'],
      tenantCode: json['tenantCode'],
      invoiceTransactionAmount: json['invoiceTransactionAmount'] ?? [],
    );
  }
}
