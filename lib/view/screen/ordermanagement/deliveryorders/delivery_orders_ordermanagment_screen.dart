import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/ordermanagement/deliveryorders/delivery_orders_request_model.dart';
import '../../../../model/ordermanagement/deliveryorders/delivery_orders_response_model.dart';
import '../../../../utilities/common.dart';
import '../../../../utilities/common_dialog.dart';
import '../../../../utilities/common_widgets.dart';
import '../../../../view_model/ordermanagement_view_model.dart';
import 'delivery_orders_detail_ordermanagment_screen.dart';

class DeliveryOrderListScreen extends StatefulWidget {
  const DeliveryOrderListScreen({super.key});

  @override
  State<DeliveryOrderListScreen> createState() =>
      _DeliveryOrderListScreenState();
}

class _DeliveryOrderListScreenState extends State<DeliveryOrderListScreen> {
  late final OrderManagementViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _tenantCode = '';

  // TAB
  int _selectedTab = 0;
  final List<String> _tabs = const [
    'Open',
    'Closed',
    'Completed',
  ];

  bool? get _multiVehicleParam {
    if (_appliedMultiVehicle == 'Yes') return true;
    if (_appliedMultiVehicle == 'No') return false;
    return null;
  }

  // Adjusted tab flags to handle index-based states
  bool get _isOpenTab => _selectedTab == 0;
  bool get _isClosedTab => _selectedTab == 1;
  bool get _isCompletedTab => _selectedTab == 2;

  String? _appliedFilter;
  String? _appliedMultiVehicle;
  String? _appliedOrderType;

  final List<String> _filterOptions = const [
    'CDO Number',
    'BDO Number',
    'Location Name',
    'Material Name',
    'Customer Name',
    'STO Number',
    'SO Number',
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
    final savedTenant = prefs.getString(Common.selectedTenant);
    if (savedTenant != null && savedTenant.isNotEmpty) {
      _tenantCode = savedTenant;
    }

    if (mounted) {
      await Future.wait([
        _viewModel.fetchActiveTransporterList(),
        _fetchData(isLoadMore: false),
      ]);
    }
  }

  void _onTabChanged(int index) {
    if (index == _selectedTab) return;

    setState(() {
      _selectedTab = index;
      _appliedFilter = null;
      _appliedMultiVehicle = null;
      _appliedOrderType = null;
      _searchController.clear();
    });

    // Clear existing view model list content on tab change to prevent mixing data
    _viewModel.cdoList.clear();
    _fetchData(isLoadMore: false);
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    if (isLoadMore && (_viewModel.isPaginating || !_viewModel.hasMoreData)) {
      return;
    }

    final String searchQuery = _searchController.text.trim();
    String? cdoNumber;
    String? bdoNumber;
    String? locationName;
    String? stoNumber;
    String? customerName;
    String? materialName;
    String? soNumber;
    String? orderType;
    String? globalSearch;

    if (searchQuery.isNotEmpty) {
      switch (_appliedFilter) {
        case 'CDO Number':
          cdoNumber = searchQuery;
          break;
        case 'BDO Number':
          bdoNumber = searchQuery;
          break;
        case 'Location Name':
          locationName = searchQuery;
          break;
        case 'Material Name':
          materialName = searchQuery;
          break;
        case 'Customer Name':
          customerName = searchQuery;
          break;
        case 'STO Number':
          stoNumber = searchQuery;
          break;
        case 'SO Number':
          soNumber = searchQuery;
          break;
        default:
          globalSearch = searchQuery;
          break;
      }
    }

    final int targetPage = isLoadMore ? (_viewModel.currentPage + 1) : 1;

    // Explicit status mapping based on the active tab
    // Note: If your API supports multiple statuses or lists for a single request,
    // you can adjust how status is passed to CdoFilterRequestModel.
    String? statusParam;
    bool? isActiveParam;

    if (_isOpenTab) {
      // Open tab displays both Publish and Pending items
      // If your backend accepts a status list, pass it accordingly; otherwise,
      // check if it handles single status strings or uses isActive: true.
      isActiveParam = true;
    } else if (_isClosedTab) {
      statusParam = 'Closed';
      isActiveParam = false;
    } else if (_isCompletedTab) {
      statusParam = 'Completed'; // handles variations like 'Complete' or 'Completed'
      isActiveParam = false;
    }

    final request = CdoFilterRequestModel(
      tenantCode: _tenantCode,
      currentPage: targetPage,
      rowSize: 15,
      cdoNumber: cdoNumber,
      bdoNumber: bdoNumber,
      mdoNumber: locationName,
      stoNumber: stoNumber,
      customerName: customerName,
      materialName: materialName,
      orderType: orderType ?? _appliedOrderType,
      isActive: isActiveParam,
      status: statusParam, // Passes the respective tab status filter to the backend
      globalSearch: globalSearch,
      isMultiVehicle: _multiVehicleParam,
    );

    try {
      await _viewModel.fetchFilterCDODetails(
        request: request,
        isLoadMore: isLoadMore,
      );
    } catch (e) {
      debugPrint("Error fetching CDO list: $e");
    }
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return DeliveryOrdersFilterPopup(
          filterOptions: _filterOptions,
          selectedMultiVehicle: _appliedMultiVehicle,
          selectedFilter: _appliedFilter,
          onApply: (filter, multiVehicle) {
            setState(() {
              _appliedMultiVehicle = multiVehicle;
              _appliedFilter = filter;
            });

            _fetchData(isLoadMore: false);
          },
        );
      },
    );
  }

  void _openDetails(CdoFilterResponseModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeliveryOrdersdetailOrdermanagmentScreen(
          order: order,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          return _buildTabItem(index, _tabs[index]);
        },
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final bool isSelected = _selectedTab == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () => _onTabChanged(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0878B8)
                    : const Color(0xFF9AA6AF),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2,
              width: 40,
              color: isSelected ? const Color(0xFF0878B8) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
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

  String get _currentTabLabel {
    if (_isOpenTab) return 'Open';
    if (_isClosedTab) return 'Closed';
    if (_isCompletedTab) return 'Completed';
    return 'Completed';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderManagementViewModel>(
      builder: (context, viewModel, child) {
        final List<CdoFilterResponseModel> orders = List.from(viewModel.cdoList);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildTabs(),
                const Divider(height: 1, color: Color(0xFFE1E3E8)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _buildSearchRow(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      viewModel.isLoading && orders.isEmpty
                          ? 'Loading...'
                          : '${orders.length} $_currentTabLabel Orders',
                      style: const TextStyle(
                        color: Color(0xFF131754),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE1E3E8)),
                Expanded(
                  child: viewModel.isLoading && orders.isEmpty
                      ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF0878B8)),
                  )
                      : orders.isEmpty
                      ? Center(
                    child: viewModel.errorMessage != null
                        ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 32,
                              color: Color(0xFFD32F2F)),
                          const SizedBox(height: 8),
                          const Text(
                            'Failed to load delivery orders',
                            style: TextStyle(
                              color: Color(0xFF131754),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            viewModel.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color(0xFF777777),
                                fontSize: 12),
                          ),
                        ],
                      ),
                    )
                        : const Text(
                      "No delivery orders found",
                      style:
                      TextStyle(color: Color(0xFF777777)),
                    ),
                  )
                      : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding:
                      const EdgeInsets.symmetric(vertical: 8),
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
                                color: Color(0xFF0878B8),
                              ),
                            ),
                          );
                        }

                        return _DeliveryOrderTile(
                          order: orders[index],
                          onTap: () => _openDetails(orders[index]),
                          onMenuSelected: (action) {
                            if (action == 'view') {
                              _openDetails(orders[index]);
                            }
                          },
                        );
                      },
                    ),
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

class _DeliveryOrderTile extends StatelessWidget {
  final CdoFilterResponseModel order;
  final VoidCallback? onTap;
  final ValueChanged<String>? onMenuSelected;

  const _DeliveryOrderTile({
    required this.order,
    this.onTap,
    this.onMenuSelected,
  });

  String get _doNumber => order.cdoNumber.toString();
  String get _orderType => order.transactionType;
  String get _status => order.status;
  String get _material => order.materialName;
  String get _balanceQuantity => _formatQty(order.doBalanceQty);
  String get _locationName =>
      order.locationName ?? order.customerLocation ?? order.city ?? '-';

  String get _orderDate {
    final String direct = _formatDate(order.createdDate ?? order.publishedOn);
    if (direct != '-') return direct;

    try {
      final dynamic json = (order as dynamic).toJson();
      if (json is Map) {
        for (final entry in json.entries) {
          final String key = entry.key.toString().toLowerCase();
          if (!key.contains('date')) continue;
          final dynamic value = entry.value;
          if (value == null) continue;
          final String formatted = _formatDate(value);
          if (formatted != '-') {
            return formatted;
          }
        }
      }
    } catch (_) {}

    return '-';
  }

  static String _formatQty(double? value) {
    if (value == null) return '-';
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  static String _formatDate(dynamic rawDate) {
    if (rawDate == null) return '-';

    DateTime? dt;
    if (rawDate is DateTime) {
      dt = rawDate;
    } else if (rawDate is String) {
      if (rawDate.isEmpty) return '-';
      dt = DateTime.tryParse(rawDate);
      if (dt == null) return rawDate.split('T').first;
    }

    if (dt == null) return '-';

    final String d = dt.day.toString().padLeft(2, '0');
    final String m = dt.month.toString().padLeft(2, '0');
    return '$d-$m-${dt.year}';
  }

  ({Color bg, Color fg}) get _statusColors {
    switch (_status.trim().toLowerCase()) {
      case 'publish':
      case 'published':
      case 'open':
        return (bg: const Color(0xFFE4F7E8), fg: const Color(0xFF248A3D));
      case 'closed':
        return (bg: const Color(0xFFFDE4E4), fg: const Color(0xFFD32F2F));
      case 'completed':
        return (bg: const Color(0xFFE0F2FE), fg: const Color(0xFF0369A1));
      case 'pending':
        return (bg: const Color(0xFFFFF1D6), fg: const Color(0xFFB88600));
      default:
        return (bg: const Color(0xFFEAF6FC), fg: const Color(0xFF0878B8));
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = _statusColors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _doNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF131754),
                  ),
                ),
                const SizedBox(width: 10),
                if (_orderType.isNotEmpty) ...[
                  _chip(_orderType, const Color(0xFFEAF6FC),
                      const Color(0xFF0878B8)),
                  const SizedBox(width: 6),
                ],
                _chip(_status, statusColors.bg, statusColors.fg),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (onMenuSelected != null) {
                      onMenuSelected!('view');
                    }
                  },
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF0FA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 13,
                      color: Color(0xFF1C6DD0),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _material,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF606770),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text(
                  'Bal. Qty ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF606770),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  _balanceQuantity,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0878B8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: Color(0xFF0878B8),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    _locationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF606770),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _orderDate,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}