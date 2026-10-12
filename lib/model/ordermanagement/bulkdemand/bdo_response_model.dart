import 'dart:convert';

List<BdoResponseModel> bdoResponseListFromJson(String str) =>
    List<BdoResponseModel>.from(
      json.decode(str).map((x) => BdoResponseModel.fromJson(x)),
    );

String bdoResponseListToJson(List<BdoResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BdoResponseModel {
  final int bulkDemandOrderId;
  final String bdoNumber;
  final String routeCode;
  final String permitPurpose;
  final double royaltyRate;
  final String transportMode;
  final String type;
  final String status;
  final bool isMultiVehicle;
  final double remainingQuantity;
  final double quantity;
  final int mdoMasterId;
  final int stoMasterId;
  final int totalRecord;
  final int totalPages;
  final bool isActive;
  final String createdBy;
  final DateTime? createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;

  BdoResponseModel({
    required this.bulkDemandOrderId,
    required this.bdoNumber,
    required this.routeCode,
    required this.permitPurpose,
    required this.royaltyRate,
    required this.transportMode,
    required this.type,
    required this.status,
    required this.isMultiVehicle,
    required this.remainingQuantity,
    required this.quantity,
    required this.mdoMasterId,
    required this.stoMasterId,
    required this.totalRecord,
    required this.totalPages,
    required this.isActive,
    required this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory BdoResponseModel.fromJson(Map<String, dynamic> json) =>
      BdoResponseModel(
        bulkDemandOrderId: json['bulkDemandOrderId'] as int? ?? 0,
        bdoNumber: json['bdoNumber'] as String? ?? '',
        routeCode: json['routeCode'] as String? ?? '',
        permitPurpose: json['permitPurpose'] as String? ?? '',
        royaltyRate: (json['royaltyRate'] as num?)?.toDouble() ?? 0.0,
        transportMode: json['transportMode'] as String? ?? '',
        type: json['type'] as String? ?? '',
        status: json['status'] as String? ?? '',
        isMultiVehicle: json['isMultiVehicle'] as bool? ?? false,
        remainingQuantity:
        (json['remainingQuantity'] as num?)?.toDouble() ?? 0.0,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
        mdoMasterId: json['mdoMasterId'] as int? ?? 0,
        stoMasterId: json['stoMasterId'] as int? ?? 0,
        totalRecord: json['totalRecord'] as int? ?? 0,
        totalPages: json['totalPages'] as int? ?? 0,
        isActive: json['isActive'] as bool? ?? false,
        createdBy: json['createdBy'] as String? ?? '',
        createdDate: json['createdDate'] != null
            ? DateTime.tryParse(json['createdDate'])
            : null,
        modifiedBy: json['modifiedBy'] as String?,
        modifiedDate: json['modifiedDate'] != null
            ? DateTime.tryParse(json['modifiedDate'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'bulkDemandOrderId': bulkDemandOrderId,
    'bdoNumber': bdoNumber,
    'routeCode': routeCode,
    'permitPurpose': permitPurpose,
    'royaltyRate': royaltyRate,
    'transportMode': transportMode,
    'type': type,
    'status': status,
    'isMultiVehicle': isMultiVehicle,
    'remainingQuantity': remainingQuantity,
    'quantity': quantity,
    'mdoMasterId': mdoMasterId,
    'stoMasterId': stoMasterId,
    'totalRecord': totalRecord,
    'totalPages': totalPages,
    'isActive': isActive,
    'createdBy': createdBy,
    'createdDate': createdDate?.toIso8601String(),
    'modifiedBy': modifiedBy,
    'modifiedDate': modifiedDate?.toIso8601String(),
  };
}