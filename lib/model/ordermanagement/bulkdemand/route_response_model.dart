import 'dart:convert';

List<RouteResponseModel> routeResponseListFromJson(String str) =>
    List<RouteResponseModel>.from(
      json.decode(str).map((x) => RouteResponseModel.fromJson(x)),
    );

String routeResponseListToJson(List<RouteResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RouteResponseModel {
  final int routeMasterId;
  final String routeCode;
  final String routeName;
  final String source;
  final String destination;
  final double distance;
  final bool isActive;
  final String createdBy;
  final DateTime? createdDate;
  final String? modifiedBy;
  final DateTime? modifiedDate;
  final String? tenantGroupCode;
  final String tenantCode;

  RouteResponseModel({
    required this.routeMasterId,
    required this.routeCode,
    required this.routeName,
    required this.source,
    required this.destination,
    required this.distance,
    required this.isActive,
    required this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
    required this.tenantCode,
  });

  factory RouteResponseModel.fromJson(Map<String, dynamic> json) =>
      RouteResponseModel(
        routeMasterId: json['routeMasterId'] as int? ?? 0,
        routeCode: json['routeCode'] as String? ?? '',
        routeName: json['routeName'] as String? ?? '',
        source: json['source'] as String? ?? '',
        destination: json['destination'] as String? ?? '',
        distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
        isActive: json['isActive'] as bool? ?? false,
        createdBy: json['createdBy'] as String? ?? '',
        createdDate: json['createdDate'] != null
            ? DateTime.tryParse(json['createdDate'])
            : null,
        modifiedBy: json['modifiedBy'] as String?,
        modifiedDate: json['modifiedDate'] != null
            ? DateTime.tryParse(json['modifiedDate'])
            : null,
        tenantGroupCode: json['tenantGroupCode'] as String?,
        tenantCode: json['tenantCode'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'routeMasterId': routeMasterId,
    'routeCode': routeCode,
    'routeName': routeName,
    'source': source,
    'destination': destination,
    'distance': distance,
    'isActive': isActive,
    'createdBy': createdBy,
    'createdDate': createdDate?.toIso8601String(),
    'modifiedBy': modifiedBy,
    'modifiedDate': modifiedDate?.toIso8601String(),
    'tenantGroupCode': tenantGroupCode,
    'tenantCode': tenantCode,
  };
}