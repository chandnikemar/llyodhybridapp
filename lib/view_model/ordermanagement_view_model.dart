import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ut_lloyd_web_app/model/ordermanagement/sosto/filter_mdo_master_request_model.dart';
import 'package:ut_lloyd_web_app/model/ordermanagement/sosto/mdo_response.dart';
import 'package:ut_lloyd_web_app/model/ordermanagement/sosto/sto_master_response.dart';
import 'package:ut_lloyd_web_app/model/ordermanagement/purchaseorder/filter_po_masters_request.dart';
import 'package:ut_lloyd_web_app/model/ordermanagement/purchaseorder/po_master_response.dart';

import '../model/ordermanagement/bulkdemand/bdo_request_model.dart';
import '../model/ordermanagement/bulkdemand/bdo_response_model.dart';
import '../model/ordermanagement/bulkdemand/route_request_model.dart';
import '../model/ordermanagement/bulkdemand/route_response_model.dart';

import '../model/ordermanagement/deliveryorders/activetransport_response_model.dart';
import '../model/ordermanagement/deliveryorders/delivery_orders_request_model.dart';
import '../model/ordermanagement/deliveryorders/delivery_orders_response_model.dart';
import '../model/ordermanagement/deliveryorders/invoice_transaction_request_model.dart';
import '../model/ordermanagement/deliveryorders/invoice_transaction_response_model.dart';

import '../model/ordermanagement/deliveryorders/milestoneplan_model.dart';
import '../model/ordermanagement/deliveryorders/milestoneplan_request_model.dart';
import '../model/ordermanagement/deliveryorders/vehical_milstone_request_model.dart';
import '../model/ordermanagement/deliveryorders/vehical_milstone_response_model.dart';
import '../model/ordermanagement/deliveryorders/vehical_transaction_request_model.dart';
import '../model/ordermanagement/deliveryorders/vehicle_transaction_response_model.dart';
import '../model/ordermanagement/sosto/filter_sto_master_request.dart';

import '../model/ordermanagement/sosto/sostodetail/condition_record_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/currency_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/customer_location_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/customer_request_model.dart';
import '../model/ordermanagement/sosto/sostodetail/customer_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/distribution_channel_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/division_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/incoterms_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/location_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/order_type_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/payment_terms_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/product_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/tax_type_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/tenant_group_response_model.dart';
import '../model/ordermanagement/sosto/sostodetail/tenant_response_model.dart';
import '../service/api_service.dart';

class OrderManagementViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  String currentTenantCode = '';
  bool _isDisposed = false;

  // --- State ---
  bool isLoading = false;
  bool isPaginating = false;
  bool hasMoreData = true;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool _isMilestoneLoading = false;
  bool get isMilestoneLoading => _isMilestoneLoading;

  // --- Order Management Data Lists ---
  List<MilestonePlanResponseModel> _milestonePlanList = [];
  List<BdoResponseModel> _bdoList = [];
  List<RouteResponseModel> _routeList = [];
  List<CdoFilterResponseModel> _cdoList = [];
  List<TransporterResponseModel> _transporterList = [];
  List<InvoiceRecord> _invoiceList = [];
  List<VehicleTransactionResponseModel> _vehicleTransactionList = [];
  List<MdoMaster> _mdoList = [];
  List<StoMaster> _stoList = [];
  List<PoMasterResponse> _purchaseOrderList = [];


  List<MilestonePlanResponseModel> get milestonePlanList => _milestonePlanList;
  List<BdoResponseModel> get bdoList => _bdoList;
  List<RouteResponseModel> get routeList => _routeList;
  List<CdoFilterResponseModel> get cdoList => _cdoList;
  List<TransporterResponseModel> get transporterList => _transporterList;
  List<InvoiceRecord> get invoiceList => _invoiceList;
  List<VehicleTransactionResponseModel> get vehicleTransactionList => _vehicleTransactionList;
  List<MdoMaster> get mdoList => _mdoList;
  List<StoMaster> get stoList => _stoList;
  List<PoMasterResponse> get purchaseOrderList => _purchaseOrderList;

  Map<String, dynamic>? _singleDHData;
  Map<String, dynamic>? get singleDHData => _singleDHData;



  List<VehicleMilestoneResponse> _vehicleMilestoneDetail = [];
  List<VehicleMilestoneResponse> get vehicleMilestoneDetail => _vehicleMilestoneDetail;

  InvoiceRecord? _selectedInvoice;
  InvoiceRecord? get selectedInvoice => _selectedInvoice;

  List<ConditionTypeResponseModel> _conditionTypeList = [];
  List<ConditionTypeResponseModel> get conditionTypeList => _conditionTypeList;

  List<CurrencyResponseModel> _currencyList = [];
  List<CurrencyResponseModel> get currencyList => _currencyList;

  List<PaymentTermsResponseModel> _paymentTermsList = [];
  List<PaymentTermsResponseModel> get paymentTermsList => _paymentTermsList;

  List<CustomerResponseModel> _customerList = [];
  List<CustomerResponseModel> get customerList => _customerList;

  List<DistributionChannelResponseModel> _distributionChannelList = [];
  List<DistributionChannelResponseModel> get distributionChannelList => _distributionChannelList;

  List<DivisionResponseModel> _divisionList = [];
  List<DivisionResponseModel> get divisionList => _divisionList;

  List<IncotermsResponseModel> _incotermsList = [];
  List<IncotermsResponseModel> get incotermsList => _incotermsList;

  List<TaxTypeResponseModel> _taxTypeList = [];
  List<TaxTypeResponseModel> get taxTypeList => _taxTypeList;

  List<OrderTypeResponseModel> _orderTypeList = [];
  List<OrderTypeResponseModel> get orderTypeList => _orderTypeList;

  List<ProductResponseModel> _productList = [];
  List<ProductResponseModel> get productList => _productList;

  List<TenantGroupResponseModel> _tenantGroupList = [];
  List<TenantGroupResponseModel> get tenantGroupList => _tenantGroupList;

  List<TenantResponseModel> _tenantList = [];
  List<TenantResponseModel> get tenantList => _tenantList;

  List<CustomerLocationResponseModel> _customerLocationList = [];
  List<CustomerLocationResponseModel> get customerLocationList => _customerLocationList;

  List<LocationResponseModel> _locationList = [];
  List<LocationResponseModel> get locationList => _locationList;
  // --- Pagination ---
  int _currentPage = 1;
  final int _rowSize = 15;

  int get currentPage => _currentPage;

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

  // --- MDO API Integration ---
  Future<bool> fetchFilterMDOMasters({
    required FilterMdoMasterRequest request,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _mdoList.clear();
      hasMoreData = true;
    }


    _currentPage = request.currentPage;

    _errorMessage = null;
    safeNotifyListeners();

    try {
      debugPrint('Filter MDO Request Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postFilterMDOMasters(request);

      if (response != null && response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data;

        List<MdoMaster> newData =
        data.map((json) => MdoMaster.fromJson(json)).toList();

        if (newData.length < _rowSize) {
          hasMoreData = false;
        }

        if (isLoadMore) {
          _mdoList.addAll(newData);
        } else {
          _mdoList = newData;
        }

        return true;
      } else {
        throw Exception("Failed to fetch MDO Master details");
      }
    } catch (e) {
      debugPrint('Filter MDO Master Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  // --- STO API Integration ---
  Future<bool> fetchFilterSTOMasters({
    required FilterStoMasterRequest request,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _stoList.clear();
      hasMoreData = true;
    }

    // Same fix as fetchFilterMDOMasters above — keep _currentPage in sync
    // with the page that was actually requested so the caller's
    // "currentPage + 1" logic advances correctly on subsequent load-more
    // calls instead of re-requesting the same page forever.
    _currentPage = request.currentPage;

    _errorMessage = null;
    safeNotifyListeners();

    try {
      debugPrint('Filter STO Request Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postFilterSTOMasters(request);

      if (response != null && response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data;

        List<StoMaster> newData =
        data.map((json) => StoMaster.fromJson(json)).toList();

        if (newData.length < _rowSize) {
          hasMoreData = false;
        }

        if (isLoadMore) {
          _stoList.addAll(newData);
        } else {
          _stoList = newData;
        }

        return true;
      } else {
        throw Exception("Failed to fetch STO Master details");
      }
    } catch (e) {
      debugPrint('Filter STO Master Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchPOMasters({
    required String fromDate,
    required String toDate,
    required String tenantCode,
    String? globalSearch,
    int currentPage = 1,
    int rowSize = 15,
    String? poNumber,
    String? materialCode,
    String? materialDescription,
    String? materialGroup,
    String? plantCode,
    String? storageLocation,
    String? itemCategory,
    String? accountAssignment,
    String? status,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (!hasMoreData || isPaginating || isLoading) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _purchaseOrderList.clear();
      hasMoreData = true;
      _currentPage = 1;
    }
    _errorMessage = null;
    safeNotifyListeners();

    try {
      final request = FilterPoMastersRequest(
        fromDate: fromDate,
        toDate: toDate,
        currentPage: currentPage,
        rowSize: rowSize,
        globalSearch: globalSearch,
        tenantCode: tenantCode,
        poNumber: poNumber,
        materialCode: materialCode,
        materialDescription: materialDescription,
        materialGroup: materialGroup,
        plantCode: plantCode,
        storageLocation: storageLocation,
        itemCategory: itemCategory,
        accountAssignment: accountAssignment,
        status: status,
      );
      debugPrint('Filter PO Master Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postFilterPOMasters(request);
      if (response != null && response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final records = data is List
            ? data
            : data is Map<String, dynamic> && data['data'] is List
            ? data['data'] as List
            : <dynamic>[];
        final newMasters = records
            .whereType<Map>()
            .map((record) => PoMasterResponse.fromJson(Map<String, dynamic>.from(record)))
            .toList();

        if (isLoadMore) {
          _purchaseOrderList.addAll(newMasters);
        } else {
          _purchaseOrderList = newMasters;
        }

        _currentPage = currentPage;
        if (newMasters.length < rowSize) hasMoreData = false;
        return true;
      }
      throw Exception('Failed to fetch purchase orders');
    } catch (e) {
      debugPrint('Filter PO Master Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchFilterRouteMaster({
    int routeMasterId = 0,
    String tenantCode = '',
  }) async {
    isLoading = true;
    _errorMessage = null;
    _routeList.clear();
    safeNotifyListeners();

    try {
      final request = RouteRequestModel(
        routeMasterId: routeMasterId,
        tenantCode: tenantCode,
      );

      debugPrint('Filter Route Master Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postFilterRouteMaster(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        _routeList = data
            .map((json) => RouteResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch Route Master data");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchPaginatedBdoList({
    required BdoRequestModel request,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _bdoList.clear();
      hasMoreData = true;
    }

    _currentPage = request.currentPage;
    _errorMessage = null;
    safeNotifyListeners();

    try {
      debugPrint('Paginated BDO Request Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.getPaginatedBdoList(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        List<BdoResponseModel> newData =
        data.map((json) => BdoResponseModel.fromJson(json)).toList();

        if (newData.length < _rowSize) {
          hasMoreData = false;
        }

        if (isLoadMore) {
          _bdoList.addAll(newData);
        } else {
          _bdoList = newData;
        }

        return true;
      } else {
        throw Exception("Failed to fetch Paginated BDO List");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchFilterCDODetails({
    required CdoFilterRequestModel request,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _cdoList.clear();
      hasMoreData = true;
    }

    _currentPage = request.currentPage;
    _errorMessage = null;
    safeNotifyListeners();

    try {
      debugPrint('Filter CDO Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postFilterCDODetails(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        List<CdoFilterResponseModel> newData = data
            .map((json) => CdoFilterResponseModel.fromJson(json))
            .toList();

        if (newData.length < _rowSize) {
          hasMoreData = false;
        }

        if (isLoadMore) {
          _cdoList.addAll(newData);
        } else {
          _cdoList = newData;
        }

        _cdoList.sort((a, b) {
          final DateTime? dateA = _parseDate(a.publishedOn);
          final DateTime? dateB = _parseDate(b.publishedOn);

          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;

          return dateB.compareTo(dateA);
        });

        return true;
      } else {
        throw Exception("Failed to fetch CDO details");
      }
    } catch (e) {
      debugPrint('Filter CDO Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }

  Future<bool> fetchActiveTransporterList() async {
    isLoading = true;
    _errorMessage = null;
    _transporterList.clear();
    safeNotifyListeners();

    try {
      final response = await _apiService.getActiveTransporterList();

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        _transporterList = data
            .map((json) => TransporterResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch active transporters");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchInvoicesByCdoAndStatus({
    required int cdoMasterId,
    required String status,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (!hasMoreData || isPaginating) return false;
      isPaginating = true;
    } else {
      isLoading = true;
      _invoiceList.clear();
      hasMoreData = true;
      _currentPage = 1;
    }

    _errorMessage = null;
    safeNotifyListeners();

    try {
      final request = InvoiceFilterRequestModel(
        cdoMasterId: cdoMasterId,
        status: status,
        tenantCode: currentTenantCode,
        page: _currentPage,
        pageSize: _rowSize,
      );

      debugPrint('Invoice Filter Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postFilterInvoiceTransaction(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<InvoiceRecord> newData =
        data.map((json) => InvoiceRecord.fromJson(json)).toList();

        if (newData.length < _rowSize) {
          hasMoreData = false;
        }

        if (isLoadMore) {
          _invoiceList.addAll(newData);
        } else {
          _invoiceList = newData;
        }

        _currentPage++;
        return true;
      } else {
        throw Exception("Failed to fetch Invoice details");
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      isPaginating = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchVehicleTransactions(int cdoMasterId) async {
    isLoading = true;
    _errorMessage = null;
    _vehicleTransactionList.clear();
    safeNotifyListeners();

    try {
      final request = VehicleTransactionRequestModel(
        cdoMasterId: cdoMasterId,
        currentPage: 1,
        rowSize: 15,
        tenantCode: currentTenantCode,
        transactionType: 'Outbound',
      );

      debugPrint('Filter Vehicle Transaction Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postFilterVehicalTransaction(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        _vehicleTransactionList = data
            .map((json) => VehicleTransactionResponseModel.fromJson(json))
            .toList();
        debugPrint('Filter Vehicle Transaction : $response');
        return true;
      } else {
        throw Exception("Failed to fetch vehicle transactions");
      }
    } catch (e) {
      debugPrint('Filter Vehicle Transaction Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchSingleDH(String dhCode) async {
    isLoading = true;
    _errorMessage = null;
    _singleDHData = null;
    safeNotifyListeners();

    try {
      final response = await _apiService.postFilterSingleDH(dhCode);

      if (response != null && response.statusCode == 200 && response.data != null) {
        if (response.data is List && (response.data as List).isNotEmpty) {
          _singleDHData = response.data[0];
        } else if (response.data is Map<String, dynamic>) {
          _singleDHData = response.data;
        }
        return true;
      } else {
        throw Exception("Failed to fetch DH details");
      }
    } catch (e) {
      debugPrint('Single DH Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> fetchVehicleMilestoneDetails({
    required String tenantCode,
    required String transactionCode,
  }) async {
    _isMilestoneLoading = true;
    _errorMessage = null;
    _vehicleMilestoneDetail.clear(); // Fixed: avoid assigning null to a List
    safeNotifyListeners();

    try {
      final request = VehicleMilestoneRequestModel(
        tenantCode: tenantCode,
        transactionCode: transactionCode,
      );

      debugPrint('Vehicle Milestone Detail Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postVehicleMilestoneDetails(request);

      debugPrint('📥 [API RESPONSE] Vehicle Milestone Status Code: ${response?.statusCode}');

      if (response != null && response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data;
        _vehicleMilestoneDetail = data
            .map((json) => VehicleMilestoneResponse.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch vehicle milestone details (Status: ${response?.statusCode})");
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [API ERROR] Vehicle Milestone Detail Error: $e');
      debugPrint('   -> StackTrace: $stackTrace');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isMilestoneLoading = false;
      safeNotifyListeners();
    }
  }
  /// Fetch Milestone Plan data for the Vehicle Trip screen
  Future<void> fetchMilestonePlan({required String transactionCode}) async {
    print("🚀 [ViewModel] fetchMilestonePlan called with transactionCode: '$transactionCode'");

    if (transactionCode.isEmpty) {
      print("⚠️ [ViewModel] Transaction code is empty.");
      _errorMessage = 'Transaction code cannot be empty.';
      notifyListeners();
      return;
    }

    try {
      _isMilestoneLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 1. Create request model object
      final request = MilestonePlanRequestModel(transactionCode: transactionCode);
      print("📦 [ViewModel] Request payload built: ${request.toJson()}");

      // 2. Call the ApiService method
      print("🌐 [ViewModel] Calling ApiService.postGetMilestonePlan...");
      final response = await _apiService.postGetMilestonePlan(request);

      if (response == null) {
        print("⚠️ [ViewModel] API response is NULL.");
        _milestonePlanList = [];
        return;
      }

      print("📥 [ViewModel] Response received with status code: ${response.statusCode}");
      print("📥 [ViewModel] Response raw data: ${response.data}");

      // 3. Handle HTTP 204 No Content or empty data safely
      if (response.statusCode == 204 || response.data == null) {
        print("ℹ️ [ViewModel] Server returned 204 No Content. Setting milestone list to empty.");
        _milestonePlanList = [];
        return;
      }

      final dynamic responseData = response.data;

      // 4. Parse the response into MilestonePlanResponseModel list
      if (responseData is List) {
        print("⚙️ [ViewModel] Parsing data as a direct List of length: ${responseData.length}");
        _milestonePlanList = responseData
            .map((json) => MilestonePlanResponseModel.fromJson(json))
            .toList();
      } else if (responseData is Map<String, dynamic> && responseData['data'] is List) {
        final listData = responseData['data'] as List;
        print("⚙️ [ViewModel] Parsing data wrapped inside 'data' key of length: ${listData.length}");
        _milestonePlanList = listData
            .map((json) => MilestonePlanResponseModel.fromJson(json))
            .toList();
      } else {
        print("⚠️ [ViewModel] Response data structure did not match expected List formats.");
        _milestonePlanList = [];
      }

      print("✅ [ViewModel] Successfully mapped ${_milestonePlanList.length} milestone items.");

    } catch (e) {
      // 5. Intercept status 204 thrown by ApiService/Dio exceptions and handle gracefully
      if (e.toString().contains('204')) {
        print("ℹ️ [ViewModel] Caught 204 status exception. Treating as empty milestone list.");
        _milestonePlanList = [];
        _errorMessage = null;
      } else {
        print("❌ [ViewModel] Error fetching milestone plan: $e");
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _milestonePlanList = [];
      }
    } finally {
      _isMilestoneLoading = false;
      notifyListeners();
      print("🏁 [ViewModel] fetchMilestonePlan finished. Loading state reset.");
    }
  }
// --- 1. Filter Condition Type ---
  Future<bool> postFilterConditionType(int conditionTypeId) async {
    isLoading = true;
    _errorMessage = null;
    _conditionTypeList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Filter Condition Type Payload: ${jsonEncode({'CondtionTypeId': conditionTypeId})}');

      final response = await _apiService.postFilterConditionType(conditionTypeId);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _conditionTypeList = listToParse
            .map((json) => ConditionTypeResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch condition type details");
      }
    } catch (e) {
      debugPrint('Filter Condition Type Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 2. Filter Currencies ---
  Future<bool> postFilterCurrencies(int currencyId, String currencyCode, bool isActive) async {
    isLoading = true;
    _errorMessage = null;
    _currencyList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Filter Currencies Payload: ${jsonEncode({'CurrencyId': currencyId, 'CurrencyCode': currencyCode, 'IsActive': isActive})}');

      final response = await _apiService.postFilterCurrencies(currencyId, currencyCode, isActive);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _currencyList = listToParse
            .map((json) => CurrencyResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch currency details");
      }
    } catch (e) {
      debugPrint('Filter Currencies Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 3. Filter Payment Terms ---
  Future<bool> postFilterPaymentTerms(int paymentTermsId) async {
    isLoading = true;
    _errorMessage = null;
    _paymentTermsList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Filter Payment Terms Payload: ${jsonEncode({'PaymentTermsId': paymentTermsId})}');

      final response = await _apiService.postFilterPaymentTerms(paymentTermsId);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _paymentTermsList = listToParse
            .map((json) => PaymentTermsResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch payment terms details");
      }
    } catch (e) {
      debugPrint('Filter Payment Terms Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 4. Filter Customers ---
  Future<bool> postFilterCustomers(CustomerRequestModel request) async {
    isLoading = true;
    _errorMessage = null;
    _customerList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Filter Customers Payload: ${jsonEncode(request.toJson())}');

      final response = await _apiService.postFilterCustomers(request);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _customerList = listToParse
            .map((json) => CustomerResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch customer details");
      }
    } catch (e) {
      debugPrint('Filter Customers Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 5. Get Paginated Distribution Channel List ---
  Future<bool> getPaginatedDistributionChannelList(int dcId) async {
    isLoading = true;
    _errorMessage = null;
    _distributionChannelList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Distribution Channel Payload: ${jsonEncode({'DCId': dcId})}');

      final response = await _apiService.getPaginatedDistributionChannelList(dcId);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _distributionChannelList = listToParse
            .map((json) => DistributionChannelResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch distribution channel details");
      }
    } catch (e) {
      debugPrint('Distribution Channel Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 6. Get Paginated Division List ---
  Future<bool> getPaginatedDivisionList(int divId) async {
    isLoading = true;
    _errorMessage = null;
    _divisionList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Division List Payload: ${jsonEncode({'DivId': divId})}');

      final response = await _apiService.getPaginatedDivisionList(divId);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _divisionList = listToParse
            .map((json) => DivisionResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch division details");
      }
    } catch (e) {
      debugPrint('Division List Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 7. Get Paginated IncoTerm List ---
  Future<bool> getPaginatedIncoTermList(int incId) async {
    isLoading = true;
    _errorMessage = null;
    _incotermsList.clear();
    safeNotifyListeners();

    try {
      debugPrint('IncoTerm List Payload: ${jsonEncode({'IncId': incId})}');

      final response = await _apiService.getPaginatedIncoTermList(incId);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _incotermsList = listToParse
            .map((json) => IncotermsResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch incoterms details");
      }
    } catch (e) {
      debugPrint('IncoTerm List Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 8. Post Filter Tax Type ---
  Future<bool> postFilterTaxType(int taxTypeId) async {
    isLoading = true;
    _errorMessage = null;
    _taxTypeList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Filter Tax Type Payload: ${jsonEncode({'TaxTypeId': taxTypeId})}');

      final response = await _apiService.postFilterTaxType(taxTypeId);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _taxTypeList = listToParse
            .map((json) => TaxTypeResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch tax type details");
      }
    } catch (e) {
      debugPrint('Filter Tax Type Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 9. Get Paginated Order Type List ---
  Future<bool> getPaginatedOrderTypeList(int otId) async {
    isLoading = true;
    _errorMessage = null;
    _orderTypeList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Order Type List Payload: ${jsonEncode({'OTId': otId})}');

      final response = await _apiService.getPaginatedOrderTypeList(otId);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _orderTypeList = listToParse
            .map((json) => OrderTypeResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch order type details");
      }
    } catch (e) {
      debugPrint('Order Type List Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 10. Post Filter Product ---
  Future<bool> postFilterProduct(int productId) async {
    isLoading = true;
    _errorMessage = null;
    _productList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Filter Product Payload: ${jsonEncode({'productId': productId})}');

      final response = await _apiService.postFilterProduct(productId);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _productList = listToParse
            .map((json) => ProductResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch product details");
      }
    } catch (e) {
      debugPrint('Filter Product Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 11. Get All Tenant Groups ---
  Future<bool> getAlltenantgroup() async {
    isLoading = true;
    _errorMessage = null;
    _tenantGroupList.clear();
    safeNotifyListeners();

    try {
      final response = await _apiService.getAlltenantgroup();

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _tenantGroupList = listToParse
            .map((json) => TenantGroupResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch tenant groups");
      }
    } catch (e) {
      debugPrint('Get All Tenant Groups Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 12. Get All Tenants ---
  Future<bool> getAllTenants() async {
    isLoading = true;
    _errorMessage = null;
    _tenantList.clear();
    safeNotifyListeners();

    try {
      final response = await _apiService.getAllTenants();

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _tenantList = listToParse
            .map((json) => TenantResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch tenants");
      }
    } catch (e) {
      debugPrint('Get All Tenants Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

// --- 13. Post Filter Single Customer Delivery Location ---
  Future<bool> postFilterSingleCustomerDeliveryLocation(String locationCode) async {
    isLoading = true;
    _errorMessage = null;
    _customerLocationList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Customer Delivery Location Payload: ${jsonEncode({'LocationCode': locationCode})}');

      final response = await _apiService.postFilterSingleCustomerDeliveryLocation(locationCode);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _customerLocationList = listToParse
            .map((json) => CustomerLocationResponseModel.fromJson(json))
            .toList();

        return true;
      } else {

        debugPrint("Warning: No customer location found for code: $locationCode");
        return false;
      }
    } catch (e) {
      debugPrint('Customer Delivery Location Error: $e');
      _errorMessage = null; // Prevent showing raw technical exception messages to users
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  // --- 14. Post Filter Location With Pagination ---
  Future<bool> postFilterLocationWithPagination(String plantCode, String tenantCode) async {
    isLoading = true;
    _errorMessage = null;
    _locationList.clear();
    safeNotifyListeners();

    try {
      debugPrint('Location Pagination Payload: ${jsonEncode({'plantCode': plantCode, 'tenantCode': tenantCode})}');

      final response = await _apiService.postFilterLocationWithPagination(plantCode, tenantCode);

      if (response != null && response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;
        List<dynamic> listToParse = data is List ? data : [data];

        _locationList = listToParse
            .map((json) => LocationResponseModel.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch location details");
      }
    } catch (e) {
      debugPrint('Location Pagination Error: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }
  // --- Reset State ---
  void reset() {
    isLoading = false;
    isPaginating = false;
    _milestonePlanList = [];
    _isMilestoneLoading = false;

    _bdoList.clear();
    _routeList.clear();
    _cdoList.clear();
    _transporterList.clear();
    _invoiceList.clear();

    _mdoList.clear();
    _stoList.clear();

    _paymentTermsList.clear();
    _customerList.clear();
    _distributionChannelList.clear();
    _divisionList.clear();
    _incotermsList.clear();
    _taxTypeList.clear();
    _orderTypeList.clear();
    _productList.clear();
    _tenantGroupList.clear();
    _tenantList.clear();
    _customerLocationList.clear();
    _locationList.clear();

    _singleDHData = null;
    _vehicleMilestoneDetail.clear();

    _selectedInvoice = null;
    _errorMessage = null;
    _currentPage = 1;
    hasMoreData = true;
    isLoading = false;
    _errorMessage = null;
    _paymentTermsList.clear();
    _customerList.clear();
    _distributionChannelList.clear();
    _divisionList.clear();
    _incotermsList.clear();
    _taxTypeList.clear();
    _orderTypeList.clear();
    _productList.clear();
    _tenantGroupList.clear();
    _tenantList.clear();
    _customerLocationList.clear();
    _locationList.clear();
    safeNotifyListeners();
  }
}