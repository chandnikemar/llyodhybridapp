import 'dart:convert';

SingleDhModel singleDhModelFromJson(String str) =>
    SingleDhModel.fromJson(json.decode(str));

String singleDhModelToJson(SingleDhModel data) => json.encode(data.toJson());

class SingleDhModel {
  final int? dhId;
  final String? dhType;
  final String? dhCode;
  final String? name;
  final DateTime? doB;
  final String? category;
  final String? address;
  final String? mobileNo;
  final String? email;
  final String? aadharNo;
  final String? dlNo;
  final DateTime? dlValidaty;
  final DateTime? mpSyncDate;
  final String? mpStatus;
  final bool? isBlackListed;
  final String? frStatus;
  final String? imagePath;
  final int? totalRecords;
  final DateTime? inTransitUpto;
  final int? transporterId;
  final String? registeredBy;
  final dynamic transporterMaster;
  final bool? isActive;
  final String? createdBy;
  final DateTime? createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  SingleDhModel({
    this.dhId,
    this.dhType,
    this.dhCode,
    this.name,
    this.doB,
    this.category,
    this.address,
    this.mobileNo,
    this.email,
    this.aadharNo,
    this.dlNo,
    this.dlValidaty,
    this.mpSyncDate,
    this.mpStatus,
    this.isBlackListed,
    this.frStatus,
    this.imagePath,
    this.totalRecords,
    this.inTransitUpto,
    this.transporterId,
    this.registeredBy,
    this.transporterMaster,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
    this.tenantCode,
  });

  factory SingleDhModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic val) =>
        val != null ? int.tryParse(val.toString()) : null;
    String? parseString(dynamic val) => val?.toString();
    bool? parseBool(dynamic val) {
      if (val == null) return null;
      if (val is bool) return val;
      return val.toString().toLowerCase() == 'true';
    }

    DateTime? parseDate(dynamic val) =>
        val != null ? DateTime.tryParse(val.toString()) : null;

    return SingleDhModel(
      dhId: parseInt(json['dhId']),
      dhType: parseString(json['dhType']),
      dhCode: parseString(json['dhCode']),
      name: parseString(json['name']),
      doB: parseDate(json['doB']),
      category: parseString(json['category']),
      address: parseString(json['address']),
      mobileNo: parseString(json['mobileNo']),
      email: parseString(json['email']),
      aadharNo: parseString(json['aadharNo']),
      dlNo: parseString(json['dlNo']),
      dlValidaty: parseDate(json['dlValidaty']),
      mpSyncDate: parseDate(json['mpSyncDate']),
      mpStatus: parseString(json['mpStatus']),
      isBlackListed: parseBool(json['isBlackListed']),
      frStatus: parseString(json['frStatus']),
      imagePath: parseString(json['imagePath']),
      totalRecords: parseInt(json['totalRecords']),
      inTransitUpto: parseDate(json['inTransitUpto']),
      transporterId: parseInt(json['transporterId']),
      registeredBy: parseString(json['registeredBy']),
      transporterMaster: json['transporterMaster'],
      isActive: parseBool(json['isActive']),
      createdBy: parseString(json['createdBy']),
      createdDate: parseDate(json['createdDate']),
      modifiedBy: parseString(json['modifiedBy']),
      modifiedDate: parseDate(json['modifiedDate']),
      tenantGroupCode: parseString(json['tenantGroupCode']),
      tenantCode: parseString(json['tenantCode']),
    );
  }

  Map<String, dynamic> toJson() => {
        'dhId': dhId,
        'dhType': dhType,
        'dhCode': dhCode,
        'name': name,
        'doB': doB?.toIso8601String(),
        'category': category,
        'address': address,
        'mobileNo': mobileNo,
        'email': email,
        'aadharNo': aadharNo,
        'dlNo': dlNo,
        'dlValidaty': dlValidaty?.toIso8601String(),
        'mpSyncDate': mpSyncDate?.toIso8601String(),
        'mpStatus': mpStatus,
        'isBlackListed': isBlackListed,
        'frStatus': frStatus,
        'imagePath': imagePath,
        'totalRecords': totalRecords,
        'inTransitUpto': inTransitUpto?.toIso8601String(),
        'transporterId': transporterId,
        'registeredBy': registeredBy,
        'transporterMaster': transporterMaster,
        'isActive': isActive,
        'createdBy': createdBy,
        'createdDate': createdDate?.toIso8601String(),
        'modifiedBy': modifiedBy,
        'modifiedDate': modifiedDate?.toIso8601String(),
        'tenantGroupCode': tenantGroupCode,
        'tenantCode': tenantCode,
      };
}
