class MaterialDispatchRequest {
  final String fromDate;
  final String toDate;
  final String tenantCode;

  MaterialDispatchRequest({
    required this.fromDate,
    required this.toDate,
    required this.tenantCode,
  });

  factory MaterialDispatchRequest.fromJson(Map<String, dynamic> json) {
    return MaterialDispatchRequest(
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      tenantCode: json['tenantCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromDate': fromDate,
      'toDate': toDate,
      'tenantCode': tenantCode,
    };
  }
}
class MaterialDispatchResponse {
  final String? materialName;
  final int? totalTrips;
  final double? totalQty;
  final int? soTrips;
  final double? soQty;
  final int? hedriTrips;
  final double? hedriQty;
  final int? kamancheruTrips;
  final double? kamancheruQty;
  final int? ghugusTrips;
  final double? ghugusQty;
  final int? sidingTrips;
  final double? railwayQty;
  final int? ftmTrips;
  final double? ftmQty;
  final int? jsyTrips;
  final double? jsyQty;

  MaterialDispatchResponse({
    this.materialName,
    this.totalTrips,
    this.totalQty,
    this.soTrips,
    this.soQty,
    this.hedriTrips,
    this.hedriQty,
    this.kamancheruTrips,
    this.kamancheruQty,
    this.ghugusTrips,
    this.ghugusQty,
    this.sidingTrips,
    this.railwayQty,
    this.ftmTrips,
    this.ftmQty,
    this.jsyTrips,
    this.jsyQty,
  });

  factory MaterialDispatchResponse.fromJson(Map<String, dynamic> json) {
    return MaterialDispatchResponse(
      materialName: json['materialName'] as String?,
      totalTrips: json['totalTRIPS'] as int?,
      totalQty: (json['totalQty'] as num?)?.toDouble(),
      soTrips: json['soTrips'] as int?,
      soQty: (json['soQty'] as num?)?.toDouble(),
      hedriTrips: json['hedriTrips'] as int?,
      hedriQty: (json['hedriQty'] as num?)?.toDouble(),
      kamancheruTrips: json['kamancheruTrips'] as int?,
      kamancheruQty: (json['kamancheruQty'] as num?)?.toDouble(),
      ghugusTrips: json['ghugusTrips'] as int?,
      ghugusQty: (json['ghugusQty'] as num?)?.toDouble(),
      sidingTrips: json['sidingTrips'] as int?,
      railwayQty: (json['railwayQty'] as num?)?.toDouble(),
      ftmTrips: json['ftM_Trips'] as int?,
      ftmQty: (json['ftM_Qty'] as num?)?.toDouble(),
      jsyTrips: json['jsyTrips'] as int?,
      jsyQty: (json['jsyQty'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materialName': materialName,
      'totalTRIPS': totalTrips,
      'totalQty': totalQty,
      'soTrips': soTrips,
      'soQty': soQty,
      'hedriTrips': hedriTrips,
      'hedriQty': hedriQty,
      'kamancheruTrips': kamancheruTrips,
      'kamancheruQty': kamancheruQty,
      'ghugusTrips': ghugusTrips,
      'ghugusQty': ghugusQty,
      'sidingTrips': sidingTrips,
      'railwayQty': railwayQty,
      'ftM_Trips': ftmTrips,
      'ftM_Qty': ftmQty,
      'jsyTrips': jsyTrips,
      'jsyQty': jsyQty,
    };
  }
}

class MaterialDispatchNewRequest {
  final String tenantCode;
  final String fromDate;
  final String toDate;

  MaterialDispatchNewRequest({
    required this.tenantCode,
    required this.fromDate,
    required this.toDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "tenantCode": tenantCode,
      "FromDate": fromDate,
      "ToDate": toDate,
    };
  }
}

class MaterialDispatchNewResponse {
  final String? direction;
  final double? totalActualWeight;

  MaterialDispatchNewResponse({
    this.direction,
    this.totalActualWeight,
  });

  factory MaterialDispatchNewResponse.fromJson(Map<String, dynamic> json) {
    return MaterialDispatchNewResponse(
      direction: json['direction'] as String?,
      totalActualWeight: (json['totalActualWeight'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direction': direction,
      'totalActualWeight': totalActualWeight,
    };
  }
}