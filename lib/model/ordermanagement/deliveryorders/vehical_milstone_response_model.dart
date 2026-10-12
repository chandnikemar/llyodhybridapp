import '../../../utilities/json_parsers.dart';

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
      vehicleTransactionId: asInt(json['vehicleTransactionId']),
      cdoMasterId: asInt(json['cdoMasterId']),
      asnMsterId: asInt(json['asnMsterId']),
      vrn: asString(json['vrn']),
      tenantCode: asString(json['tenantCode']),
      driverCode: asString(json['driverCode']),
      driverName: asString(json['driverName']),
      driverMobileNo: asString(json['driverMobileNo']),
      dlNo: asString(json['dlNo']),
      helperCode: asString(json['helperCode']),
      transporterCode: asString(json['transporterCode']),
      transporterName: asString(json['transporterName']),
      tareWeight: asDouble(json['tareWeight']),
      grossWeight: asDouble(json['grossWeight']),
      netWeight: asDouble(json['netWeight']),
      customerVendorName: asString(json['customerVendorName']),
      customerLocationName: asString(json['customerLocationName']),
      doNumber: asInt(json['doNumber']),
      materialName: asString(json['materialName']),
      lrNo: asString(json['lrNo']),
      transactionCode: asString(json['transactionCode']),
      jeepNumber: asString(json['jeepNumber']),
      transactionType: asString(json['transactionType']),
      vendorCode: asString(json['vendorCode']),
      transactionStartTime: asString(json['transactionStartTime']),
      transactionEndTime: asString(json['transactionEndTime']),
      tpNumber: asString(json['tpNumber']),
      status: asString(json['status']),
      parentVehicleTransactionId: asInt(json['parentVehicleTransactionId']),
      govtSyncStatus: asBool(json['govtSyncStatus']),
      totalRecord: asInt(json['totalRecord']),
      totalPages: asInt(json['totalPages']),
      remark: asString(json['remark']),
      deliveryReceived: asString(json['deliveryReceived']),
      lrDate: asString(json['lrDate']),
      isCancellation: asBool(json['isCancellation']),
      cancellationDate: asString(json['cancellationDate']),
      dcNumber: asString(json['dcNumber']),
      obdNumber: asString(json['obdNumber']),
      grnNumber: asString(json['grnNumber']),
      pgiNo: asString(json['pgiNo']),
      sapInvoiceNo: asString(json['sapInvoiceNo']),
      totalNW: asDouble(json['totalNW']),
      orderType: asString(json['orderType']),
      tpGenerationDate: asString(json['tpGenerationDate']),
      transitPassPDF: asString(json['transitPassPDF']),
      currentTAT: asString(json['currentTAT']),
      vehicleTransactionCDOMapping: asList(json['vehicleTransactionCDOMapping'])
          ?.map((v) => VehicleTransactionCDOMapping.fromJson(v))
          .toList(),
      milestonePlan: asList(json['milestonePlan'])
          ?.map((v) => MilestonePlanV.fromJson(v))
          .toList(),
      productAllocation: asList(json['productAllocation']) ?? [],
      invoiceTransaction: asList(json['invoiceTransaction'])
          ?.map((v) => InvoiceTransaction.fromJson(v))
          .toList(),
      ewayBill: asList(json['ewayBill']) ?? [],
      asnMaster: asList(json['asnMaster']) ?? [],
      isActive: asBool(json['isActive']),
      createdBy: asString(json['createdBy']),
      createdDate: asString(json['createdDate']),
      modifiedBy: asString(json['modifiedBy']),
      modifiedDate: asString(json['modifiedDate']),
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
      vtcdoMappingId: asInt(json['vtcdoMappingId']),
      vehicleTransactionId: asInt(json['vehicleTransactionId']),
      cdoId: asInt(json['cdoId']),
      allocatedWeight: asDouble(json['allocatedWeight']),
      cdo: json['cdo'] is Map<String, dynamic>
          ? Cdo.fromJson(json['cdo'])
          : null,
      actualWeight: asDouble(json['actualWeight']),
      uom: asString(json['uom']),
      documentQuantity: asDouble(json['documentQuantity']),
      isActive: asBool(json['isActive']),
      createdBy: asString(json['createdBy']),
      createdDate: asString(json['createdDate']),
      modifiedBy: asString(json['modifiedBy']),
      modifiedDate: asString(json['modifiedDate']),
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
      cdoMasterId: asInt(json['cdoMasterId']),
      mdoDetailId: asInt(json['mdoDetailId']),
      stoDetailId: asInt(json['stoDetailId']),
      bulkDemandOrderId: asInt(json['bulkDemandOrderId']),
      bdoNumber: asString(json['bdoNumber']),
      cdoNumber: asInt(json['cdoNumber']),
      materialCode: asString(json['materialCode']),
      quantity: asDouble(json['quantity']),
      allocatedQuantity: asDouble(json['allocatedQuantity']),
      pendingAllocatedQuantity: asDouble(json['pendingAllocatedQuantity']),
      actualPickupDate: asString(json['actualPickupDate']),
      actualDropDate: asString(json['actualDropDate']),
      status: asString(json['status']),
      isActive: asBool(json['isActive']),
      locationName: asString(json['locationName']),
      plantCode: asString(json['plantCode']),
      tenantName: asString(json['tenantName']),
      tenantCode: asString(json['tenantCode']),
      city: asString(json['city']),
      stoDestination: asString(json['stoDestination']),
      stoSource: asString(json['stoSource']),
      stoSourceCode: asString(json['stoSourceCode']),
      mdoNumber: asString(json['mdoNumber']),
      stoNumber: asString(json['stoNumber']),
      locationCode: asString(json['locationCode']),
      transactionCoolingTime: asInt(json['transactionCoolingTime']),
      transactionType: asString(json['transactionType']),
      customerCode: asString(json['customerCode']),
      customerName: asString(json['customerName']),
      materialName: asString(json['materialName']),
      uom: asString(json['uom']),
      customerLocation: asString(json['customerLocation']),
      publishedOn: asString(json['publishedOn']),
      priority: asString(json['priority']),
      isMultiVehicle: asBool(json['isMultiVehicle']),
      toleranceLimit: asDouble(json['toleranceLimit']),
      printDC: asBool(json['printDC']),
      dcCount: asInt(json['dcCount']),
      printEInvoice: asBool(json['printEInvoice']),
      eiCount: asInt(json['eiCount']),
      printEWayBill: asBool(json['printEWayBill']),
      ewCount: asInt(json['ewCount']),
      printTransportChallan: asBool(json['printTransportChallan']),
      tcCount: asInt(json['tcCount']),
      distance: asDouble(json['distance']),
      freightAmount: asDouble(json['freightAmount']),
      remarks: asString(json['remarks']),
      isEwayBillRequired: asBool(json['isEwayBillRequired']),
      totalRecord: asInt(json['totalRecord']),
      totalPages: asInt(json['totalPages']),
      driverName: asString(json['driverName']),
      dispatchQuantity: asDouble(json['dispatchQuantity']),
      salesContractNumber: asString(json['salesContractNumber']),
      salesContractQuantity: asString(json['salesContractQuantity']),
      customerReference: asString(json['customerReference']),
      contractValidFromDate: asString(json['contractValidFromDate']),
      contractValidTillDate: asString(json['contractValidTillDate']),
      l1Destination: asString(json['l1Destination']),
      doBalanceQty: asDouble(json['doBalanceQty']),
      publishRule: asList(json['publishRule']) ?? [],
      cdoDeliveryRouteSteps: asList(json['cdoDeliveryRouteSteps']) ?? [],
      createdBy: asString(json['createdBy']),
      createdDate: asString(json['createdDate']),
      modifiedBy: asString(json['modifiedBy']),
      modifiedDate: asString(json['modifiedDate']),
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
      milestonePlanId: asInt(json['milestonePlanId']),
      vehicleTransactionId: asInt(json['vehicleTransactionId']),
      transactionCode: asString(json['transactionCode']),
      milestoneCode: asString(json['milestoneCode']),
      milestoneName: asString(json['milestoneName']),
      locationCode: asString(json['locationCode']),
      status: asString(json['status']),
      sequence: asInt(json['sequence']),
      lane: asString(json['lane']),
      completionTime: asString(json['completionTime']),
      isOptional: asBool(json['isOptional']),
      remark: asString(json['remark']),
      imagePath: asString(json['imagePath']),
      milestoneDetails: asList(json['milestoneDetails'])
          ?.map((v) => MilestoneDetail.fromJson(v))
          .toList(),
      isActive: asBool(json['isActive']),
      createdBy: asString(json['createdBy']),
      createdDate: asString(json['createdDate']),
      modifiedBy: asString(json['modifiedBy']),
      modifiedDate: asString(json['modifiedDate']),
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
      milestoneDetailsId: asInt(json['milestoneDetailsId']),
      milestonePlanId: asInt(json['milestonePlanId']),
      detailKey: asString(json['detailKey']),
      value: asString(json['value']),
      status: asString(json['status']),
      isActive: asBool(json['isActive']),
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
      invoicingId: asInt(json['invoicingId']),
      invoiceNumber: asString(json['invoiceNumber']),
      generationDateTime: asString(json['generationDateTime']),
      acknowledgementNo: asString(json['acknowledgementNo']),
      acknowledgementDateTime: asString(json['acknowledgementDateTime']),
      eWayBillNo: asString(json['eWayBillNo']),
      eWayBillDateTime: asString(json['eWayBillDateTime']),
      irn: asString(json['irn']),
      vehicleTransactionId: asInt(json['vehicleTransactionId']),
      mdoMasterId: asInt(json['mdoMasterId']),
      isActive: asBool(json['isActive']),
      ewayBillExpDate: asString(json['ewayBillExpDate']),
      status: asString(json['status']),
      signedInvoice: asString(json['signedInvoice']),
      signedQRCode: asString(json['signedQRCode']),
      invoiceingJson: asString(json['invoiceingJson']),
      eWayBillJson: asString(json['eWayBillJson']),
      totalNetAmount: asDouble(json['totalNetAmount']),
      totalTaxAmount: asDouble(json['totalTaxAmount']),
      vrn: asString(json['vrn']),
      sapInvoiceNo: asString(json['sapInvoiceNo']),
      soNumber: asString(json['soNumber']),
      cdoNumber: asString(json['cdoNumber']),
      customerName: asString(json['customerName']),
      vehicleTransactionCode: asString(json['vehicleTransactionCode']),
      totalRecord: asInt(json['totalRecord']),
      totalPages: asInt(json['totalPages']),
      cancelledBy: asString(json['cancelledBy']),
      cancelledDateTime: asString(json['cancelledDateTime']),
      invoicePdf: asString(json['invoicePdf']),
      ewayBillPdf: asString(json['ewayBillPdf']),
      ewayBillPath: asString(json['ewayBillPath']),
      invoicePath: asString(json['invoicePath']),
      tenantCode: asString(json['tenantCode']),
      invoiceTransactionAmount: asList(json['invoiceTransactionAmount']) ?? [],
    );
  }
}
