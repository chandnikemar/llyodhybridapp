class TenantGroupResponseModel {
  final int? tgId;
  final String? tgName;
  final String? tgCode;
  final String? addressLine1;
  final String? addressLine2;
  final String? country;
  final String? state;
  final String? stateCode;
  final String? contactNo;
  final String? district;
  final String? city;
  final String? pincode;
  final String? panNo;
  final String? cinNo;
  final String? emailId;
  final String? webSite;
  final String? plantCode;
  final List<dynamic>? tenantMaster;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  TenantGroupResponseModel({
    this.tgId,
    this.tgName,
    this.tgCode,
    this.addressLine1,
    this.addressLine2,
    this.country,
    this.state,
    this.stateCode,
    this.contactNo,
    this.district,
    this.city,
    this.pincode,
    this.panNo,
    this.cinNo,
    this.emailId,
    this.webSite,
    this.plantCode,
    this.tenantMaster,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory TenantGroupResponseModel.fromJson(Map<String, dynamic> json) {
    return TenantGroupResponseModel(
      tgId: json['tgId'],
      tgName: json['tgName'],
      tgCode: json['tgCode'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      country: json['country'],
      state: json['state'],
      stateCode: json['stateCode'],
      contactNo: json['contactNo'],
      district: json['district'],
      city: json['city'],
      pincode: json['pincode'],
      panNo: json['panNo'],
      cinNo: json['cinNo'],
      emailId: json['emailId'],
      webSite: json['webSite'],
      plantCode: json['plantCode'],
      tenantMaster: json['tenantMaster'] != null
          ? List<dynamic>.from(json['tenantMaster'])
          : null,
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tgId': tgId,
      'tgName': tgName,
      'tgCode': tgCode,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'country': country,
      'state': state,
      'stateCode': stateCode,
      'contactNo': contactNo,
      'district': district,
      'city': city,
      'pincode': pincode,
      'panNo': panNo,
      'cinNo': cinNo,
      'emailId': emailId,
      'webSite': webSite,
      'plantCode': plantCode,
      'tenantMaster': tenantMaster,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
    };
  }
}