import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/reports/vtrinbound/reports_vtr_inbound_model.dart'; // Ensure this path is correct


class MGMVtrInboundDetailScreen extends StatelessWidget {
  final ReportsVtrInboundResponseModel transaction;
  final String title;

  const MGMVtrInboundDetailScreen({
    super.key,
    required this.transaction,
    this.title = 'VTR - Inbound',
  });

  // --- Formatting Helpers ---
  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '-';
    try {
      DateTime dt = DateTime.parse(isoString);
      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (e) {
      return '-';
    }
  }

  String _formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '-';
    try {
      DateTime dt = DateTime.parse(isoString);
      return DateFormat('HH:mm').format(dt);
    } catch (e) {
      return '-';
    }
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return '-';
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ', decimalDigits: 2);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF0FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Color(0xFF1C6DD0)),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF131754),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              transaction.vrn ?? '-',
              style: const TextStyle(
                color: Color(0xFF1C6DD0), // Brand Blue
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF1C6DD0),
              radius: 18,
              child: const Text(
                'SG',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE1E3E8), height: 1.0),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. ORDER INFORMATION
              _buildExpandableSection(
                context: context,
                initiallyExpanded: true,
                icon: Icons.article_outlined,
                title: 'Order Information',
                children: [
                  _buildDetailRow('VRN', transaction.vrn),
                  _buildDetailRow('Order no.', transaction.orderNumber?.toString()),
                  _buildDetailRow('OBD number', transaction.obdNumber),
                  _buildDetailRow('GRN number', transaction.grnNumber),
                  _buildDetailRow('DO no.', transaction.doNumber?.toString()),
                  _buildDetailRow('Material Code', transaction.productCode),
                  _buildDetailRow('Material Name', transaction.productName),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFE1E3E8), indent: 16, endIndent: 16),

              // 2. TRANSPORT
              _buildExpandableSection(
                context: context,
                icon: Icons.local_shipping_outlined,
                title: 'Transport',
                children: [
                  _buildDetailRow('Transporter', transaction.transporterName),
                  _buildDetailRow('Driver Name', transaction.driverName),
                  _buildDetailRow('DL Number', transaction.dlNo),
                  _buildDetailRow('Sender Plant', transaction.senderPlantPlantCode),
                  _buildDetailRow('Receiver Plant', transaction.receiverPlantCode),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFE1E3E8), indent: 16, endIndent: 16),

              // 3. DOCUMENTATION
              _buildExpandableSection(
                context: context,
                icon: Icons.file_copy_outlined,
                title: 'Documentation',
                children: [
                  _buildDetailRow('Transaction Code', transaction.transactionCode),
                  _buildDetailRow('Pass No. (TP)', transaction.tpNumber),
                  _buildDetailRow('Challan No.', transaction.challanNumber),
                  _buildDetailRow('Challan Date', _formatDate(transaction.challanDate)),
                  _buildDetailRow('Eway Bill No.', transaction.ewayBillNo),
                  _buildDetailRow('Bulk Demand No.', transaction.bulkDemandNumber),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFE1E3E8), indent: 16, endIndent: 16),

              // 4. WEIGHMENT
              _buildExpandableSection(
                context: context,
                icon: Icons.shopping_bag_outlined,
                title: 'Weighment',
                children: [
                  _buildDetailRow(
                      'GW/TW/NW',
                      '${transaction.grossWeight ?? '-'}/${transaction.tareWeight ?? '-'}/${transaction.netWeight ?? '-'}T'
                  ),
                  _buildDetailRow('Expected Qty', '${transaction.expectedQuantity ?? '-'}T'),
                  _buildDetailRow('Material rate', '₹ ${transaction.productRate ?? '-'}/T'),
                  _buildDetailRow('Material amt', _formatCurrency(transaction.materialAmount)),
                  _buildDetailRow(
                      'GW / TW time',
                      '${_formatTime(transaction.gwTime)} / ${_formatTime(transaction.twTime)}'
                  ),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFE1E3E8), indent: 16, endIndent: 16),

              // 5. GATE MOVEMENT
              _buildExpandableSection(
                context: context,
                icon: Icons.schedule_outlined,
                title: 'Gate Movement',
                children: [
                  _buildDetailRow('Gate In', '${_formatDate(transaction.gateInTime)}  ${_formatTime(transaction.gateInTime)}'),
                  _buildDetailRow('Gate Out', '${_formatDate(transaction.gateOutTime)}  ${_formatTime(transaction.gateOutTime)}'),
                  _buildDetailRow('Plant TAT', transaction.plantTAT),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Helpers ---

  /// Builds the collapsible accordion sections
  Widget _buildExpandableSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        iconColor: const Color(0xFF1C6DD0),
        collapsedIconColor: const Color(0xFF1C6DD0),
        title: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF4A5671)),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5671),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the individual Key-Value rows inside the expandable sections
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF131754), // Dark Navy Key
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              (value == null || value.trim().isEmpty || value == 'null') ? '-' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF4A5671), // Lighter Grey/Blue Value
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}