import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/reports/salereport/sales_order_model.dart';
import '../../../../model/reports/salereport/so_sc_po_model.dart';
import '../../../../utilities/app_colors.dart';
import '../../../../utilities/common.dart';
import '../../../../utilities/common_dialog.dart';
import '../../../../utilities/common_text.dart';
import '../../../../utilities/common_widgets.dart';
import '../../../../view_model/reports_view_model.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  final ReportsViewModel _viewModel = ReportsViewModel();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _tenantCode = '';
  SalesReportTab _selectedTab = SalesReportTab.doWise;
  bool _isLoadingMore = false;

  // What the user picked in the filter popup. Dates default to today.
  String? _appliedFilter;
  late DateTime _appliedFromDate;
  late DateTime _appliedToDate;

  // What the CURRENT list was fetched with. Load-more always reuses these,
  // so pages never mix different searches.
  String? _committedFilter;
  String _committedQuery = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _appliedFromDate = DateTime(now.year, now.month, now.day);
    _appliedToDate = _appliedFromDate;

    _scrollController.addListener(_onScroll);
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    _tenantCode = prefs.getString(Common.selectedTenant) ?? '';
    if (mounted) _fetchData(isLoadMore: false);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _fetchData(isLoadMore: true);
    }
  }

  int _getTabIndex(SalesReportTab tab) {
    switch (tab) {
      case SalesReportTab.doWise:
        return 0;
      case SalesReportTab.soWise:
        return 1;
      case SalesReportTab.scWise:
        return 2;
      case SalesReportTab.customerPoWise:
        return 3;
    }
  }

  // Tolerant to case / spacing differences in the popup's labels
  String? _getApiFilterKey(String? filterName) {
    switch (filterName?.trim().toLowerCase()) {
      case 'so number':
        return 'soNumber';
      case 'do number':
        return 'cdoNumber';
      case 'destination':
        return 'shipLocation';
      case 'customer name':
        return 'customerName';
      case 'customer reference':
        return 'customerReference';
      case 'material name':
        return 'materialName';
      case 'material code':
        return 'materialCode';
      case 'sales contract number':
        return 'salesContractNumber';
      default:
        return null;
    }
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (_isLoadingMore ||
          _viewModel.isLoading ||
          _viewModel.isPaginating ||
          !_viewModel.hasMoreData) {
        return;
      }
      _isLoadingMore = true;
    } else {
      // A fresh search commits what is on screen now.
      _committedFilter = _appliedFilter;
      _committedQuery = _searchController.text.trim();
      _viewModel.setDateRange(_appliedFromDate, _appliedToDate);
      FocusScope.of(context).unfocus();
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    }

    // Page 1 on a fresh search, last loaded page + 1 on load-more
    final int targetPage = isLoadMore ? _viewModel.currentPage + 1 : 1;

    final String q = _committedQuery;
    final String? key = _getApiFilterKey(_committedFilter);
    final bool useFilter = key != null && q.isNotEmpty;

    // Only set the filter field that's being used
    String cdoNumber = '';
    String customerName = '';
    String customerReference = '';
    String materialCode = '';
    String materialName = '';
    String soNumber = '';
    String salesContractNumber = '';
    String shipLocation = '';

    if (useFilter) {
      switch (key) {
        case 'cdoNumber':
          cdoNumber = q;
          break;
        case 'customerName':
          customerName = q;
          break;
        case 'customerReference':
          customerReference = q;
          break;
        case 'materialCode':
          materialCode = q;
          break;
        case 'materialName':
          materialName = q;
          break;
        case 'soNumber':
          soNumber = q;
          break;
        case 'salesContractNumber':
          salesContractNumber = q;
          break;
        case 'shipLocation':
          shipLocation = q;
          break;
      }
    }

    debugPrint('[SalesReport] tab: $_selectedTab, page: $targetPage, '
        'filter: $_committedFilter, key: $key, query: "$q", '
        'dates: ${_viewModel.fromDate} -> ${_viewModel.toDate}');

    try {
      await _viewModel.fetchSalesReport(
        tenantCode: _tenantCode,
        currentPage: targetPage,
        isLoadMore: isLoadMore,
        globalSearch: key == null ? q : '',
        cdoNumber: cdoNumber,
        customerName: customerName,
        customerReference: customerReference,
        materialCode: materialCode,
        materialName: materialName,
        soNumber: soNumber,
        salesContractNumber: salesContractNumber,
        shipLocation: shipLocation,
      );
    } finally {
      _isLoadingMore = false;
    }

    if (mounted) _fillViewport();
  }

  /// If the loaded cards don't fill the screen there is nothing to scroll,
  /// so keep loading the next 15 until it scrolls or the data ends.
  void _fillViewport() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      if (_viewModel.errorMessage != null || !_viewModel.hasMoreData) return;
      if (_scrollController.position.maxScrollExtent <= 0) {
        _fetchData(isLoadMore: true);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Tabs / filter dialog
  // ---------------------------------------------------------------------------
  void _onTabChanged(SalesReportTab tab) {
    if (tab == _selectedTab) return;
    setState(() {
      _selectedTab = tab;
      _appliedFilter = null; // options differ per tab; date range is kept
      _committedFilter = null;
      _committedQuery = '';
      _searchController.clear();
    });
    _viewModel.switchTab(_getTabIndex(tab));
    _fetchData(isLoadMore: false);
  }

  List<String> _getFilterOptionsForTab() {
    switch (_selectedTab) {
      case SalesReportTab.doWise:
        return [
          'DO Number',
          'SO Number',
          'Destination',
          'Customer Name',
          'Customer Reference',
          'Material Name',
          'Material Code',
        ];
      case SalesReportTab.soWise:
        return [
          'SO Number',
          'Destination',
          'Customer Name',
          'Customer Reference',
          'Material Name',
          'Material Code',
        ];
      case SalesReportTab.scWise:
        return [
          'Sales Contract Number',
          'SO Number',
          'Destination',
          'Customer Name',
          'Customer Reference',
          'Material Name',
          'Material Code',
        ];
      case SalesReportTab.customerPoWise:
        return [
          'Customer Reference',
          'SO Number',
          'Destination',
          'Customer Name',
          'Material Name',
          'Material Code',
        ];
    }
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => CommonDateOrderFilterPopup(
        filterOptions: _getFilterOptionsForTab(),
        selectedFilter: _appliedFilter,
        fromDate: _appliedFromDate,
        toDate: _appliedToDate,
        onApply: (filter, from, to) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          setState(() {
            _appliedFilter = filter;

            _appliedFromDate = from ?? to ?? today;
            _appliedToDate = to ?? from ?? today;
          });
          _fetchData(isLoadMore: false);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  Widget _squareButton({required VoidCallback onTap, required Widget child}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF0FA),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.only(left: 12, right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _fetchData(isLoadMore: false),
                    decoration: InputDecoration(
                      hintText: _appliedFilter != null
                          ? 'Search by $_appliedFilter...'
                          : 'Search SO, CDO, Customer...',
                      hintStyle: const TextStyle(
                          color: AppColors.kTextGrey, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {});
                      _fetchData(isLoadMore: false);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.close,
                          size: 18, color: Color(0xFF777777)),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _squareButton(
          onTap: () => _fetchData(isLoadMore: false),
          child: const Icon(Icons.search, color: Color(0xFF1C6DD0), size: 20),
        ),
        const SizedBox(width: 8),
        _squareButton(
          onTap: _openFilterDialog,
          child: Image.asset(
            'assets/images/filter.png',
            width: 18,
            height: 18,
            color: const Color(0xFF1C6DD0),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: Color(0xFF777777)),
          const SizedBox(height: 10),
          CommonText.h4('No orders found',
              fontWeight: FontWeight.w600, color: const Color(0xFF131754)),
          const SizedBox(height: 4),
          CommonText.caption('Try searching with another keyword or filter.',
              color: const Color(0xFF777777)),
        ],
      ),
    );
  }

  Widget _buildOrdersList(ReportsViewModel vm) {
    final bool isDoTab = _selectedTab == SalesReportTab.doWise;
    final int itemCount = isDoTab ? vm.doList.length : vm.soscpoList.length;

    if (vm.isLoading && itemCount == 0) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF1C6DD0)));
    }
    if (itemCount == 0) return _buildEmptyState();

    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: itemCount + (vm.isPaginating ? 1 : 0),
      separatorBuilder: (_, __) =>
      const Divider(height: 24, color: Color(0xFFE1E3E8)),
      itemBuilder: (context, index) {
        if (index == itemCount) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
                child: CircularProgressIndicator(color: Color(0xFF1C6DD0))),
          );
        }
        return isDoTab
            ? _OrderCard.fromDoWise(
            order: vm.doList[index], tabType: _selectedTab)
            : _OrderCard.fromOtherWise(
            order: vm.soscpoList[index], tabType: _selectedTab);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReportsViewModel>.value(
      value: _viewModel,
      child: Consumer<ReportsViewModel>(
        builder: (context, vm, _) {
          final int loadedCount = _selectedTab == SalesReportTab.doWise
              ? vm.doList.length
              : vm.soscpoList.length;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  const Divider(height: 1, color: Color(0xFFE1E3E8)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: CommonTabBar<SalesReportTab>(
                      selectedTab: _selectedTab,
                      tabs: const {
                        SalesReportTab.doWise: 'DO Wise',
                        SalesReportTab.soWise: 'SO Wise',
                        SalesReportTab.scWise: 'SC Wise',
                        SalesReportTab.customerPoWise: 'Customer PO Wise',
                      },
                      onTabChanged: _onTabChanged,
                      tabSpacing: 22,
                      verticalPadding: 12,
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE1E3E8)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                    child: _buildSearchRow(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CommonText.h4(
                        vm.isLoading && loadedCount == 0
                            ? 'Loading Orders...'
                            : vm.isPaginating
                                ? 'Loading more orders...'
                                : '$loadedCount Orders',
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF131754),
                      ),
                    ),
                  ),
                  Expanded(child: _buildOrdersList(vm)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }
}

// ============================================================================
// ORDER CARD (unchanged)
// ============================================================================
class _OrderCard extends StatelessWidget {
  final SalesReportTab tabType;

  final String? primaryTitle;
  final String? primaryValue;
  final String? secondaryTitle;
  final String? secondaryValue;

  final String? status;
  final String? customerName;
  final String? materialName;
  final String? rightAlignedTitle;

  final double? qty1;
  final double? qty2;
  final double? dispatchedQty;
  final double? balanceQty;
  final int? trips;
  final String? poDate;
  final String? publishedOn;

  _OrderCard.fromDoWise({
    required SalesReportResponse order,
    required this.tabType,
  })  : primaryTitle = 'SO',
        primaryValue = order.soNumber?.toString() ?? '-',
        secondaryTitle = 'DO',
        secondaryValue = order.cdoNumber ?? '-',
        status = order.status,
        customerName = order.customerName,
        rightAlignedTitle = order.customerReference,
        materialName = order.materialName,
        qty1 = order.soQuantity,
        qty2 = order.cdoQty,
        dispatchedQty = order.dispatchedQty,
        balanceQty = order.balanceQty,
        trips = order.noOfTruckTrips,
        poDate = order.poDate,
        publishedOn = order.publishedOn;

  _OrderCard.fromOtherWise({
    required SalesSOSCPOResponse order,
    required this.tabType,
  })  : primaryTitle = _getPrimaryTitle(tabType),
        primaryValue = _getPrimaryValue(order, tabType),
        secondaryTitle = _getSecondaryTitle(tabType),
        secondaryValue = _getSecondaryValue(order, tabType),
        status = null,
        customerName = order.customerName,
        rightAlignedTitle = order.shipLocation,
        materialName = order.materialName,
        qty1 = tabType == SalesReportTab.scWise
            ? order.salesContractQuantity
            : order.soQuantity,
        qty2 = order.totalCDOQty,
        dispatchedQty = order.totalDispatchedQty,
        balanceQty = order.totalBalanceQty,
        trips = order.totalTruckTrips,
        poDate = order.salesContractDate,
        publishedOn = null;

  static String _getPrimaryTitle(SalesReportTab tab) {
    if (tab == SalesReportTab.soWise) return 'SO';
    if (tab == SalesReportTab.scWise) return 'SC';
    return 'PO Ref';
  }

  static String _getPrimaryValue(
      SalesSOSCPOResponse order, SalesReportTab tab) {
    if (tab == SalesReportTab.soWise) return order.soNumber?.toString() ?? '-';
    if (tab == SalesReportTab.scWise) return order.salesContractNumber ?? '-';
    return order.customerReference ?? '-';
  }

  static String _getSecondaryTitle(SalesReportTab tab) {
    if (tab == SalesReportTab.soWise) return 'Cust Ref';
    return 'SO';
  }

  static String _getSecondaryValue(
      SalesSOSCPOResponse order, SalesReportTab tab) {
    if (tab == SalesReportTab.soWise) return order.customerReference ?? '-';
    return order.soNumber?.toString() ?? '-';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CommonText.h2(
                '$primaryTitle - $primaryValue',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF131754),
              ),
            ),
            if (status != null && status!.trim().isNotEmpty)
              _StatusChip(status: status!),
            const SizedBox(width: 6),
          ],
        ),
        const SizedBox(height: 4),
        CommonText.caption('$secondaryTitle: $secondaryValue',
            color: const Color(0xFF777777)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: CommonText.h4(
                customerName ?? '-',
                fontWeight: FontWeight.w600,
                color: AppColors.kTextGreyLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: CommonText.h4(
                rightAlignedTitle ?? '-',
                fontWeight: FontWeight.w600,
                color: AppColors.kTextGreyLight,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        CommonText.caption(materialName ?? '-', color: const Color(0xFF777777)),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1E3E8), width: 0.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: _StatColumn(
                  label: tabType == SalesReportTab.scWise ? 'SC Qty' : 'SO Qty',
                  value: _formatQty(qty1),
                  alignment: CrossAxisAlignment.start,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label:
                  tabType == SalesReportTab.doWise ? 'DO Qty' : 'Total DO',
                  value: _formatQty(qty2),
                  alignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Disp.',
                  value: _formatQty(dispatchedQty),
                  alignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Bal.',
                  value: _formatQty(balanceQty),
                  alignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Trips',
                  value: trips?.toString() ?? '0',
                  alignment: CrossAxisAlignment.end,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CommonText.caption(
                'Date: ${_formatDate(poDate)}',
                color: const Color(0xFF777777),
              ),
            ),
            if (publishedOn != null)
              Expanded(
                child: CommonText.caption(
                  'Published: $publishedOn',
                  textAlign: TextAlign.right,
                  color: const Color(0xFF777777),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _formatQty(double? value) {
    if (value == null) return '0.00';
    return value.toStringAsFixed(1);
  }

  String _formatDate(String? date) {
    if (date == null || date.trim().isEmpty) return '-';
    if (date.contains('T')) return date.split('T').first;
    return date;
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;
  final TextAlign textAlign;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.alignment,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        CommonText.caption(
          label,
          textAlign: textAlign,
          fontSize: 11,
          color: const Color(0xFF777777),
        ),
        const SizedBox(height: 4),
        CommonText.h3(
          value,
          fontWeight: FontWeight.w600,
          color: AppColors.kPrimaryBlue,
          textAlign: textAlign,
          fontSize: 13,
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final String s = status.trim().toLowerCase();
    final bool isClosed = s == 'closed';
    final bool isPublished = s == 'publish' || s == 'published';

    final Color bgColor = isClosed
        ? const Color(0xFFFDE4E4)
        : isPublished
        ? const Color(0xFFE3F8EC)
        : const Color(0xFFFFF3E0);

    final Color textColor = isClosed
        ? const Color(0xFFD32F2F)
        : isPublished
        ? const Color(0xFF1E9E5C)
        : const Color(0xFFE65100);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CommonText.small(
        status,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}