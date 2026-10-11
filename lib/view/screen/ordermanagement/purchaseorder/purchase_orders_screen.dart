
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ut_lloyd_web_app/model/ordermanagement/purchaseorder/po_master_response.dart';
import 'package:ut_lloyd_web_app/utilities/common.dart';
import 'package:ut_lloyd_web_app/view/screen/ordermanagement/purchaseorder/po_detail_screen.dart';
import 'package:ut_lloyd_web_app/view_model/ordermanagement_view_model.dart';

import '../../../../utilities/common_dialog.dart';
import '../../../../utilities/common_widgets.dart';

class PurchaseOrdersScreen extends StatefulWidget {
  const PurchaseOrdersScreen({super.key});

  @override
  State<PurchaseOrdersScreen> createState() =>
      _PurchaseOrdersScreenState();
}

class _PurchaseOrdersScreenState extends State<PurchaseOrdersScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _purchaseOrders = [];

  // Count of rows currently displayed
  int _poMasterCount = 0;

  String _tenantCode = '';

  bool _isLoadingMore = false;

  // Filter state
  String? _appliedFilter;
  DateTime? _appliedFromDate;
  DateTime? _appliedToDate;

  final List<String> _filterOptions = const [
    'PO Number',
    'Material Code',
    'Material Description',
    'Material Group',
    'Plant Code',
    'Storage Location',
    'Item Category',
    'Account Assignment',
    'Status',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeData();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      _fetchPurchaseOrders(isLoadMore: true);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();

    _tenantCode = prefs.getString(Common.selectedTenant) ?? '';

    if (!mounted) return;

    await _fetchPurchaseOrders();
  }

  Future<void> _fetchPurchaseOrders({
    bool isLoadMore = false,
  }) async {
    final viewModel = context.read<OrderManagementViewModel>();

    if (isLoadMore) {
      if (_isLoadingMore ||
          viewModel.isPaginating ||
          !viewModel.hasMoreData) {
        return;
      }

      _isLoadingMore = true;
    }

    final now = DateTime.now();
    final defaultFrom = now.subtract(const Duration(days: 365));

    String isoDate(DateTime date) {
      return '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
    }

    final String searchQuery = _searchController.text.trim();

    String? poNumber;
    String? materialCode;
    String? materialDescription;
    String? materialGroup;
    String? plantCode;
    String? storageLocation;
    String? itemCategory;
    String? accountAssignment;
    String? status;
    String? globalSearch;

    if (searchQuery.isNotEmpty) {
      switch (_appliedFilter) {
        case 'PO Number':
          poNumber = searchQuery;
          break;

        case 'Material Code':
          materialCode = searchQuery;
          break;

        case 'Material Description':
          materialDescription = searchQuery;
          break;

        case 'Material Group':
          materialGroup = searchQuery;
          break;

        case 'Plant Code':
          plantCode = searchQuery;
          break;

        case 'Storage Location':
          storageLocation = searchQuery;
          break;

        case 'Item Category':
          itemCategory = searchQuery;
          break;

        case 'Account Assignment':
          accountAssignment = searchQuery;
          break;

        case 'Status':
          status = searchQuery;
          break;

        default:
          globalSearch = searchQuery;
          break;
      }
    }

    final int targetPage = isLoadMore
        ? viewModel.currentPage + 1
        : 1;

    final String fromDate = _appliedFromDate != null
        ? '${isoDate(_appliedFromDate!)} 00:00:00'
        : '${isoDate(defaultFrom)} 00:00:00';

    final String toDate = _appliedToDate != null
        ? '${isoDate(_appliedToDate!)} 23:59:59'
        : '${isoDate(now)} 23:59:59';

    debugPrint(
      '[PurchaseOrdersScreen] Fetching POs: '
          'page=$targetPage, '
          'loadMore=$isLoadMore, '
          'tenant=$_tenantCode, '
          'globalSearch=$globalSearch',
    );

    const int pageSize = 15;

    try {
      final success = await viewModel.fetchPOMasters(
        fromDate: fromDate,
        toDate: toDate,
        currentPage: targetPage,
        rowSize: pageSize,
        globalSearch: globalSearch,
        tenantCode: _tenantCode,
        poNumber: poNumber,
        materialCode: materialCode,
        materialDescription: materialDescription,
        materialGroup: materialGroup,
        plantCode: plantCode,
        storageLocation: storageLocation,
        itemCategory: itemCategory,
        accountAssignment: accountAssignment,
        status: status,
        isLoadMore: isLoadMore,
      );

      if (!mounted || !success) {
        debugPrint(
          '[PurchaseOrdersScreen] Fetch failed: '
              'page=$targetPage, success=$success',
        );
        return;
      }

      final List<PoMasterResponse> pageMasters =
          viewModel.purchaseOrderList;

      debugPrint(
        '[PurchaseOrdersScreen] Masters returned: '
            '${pageMasters.length}',
      );

      // Convert PO masters and their line items into display rows.
      final List<Map<String, dynamic>> newRows = pageMasters
          .expand(
            (master) => master.poLineItemDetails.isEmpty
            ? [_toCardData(master)]
            : master.poLineItemDetails.map(
              (line) => _toCardData(master, line),
        ),
      )
          .toList();

      if (!mounted) return;

      setState(() {
        if (isLoadMore) {
          // Append the newly fetched rows.
          _purchaseOrders.addAll(newRows);
        } else {
          // Replace the list for a fresh search/filter.
          _purchaseOrders = newRows;
        }

        // IMPORTANT:
        // Keep the count synchronized with displayed rows.
        _poMasterCount = _purchaseOrders.length;
      });

      debugPrint(
        '[PurchaseOrdersScreen] Fetch complete: '
            'newRows=${newRows.length}, '
            'displayedRows=${_purchaseOrders.length}, '
            'openOrdersCount=$_poMasterCount',
      );
    } catch (e, stackTrace) {
      debugPrint(
        '[PurchaseOrdersScreen] Error fetching POs: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoadingMore = false;
    }
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

            _fetchPurchaseOrders();
          },
        );
      },
    );
  }

  Map<String, dynamic> _toCardData(
      PoMasterResponse master, [
        PoLineItemDetail? line,
      ]) {
    final bool isAllocated = line != null &&
        line.quantity > 0 &&
        line.allocatedQuantity >= line.quantity;

    return {
      'master': master,
      'poNumber': master.poNumber,
      'poDate': master.poDate,
      'supplier': master.supplierName,
      'lineItem': line?.lineItemNumber ?? '-',
      'material': line?.materialDescription.isNotEmpty == true
          ? line!.materialDescription
          : line?.materialCode ?? '-',
      'quantity': line == null
          ? '-'
          : '${line.quantity} ${line.uom}',
      'allocated': line == null
          ? '-'
          : '${line.allocatedQuantity.toStringAsFixed(3)} ${line.uom}',
      'status': isAllocated ? 'Allocated' : 'Pending',
      'orderType': master.orderType,
    };
  }

  String _formatDate(Object? value) {
    final date = value?.toString().trim() ?? '';

    if (date.isEmpty || date == '-' || date == 'null') {
      return '-';
    }

    final parsed = DateTime.tryParse(date);

    if (parsed == null) {
      return date.split('T').first;
    }

    if (parsed.year <= 1) return '-';

    return '${parsed.day.toString().padLeft(2, '0')}-'
        '${parsed.month.toString().padLeft(2, '0')}-'
        '${parsed.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderManagementViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16, 12, 16, 8,
                  ),
                  child: _buildSearchRow(),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16, 8, 16, 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      viewModel.isLoading &&
                          _purchaseOrders.isEmpty
                          ? 'Loading Purchase Orders...'
                          : '$_poMasterCount Open Orders',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF131754),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: _buildList(viewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchRow() {
    return CommonSearchFilterRow(
      searchController: _searchController,
      hintText: _appliedFilter != null
          ? 'Search $_appliedFilter...'
          : 'Search for Order Number..',
      onSearch: () {
        _fetchPurchaseOrders();
      },
      onClear: () {
        setState(() {
          _appliedFilter = null;
          _appliedFromDate = null;
          _appliedToDate = null;
          _searchController.clear();
        });

        _fetchPurchaseOrders();
      },
      onFilterTap: _openFilterDialog,
    );
  }

  Widget _buildList(
      OrderManagementViewModel viewModel,
      ) {
    if (viewModel.isLoading && _purchaseOrders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF0878B8),
        ),
      );
    }

    if (_purchaseOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            viewModel.errorMessage ??
                'No purchase orders found',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF777777),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _purchaseOrders.length +
          (viewModel.isPaginating ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color(0xFFE5E7EB),
      ),
      itemBuilder: (_, index) {
        if (index == _purchaseOrders.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0878B8),
              ),
            ),
          );
        }

        return _buildPurchaseOrderRow(
          _purchaseOrders[index],
        );
      },
    );
  }

  Widget _buildPurchaseOrderRow(
      Map<String, dynamic> order,
      ) {
    final String status =
        order['status']?.toString() ?? '-';

    final bool isAllocated =
        status.toUpperCase() == 'ALLOCATED';

    final PoMasterResponse? master =
    order['master'] as PoMasterResponse?;

    void openDetails() {
      if (master == null) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PoDetailsScreen(poMaster: master),
        ),
      );
    }

    return InkWell(
      onTap: openDetails,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${order['poNumber']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF07507C),
                    ),
                  ),
                ),

                _chip(
                  order['orderType']?.toString() ?? '-',
                  const Color(0xFFE0F2FE),
                  const Color(0xFF0878B8),
                ),

                const SizedBox(width: 6),

                _chip(
                  status,
                  isAllocated
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEF3C7),
                  isAllocated
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFD97706),
                ),

                const SizedBox(width: 8),

                InkWell(
                  onTap: openDetails,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF0FA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Color(0xFF1C6DD0),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              order['material']?.toString() ?? '-',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              order['supplier']?.toString() ?? '-',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                _infoItem('Qty', order['quantity']),
                _infoItem(
                  'Allocated',
                  order['allocated'],
                ),
                Text(
                  _formatDate(order['poDate']),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(
      String text,
      Color background,
      Color foreground,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }

  Widget _infoItem(
      String label,
      Object? value,
      ) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
            ),
          ),
          TextSpan(
            text: value?.toString() ?? '-',
            style: const TextStyle(
              color: Color(0xFF0878B8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
