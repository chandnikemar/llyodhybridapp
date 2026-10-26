import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
 import 'package:ut_lloyd_web_app/view/screen/reports/vtroutbound/vtr_outbound_detail_screen.dart';

import '../../../../model/reports/vtroutbound/reports_vtr_outbound_model.dart';
import '../../../../utilities/common.dart';
import '../../../../utilities/common_dialog.dart';
import '../../../../view_model/reports_view_model.dart';
// Ensure this path points to your CommonDateFilterPopup file

// 🔹 ADDED: Import the detail screen here



class VtrOutBoundListScreen extends StatefulWidget {
  final String title;

  const VtrOutBoundListScreen({super.key, required this.title});

  @override
  State<VtrOutBoundListScreen> createState() => _VtrOutBoundListState();
}

class _VtrOutBoundListState extends State<VtrOutBoundListScreen> {
  late final ReportsViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _tenantCode = '';

  // Filter States
  String? _appliedFilter;
  DateTime? _appliedFromDate;
  DateTime? _appliedToDate;

  // 🔹 ADDED: All the filter fields you requested
  final List<String> _filterOptions = [
    'VRN',
    'Order Number',
    'Order Type',
    'Transaction Code',
    'Bd Number',
    'PGI Number',
    'Inbound GRN',
    'DO Number',
    'Material Code',
    'Material Name',
    'Destination',
    'Transporter Name',
    'TP Number'
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ReportsViewModel>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
        if (!_viewModel.isPaginating && _viewModel.hasMoreData) {
          _fetchData(isLoadMore: true);
        }
      }
    });

    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    _tenantCode = prefs.getString(Common.selectedTenant) ?? 'LIMS'; // Ensure a fallback

    if (mounted) {
      _fetchData(isLoadMore: false);
    }
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    final String searchQuery = _searchController.text.trim();

    // Set dates in viewmodel if they were updated via filter
    if (_appliedFromDate != null && _appliedToDate != null) {
      final String fromStr = "${_appliedFromDate!.toIso8601String().split('T').first}T00:00:00";
      final String toStr = "${_appliedToDate!.toIso8601String().split('T').first}T23:59:59";
      _viewModel.fromDate = fromStr;
      _viewModel.toDate = toStr;
    }

    // 🔹 Build the Request Model directly in the UI based on the dropdown selection
    final request = ReportsVtrOutboundRequestModel(
      tenantCode: _tenantCode,
      fromDate: _viewModel.fromDate.replaceAll(' ', 'T'),
      toDate: _viewModel.toDate.replaceAll(' ', 'T'),
      currentPage: 1, // Will be overridden by ViewModel pagination
      rowSize: 15,    // Will be overridden by ViewModel pagination

      globalSearch: _appliedFilter == null && searchQuery.isNotEmpty ? searchQuery : null,
      vrn: _appliedFilter == 'VRN' && searchQuery.isNotEmpty ? searchQuery : null,
      orderNumber: _appliedFilter == 'Order Number' && searchQuery.isNotEmpty ? searchQuery : null,
      orderType: _appliedFilter == 'Order Type' && searchQuery.isNotEmpty ? searchQuery : null,
      transactionCode: _appliedFilter == 'Transaction Code' && searchQuery.isNotEmpty ? searchQuery : null,
      bulkDemandNumber: _appliedFilter == 'Bd Number' && searchQuery.isNotEmpty ? searchQuery : null,
      pgiNumber: _appliedFilter == 'PGI Number' && searchQuery.isNotEmpty ? searchQuery : null,
      inboundGRN: _appliedFilter == 'Inbound GRN' && searchQuery.isNotEmpty ? searchQuery : null,
      doNumber: _appliedFilter == 'DO Number' && searchQuery.isNotEmpty ? int.tryParse(searchQuery) : null,
      productCode: _appliedFilter == 'Material Code' && searchQuery.isNotEmpty ? searchQuery : null,
      productName: _appliedFilter == 'Material Name' && searchQuery.isNotEmpty ? searchQuery : null,
      city: _appliedFilter == 'Destination' && searchQuery.isNotEmpty ? searchQuery : null,
      transporterName: _appliedFilter == 'Transporter Name' && searchQuery.isNotEmpty ? searchQuery : null,
      passNo: _appliedFilter == 'TP Number' && searchQuery.isNotEmpty ? searchQuery : null,
    );

    // Pass the entire model to the ViewModel
    await _viewModel.fetchVtrOutboundData(request: request, isLoadMore: isLoadMore);
  }


  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CommonDateOrderFilterPopup(
          filterOptions: _filterOptions,
          selectedFilter: _appliedFilter,
          fromDate: _appliedFromDate,
          toDate: _appliedToDate,
          onApply: (filter, fromDate, toDate) {
            setState(() {
              _appliedFilter = filter;
              _appliedFromDate = fromDate;
              _appliedToDate = toDate;
            });
            _fetchData(isLoadMore: false);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, child) {
        final List<ReportsVtrOutboundResponseModel> transactions = viewModel.vtrOutboundList;
        final bool hasSearchText = _searchController.text.trim().isNotEmpty;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // SEARCH & FILTER ROW
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      // SEARCH BOX
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F9FB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Color(0xFF777777), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (_) {
                                    _fetchData(isLoadMore: false);
                                  },
                                  decoration: InputDecoration(
                                    hintText: _appliedFilter != null ? 'Search $_appliedFilter...' : 'Search...',
                                    hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 14),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (hasSearchText)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    _fetchData(isLoadMore: false);
                                  },
                                  child: const Icon(Icons.close, size: 18, color: Color(0xFF777777)),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // FILTER BUTTON
                      InkWell(
                        onTap: _openFilterDialog,
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF0FA), // Light blue background
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.tune, color: Color(0xFF1C6DD0), size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                // ITEM COUNT
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      viewModel.isLoading
                          ? 'Loading...'
                          : transactions.isEmpty
                          ? '0 Open Orders'
                          : '${transactions.length}/${transactions.first.totalRecord} Open Orders',
                      style: const TextStyle(
                        color: Color(0xFF131754),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFE1E3E8)),

                // LIST VIEW
                Expanded(
                  child: viewModel.isLoading && transactions.isEmpty
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF1C6DD0)))
                      : transactions.isEmpty
                      ? const Center(
                      child: Text("No transactions found", style: TextStyle(color: Color(0xFF777777))))
                      : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: transactions.length + (viewModel.isPaginating ? 1 : 0),
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE1E3E8)),
                    itemBuilder: (context, index) {
                      if (index == transactions.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator(color: Color(0xFF1C6DD0))),
                        );
                      }
                      return VtrTransactionCard(transaction: transactions[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// ============================================================================
// INDIVIDUAL CARD COMPONENT
// ============================================================================
class VtrTransactionCard extends StatelessWidget {
  final ReportsVtrOutboundResponseModel transaction;

  const VtrTransactionCard({super.key, required this.transaction});

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 🔹 ADDED: Navigate to the Details Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VtrOutboundDetailScreen(
              transaction: transaction,
              title: 'VTR - Outbound',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ROW 1: VRN, Material Chip, TAT Chip, Info Icon
            Row(
              children: [
                Text(
                  transaction.vrn ?? '-',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131754),
                  ),
                ),
                const Spacer(),

                if (transaction.productName != null)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F8EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      transaction.obdNumber??"",
                      style: const TextStyle(
                        color: Color(0xFF1E9E5C),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'TAT ${transaction.plantTAT ?? '-'}',
                    style: const TextStyle(
                      color: Color(0xFF1C6DD0),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF0FA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline, size: 14, color: Color(0xFF1C6DD0)),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              transaction.transporterName ?? '-',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4A5671),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const SizedBox(
                  width: 32,
                  child: Text('In', style: TextStyle(color: Color(0xFF777777), fontSize: 13)),
                ),
                const Text(':', style: TextStyle(color: Color(0xFF777777), fontSize: 13)),
                const SizedBox(width: 8),
                Text(
                  _formatDate(transaction.gateInTime),
                  style: const TextStyle(color: Color(0xFF4A5671), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 14, color: Color(0xFF999999)),
                const SizedBox(width: 4),
                Text(
                  _formatTime(transaction.gateInTime),
                  style: const TextStyle(color: Color(0xFF4A5671), fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const SizedBox(
                  width: 32,
                  child: Text('Out', style: TextStyle(color: Color(0xFF777777), fontSize: 13)),
                ),
                const Text(':', style: TextStyle(color: Color(0xFF777777), fontSize: 13)),
                const SizedBox(width: 8),
                Text(
                  _formatDate(transaction.gateOutTime),
                  style: const TextStyle(color: Color(0xFF4A5671), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 14, color: Color(0xFF999999)),
                const SizedBox(width: 4),
                Text(
                  _formatTime(transaction.gateOutTime),
                  style: const TextStyle(color: Color(0xFF4A5671), fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text('NW', style: TextStyle(color: Color(0xFF777777), fontSize: 12)),
                const SizedBox(width: 8),
                Text(
                  transaction.netWeight != null ? transaction.netWeight.toString() : '-',
                  style: const TextStyle(
                    color: Color(0xFF1C6DD0),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (transaction.netWeight != null)
                  const Text('T', style: TextStyle(color: Color(0xFF1C6DD0), fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}