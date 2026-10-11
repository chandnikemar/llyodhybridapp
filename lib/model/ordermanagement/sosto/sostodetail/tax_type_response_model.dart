class TaxTypeResponseModel {
  final int? taxTypeId;
  final String? code;
  final String? description;
  final String? taxType;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  TaxTypeResponseModel({
    this.taxTypeId,
    this.code,
    this.description,
    this.taxType,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
    this.tenantCode,
  });

  factory TaxTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return TaxTypeResponseModel(
      taxTypeId: json['taxTypeId'],
      code: json['code'],
      description: json['description'],
      taxType: json['taxType'],
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
      'taxTypeId': taxTypeId,
      'code': code,
      'description': description,
      'taxType': taxType,
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