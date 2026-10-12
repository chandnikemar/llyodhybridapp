class IncotermsResponseModel {
  final int? incId;
  final String? code;
  final String? description;
  final int? totalRecord;
  final int? totalPages;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  IncotermsResponseModel({
    this.incId,
    this.code,
    this.description,
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

  factory IncotermsResponseModel.fromJson(Map<String, dynamic> json) {
    return IncotermsResponseModel(
      incId: json['incId'],
      code: json['code'],
      description: json['description'],
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
      'incId': incId,
      'code': code,
      'description': description,
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