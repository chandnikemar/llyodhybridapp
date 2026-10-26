import 'dart:convert';

String routeRequestModelToJson(RouteRequestModel data) =>
    json.encode(data.toJson());

class RouteRequestModel {
  final int routeMasterId;
  final String tenantCode;

  RouteRequestModel({
    this.routeMasterId = 0,
    this.tenantCode = 'LKOP',
  });

  factory RouteRequestModel.fromJson(Map<String, dynamic> json) =>
      RouteRequestModel(
        routeMasterId: json['RouteMasterId'] as int? ?? 0,
        tenantCode: json['TenantCode'] as String? ?? 'LKOP',
      );

  Map<String, dynamic> toJson() => {
    'RouteMasterId': routeMasterId,
    'TenantCode': tenantCode,
  };
}