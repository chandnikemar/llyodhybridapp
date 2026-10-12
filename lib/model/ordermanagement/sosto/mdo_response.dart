class MdoMaster {
  final int? mdoMasterId;
  final int? mdoNumber;
  final String? mdoDate;
  final String? orderType;
  final String? orderValidTillDate;
  final String? companyCode;
  final String? distributionChannel;
  final String? division;
  final String? soldToParty;
  final String? soldToPartyName;
  final String? shipToParty;
  final String? shipToPartyName;
  final String? shippingLocation;
  final String? billingLocation;
  final String? customerReference;
  final String? customerReferenceDate;
  final String? requiredDeliveryStartdate;
  final String? senderPlant;
  final String? senderPlantName;
  final String? currency;
  final double? aggregateDiscount;
  final String? transactionType;
  final String? status;
  final String? paymentTerms;
  final String? inscoTerm1;
  final String? inscoTerm2;
  final String? salesContractNumber;
  final String? contractValidFromDate;
  final String? contractValidTillDate;
  final String? productName;
  final int? totalRecord;
  final int? totalPages;
  final bool? isTolerance;
  final List<MdoDetail>? mdoDetails;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  MdoMaster({
    this.mdoMasterId,
    this.mdoNumber,
    this.mdoDate,
    this.orderType,
    this.orderValidTillDate,
    this.companyCode,
    this.distributionChannel,
    this.division,
    this.soldToParty,
    this.soldToPartyName,
    this.shipToParty,
    this.shipToPartyName,
    this.shippingLocation,
    this.billingLocation,
    this.customerReference,
    this.customerReferenceDate,
    this.requiredDeliveryStartdate,
    this.senderPlant,
    this.senderPlantName,
    this.currency,
    this.aggregateDiscount,
    this.transactionType,
    this.status,
    this.paymentTerms,
    this.inscoTerm1,
    this.inscoTerm2,
    this.salesContractNumber,
    this.contractValidFromDate,
    this.contractValidTillDate,
    this.productName,
    this.totalRecord,
    this.totalPages,
    this.isTolerance,
    this.mdoDetails,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory MdoMaster.fromJson(Map<String, dynamic> json) {
    return MdoMaster(
      mdoMasterId: json['mdoMasterId'],
      mdoNumber: json['mdoNumber'],
      mdoDate: json['mdoDate'],
      orderType: json['orderType'],
      orderValidTillDate: json['orderValidTillDate'],
      companyCode: json['companyCode'],
      distributionChannel: json['distributionChannel'],
      division: json['division'],
      soldToParty: json['soldToParty'],
      soldToPartyName: json['soldToPartyName'],
      shipToParty: json['shipToParty'],
      shipToPartyName: json['shipToPartyName'],
      shippingLocation: json['shippingLocation'],
      billingLocation: json['billingLocation'],
      customerReference: json['customerReference'],
      customerReferenceDate: json['customerReferenceDate'],
      requiredDeliveryStartdate: json['requiredDeliveryStartdate'],
      senderPlant: json['senderPlant'],
      senderPlantName: json['senderPlantName'],
      currency: json['currency'],
      aggregateDiscount: (json['aggregateDiscount'] as num?)?.toDouble(),
      transactionType: json['transactionType'],
      status: json['status'],
      paymentTerms: json['paymentTerms'],
      inscoTerm1: json['inscoTerm1'],
      inscoTerm2: json['inscoTerm2'],
      salesContractNumber: json['salesContractNumber'],
      contractValidFromDate: json['contractValidFromDate'],
      contractValidTillDate: json['contractValidTillDate'],
      productName: json['productName'],
      totalRecord: json['totalRecord'],
      totalPages: json['totalPages'],
      isTolerance: json['isTolerance'],
      mdoDetails: (json['mdoDetails'] as List<dynamic>?)
          ?.map((e) => MdoDetail.fromJson(e))
          .toList(),
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mdoMasterId': mdoMasterId,
      'mdoNumber': mdoNumber,
      'mdoDate': mdoDate,
      'orderType': orderType,
      'orderValidTillDate': orderValidTillDate,
      'companyCode': companyCode,
      'distributionChannel': distributionChannel,
      'division': division,
      'soldToParty': soldToParty,
      'soldToPartyName': soldToPartyName,
      'shipToParty': shipToParty,
      'shipToPartyName': shipToPartyName,
      'shippingLocation': shippingLocation,
      'billingLocation': billingLocation,
      'customerReference': customerReference,
      'customerReferenceDate': customerReferenceDate,
      'requiredDeliveryStartdate': requiredDeliveryStartdate,
      'senderPlant': senderPlant,
      'senderPlantName': senderPlantName,
      'currency': currency,
      'aggregateDiscount': aggregateDiscount,
      'transactionType': transactionType,
      'status': status,
      'paymentTerms': paymentTerms,
      'inscoTerm1': inscoTerm1,
      'inscoTerm2': inscoTerm2,
      'salesContractNumber': salesContractNumber,
      'contractValidFromDate': contractValidFromDate,
      'contractValidTillDate': contractValidTillDate,
      'productName': productName,
      'totalRecord': totalRecord,
      'totalPages': totalPages,
      'isTolerance': isTolerance,
      'mdoDetails': mdoDetails?.map((e) => e.toJson()).toList(),
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
    };
  }
}

class MdoDetail {
  final int? mdoMasterId;
  final int? mdoDetailId;
  final String? materialCode;
  final double? quantity;
  final String? status;
  final double? allocatedQuantity;
  final double? pendingQuantity;
  final double? unitCost;
  final double? discountAmount;
  final double? discountPercentage;
  final int? lineItemNumber;
  final List<ConditionType>? conditionTypes;
  final String? productUOM;
  final String? productName;
  final String? productHSNCode;
  final bool? productIsBulk;
  final String? productCategory;
  final double? salesContractQuantity;
  final double? targetQuantity;
  final double? toleranceWeight;
  final List<dynamic>? mdoDetailTaxTypeMapping;
  final List<CdoMaster>? cdOs;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  MdoDetail({
    this.mdoMasterId,
    this.mdoDetailId,
    this.materialCode,
    this.quantity,
    this.status,
    this.allocatedQuantity,
    this.pendingQuantity,
    this.unitCost,
    this.discountAmount,
    this.discountPercentage,
    this.lineItemNumber,
    this.conditionTypes,
    this.productUOM,
    this.productName,
    this.productHSNCode,
    this.productIsBulk,
    this.productCategory,
    this.salesContractQuantity,
    this.targetQuantity,
    this.toleranceWeight,
    this.mdoDetailTaxTypeMapping,
    this.cdOs,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory MdoDetail.fromJson(Map<String, dynamic> json) {
    return MdoDetail(
      mdoMasterId: json['mdoMasterId'],
      mdoDetailId: json['mdoDetailId'],
      materialCode: json['materialCode'],
      quantity: (json['quantity'] as num?)?.toDouble(),
      status: json['status'],
      allocatedQuantity: (json['allocatedQuantity'] as num?)?.toDouble(),
      pendingQuantity: (json['pendingQuantity'] as num?)?.toDouble(),
      unitCost: (json['unitCost'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      lineItemNumber: json['lineItemNumber'],
      conditionTypes: (json['conditionTypes'] as List<dynamic>?)
          ?.map((e) => ConditionType.fromJson(e))
          .toList(),
      productUOM: json['productUOM'],
      productName: json['productName'],
      productHSNCode: json['productHSNCode'],
      productIsBulk: json['productIsBulk'],
      productCategory: json['productCategory'],
      salesContractQuantity: (json['salesContractQuantity'] as num?)?.toDouble(),
      targetQuantity: (json['targetQuantity'] as num?)?.toDouble(),
      toleranceWeight: (json['toleranceWeight'] as num?)?.toDouble(),
      mdoDetailTaxTypeMapping: json['mdoDetailTaxTypeMapping'],
      cdOs: (json['cdOs'] as List<dynamic>?)
          ?.map((e) => CdoMaster.fromJson(e))
          .toList(),
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mdoMasterId': mdoMasterId,
      'mdoDetailId': mdoDetailId,
      'materialCode': materialCode,
      'quantity': quantity,
      'status': status,
      'allocatedQuantity': allocatedQuantity,
      'pendingQuantity': pendingQuantity,
      'unitCost': unitCost,
      'discountAmount': discountAmount,
      'discountPercentage': discountPercentage,
      'lineItemNumber': lineItemNumber,
      'conditionTypes': conditionTypes?.map((e) => e.toJson()).toList(),
      'productUOM': productUOM,
      'productName': productName,
      'productHSNCode': productHSNCode,
      'productIsBulk': productIsBulk,
      'productCategory': productCategory,
      'salesContractQuantity': salesContractQuantity,
      'targetQuantity': targetQuantity,
      'toleranceWeight': toleranceWeight,
      'mdoDetailTaxTypeMapping': mdoDetailTaxTypeMapping,
      'cdOs': cdOs?.map((e) => e.toJson()).toList(),
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
    };
  }
}

class ConditionType {
  final int? conditionMDODetailMappingId;
  final int? mdoDetailId;
  final int? stoDetailId;
  final int? poLineItemDetailId;
  final String? conditionType;
  final double? conditionPrice;
  final double? conditionAmount;
  final double? conditionPercentage;
  final int? totalRecord;
  final int? totalPages;

  ConditionType({
    this.conditionMDODetailMappingId,
    this.mdoDetailId,
    this.stoDetailId,
    this.poLineItemDetailId,
    this.conditionType,
    this.conditionPrice,
    this.conditionAmount,
    this.conditionPercentage,
    this.totalRecord,
    this.totalPages,
  });

  factory ConditionType.fromJson(Map<String, dynamic> json) {
    return ConditionType(
      conditionMDODetailMappingId: json['conditionMDODetailMappingId'],
      mdoDetailId: json['mdoDetailId'],
      stoDetailId: json['stoDetailId'],
      poLineItemDetailId: json['poLineItemDetailId'],
      conditionType: json['conditionType'],
      conditionPrice: (json['conditionPrice'] as num?)?.toDouble(),
      conditionAmount: (json['conditionAmount'] as num?)?.toDouble(),
      conditionPercentage: (json['conditionPercentage'] as num?)?.toDouble(),
      totalRecord: json['totalRecord'],
      totalPages: json['totalPages'],
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

class CdoMaster {
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
  final double? salesContractQuantity;
  final String? customerReference;
  final String? contractValidFromDate;
  final String? contractValidTillDate;
  final String? l1Destination;
  final double? doBalanceQty;
  final List<PublishRule>? publishRule;
  final List<CdoDeliveryRouteStep>? cdoDeliveryRouteSteps;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  CdoMaster({
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

  factory CdoMaster.fromJson(Map<String, dynamic> json) {
    return CdoMaster(
      cdoMasterId: json['cdoMasterId'],
      mdoDetailId: json['mdoDetailId'],
      stoDetailId: json['stoDetailId'],
      bulkDemandOrderId: json['bulkDemandOrderId'],
      bdoNumber: json['bdoNumber'],
      cdoNumber: json['cdoNumber'],
      materialCode: json['materialCode'],
      quantity: (json['quantity'] as num?)?.toDouble(),
      allocatedQuantity: (json['allocatedQuantity'] as num?)?.toDouble(),
      pendingAllocatedQuantity: (json['pendingAllocatedQuantity'] as num?)?.toDouble(),
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
      salesContractQuantity: (json['salesContractQuantity'] as num?)?.toDouble(),
      customerReference: json['customerReference'],
      contractValidFromDate: json['contractValidFromDate'],
      contractValidTillDate: json['contractValidTillDate'],
      l1Destination: json['l1Destination'],
      doBalanceQty: (json['doBalanceQty'] as num?)?.toDouble(),
      publishRule: (json['publishRule'] as List<dynamic>?)
          ?.map((e) => PublishRule.fromJson(e))
          .toList(),
      cdoDeliveryRouteSteps: (json['cdoDeliveryRouteSteps'] as List<dynamic>?)
          ?.map((e) => CdoDeliveryRouteStep.fromJson(e))
          .toList(),
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cdoMasterId': cdoMasterId,
      'mdoDetailId': mdoDetailId,
      'stoDetailId': stoDetailId,
      'bulkDemandOrderId': bulkDemandOrderId,
      'bdoNumber': bdoNumber,
      'cdoNumber': cdoNumber,
      'materialCode': materialCode,
      'quantity': quantity,
      'allocatedQuantity': allocatedQuantity,
      'pendingAllocatedQuantity': pendingAllocatedQuantity,
      'actualPickupDate': actualPickupDate,
      'actualDropDate': actualDropDate,
      'status': status,
      'isActive': isActive,
      'locationName': locationName,
      'plantCode': plantCode,
      'tenantName': tenantName,
      'tenantCode': tenantCode,
      'city': city,
      'stoDestination': stoDestination,
      'stoSource': stoSource,
      'stoSourceCode': stoSourceCode,
      'mdoNumber': mdoNumber,
      'stoNumber': stoNumber,
      'locationCode': locationCode,
      'transactionCoolingTime': transactionCoolingTime,
      'transactionType': transactionType,
      'customerCode': customerCode,
      'customerName': customerName,
      'materialName': materialName,
      'customerLocation': customerLocation,
      'publishedOn': publishedOn,
      'priority': priority,
      'isMultiVehicle': isMultiVehicle,
      'toleranceLimit': toleranceLimit,
      'printDC': printDC,
      'dcCount': dcCount,
      'printEInvoice': printEInvoice,
      'eiCount': eiCount,
      'printEWayBill': printEWayBill,
      'ewCount': ewCount,
      'printTransportChallan': printTransportChallan,
      'tcCount': tcCount,
      'distance': distance,
      'freightAmount': freightAmount,
      'remarks': remarks,
      'isEwayBillRequired': isEwayBillRequired,
      'totalRecord': totalRecord,
      'totalPages': totalPages,
      'driverName': driverName,
      'dispatchQuantity': dispatchQuantity,
      'salesContractNumber': salesContractNumber,
      'salesContractQuantity': salesContractQuantity,
      'customerReference': customerReference,
      'contractValidFromDate': contractValidFromDate,
      'contractValidTillDate': contractValidTillDate,
      'l1Destination': l1Destination,
      'doBalanceQty': doBalanceQty,
      'publishRule': publishRule?.map((e) => e.toJson()).toList(),
      'cdoDeliveryRouteSteps': cdoDeliveryRouteSteps?.map((e) => e.toJson()).toList(),
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
    };
  }
}

class PublishRule {
  final int? publishRuleId;
  final int? cdoMasterId;
  final String? type;
  final String? code;
  final String? name;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  PublishRule({
    this.publishRuleId,
    this.cdoMasterId,
    this.type,
    this.code,
    this.name,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory PublishRule.fromJson(Map<String, dynamic> json) {
    return PublishRule(
      publishRuleId: json['publishRuleId'],
      cdoMasterId: json['cdoMasterId'],
      type: json['type'],
      code: json['code'],
      name: json['name'],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publishRuleId': publishRuleId,
      'cdoMasterId': cdoMasterId,
      'type': type,
      'code': code,
      'name': name,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
    };
  }
}

class CdoDeliveryRouteStep {
  final int? cdoDeliveryRouteStepId;
  final int? deliveryStepNo;
  final String? destination;
  final int? destinationStateCode;
  final bool? isActive;
  final String? mode;
  final String? status;
  final bool? invoiceGeneration;
  final int? cdoMasterId;

  CdoDeliveryRouteStep({
    this.cdoDeliveryRouteStepId,
    this.deliveryStepNo,
    this.destination,
    this.destinationStateCode,
    this.isActive,
    this.mode,
    this.status,
    this.invoiceGeneration,
    this.cdoMasterId,
  });

  factory CdoDeliveryRouteStep.fromJson(Map<String, dynamic> json) {
    return CdoDeliveryRouteStep(
      cdoDeliveryRouteStepId: json['cdoDeliveryRouteStepId'],
      deliveryStepNo: json['deliveryStepNo'],
      destination: json['destination'],
      destinationStateCode: json['destinationStateCode'],
      isActive: json['isActive'],
      mode: json['mode'],
      status: json['status'],
      invoiceGeneration: json['invoiceGeneration'],
      cdoMasterId: json['cdoMasterId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cdoDeliveryRouteStepId': cdoDeliveryRouteStepId,
      'deliveryStepNo': deliveryStepNo,
      'destination': destination,
      'destinationStateCode': destinationStateCode,
      'isActive': isActive,
      'mode': mode,
      'status': status,
      'invoiceGeneration': invoiceGeneration,
      'cdoMasterId': cdoMasterId,
    };
  }
}