import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_lloyd_web_app/utilities/common_widgets.dart';
import 'package:ut_lloyd_web_app/view/screen/ordermanagement/sostoorders/sosto_ordermanagment_detail_screen.dart';
import '../../../../../model/ordermanagement/sosto/filter_mdo_master_request_model.dart';
import '../../../../../model/ordermanagement/sosto/filter_sto_master_request.dart';
import '../../../../../model/ordermanagement/sosto/mdo_response.dart';
import '../../../../../model/ordermanagement/sosto/sto_master_response.dart';
import '../../../../../utilities/common.dart';
import '../../../../../view_model/ordermanagement_view_model.dart';
import '../../../../utilities/app_colors.dart';
import '../../../../utilities/common_dialog.dart';
import '../../../../utilities/common_text.dart';

class SostoOrdermanagementScreen extends StatefulWidget {
  const SostoOrdermanagementScreen({super.key});

  @override
  State<SostoOrdermanagementScreen> createState() =>
      _SostoOrdermanagementScreenState();
}

class _SostoOrdermanagementScreenState
    extends State<SostoOrdermanagementScreen> {
  late final OrderManagementViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _tenantCode = '';
  int _selectedTab = 0;
  bool _isLoadingMore = false;

  final Map<int, String> _tabsMap = const {
    0: 'Open SO',
    1: 'Open STO',
    2: 'Close SO',
    3: 'Close STO',
  };



  bool get _isSoTab => _selectedTab == 0 || _selectedTab == 2;

  bool get _isOpenTab => _selectedTab == 0 || _selectedTab == 1;

  // Filter State Variables
  String? _appliedFilter;
  DateTime? _appliedFromDate;
  DateTime? _appliedToDate;

  final List<String> _soFilterOptions = const [
    'Order Number',
    'BDO Number',
    'Material Name',
    'Division',
    'Customer Reference',
    'Order Type',
    'Sender Plant',
    'Sold To Party',
  ];

  final List<String> _stoFilterOptions = const [
    'stoNumber',
    'BDO Number',
    'Order Type',
    'Sender Plant Name',
  ];

  List<String> get _filterOptions =>
      _isSoTab ? _soFilterOptions : _stoFilterOptions;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<OrderManagementViewModel>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (!_isLoadingMore &&
            !_viewModel.isPaginating &&
            _viewModel.hasMoreData) {
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
    if (isLoadMore) {
      if (_isLoadingMore ||
          _viewModel.isPaginating ||
          !_viewModel.hasMoreData) {
        debugPrint(
          '[SostoOrdermanagementScreen] Skipping load-more — '
          'isLoadingMore: $_isLoadingMore, isPaginating: ${_viewModel.isPaginating}, '
          'hasMoreData: ${_viewModel.hasMoreData}',
        );
        return;
      }
      _isLoadingMore = true;
    }

    final String searchQuery = _searchController.text.trim();
    final int targetPage = isLoadMore ? (_viewModel.currentPage + 1) : 1;
    final String statusValue = _isOpenTab ? 'Open' : 'Closed';

    try {
      debugPrint(
        '[SostoOrdermanagementScreen] Fetching ${_isSoTab ? 'SO' : 'STO'} — '
        'tab: ${_tabsMap[_selectedTab]}, status: $statusValue, page: $targetPage, '
        'rowSize: 15, isLoadMore: $isLoadMore, filter: $_appliedFilter, search: "$searchQuery"',
      );
      if (_isSoTab) {
        int mdoNumber = 0;
        String? bdoNumber;
        String? productName;
        String? customerReference;
        String? orderType;
        String? senderPlantName;
        String? soldToPartyName;
        String? division;

        if (searchQuery.isNotEmpty) {
          switch (_appliedFilter) {
            case 'Order Number':
              mdoNumber = int.tryParse(searchQuery) ?? 0;
              break;
            case 'BDO Number':
              bdoNumber = searchQuery;
              break;
            case 'Material Name':
              productName = searchQuery;
              break;
            case 'Division':
              division = searchQuery;
              break;
            case 'Customer Reference':
              customerReference = searchQuery;
              break;
            case 'Order Type':
              orderType = searchQuery;
              break;
            case 'Sender Plant':
              senderPlantName = searchQuery;
              break;
            case 'Sold To Party':
              soldToPartyName = searchQuery;
              break;
            default:
              mdoNumber = int.tryParse(searchQuery) ?? 0;
              break;
          }
        }

        final request = FilterMdoMasterRequest(
          status: statusValue,
          tenantCode: _tenantCode,
          currentPage: targetPage,
          rowSize: 15,
          filter: _appliedFilter ?? '',
          mdoNumber: mdoNumber,
          bdoNumber: bdoNumber,
          productName: productName,
          customerReference: customerReference,
          orderType: orderType,
          senderPlantName: senderPlantName,
          soldToPartyName: soldToPartyName,
          division: division,
        );

        if (division != null) {
          debugPrint(
            '[SostoOrdermanagementScreen] Division filter selected ("$division") but '
            'FilterMdoMasterRequest has no division field yet — not sent to the API.',
          );
        }
        await _viewModel.fetchFilterMDOMasters(
          request: request,
          isLoadMore: isLoadMore,
        );

        if (!mounted) return;

        final int mdoCountRaw = _viewModel.mdoList.length;
        final int mdoCountDeduped = _dedupedMdoList(_viewModel).length;
        final int lineItemCount = _viewModel.mdoList.fold<int>(
          0,
          (sum, master) => sum + (master.mdoDetails?.length ?? 0),
        );

        debugPrint(
          '[SostoOrdermanagementScreen] SO fetch complete — '
          'page: $targetPage, mdoList count (raw): $mdoCountRaw, '
          'mdoList count (deduped): $mdoCountDeduped, '
          'total line items across masters: $lineItemCount, '
          'hasMoreData: ${_viewModel.hasMoreData}',
        );
      }
      else {

        int stoNumber = 0;
        String? bdoNumber;
        String? orderType;
        String? senderPlantName;

        if (searchQuery.isNotEmpty) {
          switch (_appliedFilter) {
            case 'stoNumber':
              stoNumber = int.tryParse(searchQuery) ?? 0;
              break;

              case 'BDO Number':
              bdoNumber = searchQuery;
              break;
            case 'Order Type':
              orderType = searchQuery;
              break;
            case 'Sender Plant Name':
              senderPlantName = searchQuery;
              break;
            default:
              stoNumber = int.tryParse(searchQuery) ?? 0;
              break;
          }
        }

        final request = FilterStoMasterRequest(
          companyCode: '',
          soldToParty: '',
          senderPlant: '',
          status: statusValue,
          purchaseOrganization: '',
          receiverPlant: '',
          tenantCode: _tenantCode,
          currentPage: targetPage,
          rowSize: 15,
          stoNumber: stoNumber,
          bdoNumber: bdoNumber,
          orderType: orderType,
          senderPlantName: senderPlantName,
        );

        await _viewModel.fetchFilterSTOMasters(
          request: request,
          isLoadMore: isLoadMore,
        );

        if (!mounted) return;

        final int stoMasterCountRaw = _viewModel.stoList.length;
        final List<StoMaster> dedupedStoMasters = _dedupedStoList(_viewModel);
        final int stoMasterCountDeduped = dedupedStoMasters.length;
        final int stoCardCount = dedupedStoMasters.fold<int>(
          0,
          (sum, master) =>
              sum + (master.stoDetails.isEmpty ? 1 : master.stoDetails.length),
        );
        debugPrint(
          '[SostoOrdermanagementScreen] STO fetch complete — '
          'page: $targetPage, stoList count (raw): $stoMasterCountRaw, '
          'stoList count (deduped): $stoMasterCountDeduped, '
          'expanded card count (deduped masters + details): $stoCardCount, '
          'hasMoreData: ${_viewModel.hasMoreData}',
        );
      }
    } finally {
      if (isLoadMore) _isLoadingMore = false;
    }
  }

  List<MdoMaster> _dedupedMdoList(OrderManagementViewModel viewModel) {
    final Set<String> seen = {};
    final List<MdoMaster> result = [];
    for (final master in viewModel.mdoList) {
      final String key =
          master.mdoNumber?.toString() ?? master.hashCode.toString();
      if (seen.add(key)) {
        result.add(master);
      }
    }
    return result;
  }

  List<StoMaster> _dedupedStoList(OrderManagementViewModel viewModel) {
    final Set<String> seen = {};
    final List<StoMaster> result = [];
    for (final master in viewModel.stoList) {
      final String key = master.stoNumber.toString();
      if (seen.add(key)) {
        result.add(master);
      }
    }
    return result;
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

            _fetchData(isLoadMore: false);
          },
        );
      },
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CommonTabBar<int>(
        selectedTab: _selectedTab,
        tabs: _tabsMap,
        onTabChanged: _onTabChanged,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderManagementViewModel>(
      builder: (context, viewModel, child) {
        final int itemCount = _isSoTab
            ? _dedupedMdoList(viewModel).length
            : _dedupedStoList(viewModel).length;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildTabs(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _buildSearchRow(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      viewModel.isLoading
                          ? 'Loading Orders...'
                          : '$itemCount ${_isOpenTab ? 'Open' : 'Closed'} Orders',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF131754),
                      ),
                    ),
                  ),
                ),
                Expanded(child: _buildList(viewModel)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(OrderManagementViewModel viewModel) {
    final List<MdoMaster> dedupedSoList = _dedupedMdoList(viewModel);
    final List<StoMaster> dedupedStoMasterList = _dedupedStoList(viewModel);

    final bool isEmpty =
        _isSoTab ? dedupedSoList.isEmpty : dedupedStoMasterList.isEmpty;

    if (viewModel.isLoading && isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0878B8)),
      );
    }

    if (isEmpty) {
      return Center(
        child: viewModel.errorMessage != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  viewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF777777)),
                ),
              )
            : const Text(
                'No orders found',
                style: TextStyle(color: Color(0xFF777777)),
              ),
      );
    }

    if (_isSoTab) {
      debugPrint(
        '[SostoOrdermanagementScreen] Rendering SO list — '
        'rows: ${dedupedSoList.length}',
      );
      return ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dedupedSoList.length + (viewModel.isPaginating ? 1 : 0),
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
        itemBuilder: (context, index) {
          if (index == dedupedSoList.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF0878B8)),
              ),
            );
          }
          return _SoCard(order: dedupedSoList[index]);
        },
      );
    }

    final List<_StoCardData> stoCards = [];
    for (final master in dedupedStoMasterList) {
      if (master.stoDetails.isEmpty) {
        stoCards.add(_StoCardData(master: master, detail: null));
      } else {
        for (final detail in master.stoDetails) {
          stoCards.add(_StoCardData(master: master, detail: detail));
        }
      }
    }
    debugPrint(
      '[SO/STO Order managementScreen] Rendering STO list — '
      'masters: ${dedupedStoMasterList.length}, expanded rows: ${stoCards.length}',
    );
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: stoCards.length + (viewModel.isPaginating ? 1 : 0),
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
      itemBuilder: (context, index) {
        if (index == stoCards.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF0878B8)),
            ),
          );
        }
        return _StoCard(data: stoCards[index]);
      },
    );
  }
}
List<Map<String, dynamic>> _conditionMaps(dynamic list) {
  if (list is! List) return [];
  return list.map<Map<String, dynamic>>((c) {
    if (c is Map) return Map<String, dynamic>.from(c);
    try {
      final d = c as dynamic;
      return {
        'conditionType': d.conditionType,
        'unitPrice': d.conditionPrice,
        'conditionPercentage': d.conditionPercentage,
        'totalValue': d.conditionAmount,
      };
    } catch (_) {
      return {'conditionType': c.toString()};
    }
  }).toList();
}


class _SoCard extends StatelessWidget {
  final MdoMaster order;

  const _SoCard({required this.order});

  static String _formatQty(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  static String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      final DateTime dt = DateTime.parse(rawDate);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      return rawDate.split('T').first;
    }
  }

  void _navigateToDetails(BuildContext context) {
    final String productName = (order.mdoDetails != null &&
            order.mdoDetails!.isNotEmpty &&
            order.mdoDetails!.first.productName != null &&
            order.mdoDetails!.first.productName!.isNotEmpty)
        ? order.mdoDetails!.first.productName!
        : (order.productName ?? '-');

    final List<Map<String, dynamic>> materialsList =
        order.mdoDetails?.map((item) {
              return {
                'lineNo': item.lineItemNumber?.toString() ?? 'LI1',
                'name': item.productName ?? productName,
                'materialCode': item.materialCode ?? '',
                'qty': item.quantity ?? 0,
                'unitCost': item.unitCost ?? 0,
                'conditionDetails': _conditionMaps(item.conditionTypes),
                'status': order.status ?? 'OPEN',
                'pendingQty':
                    (item.quantity ?? 0) - (item.allocatedQuantity ?? 0),
              };
            }).toList() ??
            [];

    final List<Map<String, dynamic>> deliveryOrdersList = [];
    if (order.mdoDetails != null) {
      for (final detail in order.mdoDetails!) {
        final cdos = detail.cdOs;
        if (cdos == null || cdos.isEmpty) continue;
        for (final cdo in cdos) {
          deliveryOrdersList.add({
            'doNumber': cdo.cdoNumber?.toString() ?? '-',
            'bdoNumber': cdo.bdoNumber ?? '-',
            'locationName': cdo.locationName ?? '-',
            'materialCode': cdo.materialCode ?? detail.materialCode ?? '-',
            'quantity': cdo.quantity,
            'doBalanceQty': cdo.doBalanceQty ?? '-',
            'dispatchQuantity': cdo.dispatchQuantity ?? '-',
            'createdBy': cdo.createdBy ?? '-',
            'createdDate': cdo.createdDate ?? '-',
            'allocatedQuantity': cdo.allocatedQuantity,
            'status': cdo.status ?? '-',
            'driverName': cdo.driverName ?? '-',
            'city': cdo.city ?? '-',
          });
        }
      }
    }

    final Map<String, dynamic> orderData = {
      'soNumber': order.mdoNumber?.toString() ?? '-',
      'soDate': order.mdoDate ?? '-',
      'orderType': order.orderType ?? '-',
      'seneder': order.senderPlant ?? '_',
      'division': order.division ?? '-',
      'incoTerm1': order.inscoTerm1 ?? '-',
      'incoTerm2': order.inscoTerm2 ?? '-',
      'distributionChnl': order.distributionChannel ?? '-',
      'salesContractNo': order.salesContractNumber ?? '-',
      'contractValidFrom': order.contractValidFromDate ?? '-',
      'contractValidTo': order.contractValidTillDate ?? '-',
      'senderPlant': order.senderPlant ?? '_',
      'senderPlantName': order.senderPlantName ?? '_',
      'soldToParty': order.soldToPartyName ?? '-',
      'shipToParty': order.shipToPartyName ?? '-',
      'customerReference': order.customerReference ?? '-',
      'customerRefDate': order.customerReferenceDate ?? '-',
      'shipToPartyName': order.shipToParty ?? '-',
      'shippingLocation': order.shippingLocation ?? '-',
      'billingLocation': order.billingLocation ??'-',
      'orderValidTill': order.orderValidTillDate ?? '-',
      'requiredDeliveryStartDate': order.requiredDeliveryStartdate ?? '-',
      'paymentTerms': order.paymentTerms ?? '-',
      'aggregateDis': order.aggregateDiscount?.toString() ?? '0',
      'currency': order.currency ?? '',
      'status': order.status ?? '',
      'materials': materialsList,
      'deliveryOrders': deliveryOrdersList,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SostoOrderDetailsScreen(
          order: orderData,
          isSO: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double orderedQuantity = order.mdoDetails?.fold<double>(
          0.0,
          (sum, item) => sum + (item.quantity ?? 0.0),
        ) ??
        0.0;

    final double allocatedQuantity = order.mdoDetails?.fold<double>(
          0.0,
          (sum, item) => sum + (item.allocatedQuantity ?? 0.0),
        ) ??
        0.0;

    //final bool isAllocated = allocatedQuantity > 0 && allocatedQuantity >= orderedQuantity;
    final String statusText = order.status ?? "";
    final bool isCompleted = statusText.toLowerCase() == 'completed';

    final String productName = (order.mdoDetails != null &&
            order.mdoDetails!.isNotEmpty &&
            order.mdoDetails!.first.productName != null &&
            order.mdoDetails!.first.productName!.isNotEmpty)
        ? order.mdoDetails!.first.productName!
        : (order.productName ?? '-');

    final String soldTo = (order.soldToPartyName?.isNotEmpty ?? false)
        ? order.soldToPartyName!
        : '-';
    final String shipTo = (order.shipToPartyName?.isNotEmpty ?? false)
        ? order.shipToPartyName!
        : '-';

    return InkWell(
      onTap: () => _navigateToDetails(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CommonText(
                    order.mdoNumber == null ? '-' : order.mdoNumber.toString(),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kTextDark,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _chip(
                  order.orderType ?? '',
                  const Color(0xFFE0F2FE),
                  AppColors.kPrimaryBlue,
                ),
                const SizedBox(width: 6),
                _chip(
                  statusText,
                  isCompleted
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEF3C7),
                  isCompleted
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFD97706),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _navigateToDetails(context),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF0FA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline,
                        size: 14, color: Color(0xFF1C6DD0)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            CommonText(
              productName,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.kTextGrey,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            _PartyInfoBox(title: 'Sold To', value: soldTo),
            const SizedBox(height: 6),
            _PartyInfoBox(title: 'Ship To', value: shipTo),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _InfoItem(
                    title: 'Qty',
                    value: _formatQty(orderedQuantity),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: _InfoItem(
                    title: 'Allocated',
                    value: _formatQty(allocatedQuantity),
                  ),
                ),
                const SizedBox(width: 8),
                CommonText(
                  _formatDate(order.mdoDate),
                  fontSize: 12,
                  color: AppColors.kTextGrey,
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: CommonText(
        text,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
    );
  }
}

class _StoCardData {
  final StoMaster master;
  final StoDetail? detail;

  _StoCardData({required this.master, this.detail});
}

class _StoCard extends StatelessWidget {
  final _StoCardData data;

  const _StoCard({required this.data});

  static String _formatQty(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  static String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      final DateTime dt = DateTime.parse(rawDate);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      return rawDate.split('T').first;
    }
  }

  ({Color bg, Color fg}) _statusColors(String status) {
    switch (status.trim().toLowerCase()) {
      case 'allocated':
      case 'completed':
        return (bg: const Color(0xFFDCFCE7), fg: const Color(0xFF16A34A));
      case 'pending':
        return (bg: const Color(0xFFFEF3C7), fg: const Color(0xFFD97706));
      default:
        return (bg: const Color(0xFFE0F2FE), fg: const Color(0xFF0878B8));
    }
  }

  Future<void> _navigateToDetails(BuildContext context) async {
    final master = data.master;
    final detail = data.detail;
    final viewModel =
        Provider.of<OrderManagementViewModel>(context, listen: false);

    // Optional: Fetch customer location details using senderPlant before navigating
    final String locationCode = master.senderPlant ?? '';
    if (locationCode.isNotEmpty) {
      await viewModel.postFilterSingleCustomerDeliveryLocation(locationCode);
    }

    final List<Map<String, dynamic>> materialsList =
        master.stoDetails.map((item) {
      return {
        'lineNo': item.lineItemNumber.toString() ?? 'LI1',
        'name': item.productName,
        'materialCode': item.materialCode,
        'qty': item.quantity,
        'uom': item.productUOM.isEmpty ? 'MTS' : item.productUOM,
        'unitCost': item.unitCost,
        'status': item.status,
        'pendingQty': item.pendingQuantity,
        'conditionDetails': _conditionMaps(item.conditionTypes),
      };
    }).toList();

    debugPrint('[SostoOrdermanagementScreen] STO ${master.stoNumber} -> '
        'details screen, materials: ${materialsList.length}');

    final Map<String, dynamic> orderData = {
      'soNumber': master.stoNumber.toString(),
      'soDate': master.stoDate,
      'orderType': master.orderType,
      'senderPlant': master.senderPlant ?? '-',
      'senderPlantName': master.senderPlantName ?? '-',
      'receiverPlant': master.receiverPlant ?? '-',
      'receiverPlantName': master.receiverPlantName ?? '-',
      'status': detail?.status ?? master.status,
      'materials': materialsList,
      'deliveryOrders': [],
    };

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SostoOrderDetailsScreen(
          order: orderData,
          isSO: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final master = data.master;
    final detail = data.detail;
    final String status = detail?.status ?? master.status;

    print('status -  $status');
    final statusColors = _statusColors(status);

    final String senderPlant = (master.senderPlantName.isNotEmpty ?? false)
        ? master.senderPlantName
        : (master.senderPlant.isNotEmpty ?? false)
            ? master.senderPlant
            : '-';
    final String receiverPlant = (master.receiverPlantName.isNotEmpty ?? false)
        ? master.receiverPlantName
        : (master.receiverPlant.isNotEmpty ?? false)
            ? master.receiverPlant
            : '-';

    return InkWell(
      onTap: () => _navigateToDetails(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    master.stoNumber.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (master.orderType.isNotEmpty)
                  _chip(master.orderType, const Color(0xFFE0F2FE),
                      const Color(0xFF0878B8)),
                const SizedBox(width: 6),
                if (status.isNotEmpty)
                  _chip(status, statusColors.bg, statusColors.fg),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _navigateToDetails(context),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF0FA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline,
                        size: 14, color: Color(0xFF1C6DD0)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              detail?.productName.isNotEmpty == true
                  ? detail!.productName
                  : '-',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            _PartyInfoBox(title: 'Sender Plant', value: senderPlant),
            const SizedBox(height: 6),
            _PartyInfoBox(title: 'Receiver Plant', value: receiverPlant),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _InfoItem(
                    title: 'Qty',
                    value: _formatQty(detail?.quantity ?? 0),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: _InfoItem(
                    title: 'Allocated',
                    value: _formatQty(detail?.allocatedQuantity ?? 0),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(master.stoDate),
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}


class _PartyInfoBox extends StatelessWidget {
  final String title;
  final String value;

  const   _PartyInfoBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF0878B8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title ',
          style: const TextStyle(
            fontSize: 12, // Reduced by 1
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Text(
            value,
            // Removed maxLines and overflow to allow text to wrap
            style: const TextStyle(
              fontSize: 12, // Reduced by 1
              color: Color(0xFF0878B8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
