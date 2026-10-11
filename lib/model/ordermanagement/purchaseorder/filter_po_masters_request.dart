class FilterPoMastersRequest {
  final String fromDate;
  final String toDate;
  final int currentPage;
  final int rowSize;
  final String? globalSearch;
  final String tenantCode;
  final String? poNumber;
  final String? materialCode;
  final String? materialDescription;
  final String? materialGroup;
  final String? plantCode;
  final String? storageLocation;
  final String? itemCategory;
  final String? accountAssignment;
  final String? status;

  const FilterPoMastersRequest({
    required this.fromDate,
    required this.toDate,
    required this.currentPage,
    required this.rowSize,
    this.globalSearch,
    required this.tenantCode,
    this.poNumber,
    this.materialCode,
    this.materialDescription,
    this.materialGroup,
    this.plantCode,
    this.storageLocation,
    this.itemCategory,
    this.accountAssignment,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'FromDate': fromDate,
      'ToDate': toDate,
      'currentPage': currentPage,
      'rowSize': rowSize,
      'GlobalSearch': globalSearch,
      'tenantCode': tenantCode,
    };

    // Only add filter fields if they have values
    if (poNumber != null && poNumber!.isNotEmpty) json['poNumber'] = poNumber;
    if (materialCode != null && materialCode!.isNotEmpty) json['materialCode'] = materialCode;
    if (materialDescription != null && materialDescription!.isNotEmpty) json['materialDescription'] = materialDescription;
    if (materialGroup != null && materialGroup!.isNotEmpty) json['materialGroup'] = materialGroup;
    if (plantCode != null && plantCode!.isNotEmpty) json['plantCode'] = plantCode;
    if (storageLocation != null && storageLocation!.isNotEmpty) json['storageLocation'] = storageLocation;
    if (itemCategory != null && itemCategory!.isNotEmpty) json['itemCategory'] = itemCategory;
    if (accountAssignment != null && accountAssignment!.isNotEmpty) json['accountAssignment'] = accountAssignment;
    if (status != null && status!.isNotEmpty) json['status'] = status;

    return json;
  }
}
