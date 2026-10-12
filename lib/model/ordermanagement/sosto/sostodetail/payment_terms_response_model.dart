class PaymentTermsResponseModel {
  final int? paymentTermsId;
  final String? code;
  final String? description;
  final bool? isAdvance;
  final int? withInDays;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  PaymentTermsResponseModel({
    this.paymentTermsId,
    this.code,
    this.description,
    this.isAdvance,
    this.withInDays,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
    this.tenantCode,
  });

  factory PaymentTermsResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentTermsResponseModel(
      paymentTermsId: json['paymentTermsId'],
      code: json['code'],
      description: json['description'],
      isAdvance: json['isAdvance'],
      withInDays: json['withInDays'],
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
      'paymentTermsId': paymentTermsId,
      'code': code,
      'description': description,
      'isAdvance': isAdvance,
      'withInDays': withInDays,
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