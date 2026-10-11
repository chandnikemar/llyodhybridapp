class ConditionTypeResponseModel {
  final int? condtionTypeId;
  final String? conditionType;
  final String? description;
  final String? conditionClass;
  final String? calculationType;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  ConditionTypeResponseModel({
    this.condtionTypeId,
    this.conditionType,
    this.description,
    this.conditionClass,
    this.calculationType,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
    this.tenantCode,
  });

  factory ConditionTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return ConditionTypeResponseModel(
      condtionTypeId: json['condtionTypeId'],
      conditionType: json['conditionType'],
      description: json['description'],
      conditionClass: json['conditionClass'],
      calculationType: json['calculationType'],
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
      'condtionTypeId': condtionTypeId,
      'conditionType': conditionType,
      'description': description,
      'conditionClass': conditionClass,
      'calculationType': calculationType,
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
