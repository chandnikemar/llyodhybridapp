import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_lloyd_web_app/model/dashboard/hourlydispatchtrend/hourly_summary.dart';
import 'package:ut_lloyd_web_app/model/dashboard/tatsummary/tat_summary.dart';
import 'package:ut_lloyd_web_app/model/dashboard/tripsummary/trip_summary.dart';
import 'package:ut_lloyd_web_app/model/dashboard/vehicleinside/vehicle_inside.dart';
import 'package:ut_lloyd_web_app/model/reports/vtroutbound/reports_vtr_outbound_model.dart';
import '../main.dart';
import '../model/dashboard/dailysummary/material_summary_report.dart';
import '../model/dashboard/dailysummary/open_do_details.dart';
import '../model/dashboard/expectedvehiclesatdifferentstages/vehicle_queue_details.dart';
import '../model/ordermanagement/bulkdemand/bdo_request_model.dart';
import '../model/ordermanagement/bulkdemand/route_request_model.dart';
import '../model/ordermanagement/deliveryorders/delivery_orders_request_model.dart';
import '../model/ordermanagement/deliveryorders/invoice_transaction_request_model.dart';
import '../model/ordermanagement/deliveryorders/milestoneplan_request_model.dart';
import '../model/ordermanagement/deliveryorders/vehical_milstone_request_model.dart';
import '../model/ordermanagement/deliveryorders/vehical_transaction_request_model.dart';
import '../model/ordermanagement/purchaseorder/filter_po_masters_request.dart';
import '../model/ordermanagement/sosto/filter_mdo_master_request_model.dart';
import '../model/ordermanagement/sosto/filter_sto_master_request.dart';
import '../model/ordermanagement/sosto/sostodetail/customer_request_model.dart';

import '../model/reports/dailydispatchreport/reports_daily_dispatch_request_model.dart';
import '../model/reports/salereport/sales_order_model.dart';
import '../model/reports/salereport/so_sc_po_model.dart';
import '../model/reports/vtrinbound/reports_vtr_inbound_model.dart';
import '../utilities/common.dart';
import '../utilities/common_config.dart';
import '../view/screen/login_screen.dart';

class ApiService {
  static final ApiService _instance = ApiService._();
  late Dio _dio;

  // 🔹 ADD THESE TWO FLAGS TO CONTROL RACE CONDITIONS
  bool _isRefreshing = false;
  bool _isRedirecting = false;

  ApiService._(); // private constructor

  /// 🔹 Call this once in main() before runApp()
  static Future<ApiService> init() async {
    await _instance._initializeDio();
    return _instance;
  }

  /// 🔹 Use this everywhere in your ViewModels
  static ApiService get instance => _instance;

  Future<void> _initializeDio() async {
    final baseUrl = await _getFullUrl();
    _dio = Dio(BaseOptions(baseUrl: baseUrl));

    // ✅ Allow all certs (DEV ONLY)
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 🔹 If we are already redirecting, block all other outbound APIs instantly
        if (_isRedirecting) {
          return handler.reject(DioException(
            requestOptions: options,
            error: 'Session expired. Aborting request.',
          ));
        }

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('jwtToken');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';

        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.path.contains(Common.getRefreshToken)) {
          // 🔹 If we are already redirecting, just ignore the rest of the 401 errors
          if (_isRedirecting) {
            return handler.next(error);
          }

          // 🔹 Prevent multiple API calls from triggering refresh at the exact same time
          if (!_isRefreshing) {
            _isRefreshing = true;
            final isRefreshed = await _refreshToken();
            _isRefreshing = false;

            if (isRefreshed) {
              print("✅ Token refreshed");
              return handler.resolve(await _retry(error.requestOptions));
            } else {
              await _redirectToLogin();
              return handler.next(error);
            }
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<String> _getFullUrl() async {
    final baseUrl = Common.baseUrl;
    if (baseUrl.isEmpty) {
      return ""; // Return empty if baseUrl is not set
    }
    return baseUrl;
  }

  Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString(Common.refreshToken);

    if (refreshToken != null) {
      try {
        final baseUrl = await _getFullUrl();
        final response = await _dio.post(
          "$baseUrl${Common.getRefreshToken}",
          data: {'Token': refreshToken},
        );

        if (response.data != null && response.data[Common.jwtToken] != null) {
          prefs.setString(Common.jwtToken, response.data[Common.jwtToken]);
          prefs.setString(
              Common.refreshToken, response.data[Common.refreshToken]);
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print('Error refreshing token: $e');
        return false;
      }
    } else {
      return false; // No refresh token available
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final prefs = await SharedPreferences.getInstance();
    final newToken = prefs.getString(Common.jwtToken);
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newToken',
      },
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  Future<void> _redirectToLogin() async {
    // Double check to make sure we absolutely only run this once
    if (_isRedirecting) return;
    _isRedirecting = true; // Lock it

    final prefs = await SharedPreferences.getInstance();

    // Wipe all user data
    await prefs.remove(Common.userName);
    await prefs.remove(Common.firstName);
    await prefs.remove(Common.lastName);
    await prefs.remove(Common.email);
    await prefs.remove(Common.mobileNumber);
    await prefs.remove(Common.roleName);
    await prefs.remove(Common.isVerified);
    await prefs.remove(Common.jwtToken);
    await prefs.remove(Common.refreshToken);
    await prefs.remove(Common.tenantGroup);
    await prefs.remove(Common.defaultTenantCode);
    await prefs.remove(Common.selectedTenant);
    await prefs.remove(Common.bpCode);
    await prefs.remove(Common.userAccess);
    await prefs.remove(Common.menuAccess);
    await prefs.remove(Common.userTenants);
    await prefs.setBool(Common.isLoggedIn, false);

    // Reset all ViewModels here
    final context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      try {
        // Provider.of<LoginViewModel>(context, listen: false).reset();
        // Provider.of<HomeDashboardViewModel>(context, listen: false).reset();
      } catch (e) {
        print('Error resetting viewmodels: $e');
      }
    }

    // Navigate to login screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );

      // Unlock after a short delay so the user can login again successfully
      Future.delayed(const Duration(seconds: 2), () {
        _isRedirecting = false;
      });
    });

    print('Redirecting to login...');
  }

  Future<T> handleDioException<T>(DioException e, String getMessage) async {
    if (e.response != null) {
      final responseData = e.response?.data;

      // Helper to safely extract a non-empty string message from dynamic response data
      String? extractMessage(dynamic data) {
        Map<String, dynamic>? jsonMap;

        if (data is Map<String, dynamic>) {
          jsonMap = data;
        } else if (data is String) {
          try {
            final parsed = jsonDecode(data);
            if (parsed is Map<String, dynamic>) {
              jsonMap = parsed;
            }
          } catch (_) {
            // If raw string is not JSON and not empty, use it directly
            if (data.trim().isNotEmpty) return data;
          }
        }

        if (jsonMap != null) {
          final rawMsg = jsonMap[getMessage] ??
              jsonMap['message'] ??
              jsonMap['errorMessage'];

          if (rawMsg != null && rawMsg.toString().trim().isNotEmpty) {
            return rawMsg.toString();
          }
        }

        return null;
      }

      // 401 Unauthorized handling
      if (e.response?.statusCode == 401) {
        final customMessage = extractMessage(responseData);
        if (customMessage != null) {
          return Future.error(customMessage);
        }
        return Future.error(CommonConfig.sessionExpired);
      }

      // General exception response handling
      print('Error response data: $responseData');
      try {
        final message = extractMessage(responseData);
        return Future.error(message ?? 'Unknown error occurred');
      } catch (jsonError) {
        print('JSON Parsing Error: $jsonError');
        return Future.error('Failed to parse error response');
      }
    }

    return Future.error('Network error, please try again');
  }

  // Login
  Future<Response?> login(String username, String password) async {
    try {
      final baseUrl = await _getFullUrl();
      final response = await _dio.post(
        "$baseUrl${Common.postAuthenticate}",
        data: {
          'username': username,
          'password': password,
        },
      );
      return response; // Return Response object if successful
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  // Switch Tenant
  Future<Response?> switchTenant(String tenantCode, String refreshToken) async {
    try {
      final baseUrl = await _getFullUrl();
      print('🔑 [SwitchTenant API] Request with tenantCode: $tenantCode');
      print('🔑 [SwitchTenant API] Using refreshToken: ${refreshToken.substring(0, 20)}...');
      final response = await _dio.post(
        "$baseUrl${Common.switchTenant}",
        data: {
          'tenantCode': tenantCode,
          'Token': refreshToken,
        },
      );
      if (response.data != null && response.data['jwtToken'] != null) {
        print('🔑 [SwitchTenant API] Response jwtToken: ${response.data['jwtToken'].substring(0, 20)}...');
      }
      if (response.data != null && response.data['refreshToken'] != null) {
        print('🔑 [SwitchTenant API] Response refreshToken: ${response.data['refreshToken'].substring(0, 20)}...');
      }
      return response; // Return Response object if successful
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  // Login
  Future<Response?> changePassword(String username, String password,
      String oldPassword, String confirmPassword) async {
    try {
      final baseUrl = await _getFullUrl();
      final response = await _dio.post(
        "$baseUrl${Common.changePassword}",
        data: {
          'ConfirmPassword': confirmPassword,
          'OldPassword': oldPassword,
          'Password': password,
          'userName': username,
        },
      );
      return response; // Return Response object if successful
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> forgotPassword(
    String username,
  ) async {
    try {
      final baseUrl = await _getFullUrl();
      final response = await _dio.post(
        "$baseUrl${Common.forgotPassword}",
        data: {
          'userName': username,
        },
      );
      return response; // Return Response object if successful
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> resetPassword(String username, String otp, String password,
      String confirmPassword, String token) async {
    try {
      final baseUrl = await _getFullUrl();
      final response = await _dio.post(
        "$baseUrl${Common.resetPassword}",
        data: {
          'userName': username,
          'otp': otp,
          'password': password,
          'confirmPassword': confirmPassword,
          'token': token,
        },
      );
      return response; // Return Response object if successful
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  // --- API METHODS REMAIN THE SAME BELOW ---

  Future<Response?> getVehicleTransactionSummaryDashboardReport(
      TripSummaryRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.getVehicleTransactionSummaryDashboardReport}",
          data: request.toJson());
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getVehicleTransactionTATDashboardReport(
      TatSummaryRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.getVehicleTransactionTATDashboardReport}",
          data: request.toJson());
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getVehicleTransactionSummaryDashboardReportVehicleInside(
      VehicleInsideRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.getVehicleTransactionSummaryDashboardReportVehicleInside}",
          data: request.toJson());
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getHourlyDispatchReport(
      HourlySummaryRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post("$baseUrl${Common.getHourlyDispatchReport}",
          data: request.toJson());
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getVehicleQueueDetails(VehicleQueueRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.get("$baseUrl${Common.getVehicleQueueDetails}",
          queryParameters: request.toJson());
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getOpenDODetailsAsync(OpenDoRequest request) async {
    try {
      final baseUrl = await _getFullUrl();


      return await _dio.post("$baseUrl${Common.getOpenDODetailsAsync}",
          data: request.toJson());

    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getMaterialDispatchSummaryReport(
      MaterialDispatchRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.getMaterialDispatchSummaryReport}",
          data: request.toJson());
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getMaterialInOutSummary(
      MaterialDispatchNewRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post("$baseUrl${Common.getMaterialInOutSummary}",
          data: request.toJson());
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  ///Reports ///Management report

//Sales Report
// 1. Fetch Sales Report (DO Wise)

  Future<Response?> getSalesReport(SalesReportRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.getSalesReport}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

// 2. Fetch Sales Report (SO / SC / PO Wise)
  Future<Response?> getSalesReportSOSCPO(SalesSOSCPORequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.getSalesReportSOSCPO}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  //Vtr _outbound
  Future<Response?> getReportsOutboundVTRView(
      ReportsVtrOutboundRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.getReportsOutboundVTRView}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getReportsInBoundVTRView(
      ReportsVtrInboundRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.getReportsInBoundVTRView}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getDayDispatchReport(
      ReportsDailyDispatchRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.getDayDispatchReport}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  ////Order Management
  //Bulk Demand
  Future<Response?> getPaginatedBdoList(BdoRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.getPaginatedBdoList}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterRouteMaster(RouteRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.postFilterRouteMaster}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  //Delivery Orders
  Future<Response?> postFilterCDODetails(CdoFilterRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.postFilterCDODetails}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> getActiveTransporterList() async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.get(
        "$baseUrl${Common.getActiveTransporterList}",
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> postFilterVehicalTransaction(VehicleTransactionRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.postFilterVehicleTransaction}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postGetMilestonePlan(MilestonePlanRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.postGetMilestonePlan}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> postVehicleMilestoneDetails(VehicleMilestoneRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.getVehicleMilestoneDetails}", // Update with your correct endpoint constant
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterInvoiceTransaction(InvoiceFilterRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.postFilterInvoiceTransaction}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> getPaginatedEWayBillList() async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.get(
        "$baseUrl${Common.getPaginatedEWayBillList}",
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterSingleDH(String DHCode) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.postFilterSingleDH}",
        data: {
          'DHCode': DHCode,
        },
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> postFilterMDOMasters(FilterMdoMasterRequest request) async {

    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterMDOMasters}",
          data: request.toJson()
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterSTOMasters(FilterStoMasterRequest request) async {

    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterSTOMasters}",
          data: request.toJson()
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterConditionType(int CondtionTypeId) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterConditionType}",
          data: {'CondtionTypeId':CondtionTypeId}
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterCurrencies(int CurrencyId,String CurrencyCode,bool IsActive) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterCurrencies}",
          data: {'CurrencyId':CurrencyId,'CurrencyCode':CurrencyCode,'IsActive':IsActive}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterPaymentTerms(int PaymentTermsId) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterPaymentTerms}",
          data: {'PaymentTermsId':PaymentTermsId}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?>postFilterPOMasters(FilterPoMastersRequest request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.postFilterPOMasters}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }

  Future<Response?> postFilterCustomers(CustomerRequestModel request) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
        "$baseUrl${Common.postFilterCustomers}",
        data: request.toJson(),
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> getPaginatedDistributionChannelList(int DCId) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.getPaginatedDistributionChannelList}",
          data: {'DCId':DCId}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> getPaginatedDivisionList(int DivId) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.getPaginatedDivisionList}",
          data: {'DivId':DivId}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> getPaginatedIncoTermList(int IncId) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.getPaginatedIncoTermList}",
          data: {'IncId':IncId}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterTaxType(int TaxTypeId) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterTaxType}",
          data: {'TaxTypeId':TaxTypeId}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> getPaginatedOrderTypeList(int OTId) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.getPaginatedOrderTypeList}",
          data: {'OTId':OTId}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterProduct(int productId) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterProduct}",
          data: {'productId':productId}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> getAlltenantgroup() async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.get(
        "$baseUrl${Common.getalltenantgroup}",
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> getAllTenants() async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.get(
        "$baseUrl${Common.getAllTenants}",
      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterSingleCustomerDeliveryLocation(String LocationCode) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterSingleCustomerDeliveryLocation}",
          data: {'LocationCode':LocationCode}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
  Future<Response?> postFilterLocationWithPagination(String plantCode,String tenantCode) async {
    try {
      final baseUrl = await _getFullUrl();
      return await _dio.post(
          "$baseUrl${Common.postFilterLocationWithPagination}",
          data: {'plantCode':plantCode,'tenantCode':tenantCode}

      );
    } on DioException catch (e) {
      return handleDioException(e, 'message');
    }
  }
}
