import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/ordermanagement/bulkdemand/bdo_request_model.dart';
import '../../../../model/ordermanagement/bulkdemand/bdo_response_model.dart';
import '../../../../utilities/common_dialog.dart';
import '../../../../utilities/common_widgets.dart';
import '../../../../view_model/ordermanagement_view_model.dart';

class BulkDemandBdoScreen extends StatefulWidget {
  const BulkDemandBdoScreen({super.key});

  @override
  State<BulkDemandBdoScreen> createState() => _BulkDemandBdoScreenState();
}

class _BulkDemandBdoScreenState extends State<    BulkDemandBdoScreen> {
  late final OrderManagementViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _tenantCode = 'LKOP';

  // TAB
  int _selectedTab = 0;

  final List<String> _tabs = const [
    'Open Bulk Demand',
    'Closed Bulk Demand',
  ];

  static const List<String> _tabTitles = [
    'Open Bulk Demand (BDO)',
    'Closed Bulk Demand (BDO)',
  ];

  bool get _isOpenTab => _selectedTab == 0;

  // FILTER STATES
  String? _appliedFilter;
  DateTime? _appliedFromDate;
  DateTime? _appliedToDate;

  final List<String> _filterOptions = const [
    'BDO Number',
    'Transport Mode',
    'Type',
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<OrderManagementViewModel>(context, listen: false);

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
    final savedTenant = prefs.getString('selectedTenant');
    if (savedTenant != null && savedTenant.isNotEmpty) {
      _tenantCode = savedTenant;
    }

    if (mounted) {
      _fetchData(isLoadMore: false);
    }
  }

  void _onTabChanged(int index) {
    if (index == _selectedTab) return;

    setState(() {
      _selectedTab = index;
      _appliedFilter = null;
      _appliedFromDate = null;
      _appliedToDate = null;
      _searchController.clear();
    });

    _fetchData(isLoadMore: false);
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    if (isLoadMore && (_viewModel.isPaginating || !_viewModel.hasMoreData)) {
      return;
    }

    final String searchQuery = _searchController.text.trim();

    String bdoNumber = '';
    String transportMode = '';
    String type = '';

    if (searchQuery.isNotEmpty) {
      if (_appliedFilter == 'BDO Number') {
        bdoNumber = searchQuery;
      } else if (_appliedFilter == 'Transport Mode') {
        transportMode = searchQuery;
      } else if (_appliedFilter == 'Type') {
        type = searchQuery;
      } else {
        bdoNumber = searchQuery;
      }
    }

    final int targetPage = isLoadMore ? (_viewModel.currentPage + 1) : 1;
    final String statusValue = _isOpenTab ? 'Open' : 'Close';

    // Format DateTime to YYYY-MM-DD
    final String? fromDateStr = _appliedFromDate != null
        ? "${_appliedFromDate!.year}-${_appliedFromDate!.month.toString().padLeft(2, '0')}-${_appliedFromDate!.day.toString().padLeft(2, '0')}"
        : null;

    final String? toDateStr = _appliedToDate != null
        ? "${_appliedToDate!.year}-${_appliedToDate!.month.toString().padLeft(2, '0')}-${_appliedToDate!.day.toString().padLeft(2, '0')}"
        : null;

    final request = BdoRequestModel(
      tenantCode: _tenantCode.isEmpty ? 'LKOP' : _tenantCode,
      status: statusValue,
      bdoNumber: bdoNumber,
      transportMode: transportMode,
      type: type,
      currentPage: targetPage,
      rowSize: 15,

    );

    try {
      await _viewModel.fetchPaginatedBdoList(
        request: request,
        isLoadMore: isLoadMore,
      );
    } catch (e) {
      debugPrint("Error fetching BDO list: $e");
    }
  }
  Widget _buildSearchRow() {
    return CommonSearchFilterRow(
      searchController: _searchController,
      hintText: _appliedFilter != null
          ? 'Search $_appliedFilter...'
          : 'Search for Order Number..',
      onSearch: () => _fetchData(isLoadMore: false),
      onClear: () => _fetchData(isLoadMore: false),
      onFilterTap: _openFilterDialog,
    );
  }
  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CommonDateFilterPopup(
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

            // Trigger API fetch with selected filters
            _fetchData(isLoadMore: false);
          },
        );
      },
    );
  }


  void _openDetails(BdoResponseModel item) {
    // TODO: Navigate to Bulk Demand Details screen, e.g.
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (_) => BulkDemandDetailsScreen(order: item),
    // ));
    debugPrint('Open details tapped for BDO: ${item.bdoNumber}');
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (int i = 0; i < _tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: 24),
            _buildTabItem(i, _tabs[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final bool isSelected = _selectedTab == index;

    return InkWell(
      onTap: () => _onTabChanged(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF1C6DD0)
                    : const Color(0xFF9AA6AF),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2,
              width: 26,
              color: isSelected ? const Color(0xFF1C6DD0) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderManagementViewModel>(
      builder: (context, viewModel, child) {
        final List<BdoResponseModel> orders = viewModel.bdoList;
        final bool hasSearchText = _searchController.text.trim().isNotEmpty;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // CommonPageHeader(title: _tabTitles[_selectedTab]),
                // const Divider(height: 1, color: Color(0xFFE1E3E8)),
                _buildTabs(),
                const Divider(height: 1, color: Color(0xFFE1E3E8)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _buildSearchRow(),
                ),
                // ITEM COUNT
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      viewModel.isLoading
                          ? 'Loading...'
                          : orders.isEmpty
                          ? '0 ${_isOpenTab ? 'Open' : 'Closed'} Orders'
                          : '${orders.length} ${_isOpenTab ? 'Open' : 'Closed'} Orders',
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
                  child: viewModel.isLoading && orders.isEmpty
                      ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF1C6DD0)),
                  )
                      : orders.isEmpty
                      ? const Center(
                    child: Text(
                      "No bulk demand orders found",
                      style: TextStyle(color: Color(0xFF777777)),
                    ),
                  )
                      : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: orders.length +
                        (viewModel.isPaginating ? 1 : 0),
                    separatorBuilder: (context, index) =>
                    const Divider(
                        height: 1, color: Color(0xFFE1E3E8)),
                    itemBuilder: (context, index) {
                      if (index == orders.length) {
                        return const Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1C6DD0),
                            ),
                          ),
                        );
                      }

                      return _BulkDemandCard(
                        item: orders[index],
                        onTap: () => _openDetails(orders[index]),
                      );
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


class _BulkDemandCard extends StatelessWidget {
  final BdoResponseModel item;
  final VoidCallback? onTap;

  const _BulkDemandCard({
    required this.item,
    this.onTap,
  });

  ({Color bg, Color fg}) get _statusColors {
    final statusStr = item.status.trim().toLowerCase();
    switch (statusStr) {
      case 'open':
      case 'active':
        return (bg: const Color(0xFFE3F8EC), fg: const Color(0xFF1E9E5C));
      case 'close':
      case 'closed':
        return (bg: const Color(0xFFFDE4E4), fg: const Color(0xFFD32F2F));
      default:
        return (bg: const Color(0xFFEAF0FA), fg: const Color(0xFF1C6DD0));
    }
  }

  static String _formatQty(double value) {
    final int intVal = value.toInt();
    final String digits = intVal.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      final int posFromEnd = digits.length - i;
      buffer.write(digits[i]);
      if (posFromEnd > 1 && (posFromEnd - 1) % 3 == 0) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = _statusColors;

    // Calculate quantities
    final double balance = item.remainingQuantity;
    final double demand = item.quantity;
    final double dispatched = demand - balance;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Row: BDO Number, Type Badge, Status Badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.bdoNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
                if (item.type.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF0FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.type,
                      style: const TextStyle(
                        color: Color(0xFF1C6DD0),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColors.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: statusColors.fg,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 2. Permit Purpose
            Text(
              item.permitPurpose,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4A5671),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            // 3. Mineral Rate (royaltyRate)
            Row(
              children: [
                const Text(
                  'Mineral Rate: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '₹${item.royaltyRate.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1C6DD0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 4. Quantities: Demand, Dispatched, Balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(title: 'Demand', value: _formatQty(demand)),
                _InfoItem(title: 'Dispatched', value: _formatQty(dispatched)),
                _InfoItem(title: 'Balance', value: _formatQty(balance)),
              ],
            ),

            const SizedBox(height: 12),

            // 5. Route Code & Transport Mode
            Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  size: 16,
                  color: Color(0xFF1C6DD0),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.routeCode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4A5671),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    item.transportMode,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4A5671),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF777777),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF131754),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}