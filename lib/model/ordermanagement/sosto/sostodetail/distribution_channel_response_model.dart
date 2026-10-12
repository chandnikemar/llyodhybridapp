class DistributionChannelResponseModel {
  final int? dcId;
  final String? companyCode;
  final String? distributionChannel;
  final String? distributionChannelDescription;
  final int? totalRecord;
  final int? totalPages;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;
  final String? tenantCode;

  DistributionChannelResponseModel({
    this.dcId,
    this.companyCode,
    this.distributionChannel,
    this.distributionChannelDescription,
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

  factory DistributionChannelResponseModel.fromJson(Map<String, dynamic> json) {
    return DistributionChannelResponseModel(
      dcId: json['dcId'],
      companyCode: json['companyCode'],
      distributionChannel: json['distributionChannel'],
      distributionChannelDescription: json['distributionChannelDescription'],
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
      'dcId': dcId,
      'companyCode': companyCode,
      'distributionChannel': distributionChannel,
      'distributionChannelDescription': distributionChannelDescription,
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