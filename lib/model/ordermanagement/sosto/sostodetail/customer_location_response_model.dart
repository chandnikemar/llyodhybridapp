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
    dynamic read(String camel, [List<String> alternates = const []]) {
      final value = json[camel];
      if (value != null) return value;
      for (final key in alternates) {
        final alternate = json[key];
        if (alternate != null) return alternate;
      }
      return null;
    }

    String pascal(String value) => value.isEmpty
        ? value
        : '${value[0].toUpperCase()}${value.substring(1)}';

    dynamic field(String name, [List<String> extraKeys = const []]) =>
        read(name, [pascal(name), ...extraKeys]);

    return CustomerLocationResponseModel(
      customerLocationId: field('customerLocationId'),
      addressLine1: field('addressLine1'),
      city: field('city'),
      state: field('state'),
      stateCode: field('stateCode'),
      pincode: field('pincode', const ['PinCode', 'PinCodeNo']),
      contactNumber: field('contactNumber'),
      locationCode: field('locationCode'),
      locationType: field('locationType'),
      addressLine2: field('addressLine2'),
      country: field('country'),
      district: field('district'),
      spocName: field('spocName', const ['SPOCName']),
      spocContactNumber:
          field('spocContactNumber', const ['SPOCContactNumber']),
      gstNo: field('gstNo', const ['GSTNo', 'GstNo']),
      emailId: field('emailId', const ['EmailID', 'EmailId']),
      customerId: field('customerId'),
      customerName: field('customerName'),
      customerCode: field('customerCode'),
      totalRecord: field('totalRecord'),
      totalPages: field('totalPages'),
      isActive: field('isActive'),
      createdBy: field('createdBy'),
      createdDate: field('createdDate'),
      modifiedBy: field('modifiedBy'),
      modifiedDate: field('modifiedDate'),
      tenantGroupCode: field('tenantGroupCode'),
      tenantCode: field('tenantCode'),
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