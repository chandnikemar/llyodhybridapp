
class InvoiceRecord {
  final int invoicingId;
  final String invoiceNumber;
  final DateTime generationDateTime;
  final String acknowledgementNo;
  final String acknowledgementDateTime;
  final String eWayBillNo;
  final String eWayBillDateTime;
  final String irn;
  final int vehicleTransactionId;
  final int mdoMasterId;
  final bool isActive;
  final String? ewayBillExpDate;
  final String status;
  final String signedInvoice;
  final String signedQRCode;
  final int cdoMasterId;
  final String invoiceingJson;
  final String eWayBillJson;
  final double totalNetAmount;
  final double totalTaxAmount;
  final String vrn;
  final String? sapInvoiceNo;
  final String? soNumber;
  final String? cdoNumber;
  final String? customerName;
  final String vehicleTransactionCode;
  final int totalRecord;
  final int totalPages;
  final String? cancelledBy;
  final String? cancelledDateTime;
  final String? invoicePdf;
  final String? ewayBillPdf;
  final String? ewayBillPath;
  final String? invoicePath;
  final String tenantCode;
  final List<InvoiceTransactionAmount> invoiceTransactionAmount;

  InvoiceRecord({
    required this.invoicingId,
    required this.invoiceNumber,
    required this.generationDateTime,
    required this.acknowledgementNo,
    required this.acknowledgementDateTime,
    required this.eWayBillNo,
    required this.eWayBillDateTime,
    required this.irn,
    required this.vehicleTransactionId,
    required this.mdoMasterId,
    required this.isActive,
    this.ewayBillExpDate,
    required this.status,
    required this.signedInvoice,
    required this.signedQRCode,
    required this.cdoMasterId,
    required this.invoiceingJson,
    required this.eWayBillJson,
    required this.totalNetAmount,
    required this.totalTaxAmount,
    required this.vrn,
    this.sapInvoiceNo,
    this.soNumber,
    this.cdoNumber,
    this.customerName,
    required this.vehicleTransactionCode,
    required this.totalRecord,
    required this.totalPages,
    this.cancelledBy,
    this.cancelledDateTime,
    this.invoicePdf,
    this.ewayBillPdf,
    this.ewayBillPath,
    this.invoicePath,
    required this.tenantCode,
    required this.invoiceTransactionAmount,
  });

  factory InvoiceRecord.fromJson(Map<String, dynamic> json) {
    return InvoiceRecord(
      invoicingId: json['invoicingId'] ?? 0,
      invoiceNumber: json['invoiceNumber'] ?? '',
      generationDateTime: DateTime.parse(json['generationDateTime']),
      acknowledgementNo: json['acknowledgementNo'] ?? '',
      acknowledgementDateTime: json['acknowledgementDateTime'] ?? '',
      eWayBillNo: json['eWayBillNo'] ?? '',
      eWayBillDateTime: json['eWayBillDateTime'] ?? '',
      irn: json['irn'] ?? '',
      vehicleTransactionId: json['vehicleTransactionId'] ?? 0,
      mdoMasterId: json['mdoMasterId'] ?? 0,
      isActive: json['isActive'] ?? false,
      ewayBillExpDate: json['ewayBillExpDate'],
      status: json['status'] ?? '',
      signedInvoice: json['signedInvoice'] ?? '',
      signedQRCode: json['signedQRCode'] ?? '',
      cdoMasterId: json['cdoMasterId'] ?? 0,
      invoiceingJson: json['invoiceingJson'] ?? '',
      eWayBillJson: json['eWayBillJson'] ?? '',
      totalNetAmount: (json['totalNetAmount'] as num?)?.toDouble() ?? 0.0,
      totalTaxAmount: (json['totalTaxAmount'] as num?)?.toDouble() ?? 0.0,
      vrn: json['vrn'] ?? '',
      sapInvoiceNo: json['sapInvoiceNo'],
      soNumber: json['soNumber'],
      cdoNumber: json['cdoNumber'],
      customerName: json['customerName'],
      vehicleTransactionCode: json['vehicleTransactionCode'] ?? '',
      totalRecord: json['totalRecord'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      cancelledBy: json['cancelledBy'],
      cancelledDateTime: json['cancelledDateTime'],
      invoicePdf: json['invoicePdf'],
      ewayBillPdf: json['ewayBillPdf'],
      ewayBillPath: json['ewayBillPath'],
      invoicePath: json['invoicePath'],
      tenantCode: json['tenantCode'] ?? '',
      invoiceTransactionAmount:
          (json['invoiceTransactionAmount'] as List<dynamic>?)
                  ?.map((item) => InvoiceTransactionAmount.fromJson(item))
                  .toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoicingId': invoicingId,
      'invoiceNumber': invoiceNumber,
      'generationDateTime': generationDateTime.toIso8601String(),
      'acknowledgementNo': acknowledgementNo,
      'acknowledgementDateTime': acknowledgementDateTime,
      'eWayBillNo': eWayBillNo,
      'eWayBillDateTime': eWayBillDateTime,
      'irn': irn,
      'vehicleTransactionId': vehicleTransactionId,
      'mdoMasterId': mdoMasterId,
      'isActive': isActive,
      'ewayBillExpDate': ewayBillExpDate,
      'status': status,
      'signedInvoice': signedInvoice,
      'signedQRCode': signedQRCode,
      'cdoMasterId': cdoMasterId,
      'invoiceingJson': invoiceingJson,
      'eWayBillJson': eWayBillJson,
      'totalNetAmount': totalNetAmount,
      'totalTaxAmount': totalTaxAmount,
      'vrn': vrn,
      'sapInvoiceNo': sapInvoiceNo,
      'soNumber': soNumber,
      'cdoNumber': cdoNumber,
      'customerName': customerName,
      'vehicleTransactionCode': vehicleTransactionCode,
      'totalRecord': totalRecord,
      'totalPages': totalPages,
      'cancelledBy': cancelledBy,
      'cancelledDateTime': cancelledDateTime,
      'invoicePdf': invoicePdf,
      'ewayBillPdf': ewayBillPdf,
      'ewayBillPath': ewayBillPath,
      'invoicePath': invoicePath,
      'tenantCode': tenantCode,
      'invoiceTransactionAmount':
          invoiceTransactionAmount.map((item) => item.toJson()).toList(),
    };
  }
}

class InvoiceTransactionAmount {
  final int invoiceTransactionAmountId;
  final int invoicingId;
  final String calculationType;
  final double amount;
  final int sequence;
  final bool isActive;

  InvoiceTransactionAmount({
    required this.invoiceTransactionAmountId,
    required this.invoicingId,
    required this.calculationType,
    required this.amount,
    required this.sequence,
    required this.isActive,
  });

  factory InvoiceTransactionAmount.fromJson(Map<String, dynamic> json) {
    return InvoiceTransactionAmount(
      invoiceTransactionAmountId: json['invoiceTransactionAmountId'] ?? 0,
      invoicingId: json['invoicingId'] ?? 0,
      calculationType: json['calculationType'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      sequence: json['sequence'] ?? 0,
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceTransactionAmountId': invoiceTransactionAmountId,
      'invoicingId': invoicingId,
      'calculationType': calculationType,
      'amount': amount,
      'sequence': sequence,
      'isActive': isActive,
    };
  }
}
