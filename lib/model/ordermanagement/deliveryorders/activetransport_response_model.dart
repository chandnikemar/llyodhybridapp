import 'dart:convert';

List<TransporterResponseModel> transporterResponseListFromJson(String str) =>
    List<TransporterResponseModel>.from(
      json.decode(str).map((x) => TransporterResponseModel.fromJson(x)),
    );

String transporterResponseListToJson(List<TransporterResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransporterResponseModel {
  final int transporterId;
  final String name;
  final String vendorCode;
  final String plantCode;
  final String address;
  final String mobileNo;
  final String telNo;
  final String email;
  final String contactPersonName;
  final String contactPersonNumber;
  final bool isBlackListed;
  final String? panNo;
  final String? gstNo;
  final int totalPages;
  final int totalCount;
  final String transporterType;
  final bool isILMSRegistered;
  final bool isActive;
  final String createdBy;
  final DateTime? createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  TransporterResponseModel({
    required this.transporterId,
    required this.name,
    required this.vendorCode,
    required this.plantCode,
    required this.address,
    required this.mobileNo,
    required this.telNo,
    required this.email,
    required this.contactPersonName,
    required this.contactPersonNumber,
    required this.isBlackListed,
    this.panNo,
    this.gstNo,
    required this.totalPages,
    required this.totalCount,
    required this.transporterType,
    required this.isILMSRegistered,
    required this.isActive,
    required this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
    this.tenantCode,
  });

  factory TransporterResponseModel.fromJson(Map<String, dynamic> json) =>
      TransporterResponseModel(
        transporterId: json['transporterId'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        vendorCode: json['vendorCode'] as String? ?? '',
        plantCode: json['plantCode'] as String? ?? '',
        address: json['address'] as String? ?? '',
        mobileNo: json['mobileNo'] as String? ?? '',
        telNo: json['telNo'] as String? ?? '',
        email: json['email'] as String? ?? '',
        contactPersonName: json['contactPersonName'] as String? ?? '',
        contactPersonNumber: json['contactPersonNumber'] as String? ?? '',
        isBlackListed: json['isBlackListed'] as bool? ?? false,
        panNo: json['panNo'] as String?,
        gstNo: json['gstNo'] as String?,
        totalPages: json['totalPages'] as int? ?? 0,
        totalCount: json['totalCount'] as int? ?? 0,
        transporterType: json['transporterType'] as String? ?? '',
        isILMSRegistered: json['isILMSRegistered'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? false,
        createdBy: json['createdBy'] as String? ?? '',
        createdDate: json['createdDate'] != null
            ? DateTime.tryParse(json['createdDate'])
            : null,
        modifiedBy: json['modifiedBy'] as String?,
        modifiedDate: json['modifiedDate'] != null
            ? DateTime.tryParse(json['modifiedDate'])
            : null,
        tenantGroupCode: json['tenantGroupCode'] as String?,
        tenantCode: json['tenantCode'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'transporterId': transporterId,
        'name': name,
        'vendorCode': vendorCode,
        'plantCode': plantCode,
        'address': address,
        'mobileNo': mobileNo,
        'telNo': telNo,
        'email': email,
        'contactPersonName': contactPersonName,
        'contactPersonNumber': contactPersonNumber,
        'isBlackListed': isBlackListed,
        'panNo': panNo,
        'gstNo': gstNo,
        'totalPages': totalPages,
        'totalCount': totalCount,
        'transporterType': transporterType,
        'isILMSRegistered': isILMSRegistered,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdDate': createdDate?.toIso8601String(),
        'modifiedBy': modifiedBy,
        'modifiedDate': modifiedDate?.toIso8601String(),
        'tenantGroupCode': tenantGroupCode,
        'tenantCode': tenantCode,
      };
}
