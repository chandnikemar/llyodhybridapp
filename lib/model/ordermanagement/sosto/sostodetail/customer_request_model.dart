class CustomerRequestModel {
  final int? customerId;
  final String? customerName;
  final String? customerCode;
  final String? phoneNo;
  final bool? isActive;

  CustomerRequestModel({
    this.customerId,
    this.customerName,
    this.customerCode,
    this.phoneNo,
    this.isActive,
  });

  factory CustomerRequestModel.fromJson(Map<String, dynamic> json) {
    return CustomerRequestModel(
      customerId: json['CustomerId'],
      customerName: json['CustomerName'],
      customerCode: json['CustomerCode'],
      phoneNo: json['PhoneNo'],
      isActive: json['IsActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerId': customerId,
      'CustomerName': customerName,
      'CustomerCode': customerCode,
      'PhoneNo': phoneNo,
      'IsActive': isActive,
    };
  }
}