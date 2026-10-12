import 'dart:convert';

List<CdoFilterResponseModel> cdoFilterResponseListFromJson(String str) =>
    List<CdoFilterResponseModel>.from(
      json.decode(str).map(
            (x) => CdoFilterResponseModel.fromJson(x as Map<String, dynamic>),
          ),
    );

String cdoFilterResponseListToJson(List<CdoFilterResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CdoFilterResponseModel {
  final int cdoMasterId;
  final int? mdoDetailId;
  final int? stoDetailId;
  final int? bulkDemandOrderId;
  final String? bdoNumber;
  final int cdoNumber;
  final String materialCode;
  final double quantity;
  final double allocatedQuantity;
  final double pendingAllocatedQuantity;
  final DateTime? actualPickupDate;
  final DateTime? actualDropDate;
  final String status;
  final bool isActive;
  final String? locationName;
  final String? plantCode;
  final String? tenantName;
  final String? tenantCode;
  final String? city;
  final String? stoDestination;
  final String? stoSource;
  final String? stoSourceCode;
  final String? mdoNumber;
  final int? stoNumber;
  final String? locationCode;
  final int transactionCoolingTime;
  final String transactionType;
  final String? customerCode;
  final String? customerName;
  final String materialName;
  final String? customerLocation;
  final DateTime? publishedOn;
  final String? priority;
  final bool isMultiVehicle;
  final double? toleranceLimit;
  final bool printDC;
  final int dcCount;
  final bool printEInvoice;
  final int eiCount;
  final bool printEWayBill;
  final int ewCount;
  final bool printTransportChallan;
  final int tcCount;
  final double distance;
  final double freightAmount;
  final String remarks;
  final bool isEwayBillRequired;
  final int? totalRecord;
  final int? totalPages;
  final String? driverName;
  final double dispatchQuantity;
  final String salesContractNumber;
  final double salesContractQuantity;
  final String customerReference;
  final DateTime? contractValidFromDate;
  final DateTime? contractValidTillDate;
  final String? l1Destination;
  final double doBalanceQty;
  final List<PublishRule> publishRule;
  final List<dynamic> cdoDeliveryRouteSteps;
  final String? createdBy;
  final DateTime? createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;

  CdoFilterResponseModel({
    required this.cdoMasterId,
    this.mdoDetailId,
    this.stoDetailId,
    this.bulkDemandOrderId,
    this.bdoNumber,
    required this.cdoNumber,
    required this.materialCode,
    required this.quantity,
    required this.allocatedQuantity,
    required this.pendingAllocatedQuantity,
    this.actualPickupDate,
    this.actualDropDate,
    required this.status,
    required this.isActive,
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
    required this.transactionCoolingTime,
    required this.transactionType,
    this.customerCode,
    this.customerName,
    required this.materialName,
    this.customerLocation,
    this.publishedOn,
    this.priority,
    required this.isMultiVehicle,
    this.toleranceLimit,
    required this.printDC,
    required this.dcCount,
    required this.printEInvoice,
    required this.eiCount,
    required this.printEWayBill,
    required this.ewCount,
    required this.printTransportChallan,
    required this.tcCount,
    required this.distance,
    required this.freightAmount,
    required this.remarks,
    required this.isEwayBillRequired,
    this.totalRecord,
    this.totalPages,
    this.driverName,
    required this.dispatchQuantity,
    required this.salesContractNumber,
    required this.salesContractQuantity,
    required this.customerReference,
    this.contractValidFromDate,
    this.contractValidTillDate,
    this.l1Destination,
    required this.doBalanceQty,
    required this.publishRule,
    required this.cdoDeliveryRouteSteps,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory CdoFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      CdoFilterResponseModel(
        cdoMasterId: _parseInt(json['cdoMasterId'] ?? json['CDOMasterId']),
        mdoDetailId:
            _parseNullableInt(json['mdoDetailId'] ?? json['MDODetailId']),
        stoDetailId:
            _parseNullableInt(json['stoDetailId'] ?? json['STODetailId']),
        bulkDemandOrderId: _parseNullableInt(
            json['bulkDemandOrderId'] ?? json['BulkDemandOrderId']),
        bdoNumber: _parseNullableString(json['bdoNumber'] ?? json['BDONumber']),
        cdoNumber: _parseInt(json['cdoNumber'] ?? json['CDONumber']),
        materialCode:
            _parseString(json['materialCode'] ?? json['MaterialCode']),
        quantity: _parseDouble(json['quantity'] ?? json['Quantity']),
        allocatedQuantity: _parseDouble(
            json['allocatedQuantity'] ?? json['AllocatedQuantity']),
        pendingAllocatedQuantity: _parseDouble(
            json['pendingAllocatedQuantity'] ??
                json['PendingAllocatedQuantity']),
        actualPickupDate: _parseDateTime(
            json['actualPickupDate'] ?? json['ActualPickupDate']),
        actualDropDate:
            _parseDateTime(json['actualDropDate'] ?? json['ActualDropDate']),
        status: _parseString(json['status'] ?? json['Status']),
        isActive: _parseBool(json['isActive'] ?? json['IsActive']),
        locationName:
            _parseNullableString(json['locationName'] ?? json['LocationName']),
        plantCode: _parseNullableString(json['plantCode'] ?? json['PlantCode']),
        tenantName:
            _parseNullableString(json['tenantName'] ?? json['TenantName']),
        tenantCode:
            _parseNullableString(json['tenantCode'] ?? json['TenantCode']),
        city: _parseNullableString(json['city'] ?? json['City']),
        stoDestination: _parseNullableString(
            json['stoDestination'] ?? json['STODestination']),
        stoSource: _parseNullableString(json['stoSource'] ?? json['STOSource']),
        stoSourceCode: _parseNullableString(
            json['stoSourceCode'] ?? json['STOSourceCode']),
        mdoNumber: _parseNullableString(json['mdoNumber'] ?? json['MDONumber']),
        stoNumber: _parseNullableInt(json['stoNumber'] ?? json['STONumber']),
        locationCode:
            _parseNullableString(json['locationCode'] ?? json['LocationCode']),
        transactionCoolingTime: _parseInt(
            json['transactionCoolingTime'] ?? json['TransactionCoolingTime']),
        transactionType:
            _parseString(json['transactionType'] ?? json['TransactionType']),
        customerCode:
            _parseNullableString(json['customerCode'] ?? json['CustomerCode']),
        customerName:
            _parseNullableString(json['customerName'] ?? json['CustomerName']),
        materialName:
            _parseString(json['materialName'] ?? json['MaterialName']),
        customerLocation: _parseNullableString(
            json['customerLocation'] ?? json['CustomerLocation']),
        publishedOn: _parseDateTime(json['publishedOn'] ?? json['PublishedOn']),
        priority: _parseNullableString(json['priority'] ?? json['Priority']),
        isMultiVehicle:
            _parseBool(json['isMultiVehicle'] ?? json['IsMultiVehicle']),
        toleranceLimit: _parseNullableDouble(
            json['toleranceLimit'] ?? json['ToleranceLimit']),
        printDC: _parseBool(json['printDC'] ?? json['PrintDC']),
        dcCount: _parseInt(json['dcCount'] ?? json['DCCount']),
        printEInvoice:
            _parseBool(json['printEInvoice'] ?? json['PrintEInvoice']),
        eiCount: _parseInt(json['eiCount'] ?? json['EICount']),
        printEWayBill:
            _parseBool(json['printEWayBill'] ?? json['PrintEWayBill']),
        ewCount: _parseInt(json['ewCount'] ?? json['EWCount']),
        printTransportChallan: _parseBool(
            json['printTransportChallan'] ?? json['PrintTransportChallan']),
        tcCount: _parseInt(json['tcCount'] ?? json['TCCount']),
        distance: _parseDouble(json['distance'] ?? json['Distance']),
        freightAmount:
            _parseDouble(json['freightAmount'] ?? json['FreightAmount']),
        remarks: _parseString(json['remarks'] ?? json['Remarks']),
        isEwayBillRequired: _parseBool(
            json['isEwayBillRequired'] ?? json['IsEwayBillRequired']),
        totalRecord:
            _parseNullableInt(json['totalRecord'] ?? json['TotalRecord']),
        totalPages: _parseNullableInt(json['totalPages'] ?? json['TotalPages']),
        driverName:
            _parseNullableString(json['driverName'] ?? json['DriverName']),
        dispatchQuantity:
            _parseDouble(json['dispatchQuantity'] ?? json['DispatchQuantity']),
        salesContractNumber: _parseString(
            json['salesContractNumber'] ?? json['SalesContractNumber']),
        salesContractQuantity: _parseDouble(
            json['salesContractQuantity'] ?? json['SalesContractQuantity']),
        customerReference: _parseString(
            json['customerReference'] ?? json['CustomerReference']),
        contractValidFromDate: _parseDateTime(
            json['contractValidFromDate'] ?? json['ContractValidFromDate']),
        contractValidTillDate: _parseDateTime(
            json['contractValidTillDate'] ?? json['ContractValidTillDate']),
        l1Destination: _parseNullableString(
            json['l1Destination'] ?? json['L1Destination']),
        doBalanceQty:
            _parseDouble(json['doBalanceQty'] ?? json['DoBalanceQty']),
        publishRule: json['publishRule'] != null
            ? List<PublishRule>.from(
                (json['publishRule'] as List<dynamic>).map(
                  (x) => PublishRule.fromJson(x as Map<String, dynamic>),
                ),
              )
            : [],
        cdoDeliveryRouteSteps: json['cdoDeliveryRouteSteps'] != null
            ? List<dynamic>.from(json['cdoDeliveryRouteSteps'] as List<dynamic>)
            : [],
        createdBy: _parseNullableString(json['createdBy'] ?? json['CreatedBy']),
        createdDate: _parseDateTime(json['createdDate'] ?? json['CreatedDate']),
        modifiedBy:
            _parseNullableString(json['modifiedBy'] ?? json['ModifiedBy']),
        modifiedDate:
            _parseDateTime(json['modifiedDate'] ?? json['ModifiedDate']),
      );

  // --- Safe Parsing Helper Methods ---

  static String _parseString(dynamic value) => value?.toString() ?? '';

  static String? _parseNullableString(dynamic value) => value?.toString();

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value == 1;
    return value.toString().toLowerCase() == 'true';
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
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
        'actualPickupDate': actualPickupDate?.toIso8601String(),
        'actualDropDate': actualDropDate?.toIso8601String(),
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
        'publishedOn': publishedOn?.toIso8601String(),
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
        'contractValidFromDate': contractValidFromDate?.toIso8601String(),
        'contractValidTillDate': contractValidTillDate?.toIso8601String(),
        'l1Destination': l1Destination,
        'doBalanceQty': doBalanceQty,
        'publishRule': List<dynamic>.from(publishRule.map((x) => x.toJson())),
        'cdoDeliveryRouteSteps':
            List<dynamic>.from(cdoDeliveryRouteSteps.map((x) => x)),
        'createdBy': createdBy,
        'createdDate': createdDate?.toIso8601String(),
        'modifiedBy': modifiedBy,
        'modifiedDate': modifiedDate?.toIso8601String(),
      };

  String toRawJson() => json.encode(toJson());

  factory CdoFilterResponseModel.fromRawJson(String str) =>
      CdoFilterResponseModel.fromJson(
        json.decode(str) as Map<String, dynamic>,
      );
}

class PublishRule {
  final int publishRuleId;
  final int cdoMasterId;
  final String type;
  final String code;
  final String name;
  final bool isActive;
  final String createdBy;
  final DateTime? createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;

  PublishRule({
    required this.publishRuleId,
    required this.cdoMasterId,
    required this.type,
    required this.code,
    required this.name,
    required this.isActive,
    required this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory PublishRule.fromJson(Map<String, dynamic> json) => PublishRule(
        publishRuleId: CdoFilterResponseModel._parseInt(
            json['publishRuleId'] ?? json['PublishRuleId']),
        cdoMasterId: CdoFilterResponseModel._parseInt(
            json['cdoMasterId'] ?? json['CDOMasterId']),
        type: CdoFilterResponseModel._parseString(json['type'] ?? json['Type']),
        code: CdoFilterResponseModel._parseString(json['code'] ?? json['Code']),
        name: CdoFilterResponseModel._parseString(json['name'] ?? json['Name']),
        isActive: CdoFilterResponseModel._parseBool(
            json['isActive'] ?? json['IsActive']),
        createdBy: CdoFilterResponseModel._parseString(
            json['createdBy'] ?? json['CreatedBy']),
        createdDate: CdoFilterResponseModel._parseDateTime(
            json['createdDate'] ?? json['CreatedDate']),
        modifiedBy: CdoFilterResponseModel._parseNullableString(
            json['modifiedBy'] ?? json['ModifiedBy']),
        modifiedDate: CdoFilterResponseModel._parseDateTime(
            json['modifiedDate'] ?? json['ModifiedDate']),
      );

  Map<String, dynamic> toJson() => {
        'publishRuleId': publishRuleId,
        'cdoMasterId': cdoMasterId,
        'type': type,
        'code': code,
        'name': name,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdDate': createdDate?.toIso8601String(),
        'modifiedBy': modifiedBy,
        'modifiedDate': modifiedDate?.toIso8601String(),
      };
}
