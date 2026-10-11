class StoMaster {
  final int stoMasterId;
  final int stoNumber;
  final String stoDate;
  final String orderType;
  final String purchaseOrganization;
  final String purchaseGroup;
  final String purchaseGroupDescription;
  final String companyCode;
  final String companyName;
  final String senderPlant;
  final String senderPlantName;
  final String receiverPlant;
  final String receiverPlantName;
  final String status;
  final bool? isTolerance;
  final int totalRecord;
  final int totalPages;
  final bool isActive;
  final String createdBy;
  final String createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final List<StoDetail> stoDetails;

  StoMaster({
    required this.stoMasterId,
    required this.stoNumber,
    required this.stoDate,
    required this.orderType,
    required this.purchaseOrganization,
    required this.purchaseGroup,
    required this.purchaseGroupDescription,
    required this.companyCode,
    required this.companyName,
    required this.senderPlant,
    required this.senderPlantName,
    required this.receiverPlant,
    required this.receiverPlantName,
    required this.status,
    this.isTolerance,
    required this.totalRecord,
    required this.totalPages,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    required this.stoDetails,
  });

  factory StoMaster.fromJson(Map<String, dynamic> json) {
    return StoMaster(
      stoMasterId: json['stoMasterId'] ?? 0,
      stoNumber: json['stoNumber'] ?? 0,
      stoDate: json['stoDate'] ?? '',
      orderType: json['orderType'] ?? '',
      purchaseOrganization: json['purchaseOrganization'] ?? '',
      purchaseGroup: json['purchaseGroup'] ?? '',
      purchaseGroupDescription: json['purchaseGroupDescription'] ?? '',
      companyCode: json['companyCode'] ?? '',
      companyName: json['companyName'] ?? '',
      senderPlant: json['senderPlant'] ?? '',
      senderPlantName: json['senderPlantName'] ?? '',
      receiverPlant: json['receiverPlant'] ?? '',
      receiverPlantName: json['receiverPlantName'] ?? '',
      status: json['status'] ?? '',
      isTolerance: json['isTolerance'],
      totalRecord: json['totalRecord'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdBy: json['createdBy'] ?? '',
      createdDate: json['createdDate'] ?? '',
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
      stoDetails: (json['stoDetails'] as List<dynamic>?)
          ?.map((item) => StoDetail.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stoMasterId': stoMasterId,
      'stoNumber': stoNumber,
      'stoDate': stoDate,
      'orderType': orderType,
      'purchaseOrganization': purchaseOrganization,
      'purchaseGroup': purchaseGroup,
      'purchaseGroupDescription': purchaseGroupDescription,
      'companyCode': companyCode,
      'companyName': companyName,
      'senderPlant': senderPlant,
      'senderPlantName': senderPlantName,
      'receiverPlant': receiverPlant,
      'receiverPlantName': receiverPlantName,
      'status': status,
      'isTolerance': isTolerance,
      'totalRecord': totalRecord,
      'totalPages': totalPages,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
      'stoDetails': stoDetails.map((item) => item.toJson()).toList(),
    };
  }
}

class StoDetail {
  final int stoDetailId;
  final int stoMasterId;
  final int lineItemNumber;
  final String materialCode;
  final double quantity;
  final String status;
  final double allocatedQuantity;
  final double pendingQuantity;
  final double unitCost;
  final String productUOM;
  final String productName;
  final String productHSNCode;
  final bool productIsBulk;
  final String productCategory;
  final double? toleranceWeight;
  final List<dynamic> cdOs;
  final List<ConditionType> conditionTypes;
  final bool isActive;
  final String createdBy;
  final String createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  StoDetail({
    required this.stoDetailId,
    required this.stoMasterId,
    required this.lineItemNumber,
    required this.materialCode,
    required this.quantity,
    required this.status,
    required this.allocatedQuantity,
    required this.pendingQuantity,
    required this.unitCost,
    required this.productUOM,
    required this.productName,
    required this.productHSNCode,
    required this.productIsBulk,
    required this.productCategory,
    this.toleranceWeight,
    required this.cdOs,
    required this.conditionTypes,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory StoDetail.fromJson(Map<String, dynamic> json) {
    return StoDetail(
      stoDetailId: json['stoDetailId'] ?? 0,
      stoMasterId: json['stoMasterId'] ?? 0,
      lineItemNumber: json['lineItemNumber'] ?? 0,
      materialCode: json['materialCode'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      allocatedQuantity: (json['allocatedQuantity'] as num?)?.toDouble() ?? 0.0,
      pendingQuantity: (json['pendingQuantity'] as num?)?.toDouble() ?? 0.0,
      unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0.0,
      productUOM: json['productUOM'] ?? '',
      productName: json['productName'] ?? '',
      productHSNCode: json['productHSNCode'] ?? '',
      productIsBulk: json['productIsBulk'] ?? false,
      productCategory: json['productCategory'] ?? '',
      toleranceWeight: (json['toleranceWeight'] as num?)?.toDouble(),
      cdOs: json['cdOs'] ?? [],
      conditionTypes: (json['conditionTypes'] as List<dynamic>?)
          ?.map((item) => ConditionType.fromJson(item))
          .toList() ??
          [],
      isActive: json['isActive'] ?? false,
      createdBy: json['createdBy'] ?? '',
      createdDate: json['createdDate'] ?? '',
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stoDetailId': stoDetailId,
      'stoMasterId': stoMasterId,
      'lineItemNumber': lineItemNumber,
      'materialCode': materialCode,
      'quantity': quantity,
      'status': status,
      'allocatedQuantity': allocatedQuantity,
      'pendingQuantity': pendingQuantity,
      'unitCost': unitCost,
      'productUOM': productUOM,
      'productName': productName,
      'productHSNCode': productHSNCode,
      'productIsBulk': productIsBulk,
      'productCategory': productCategory,
      'toleranceWeight': toleranceWeight,
      'cdOs': cdOs,
      'conditionTypes': conditionTypes.map((item) => item.toJson()).toList(),
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
    };
  }
}

class ConditionType {
  final int conditionMDODetailMappingId;
  final int? mdoDetailId;
  final int stoDetailId;
  final int? poLineItemDetailId;
  final String conditionType;
  final double conditionPrice;
  final double conditionAmount;
  final double conditionPercentage;
  final int totalRecord;
  final int totalPages;

  ConditionType({
    required this.conditionMDODetailMappingId,
    this.mdoDetailId,
    required this.stoDetailId,
    this.poLineItemDetailId,
    required this.conditionType,
    required this.conditionPrice,
    required this.conditionAmount,
    required this.conditionPercentage,
    required this.totalRecord,
    required this.totalPages,
  });

  factory ConditionType.fromJson(Map<String, dynamic> json) {
    return ConditionType(
      conditionMDODetailMappingId: json['conditionMDODetailMappingId'] ?? 0,
      mdoDetailId: json['mdoDetailId'],
      stoDetailId: json['stoDetailId'] ?? 0,
      poLineItemDetailId: json['poLineItemDetailId'],
      conditionType: json['conditionType'] ?? '',
      conditionPrice: (json['conditionPrice'] as num?)?.toDouble() ?? 0.0,
      conditionAmount: (json['conditionAmount'] as num?)?.toDouble() ?? 0.0,
      conditionPercentage: (json['conditionPercentage'] as num?)?.toDouble() ?? 0.0,
      totalRecord: json['totalRecord'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conditionMDODetailMappingId': conditionMDODetailMappingId,
      'mdoDetailId': mdoDetailId,
      'stoDetailId': stoDetailId,
      'poLineItemDetailId': poLineItemDetailId,
      'conditionType': conditionType,
      'conditionPrice': conditionPrice,
      'conditionAmount': conditionAmount,
      'conditionPercentage': conditionPercentage,
      'totalRecord': totalRecord,
      'totalPages': totalPages,
    };
  }
}