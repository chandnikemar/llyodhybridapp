class PoMasterResponse {
  final int poMasterId;
  final int poNumber;
  final String poDate;
  final String orderType;
  final String purchaseOrganization;
  final String purchaseGroup;
  final String companyCode;
  final String supplier;
  final String receiverPlant;
  final int totalRecord;
  final int totalPages;
  final String status;
  final String companyName;
  final String purchaseOrganizationName;
  final String purchaseGroupName;
  final String supplierName;
  final String receiverPlantName;
  final String tenantCode;
  final bool isToleranceApplied;
  final List<PoLineItemDetail> poLineItemDetails;

  const PoMasterResponse({
    required this.poMasterId,
    required this.poNumber,
    required this.poDate,
    required this.orderType,
    required this.purchaseOrganization,
    required this.purchaseGroup,
    required this.companyCode,
    required this.supplier,
    required this.receiverPlant,
    required this.totalRecord,
    required this.totalPages,
    required this.status,
    required this.companyName,
    required this.purchaseOrganizationName,
    required this.purchaseGroupName,
    required this.supplierName,
    required this.receiverPlantName,
    required this.tenantCode,
    required this.isToleranceApplied,
    required this.poLineItemDetails,
  });

  factory PoMasterResponse.fromJson(Map<String, dynamic> json) => PoMasterResponse(
        poMasterId: json['poMasterId'] ?? 0,
        poNumber: json['poNumber'] ?? 0,
        poDate: json['poDate'] ?? '',
        orderType: json['orderType'] ?? '',
        purchaseOrganization: json['purchaseOrganization'] ?? '',
        purchaseGroup: json['purchaseGroup'] ?? '',
        companyCode: json['companyCode'] ?? '',
        supplier: json['supplier'] ?? '',
        receiverPlant: json['receiverPlant'] ?? '',
        totalRecord: json['totalRecord'] ?? 0,
        totalPages: json['totalPages'] ?? 0,
        status: json['status'] ?? '',
        companyName: json['companyName'] ?? '',
        purchaseOrganizationName: json['purchaseOrganizationName'] ?? '',
        purchaseGroupName: json['purchaseGroupName'] ?? '',
        supplierName: json['supplierName'] ?? '',
        receiverPlantName: json['receiverPlantName'] ?? '',
        tenantCode: json['tenantCode'] ?? '',
        isToleranceApplied: json['isToleranceApplied'] ?? false,
        poLineItemDetails: (json['poLineItemDetails'] as List<dynamic>? ?? [])
            .whereType<Map>()
            .map((item) => PoLineItemDetail.fromJson(Map<String, dynamic>.from(item)))
            .toList(),
      );
}

class PoLineItemDetail {
  final int poLineItemDetailId;
  final int poMasterId;
  final int lineItemNumber;
  final String materialCode;
  final double quantity;
  final double allocatedQuantity;
  final double pendingQuantity;
  final double receivedQuantity;
  final double unitCost;
  final String deliveryDate;
  final double netPrice;
  final String storageLocation;
  final String materialGroup;
  final String status;
  final String materialDescription;
  final String uom;
  final double? toleranceWeight;
  final List<PoConditionType> conditionTypeMappings;

  const PoLineItemDetail({
    required this.poLineItemDetailId,
    required this.poMasterId,
    required this.lineItemNumber,
    required this.materialCode,
    required this.quantity,
    required this.allocatedQuantity,
    required this.pendingQuantity,
    required this.receivedQuantity,
    required this.unitCost,
    required this.deliveryDate,
    required this.netPrice,
    required this.storageLocation,
    required this.materialGroup,
    required this.status,
    required this.materialDescription,
    required this.uom,
    this.toleranceWeight,
    required this.conditionTypeMappings,
  });

  factory PoLineItemDetail.fromJson(Map<String, dynamic> json) => PoLineItemDetail(
        poLineItemDetailId: json['poLineItemDetailId'] ?? 0,
        poMasterId: json['poMasterId'] ?? 0,
        lineItemNumber: json['lineItemNumber'] ?? 0,
        materialCode: json['materialCode'] ?? '',
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
        allocatedQuantity: (json['allocatedQuantity'] as num?)?.toDouble() ?? 0,
        pendingQuantity: (json['pendingQuantity'] as num?)?.toDouble() ?? 0,
        receivedQuantity: (json['receivedQuantity'] as num?)?.toDouble() ?? 0,
        unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0,
        deliveryDate: json['deliveryDate'] ?? '',
        netPrice: (json['netPrice'] as num?)?.toDouble() ?? 0,
        storageLocation: json['storageLocation'] ?? '',
        materialGroup: json['materialGroup'] ?? '',
        status: json['status'] ?? '',
        materialDescription: json['materialDescription'] ?? '',
        uom: json['uom'] ?? '',
        toleranceWeight: (json['toleranceWeight'] as num?)?.toDouble(),
        conditionTypeMappings:
            (json['conditionTypeMDODetailMapping'] as List<dynamic>? ?? [])
                .whereType<Map>()
                .map((item) => PoConditionType.fromJson(Map<String, dynamic>.from(item)))
                .toList(),
      );
}

class PoConditionType {
  final int conditionMDODetailMappingId;
  final int poLineItemDetailId;
  final String conditionType;
  final double conditionPrice;
  final double conditionAmount;
  final double conditionPercentage;

  const PoConditionType({
    required this.conditionMDODetailMappingId,
    required this.poLineItemDetailId,
    required this.conditionType,
    required this.conditionPrice,
    required this.conditionAmount,
    required this.conditionPercentage,
  });

  factory PoConditionType.fromJson(Map<String, dynamic> json) => PoConditionType(
        conditionMDODetailMappingId: json['conditionMDODetailMappingId'] ?? 0,
        poLineItemDetailId: json['poLineItemDetailId'] ?? 0,
        conditionType: json['conditionType'] ?? '',
        conditionPrice: (json['conditionPrice'] as num?)?.toDouble() ?? 0,
        conditionAmount: (json['conditionAmount'] as num?)?.toDouble() ?? 0,
        conditionPercentage: (json['conditionPercentage'] as num?)?.toDouble() ?? 0,
      );
}
