class OrderTypeResponseModel {
  final int? otId;
  final String? documentType;
  final String? description;
  final String? pricingProcedure;
  final int? totalRecord;
  final int? totalPages;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  OrderTypeResponseModel({
    this.otId,
    this.documentType,
    this.description,
    this.pricingProcedure,
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

  factory OrderTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderTypeResponseModel(
      otId: json['otId'],
      documentType: json['documentType'],
      description: json['description'],
      pricingProcedure: json['pricingProcedure'],
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
      'otId': otId,
      'documentType': documentType,
      'description': description,
      'pricingProcedure': pricingProcedure,
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