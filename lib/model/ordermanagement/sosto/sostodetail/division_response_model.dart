class DivisionResponseModel {
  final int? divId;
  final String? division;
  final String? divisionDescription;
  final int? totalRecord;
  final int? totalPages;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  DivisionResponseModel({
    this.divId,
    this.division,
    this.divisionDescription,
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

  factory DivisionResponseModel.fromJson(Map<String, dynamic> json) {
    return DivisionResponseModel(
      divId: json['divId'],
      division: json['division'],
      divisionDescription: json['divisionDescription'],
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
      'divId': divId,
      'division': division,
      'divisionDescription': divisionDescription,
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