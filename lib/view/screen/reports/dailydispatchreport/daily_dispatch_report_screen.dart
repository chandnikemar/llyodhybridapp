  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Ensure these paths point to your actual files
import '../../../../model/reports/dailydispatchreport/reports_daily_dispatch_request_model.dart';
import '../../../../utilities/common.dart';
import '../../../../utilities/common_dialog.dart';
import '../../../../view_model/reports_view_model.dart';
import 'daily_dispatch_detail_screen.dart';

// import 'daily_dispatch_detail_screen.dart'; // Make sure this path is correct
// import '../../../../utilities/date_range_filter_dialog.dart'; // Ensure this points to your new dialog

class DailyDispatchReportScreen extends StatefulWidget {
  final String title;

  const DailyDispatchReportScreen(
      {super.key, this.title = 'Daily Dispatch Report'});

  @override
  State<DailyDispatchReportScreen> createState() =>
      _DailyDispatchReportScreenState();
}

class _DailyDispatchReportScreenState extends State<DailyDispatchReportScreen> {
  late final ReportsViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Tracks the currently selected date for the single-date calendar dialog
  DateTime _displayDate = DateTime.now();
  String _tenantCode = '';

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ReportsViewModel>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (!_viewModel.isPaginating && _viewModel.hasMoreData) {
          _fetchData(isLoadMore: true);
        }
      }
    });
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    _tenantCode = prefs.getString(Common.selectedTenant) ?? 'LIMS';
    if (mounted) {
      _fetchData(isLoadMore: false);
    }
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    final String searchQuery = _searchController.text.trim();

    final request = ReportsDailyDispatchRequestModel(
      tenantCode: _tenantCode,
        fromDate: _viewModel.fromDate.replaceAll(' ', 'T'),
        toDate: _viewModel.toDate.replaceAll(' ', 'T'),
      currentPage: 1,
      rowSize: 15,
      globalSearch: searchQuery.isNotEmpty ? searchQuery : null,
      bdoNo: null,
      buyerName: null,
      destination: null,
      doNo: null,
      soNo: null,
    );

    await _viewModel.fetchDailyDispatchData(
        request: request, isLoadMore: isLoadMore);
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => DateRangeFilterDialog(
        title: 'Select Date',
        showSingleCalendar: true,
        initialDate: _displayDate,
        onApply: (label, fromDate, toDate) {
          setState(() {
            _displayDate = DateTime.parse(fromDate);
          });

          _viewModel.fromDate = fromDate.replaceAll(' ', 'T');
          _viewModel.toDate = toDate.replaceAll(' ', 'T');

          _fetchData(isLoadMore: false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, child) {
        final List<ReportsDailyDispatchResponseModel> transactions =
            viewModel.dailyDispatchList;
        final bool hasSearchText = _searchController.text.trim().isNotEmpty;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // SEARCH & FILTER ROW
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: InkWell(
                    onTap: _openFilterDialog,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FB), // Subtle grey-blue background
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE1E3E8)), // Light border
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xFF1C6DD0),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                // Replace "Select Date" with your dynamic date variable!
                                // Example: DateFormat('dd MMM yyyy').format(_displayDate)
                                "Select Date",
                                style: const TextStyle(
                                  color: Color(0xFF131754),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF777777),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ITEM COUNT
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      viewModel.isLoading && transactions.isEmpty
                          ? 'Loading...'
                          : '${transactions.length} Records',
                      style: const TextStyle(
                        color: Color(0xFF131754),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE1E3E8)),

                // LIST VIEW
                Expanded(
                  child: viewModel.isLoading && transactions.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF1C6DD0)))
                      : transactions.isEmpty
                          ? const Center(
                              child: Text("No records found",
                                  style: TextStyle(color: Color(0xFF777777))))
                          : ListView.separated(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: transactions.length +
                                  (viewModel.isPaginating ? 1 : 0),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                      height: 1, color: Color(0xFFE1E3E8)),
                              itemBuilder: (context, index) {
                                if (index == transactions.length) {
                                  return const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            color: Color(0xFF1C6DD0))),
                                  );
                                }
                                return DailyDispatchCard(
                                    transaction: transactions[index]);
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
class DailyDispatchCard extends StatelessWidget {
  final ReportsDailyDispatchResponseModel transaction;

  const DailyDispatchCard({super.key, required this.transaction});

  String _formatNumber(num? value) {
    if (value == null) return '0.00';
    final format = NumberFormat("#,##0.00", "en_US");
    return format.format(value);
  }

  String _toTitleCase(String? text) {
    if (text == null || text.isEmpty) return '-';
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ')
        .replaceAll('.', '');
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    if (transaction.demandQty != null && transaction.demandQty! > 0) {
      progress = (transaction.cummQuantity ?? 0) / transaction.demandQty!;
    }
    double visualProgress = progress > 1.0 ? 1.0 : progress;
    String percentText = "${(progress * 100).toStringAsFixed(0)}%";

    return InkWell(
      onTap: () {
        // 🔹 UNCOMMENTED: Navigation logic added here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyDispatchDetailScreen(
              transaction: transaction,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    transaction.buyerName ?? transaction.destination ?? '-',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF0FA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline,
                      size: 14, color: Color(0xFF1C6DD0)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                Text(
                  'SO - ${transaction.soNo ?? '-'}',
                  style: const TextStyle(
                    color: Color(0xFF4A5671),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F8EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _toTitleCase(transaction.materialName),
                    style: const TextStyle(
                      color: Color(0xFF1E9E5C),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Bal ${_formatNumber(transaction.balanceQty)}',
                    style: const TextStyle(
                      color: Color(0xFF1C6DD0),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                        text: _formatNumber(transaction.demandQty),
                        style: const TextStyle(
                          color: Color(0xFF999999),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: visualProgress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE1E3E8),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF1C6DD0)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Today : ${transaction.todayTrips ?? 0} trips | ${_formatNumber(transaction.todayQuantity)} Qty | ${transaction.cummTrips ?? 0} Cumm. Trips',
              style: const TextStyle(
                color: Color(0xFF777777),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
