import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../model/reports/dailydispatchreport/reports_daily_dispatch_request_model.dart';


class DailyDispatchDetailScreen extends StatelessWidget {
  final ReportsDailyDispatchResponseModel transaction;
  final String title;
  const DailyDispatchDetailScreen({
    super.key,
    required this.transaction,
    this.title = 'Daily Dispatch Report',
  });

  // --- Formatting Helper ---
  String _formatNumber(num? value) {
    if (value == null) return '0.00';
    final format = NumberFormat("#,##0.00", "en_US");
    return format.format(value);
  }

  @override
  Widget build(BuildContext context) {
    // Progress calculation
    double progress = 0.0;
    if (transaction.demandQty != null && transaction.demandQty! > 0) {
      progress = (transaction.cummQuantity ?? 0) / transaction.demandQty!;
    }
    double visualProgress = progress > 1.0 ? 1.0 : progress;
    String percentText = "${(progress * 100).toStringAsFixed(0)}%";

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
              transaction.soNo ?? '-',
              style: const TextStyle(
                color: Color(0xFF1C6DD0), // Brand Blue
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BUYER NAME TITLE
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20), // Adjusted top padding since AppBar is removed
                child: Text(
                  transaction.buyerName ?? transaction.destination ?? '-',
                  style: const TextStyle(
                    color: Color(0xFF131754), // Dark Navy
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 2. BALANCE QTY BANNER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4FC), // Very light blue background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Balance Qty',
                        style: TextStyle(
                          color: Color(0xFF1C6DD0),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatNumber(transaction.balanceQty),
                        style: const TextStyle(
                          color: Color(0xFF1C6DD0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. PROGRESS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13),
                            children: [
                              TextSpan(
                                text: _formatNumber(transaction.cummQuantity),
                                style: const TextStyle(
                                  color: Color(0xFF131754),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' of ',
                                style: TextStyle(
                                  color: Color(0xFF4A5671),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${_formatNumber(transaction.demandQty)} Demand Qty.',
                                style: const TextStyle(
                                  color: Color(0xFF777777),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          percentText,
                          style: const TextStyle(
                            color: Color(0xFF4A5671),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: visualProgress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE1E3E8),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1C6DD0)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. STAT CARDS (Today & Cumulative)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Today',
                        trips: transaction.todayTrips,
                        qty: transaction.todayQuantity,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Cumulative',
                        trips: transaction.cummTrips,
                        qty: transaction.cummQuantity,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Divider(height: 1, color: Color(0xFFE1E3E8), indent: 16, endIndent: 16),
              const SizedBox(height: 8),

              // 5. ORDER INFORMATION ACCORDION
              _buildExpandableSection(
                context: context,
                initiallyExpanded: true,
                icon: Icons.receipt_long_outlined,
                title: 'Order Information',
                children: [
                  _buildDetailRow('Customer PO', transaction.customerReference),
                  _buildDetailRow('SO no.', transaction.soNo),
                  _buildDetailRow('DO no.', transaction.doNo),
                  _buildDetailRow('Bulk demand no.', transaction.bdoNo),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFE1E3E8), indent: 16, endIndent: 16),

              // 6. PARTIES ACCORDION
              _buildExpandableSection(
                context: context,
                initiallyExpanded: true,
                icon: Icons.business_outlined,
                title: 'Parties',
                children: [
                  _buildDetailRow('Bill to.', transaction.buyerName),
                  _buildDetailRow('Ship to.', transaction.destination),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Helpers ---

  Widget _buildStatCard({required String title, required int? trips, required double? qty}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E3E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${trips ?? 0} Trips',
                style: const TextStyle(
                  color: Color(0xFF131754),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 1,
                height: 12,
                color: const Color(0xFFD1D5DB),
              ),
              Expanded(
                child: Text(
                  '${_formatNumber(qty)} Qty',
                  style: const TextStyle(
                    color: Color(0xFF131754),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
        collapsedIconColor: const Color(0xFF4A5671),
        title: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF4A5671)),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A5671),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF131754),
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
                color: Color(0xFF4A5671),
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