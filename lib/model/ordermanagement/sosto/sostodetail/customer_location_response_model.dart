class CustomerLocationResponseModel {
  final int? customerLocationId;
  final String? addressLine1;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? pincode;
  final String? contactNumber;
  final String? locationCode;
  final String? locationType;
  final String? addressLine2;
  final String? country;
  final String? district;
  final String? spocName;
  final String? spocContactNumber;
  final String? gstNo;
  final String? emailId;
  final int? customerId;
  final String? customerName;
  final String? customerCode;
  final int? totalRecord;
  final int? totalPages;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  CustomerLocationResponseModel({
    this.customerLocationId,
    this.addressLine1,
    this.city,
    this.state,
    this.stateCode,
    this.pincode,
    this.contactNumber,
    this.locationCode,
    this.locationType,
    this.addressLine2,
    this.country,
    this.district,
    this.spocName,
    this.spocContactNumber,
    this.gstNo,
    this.emailId,
    this.customerId,
    this.customerName,
    this.customerCode,
    this.totalRecord,
    this.totalPages,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
    this.tenantCode,
  });

  factory CustomerLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerLocationResponseModel(
      customerLocationId: json['customerLocationId'],
      addressLine1: json['addressLine1'],
      city: json['city'],
      state: json['state'],
      stateCode: json['stateCode'],
      pincode: json['pincode'],
      contactNumber: json['contactNumber'],
      locationCode: json['locationCode'],
      locationType: json['locationType'],
      addressLine2: json['addressLine2'],
      country: json['country'],
      district: json['district'],
      spocName: json['spocName'],
      spocContactNumber: json['spocContactNumber'],
      gstNo: json['gstNo'],
      emailId: json['emailId'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerCode: json['customerCode'],
      totalRecord: json['totalRecord'],
      totalPages: json['totalPages'],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
      tenantGroupCode: json['tenantGroupCode'],
      tenantCode: json['tenantCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerLocationId': customerLocationId,
      'addressLine1': addressLine1,
      'city': city,
      'state': state,
      'stateCode': stateCode,
      'pincode': pincode,
      'contactNumber': contactNumber,
      'locationCode': locationCode,
      'locationType': locationType,
      'addressLine2': addressLine2,
      'country': country,
      'district': district,
      'spocName': spocName,
      'spocContactNumber': spocContactNumber,
      'gstNo': gstNo,
      'emailId': emailId,
      'customerId': customerId,
      'customerName': customerName,
      'customerCode': customerCode,
      'totalRecord': totalRecord,
      'totalPages': totalPages,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
      'tenantGroupCode': tenantGroupCode,
      'tenantCode': tenantCode,
    };
  }
}