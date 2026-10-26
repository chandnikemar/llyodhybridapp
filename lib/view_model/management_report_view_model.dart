import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:ut_lloyd_web_app/model/reports/vtroutbound/reports_vtr_outbound_model.dart';

// Ensure these files contain your newly created Request/Response classes
import '../model/reports/dailydispatchreport/reports_daily_dispatch_request_model.dart';
import '../model/reports/salereport/sales_order_model.dart';
import '../model/reports/salereport/so_sc_po_model.dart';
import '../model/reports/vtrinbound/reports_vtr_inbound_model.dart';
// 🔹 ADD THIS IMPORT: Import your new Daily Dispatch model here

import '../service/api_service.dart';

class MGMReportsViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  String currentTenantCode = '';

  // --- Dates ---
  String fromDate = '';
  String toDate = '';
  bool _isDisposed = false;

  // --- State ---
  bool isLoading = false;
  bool isPaginating = false;
  bool hasMoreData = true;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Active Tab Index (0: DO, 1: SO, 2: SC, 3: PO)
  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  // Independent Lists
  List<SalesReportResponse> _doList = [];
  List<SalesSOSCPOResponse> _soscpoList = [];
  List<ReportsVtrOutboundResponseModel> _vtrOutboundList = [];
  List<ReportsVtrInboundResponseModel> _vtrInboundList = [];

  // 🔹 ADDED: Daily Dispatch List
  List<ReportsDailyDispatchResponseModel> _dailyDispatchList = [];


  List<SalesReportResponse> get doList => _doList;
  List<SalesSOSCPOResponse> get soscpoList => _soscpoList;
  List<ReportsVtrOutboundResponseModel> get vtrOutboundList => _vtrOutboundList;
  List<ReportsVtrInboundResponseModel> get vtrInboundList => _vtrInboundList;

  // 🔹 ADDED: Getter for Daily Dispatch
  List<ReportsDailyDispatchResponseModel> get dailyDispatchList => _dailyDispatchList;

  // Pagination
  int _currentPage = 1;
  final int _rowSize = 15;

  MGMReportsViewModel() {
    _initDefaultDates();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _initDefaultDates() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');

    // 🔹 FIX: Hardcoded the 'T' here so it defaults safely
    fromDate = "$y-$m-${d}T00:00:00";
    toDate = "$y-$m-${d}T23:59:59";
  }

  /// Change the active tab and reload
  void switchTab(int index, String tenantCode) {
    if (_activeTabIndex == index) return;
    _activeTabIndex = index;

    // Clear old data
    _doList.clear();
    _soscpoList.clear();
    _currentPage = 1;
    hasMoreData = true;

    fetchData(tenantCode: tenantCode, isLoadMore: false);
  }

  /// Core fetch method with all filters added
  Future<bool> fetchData({
    required String tenantCode,
    bool isLoadMore = false,
    String globalSearch = "",
    String cdoNumber = "",
    String customerName = "",
    String customerReference = "",
    String materialCode = "",
    String materialName = "",
    String salesContractNumber = "",
    String soNumber = "",
  }) async {
    currentTenantCode = tenantCode;

    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
      _currentPage++;
    } else {
      isLoading = true;
      _currentPage = 1;
      _doList.clear();
      _soscpoList.clear();
      hasMoreData = true;
    }

    _errorMessage = null;
    safeNotifyListeners();

    try {
      if (_activeTabIndex == 0) {
        // --- 1. Call DO API ---
        final request = SalesReportRequest(
          fromDate: fromDate.replaceAll(' ', ''),
          toDate: toDate.replaceAll(' ', ''),
          tenantCode: tenantCode,
          currentPage: _currentPage,
          rowSize: _rowSize,
          globalSearch: globalSearch,
          cdoNumber: cdoNumber,
          customerName: customerName,
          customerReference: customerReference,
          materialCode: materialCode,
          materialName: materialName,
          salesContractNumber: salesContractNumber,
          soNumber: soNumber,
        );

        debugPrint('DO API Request Payload: ${jsonEncode(request.toJson())}');

        final response = await _apiService.getSalesReport(request);
        if (response != null && response.statusCode == 200) {
          List<dynamic> data = response.data;
          if (data.length < _rowSize) hasMoreData = false;

          List<SalesReportResponse> newData = data.map((json) => SalesReportResponse.fromJson(json)).toList();
          if (isLoadMore) {
            _doList.addAll(newData);
          } else {
            _doList = newData;
          }
        }
      } else {
        // --- 2. Call SO/SC/PO API ---
        String reportType = _activeTabIndex == 1 ? "SO" : _activeTabIndex == 2 ? "SalesContract" : "CustomerReference";

        final request = SalesSOSCPORequest(
          fromDate: fromDate.replaceAll(' ', 'T'),
          toDate: toDate.replaceAll(' ', 'T'),
          tenantCode: tenantCode,
          reportType: reportType,
          currentPage: _currentPage,
          rowSize: _rowSize,
          globalSearch: globalSearch,
          cdoNumber: cdoNumber,
          customerName: customerName,
          customerReference: customerReference,
          materialCode: materialCode,
          materialName: materialName,
          salesContractNumber: salesContractNumber,
          soNumber: soNumber,
        );

        debugPrint('SOSCPO API ($reportType) Request Payload: ${jsonEncode(request.toJson())}');

        final response = await _apiService.getSalesReportSOSCPO(request);
        if (response != null && response.statusCode == 200) {
          List<dynamic> data = response.data;
          if (data.length < _rowSize) hasMoreData = false;

          List<SalesSOSCPOResponse> newData = data.map((json) => SalesSOSCPOResponse.fromJson(json)).toList();
          if (isLoadMore) {
            _soscpoList.addAll(newData);
          } else {
            _soscpoList = newData;
          }
        }
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (isLoadMore) _currentPage--;
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchVtrOutboundData({
    required ReportsVtrOutboundRequestModel request,
    bool isLoadMore = false,
  }) async {
    currentTenantCode = request.tenantCode;

    // Handle Pagination State
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
      _currentPage++;
    } else {
      isLoading = true;
      _currentPage = 1;
      _vtrOutboundList.clear();
      hasMoreData = true;
    }

    _errorMessage = null;
    safeNotifyListeners();

    try {
      final apiRequest = ReportsVtrOutboundRequestModel(
        fromDate: request.fromDate,
        toDate: request.toDate,
        tenantCode: request.tenantCode,
        currentPage: _currentPage,
        rowSize: _rowSize,
        globalSearch: request.globalSearch,
        bulkDemandNumber: request.bulkDemandNumber,
        challanNumber: request.challanNumber,
        city: request.city,
        doNumber: request.doNumber,
        ewayBillNo: request.ewayBillNo,
        grnNumber: request.grnNumber,
        inboundGRN: request.inboundGRN,
        invoiceNumber: request.invoiceNumber,
        obdNumber: request.obdNumber,
        orderNumber: request.orderNumber,
        orderType: request.orderType,
        passNo: request.passNo,
        pgiNumber: request.pgiNumber,
        productCode: request.productCode,
        productName: request.productName,
        transactionCode: request.transactionCode,
        transporterName: request.transporterName,
        vrn: request.vrn,
      );

      debugPrint('VTR Outbound API Request Payload: ${jsonEncode(apiRequest.toJson())}');

      final response = await _apiService.getReportsOutboundVTRView(apiRequest);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        if (data.length < _rowSize) hasMoreData = false;

        List<ReportsVtrOutboundResponseModel> newData = data.map((json) => ReportsVtrOutboundResponseModel.fromJson(json)).toList();

        if (isLoadMore) {
          _vtrOutboundList.addAll(newData);
        } else {
          _vtrOutboundList = newData;
        }
        return true;
      } else {
        throw Exception("Failed to fetch VTR Transactions");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (isLoadMore) _currentPage--;
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchVtrInboundData({
    required ReportsVtrInboundRequestModel request,
    bool isLoadMore = false,
  }) async {
    currentTenantCode = request.tenantCode;

    // Handle Pagination State
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
      _currentPage++;
    } else {
      isLoading = true;
      _currentPage = 1;
      _vtrInboundList.clear();
      hasMoreData = true;
    }

    _errorMessage = null;
    safeNotifyListeners();

    try {
      final apiRequest = ReportsVtrInboundRequestModel(
        fromDate: request.fromDate,
        toDate: request.toDate,
        tenantCode: request.tenantCode,
        currentPage: _currentPage,
        rowSize: _rowSize,
        globalSearch: request.globalSearch,
        bulkDemandNumber: request.bulkDemandNumber,
        challanNumber: request.challanNumber,
        city: request.city,
        doNumber: request.doNumber,
        ewayBillNo: request.ewayBillNo,
        grnNumber: request.grnNumber,
        invoiceNumber: request.invoiceNumber,
        obdNumber: request.obdNumber,
        orderNumber: request.orderNumber,
        productCode: request.productCode,
        productName: request.productName,
        tpNumber: request.tpNumber,
        transactionCode: request.transactionCode,
        transporterName: request.transporterName,
        vrn: request.vrn,
      );

      debugPrint('VTR Inbound API Request Payload: ${jsonEncode(apiRequest.toJson())}');

      final response = await _apiService.getReportsInBoundVTRView(apiRequest);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        if (data.length < _rowSize) {
          hasMoreData = false;
        }

        List<ReportsVtrInboundResponseModel> newData =
        data.map((json) => ReportsVtrInboundResponseModel.fromJson(json)).toList();

        if (isLoadMore) {
          _vtrInboundList.addAll(newData);
        } else {
          _vtrInboundList = newData;
        }

        return true;
      } else {
        throw Exception("Failed to fetch VTR Inbound Transactions");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (isLoadMore) _currentPage--;
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  // 🔹 ADDED: Daily Dispatch Request Method
  Future<bool> fetchDailyDispatchData({
    required ReportsDailyDispatchRequestModel request,
    bool isLoadMore = false,
  }) async {
    // Handle Pagination State
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
      _currentPage++;
    } else {
      isLoading = true;
      _currentPage = 1;
      _dailyDispatchList.clear();
      hasMoreData = true;
    }

    _errorMessage = null;
    safeNotifyListeners();

    try {
      final apiRequest = ReportsDailyDispatchRequestModel(
        tenantCode: request.tenantCode,
        fromDate: request.fromDate,
        toDate: request.toDate,
        currentPage: _currentPage,
        rowSize: _rowSize,
        globalSearch: request.globalSearch,
        bdoNo: request.bdoNo,
        buyerName: request.buyerName,
        destination: request.destination,
        doNo: request.doNo,
        soNo: request.soNo,
      );

      debugPrint('Daily Dispatch API Request Payload: ${jsonEncode(apiRequest.toJson())}');

      // Ensure your ApiService has a method named 'getDayDispatchReport'
      final response = await _apiService.getDayDispatchReport(apiRequest);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        if (data.length < _rowSize) {
          hasMoreData = false;
        }

        List<ReportsDailyDispatchResponseModel> newData =
        data.map((json) => ReportsDailyDispatchResponseModel.fromJson(json)).toList();

        if (isLoadMore) {
          _dailyDispatchList.addAll(newData);
        } else {
          _dailyDispatchList = newData;
        }

        return true;
      } else {
        throw Exception("Failed to fetch Daily Dispatch Report");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (isLoadMore) _currentPage--;
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  /// Wipe all data (useful for full app refreshes or logouts)
  void reset() {
    isLoading = false;
    isPaginating = false;
    _doList.clear();
    _soscpoList.clear();
    _vtrOutboundList.clear();
    _vtrInboundList.clear();
    _dailyDispatchList.clear(); // 🔹 ADDED: clear daily dispatch data on reset
    _errorMessage = null;
    _currentPage = 1;
    hasMoreData = true;
    _activeTabIndex = 0;
    safeNotifyListeners();
  }
}