class LocationResponseModel {
  final int? locationId;
  final String? tenantCode;
  final String? locationName;
  final String? locationCode;
  final String? parentLocationCode;
  final String? locationType;
  final String? displayName;
  final int? maxQueueSize;
  final int? minQueueSize;
  final int? sequence;
  final String? detectableBy;
  final String? govtLocationName;
  final int? totalRowCount;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;

  LocationResponseModel({
    this.locationId,
    this.tenantCode,
    this.locationName,
    this.locationCode,
    this.parentLocationCode,
    this.locationType,
    this.displayName,
    this.maxQueueSize,
    this.minQueueSize,
    this.sequence,
    this.detectableBy,
    this.govtLocationName,
    this.totalRowCount,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
  });

  factory LocationResponseModel.fromJson(Map<String, dynamic> json) {
    return LocationResponseModel(
      locationId: json['locationId'],
      tenantCode: json['tenantCode'],
      locationName: json['locationName'],
      locationCode: json['locationCode'],
      parentLocationCode: json['parentLocationCode'],
      locationType: json['locationType'],
      displayName: json['displayName'],
      maxQueueSize: json['maxQueueSize'],
      minQueueSize: json['minQueueSize'],
      sequence: json['sequence'],
      detectableBy: json['detectableBy'],
      govtLocationName: json['govtLocationName'],
      totalRowCount: json['totalRowCount'],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
      tenantGroupCode: json['tenantGroupCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'tenantCode': tenantCode,
      'locationName': locationName,
      'locationCode': locationCode,
      'parentLocationCode': parentLocationCode,
      'locationType': locationType,
      'displayName': displayName,
      'maxQueueSize': maxQueueSize,
      'minQueueSize': minQueueSize,
      'sequence': sequence,
      'detectableBy': detectableBy,
      'govtLocationName': govtLocationName,
      'totalRowCount': totalRowCount,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
      'tenantGroupCode': tenantGroupCode,
    };
  }
}