import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_lloyd_web_app/view_model/management_report_view_model.dart';

import '../../../../model/reports/salereport/sales_order_model.dart';
import '../../../../model/reports/salereport/so_sc_po_model.dart';
import '../../../../utilities/app_colors.dart';
import '../../../../utilities/common.dart';
import '../../../../utilities/common_dialog.dart';
import '../../../../utilities/common_text.dart';
import '../../../../utilities/common_widgets.dart';

class MGMSalesReportScreen extends StatefulWidget {
  const MGMSalesReportScreen({super.key});

  @override
  State<MGMSalesReportScreen> createState() => _MGMSalesReportScreenState();
}

class _MGMSalesReportScreenState extends State<MGMSalesReportScreen> {
  final MGMReportsViewModel _viewModel = MGMReportsViewModel();
  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  final String _tenantCode = '';
  SalesReportTab _selectedTab = SalesReportTab.doWise;

  String? _appliedFilter;
  DateTime? _appliedFromDate;
  DateTime? _appliedToDate;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Add pagination listener
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
    //_tenantCode = prefs.getString(Common.selectedTenant) ?? '';

    if (mounted) {
      _fetchData(isLoadMore: false);
    }
  }

  int _getTabIndex(SalesReportTab tab) {
    switch (tab) {
      case SalesReportTab.doWise: return 0;
      case SalesReportTab.soWise: return 1;
      case SalesReportTab.scWise: return 2;
      case SalesReportTab.customerPoWise: return 3;
    }
  }

  void _onTabChanged(SalesReportTab tab) {
    setState(() {
      _selectedTab = tab;
      // Reset search and filters when swapping tabs
      _appliedFilter = null;
      _searchController.clear();
    });

    _viewModel.switchTab(_getTabIndex(tab), _tenantCode);
  }

  List<String> _getFilterOptionsForTab() {
    if (_selectedTab == SalesReportTab.doWise) {
      return ['DO Number', 'SO Number', 'Destination', 'Customer Name', 'Customer Reference', 'Material Name', 'Material Code'];
    } else if (_selectedTab == SalesReportTab.soWise) {
      return ['SO Number', 'Destination', 'Customer Name', 'Customer Reference', 'Material Name', 'Material Code'];
    } else if (_selectedTab == SalesReportTab.scWise) {
      return ['Sales Contract Number', 'SO Number', 'Destination', 'Customer Name', 'Customer Reference', 'Material Name', 'Material Code'];
    } else {
      return ['Customer Reference', 'SO Number', 'Destination', 'Customer Name', 'Material Name', 'Material Code'];
    }
  }

  String? _getApiFilterKey(String? filterName) {
    switch (filterName) {
      case 'SO Number': return 'soNumber';
      case 'DO Number': return 'cdoNumber';
      case 'Destination': return 'shipLocation';
      case 'Customer Name': return 'customerName';
      case 'Customer Reference': return 'customerReference';
      case 'Material Name': return 'materialName';
      case 'Material Code': return 'materialCode';
      case 'Sales Contract Number': return 'salesContractNumber';
      default: return null;
    }
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    final String searchQuery = _searchController.text.trim();
    final String? filterKey = _getApiFilterKey(_appliedFilter);

    // Dynamic payload mapping based on active filter
    String cdoNumber = "";
    String customerName = "";
    String customerReference = "";
    String materialCode = "";
    String materialName = "";
    String soNumber = "";
    String salesContractNumber = "";

    if (filterKey != null && searchQuery.isNotEmpty) {
      if (filterKey == 'cdoNumber') cdoNumber = searchQuery;
      if (filterKey == 'customerName') customerName = searchQuery;
      if (filterKey == 'customerReference') customerReference = searchQuery;
      if (filterKey == 'materialCode') materialCode = searchQuery;
      if (filterKey == 'materialName') materialName = searchQuery;
      if (filterKey == 'soNumber') soNumber = searchQuery;
      if (filterKey == 'salesContractNumber') salesContractNumber = searchQuery;
    }

    // Set dates in viewmodel if they were updated via filter
    if (_appliedFromDate != null && _appliedToDate != null) {
      final String fromStr = "${_appliedFromDate!.toIso8601String().split('T').first} 00:00:00";
      final String toStr = "${_appliedToDate!.toIso8601String().split('T').first} 23:59:59";
      _viewModel.fromDate = fromStr;
      _viewModel.toDate = toStr;
    }

    await _viewModel.fetchData(
      tenantCode: _tenantCode,
      isLoadMore: isLoadMore,
      globalSearch: filterKey == null ? searchQuery : "", // Only use global if no specific filter
      cdoNumber: cdoNumber,
      customerName: customerName,
      customerReference: customerReference,
      materialCode: materialCode,
      materialName: materialName,
      soNumber: soNumber,
      salesContractNumber: salesContractNumber,
    );
  }

  Widget _buildSearchRow() {
    final bool hasSearchText = _searchController.text.trim().isNotEmpty;

    return Row(
      children: [
        // SEARCH BOX
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
                    onSubmitted: (_) {
                      _fetchData(isLoadMore: false);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search SO, CDO, Customer...',
                      hintStyle: TextStyle(color: AppColors.kTextGrey, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    /*decoration: InputDecoration(
                      hintText: _appliedFilter != null ? 'Search $_appliedFilter...' : 'Search...',
                      hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),*/
                  ),
                ),

                // Clear Button (only shows if there is text)
                if (hasSearchText)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _fetchData(isLoadMore: false);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.close, size: 18, color: Color(0xFF777777)),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // SEARCH BUTTON
        InkWell(
          onTap: () {
            _fetchData(isLoadMore: false);
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FA),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.search, color: Color(0xFF1C6DD0), size: 20),
          ),
        ),

        const SizedBox(width: 8),

        // FILTER BUTTON (RESTORED)
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) {
                return CommonDateFilterPopup(
                  filterOptions: _getFilterOptionsForTab(),
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
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FA), // Light blue background
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/filter.png',
              width: 18,
              height: 18,
              color: const Color(0xFF1C6DD0), // Darker brand blue
            ),
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
          CommonText.h4('No orders found', fontWeight: FontWeight.w600, color: const Color(0xFF131754)),
          const SizedBox(height: 4),
          CommonText.caption('Try searching with another keyword or filter.', color: const Color(0xFF777777)),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_viewModel.isLoading && _viewModel.doList.isEmpty && _viewModel.soscpoList.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF1C6DD0)));
    }

    final isDoTab = _selectedTab == SalesReportTab.doWise;
    final int itemCount = isDoTab ? _viewModel.doList.length : _viewModel.soscpoList.length;

    if (itemCount == 0) {
      return _buildEmptyState();
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      itemCount: itemCount + (_viewModel.isPaginating ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(height: 24, color: Color(0xFFE1E3E8)),
      itemBuilder: (context, index) {
        if (index == itemCount) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator(color: Color(0xFF1C6DD0))),
          );
        }

        if (isDoTab) {
          return _OrderCard.fromDoWise(
              order: _viewModel.doList[index],
              tabType: _selectedTab
          );
        } else {
          return _OrderCard.fromOtherWise(
              order: _viewModel.soscpoList[index],
              tabType: _selectedTab
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MGMReportsViewModel>.value(
      value: _viewModel,
      child: Consumer<MGMReportsViewModel>(
        builder: (context, viewModel, child) {
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

                  // SEARCH
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                    child: _buildSearchRow(),
                  ),

                  // RESULTS COUNT
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CommonText.h4(
                        viewModel.isLoading
                            ? 'Loading Orders...'
                            : '${_selectedTab == SalesReportTab.doWise ? viewModel.doList.length : viewModel.soscpoList.length} Open Orders',
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF131754),
                      ),
                    ),
                  ),

                  // LIST
                  Expanded(
                    child: _buildOrdersList(),
                  ),
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
    super.dispose();
  }
}

// ============================================================================
// DYNAMIC ORDER CARD
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

  // 1. DO WISE MAPPER
  _OrderCard.fromDoWise({
    required SalesReportResponse order,
    required this.tabType,
  })  : primaryTitle = 'SO',
        primaryValue = order.soNumber?.toString() ?? '-',
        secondaryTitle = 'CDO',
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

  // 2. SO / SC / PO WISE MAPPER
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
        qty1 = tabType == SalesReportTab.scWise ? order.salesContractQuantity : order.soQuantity,
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

  static String _getPrimaryValue(SalesSOSCPOResponse order, SalesReportTab tab) {
    if (tab == SalesReportTab.soWise) return order.soNumber?.toString() ?? '-';
    if (tab == SalesReportTab.scWise) return order.salesContractNumber ?? '-';
    return order.customerReference ?? '-';
  }

  static String _getSecondaryTitle(SalesReportTab tab) {
    if (tab == SalesReportTab.soWise) return 'Cust Ref';
    return 'SO';
  }

  static String _getSecondaryValue(SalesSOSCPOResponse order, SalesReportTab tab) {
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
        CommonText.caption('$secondaryTitle: $secondaryValue', color: const Color(0xFF777777)),
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

        // STATS BOX
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
                  label: tabType == SalesReportTab.doWise ? 'CDO Qty' : 'Total DO',
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

        // FOOTER DETAILS
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
                  'Published: ${publishedOn ?? '-'}',
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
    if (date == null || date.trim().isEmpty || date == "01-01-0001") return '-';
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
    final String normalizedStatus = status.trim().toLowerCase();
    final bool isClosed = normalizedStatus == 'closed';
    final bool isPublished = normalizedStatus == 'publish' || normalizedStatus == 'published';

    final Color bgColor = isClosed
        ? const Color(0xFFFDE4E4)
        : isPublished ? const Color(0xFFE3F8EC) : const Color(0xFFFFF3E0);

    final Color textColor = isClosed
        ? const Color(0xFFD32F2F)
        : isPublished ? const Color(0xFF1E9E5C) : const Color(0xFFE65100);

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