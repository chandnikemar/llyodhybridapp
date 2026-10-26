class CustomerResponseModel {
  final int? customerId;
  final String? customerName;
  final String? customerCode;
  final String? emailId;
  final String? phoneNo;
  final String? address;
  final String? contactPersonName;
  final String? contactPersonEmailId;
  final String? contactPersonMobileNo;
  final String? panNo;
  final int? totalRecord;
  final int? totalPages;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  CustomerResponseModel({
    this.customerId,
    this.customerName,
    this.customerCode,
    this.emailId,
    this.phoneNo,
    this.address,
    this.contactPersonName,
    this.contactPersonEmailId,
    this.contactPersonMobileNo,
    this.panNo,
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

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerCode: json['customerCode'],
      emailId: json['emailId'],
      phoneNo: json['phoneNo'],
      address: json['address'],
      contactPersonName: json['contactPersonName'],
      contactPersonEmailId: json['contactPersonEmailId'],
      contactPersonMobileNo: json['contactPersonMobileNo'],
      panNo: json['panNo'],
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
      'customerId': customerId,
      'customerName': customerName,
      'customerCode': customerCode,
      'emailId': emailId,
      'phoneNo': phoneNo,
      'address': address,
      'contactPersonName': contactPersonName,
      'contactPersonEmailId': contactPersonEmailId,
      'contactPersonMobileNo': contactPersonMobileNo,
      'panNo': panNo,
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