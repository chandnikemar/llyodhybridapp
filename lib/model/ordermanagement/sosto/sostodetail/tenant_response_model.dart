class TenantResponseModel {
  final int? tenantId;
  final int? tgId;
  final String? tenantName;
  final String? tenantCode;
  final String? plantType;
  final String? addressLine1;
  final String? addressLine2;
  final String? country;
  final String? state;
  final String? stateCode;
  final String? contactNo;
  final String? district;
  final String? city;
  final String? pincode;
  final String? gstNo;
  final String? subscriptionStartDate;
  final String? subscriptionEndDate;
  final String? subscriptionRenewReminderDate;
  final String? plantCode;
  final bool? isUTTenant;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;

  TenantResponseModel({
    this.tenantId,
    this.tgId,
    this.tenantName,
    this.tenantCode,
    this.plantType,
    this.addressLine1,
    this.addressLine2,
    this.country,
    this.state,
    this.stateCode,
    this.contactNo,
    this.district,
    this.city,
    this.pincode,
    this.gstNo,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.subscriptionRenewReminderDate,
    this.plantCode,
    this.isUTTenant,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory TenantResponseModel.fromJson(Map<String, dynamic> json) {
    return TenantResponseModel(
      tenantId: json['tenantId'],
      tgId: json['tgId'],
      tenantName: json['tenantName'],
      tenantCode: json['tenantCode'],
      plantType: json['plantType'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      country: json['country'],
      state: json['state'],
      stateCode: json['stateCode'],
      contactNo: json['contactNo'],
      district: json['district'],
      city: json['city'],
      pincode: json['pincode'],
      gstNo: json['gstNo'],
      subscriptionStartDate: json['subscriptionStartDate'],
      subscriptionEndDate: json['subscriptionEndDate'],
      subscriptionRenewReminderDate: json['subscriptionRenewReminderDate'],
      plantCode: json['plantCode'],
      isUTTenant: json['isUTTenant'],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'tgId': tgId,
      'tenantName': tenantName,
      'tenantCode': tenantCode,
      'plantType': plantType,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'country': country,
      'state': state,
      'stateCode': stateCode,
      'contactNo': contactNo,
      'district': district,
      'city': city,
      'pincode': pincode,
      'gstNo': gstNo,
      'subscriptionStartDate': subscriptionStartDate,
      'subscriptionEndDate': subscriptionEndDate,
      'subscriptionRenewReminderDate': subscriptionRenewReminderDate,
      'plantCode': plantCode,
      'isUTTenant': isUTTenant,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
    };
  }
}