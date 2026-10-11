class ProductResponseModel {
  final int? productId;
  final String? tenantCode;
  final String? productName;
  final String? productCode;
  final String? category;
  final String? mht;
  final String? hsnCode;
  final int? totalRecord;
  final String? uom;
  final bool? isBulk;
  final bool? isActive;
  final String? createdBy;
  final String? createdDate;
  final String? modifiedBy;
  final String? modifiedDate;
  final String? tenantGroupCode;

  ProductResponseModel({
    this.productId,
    this.tenantCode,
    this.productName,
    this.productCode,
    this.category,
    this.mht,
    this.hsnCode,
    this.totalRecord,
    this.uom,
    this.isBulk,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.tenantGroupCode,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      productId: json['productId'],
      tenantCode: json['tenantCode'],
      productName: json['productName'],
      productCode: json['productCode'],
      category: json['category'],
      mht: json['mht'],
      hsnCode: json['hsnCode'],
      totalRecord: json['totalRecord'],
      uom: json['uom'],
      isBulk: json['isBulk'],
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
      'productId': productId,
      'tenantCode': tenantCode,
      'productName': productName,
      'productCode': productCode,
      'category': category,
      'mht': mht,
      'hsnCode': hsnCode,
      'totalRecord': totalRecord,
      'uom': uom,
      'isBulk': isBulk,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
      'tenantGroupCode': tenantGroupCode,
    };
  }
}