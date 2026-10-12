class CurrencyResponseModel {
  final int? currencyId;
  final String? currencyCode;
  final String? description;
  final String? shortName;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  CurrencyResponseModel({
    this.currencyId,
    this.currencyCode,
    this.description,
    this.shortName,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
    this.tenantCode,
  });

  factory CurrencyResponseModel.fromJson(Map<String, dynamic> json) {
    return CurrencyResponseModel(
      currencyId: json['currencyId'],
      currencyCode: json['currencyCode'],
      description: json['description'],
      shortName: json['shortName'],
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
      'currencyId': currencyId,
      'currencyCode': currencyCode,
      'description': description,
      'shortName': shortName,
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