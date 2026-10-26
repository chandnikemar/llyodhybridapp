import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:ut_lloyd_web_app/model/reports/vtroutbound/reports_vtr_outbound_model.dart';

import '../model/reports/dailydispatchreport/reports_daily_dispatch_request_model.dart';
import '../model/reports/salereport/sales_order_model.dart';
import '../model/reports/salereport/so_sc_po_model.dart';
import '../model/reports/vtrinbound/reports_vtr_inbound_model.dart';
import '../service/api_service.dart';

class ReportsViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  String currentTenantCode = '';
  bool _isDisposed = false;

  // --- Date range (public: all report screens read/assign these) ---
  // Format "yyyy-MM-dd HH:mm:ss". Other screens convert ' ' to 'T' themselves.
  String fromDate = '';
  String toDate = '';

  // --- State ---
  bool isLoading = false;
  bool isPaginating = false;
  bool hasMoreData = true;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Active sales tab (0: DO, 1: SO, 2: SC, 3: PO)
  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  // --- Lists ---
  List<SalesReportResponse> _doList = [];
  List<SalesSOSCPOResponse> _soscpoList = [];
  List<ReportsVtrOutboundResponseModel> _vtrOutboundList = [];
  List<ReportsVtrInboundResponseModel> _vtrInboundList = [];
  List<ReportsDailyDispatchResponseModel> _dailyDispatchList = [];

  List<SalesReportResponse> get doList => _doList;
  List<SalesSOSCPOResponse> get soscpoList => _soscpoList;
  List<ReportsVtrOutboundResponseModel> get vtrOutboundList => _vtrOutboundList;
  List<ReportsVtrInboundResponseModel> get vtrInboundList => _vtrInboundList;
  List<ReportsDailyDispatchResponseModel> get dailyDispatchList =>
      _dailyDispatchList;

  // --- Pagination ---
  static const int rowSize = 15;
  int _currentPage = 1; // last page loaded successfully
  int get currentPage => _currentPage;

  // Bumped on every fresh search / tab switch so late responses are ignored.
  int _requestId = 0;

  ReportsViewModel() {
    setDateRange(null, null); // default: today
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Dates
  // ---------------------------------------------------------------------------
  String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// null/null -> today. One date only -> used for both ends.
  /// From after To -> swapped.
  void setDateRange(DateTime? from, DateTime? to) {
    DateTime a = from ?? to ?? DateTime.now();
    DateTime b = to ?? from ?? DateTime.now();
    if (a.isAfter(b)) {
      final tmp = a;
      a = b;
      b = tmp;
    }
    fromDate = '${_fmt(a)} 00:00:00';
    toDate = '${_fmt(b)} 23:59:59';
  }

  /// Back to today's date range.
  void resetDates() => setDateRange(null, null);

  // ---------------------------------------------------------------------------
  // Sales report (DO / SO / SC / PO)
  // ---------------------------------------------------------------------------

  /// Switches tab and clears the old list. The screen calls
  /// [fetchSalesReport] afterwards.
  void switchTab(int index) {
    if (_activeTabIndex == index) return;
    _activeTabIndex = index;
    _requestId++; // drop any in-flight response from the old tab
    _doList = [];
    _soscpoList = [];
    _currentPage = 1;
    hasMoreData = true;
    isLoading = false;
    isPaginating = false;
    safeNotifyListeners();
  }

  /// [currentPage] is the page to load (screen: 1 on a fresh search,
  /// viewModel.currentPage + 1 on load-more).
  Future<bool> fetchSalesReport({
    required String tenantCode,
    required int currentPage,
    bool isLoadMore = false,
    String globalSearch = '',
    String cdoNumber = '',
    String customerName = '',
    String customerReference = '',
    String materialCode = '',
    String materialName = '',
    String salesContractNumber = '',
    String soNumber = '',
    String shipLocation = '',
  }) async {
    currentTenantCode = tenantCode;

    if (isLoadMore) {
      if (!hasMoreData || isPaginating || isLoading) return false;
      isPaginating = true;
    } else {
      _requestId++;
      isLoading = true;
      isPaginating = false;
      _doList = [];
      _soscpoList = [];
      hasMoreData = true;
      _currentPage = 1;
    }

    final int myId = _requestId;
    _errorMessage = null;
    safeNotifyListeners();

    try {
      final dynamic response;

      if (_activeTabIndex == 0) {
        final request = SalesReportRequest(
          fromDate: fromDate,
          toDate: toDate,
          tenantCode: tenantCode,
          currentPage: currentPage,
          rowSize: rowSize,
          globalSearch: globalSearch,
          cdoNumber: cdoNumber,
          customerName: customerName,
          customerReference: customerReference,
          materialCode: materialCode,
          materialName: materialName,
          salesContractNumber: salesContractNumber,
          soNumber: soNumber,
          shipLocation: shipLocation,
        );
        debugPrint('DO Request Payload: ${jsonEncode(request.toJson())}');
        response = await _apiService.getSalesReport(request);
      } else {
        final String reportType = _activeTabIndex == 1
            ? 'SO'
            : _activeTabIndex == 2
            ? 'SalesContract'
            : 'CustomerReference';
        final request = SalesSOSCPORequest(
          fromDate: fromDate,
          toDate: toDate,
          tenantCode: tenantCode,
          reportType: reportType,
          currentPage: currentPage,
          rowSize: rowSize,
          globalSearch: globalSearch,
          cdoNumber: cdoNumber,
          customerName: customerName,
          customerReference: customerReference,
          materialCode: materialCode,
          materialName: materialName,
          salesContractNumber: salesContractNumber,
          soNumber: soNumber,
          shipLocation: shipLocation,
        );
        debugPrint(
            '$reportType Request Payload: ${jsonEncode(request.toJson())}');
        response = await _apiService.getSalesReportSOSCPO(request);
      }

      if (myId != _requestId) return false; // outdated response

      if (response == null || response.statusCode != 200) {
        throw Exception('Failed to fetch sales report');
      }

      final List<dynamic> data = response.data;
      debugPrint('Sales page $currentPage returned ${data.length} rows');

      // Backend returns all data regardless of pagination, so we need to manually slice
      final startIndex = (currentPage - 1) * rowSize;
      final endIndex = startIndex + rowSize;
      final paginatedData = startIndex < data.length
          ? data.sublist(startIndex, endIndex > data.length ? data.length : endIndex)
          : <dynamic>[];

      if (_activeTabIndex == 0) {
        final newData = paginatedData
            .map((json) => SalesReportResponse.fromJson(json))
            .toList();
        isLoadMore ? _doList.addAll(newData) : _doList = newData;
      } else {
        final newData = paginatedData
            .map((json) => SalesSOSCPOResponse.fromJson(json))
            .toList();
        isLoadMore ? _soscpoList.addAll(newData) : _soscpoList = newData;
      }

      _currentPage = currentPage; // advance only after the page loaded
      // Check if we've reached the end of all data
      if (endIndex >= data.length) hasMoreData = false;
      return true;
    } catch (e) {
      debugPrint('Sales report fetch error: $e');
      if (myId == _requestId) {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      }
      return false;
    } finally {
      if (myId == _requestId) {
        isLoading = false;
        isPaginating = false;
        safeNotifyListeners();
      }
    }
  }

  // ---------------------------------------------------------------------------
  // VTR Outbound  (request.currentPage = page to load)
  // ---------------------------------------------------------------------------
  Future<bool> fetchVtrOutboundData({
    required ReportsVtrOutboundRequestModel request,
    bool isLoadMore = false,
  }) async {
    currentTenantCode = request.tenantCode;

    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _vtrOutboundList = [];
      hasMoreData = true;
      _currentPage = 1;
    }

    _errorMessage = null;
    safeNotifyListeners();

    try {
      debugPrint(
          'VTR Outbound Request Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.getReportsOutboundVTRView(request);

      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final newData = data
            .map((json) => ReportsVtrOutboundResponseModel.fromJson(json))
            .toList();

        if (data.length < rowSize) hasMoreData = false;
        isLoadMore
            ? _vtrOutboundList.addAll(newData)
            : _vtrOutboundList = newData;

        _currentPage = request.currentPage;
        return true;
      }
      throw Exception('Failed to fetch VTR Transactions');
    } catch (e) {
      debugPrint('VTR Outbound Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // VTR Inbound
  // ---------------------------------------------------------------------------
  Future<bool> fetchVtrInboundData({
    required ReportsVtrInboundRequestModel request,
    bool isLoadMore = false,
  }) async {
    currentTenantCode = request.tenantCode;

    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _vtrInboundList = [];
      hasMoreData = true;
      _currentPage = 1;
    }

    _errorMessage = null;
    safeNotifyListeners();

    try {
      debugPrint(
          'VTR Inbound Request Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.getReportsInBoundVTRView(request);

      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final newData = data
            .map((json) => ReportsVtrInboundResponseModel.fromJson(json))
            .toList();

        if (data.length < rowSize) hasMoreData = false;
        isLoadMore
            ? _vtrInboundList.addAll(newData)
            : _vtrInboundList = newData;

        _currentPage = request.currentPage;
        return true;
      }
      throw Exception('Failed to fetch VTR Inbound Transactions');
    } catch (e) {
      debugPrint('VTR Inbound Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Daily Dispatch
  // ---------------------------------------------------------------------------
  Future<bool> fetchDailyDispatchData({
    required ReportsDailyDispatchRequestModel request,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _dailyDispatchList = [];
      hasMoreData = true;
      _currentPage = 1;
    }

    _errorMessage = null;
    safeNotifyListeners();

    try {
      debugPrint(
          'Daily Dispatch Request Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.getDayDispatchReport(request);

      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final newData = data
            .map((json) => ReportsDailyDispatchResponseModel.fromJson(json))
            .toList();

        if (data.length < rowSize) hasMoreData = false;
        isLoadMore
            ? _dailyDispatchList.addAll(newData)
            : _dailyDispatchList = newData;

        _currentPage = request.currentPage;
        return true;
      }
      throw Exception('Failed to fetch Daily Dispatch Report');
    } catch (e) {
      debugPrint('Daily Dispatch Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  /// Wipe all data (full refresh / logout)
  void reset() {
    _requestId++;
    isLoading = false;
    isPaginating = false;
    _doList = [];
    _soscpoList = [];
    _vtrOutboundList = [];
    _vtrInboundList = [];
    _dailyDispatchList = [];
    _errorMessage = null;
    _currentPage = 1;
    hasMoreData = true;
    _activeTabIndex = 0;
    resetDates();
    safeNotifyListeners();
  }
}