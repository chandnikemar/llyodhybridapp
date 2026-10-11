import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../model/dashboard/dailysummary/material_summary_report.dart';
import '../model/dashboard/dailysummary/open_do_details.dart';
import '../model/dashboard/expectedvehiclesatdifferentstages/vehicle_queue_details.dart';
import '../model/dashboard/hourlydispatchtrend/hourly_summary.dart';
import '../model/dashboard/tatsummary/tat_summary.dart';
import '../model/dashboard/tripsummary/trip_summary.dart';
import '../model/dashboard/vehicleinside/vehicle_inside.dart';
import '../service/api_service.dart';

class DashboardReportViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  String currentTenantCode = '';
  bool _isDisposed = false;
  // --- 1. Store the UI Labels (e.g., "Today", "Custom") ---
  String tripFilter = 'Today';
  String tatFilter = 'Today';
  String hourlyFilter = 'Today';
  String dailySummaryFilter = 'Today';

  // --- 2. Store the formatted Dates ("yyyy-MM-dd HH:mm:ss") ---
  String tripFromDate = '';
  String tripToDate = '';

  String tatFromDate = '';
  String tatToDate = '';

  String hourlyFromDate = '';
  String hourlyToDate = '';

  String dailyFromDate = '';
  String dailyToDate = '';

  // Individual Loading States
  bool isTripLoading = false;
  bool isTatLoading = false;
  bool isVehicleInsideLoading = false;
  bool isHourlyLoading = false;
  bool isQueueLoading = false;
  bool isOpenDoLoading = false;
  bool isMaterialLoading = false;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

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

  DashboardReportViewModel() {
    _initDefaultDates(); // Setup 'Today' bounds by default
  }

  void _initDefaultDates() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');

    // 🔹 FIX: Replaced the space with a 'T' (ISO 8601 format)
    final fromToday = "$y-$m-${d}T00:00:00";
    final toToday = "$y-$m-${d}T23:59:59";

    tripFromDate = fromToday;
    tripToDate = toToday;
    tatFromDate = fromToday;
    tatToDate = toToday;
    hourlyFromDate = fromToday;
    hourlyToDate = toToday;
    dailyFromDate = fromToday;
    dailyToDate = toToday;
  }

  // --- 3. REFRESH ALL METHOD ---
  Future<void> refreshAll(String tenantCode) async {
    currentTenantCode = tenantCode;
    _errorMessage = null;
    safeNotifyListeners(); // 🔹 Updated

    await Future.wait([
      fetchTripSummary(TripSummaryRequest(
          tenantCode: tenantCode, fromDate: tripFromDate, toDate: tripToDate)),
      fetchTatSummary(TatSummaryRequest(
          tenantCode: tenantCode, fromDate: tatFromDate, toDate: tatToDate)),
      fetchVehicleInsideSummary(VehicleInsideRequest(
          tenantCode: tenantCode,
          fromDate: dailyFromDate,
          toDate: dailyToDate)),
      fetchHourlySummary(HourlySummaryRequest(
          tenantCode: tenantCode, reportDate: hourlyFromDate)),
      fetchVehicleQueueDetails(VehicleQueueRequest(
          tenantCode: tenantCode,
          fromDate: dailyFromDate,
          toDate: dailyToDate)),
      fetchOpenDoDetails(OpenDoRequest(
          tenantCode: tenantCode,
          fromDate: dailyFromDate,
          toDate: dailyToDate)),
      fetchMaterialDispatchSummary(MaterialDispatchRequest(
          tenantCode: tenantCode,
          fromDate: dailyFromDate,
          toDate: dailyToDate)),
      fetchMaterialDispatchNewSummary(MaterialDispatchNewRequest(
          tenantCode: tenantCode,
          fromDate: dailyFromDate,
          toDate: dailyToDate)),
    ]);
  }

  // --- 4. INDIVIDUAL FILTER UPDATES ---
  // Updated to accept the 'label' so the UI can update "Total trips Today" to "Total trips Yesterday"
  void updateTripFilter(
      String tenantCode, String label, String fromDate, String toDate) {
    tripFilter = label;
    tripFromDate = fromDate;
    tripToDate = toDate;
    fetchTripSummary(TripSummaryRequest(
        tenantCode: tenantCode, fromDate: tripFromDate, toDate: tripToDate));
  }

  void updateTatFilter(
      String tenantCode, String label, String fromDate, String toDate) {
    tatFilter =
        label; // <--- FIXED: This was accidentally set to 'tripFilter = label;' before!
    tatFromDate = fromDate;
    tatToDate = toDate;
    fetchTatSummary(TatSummaryRequest(
        tenantCode: tenantCode, fromDate: tatFromDate, toDate: tatToDate));
  }

  void updateHourlyFilter(
      String tenantCode, String label, String fromDate, String toDate) {
    hourlyFilter = label;
    hourlyFromDate = fromDate;
    hourlyToDate = toDate;
    fetchHourlySummary(HourlySummaryRequest(
        tenantCode: tenantCode, reportDate: hourlyFromDate));
  }

  void updateDailySummaryFilter(
      String tenantCode, String label, String fromDate, String toDate) async {
    dailySummaryFilter = label;
    dailyFromDate = fromDate;
    dailyToDate = toDate;

    print('tenantcodes - - $tenantCode');

    // 1. Instantly clear old data so the UI drops the stale numbers
    _openDoResponse = null;
    _materialDispatchResponse = null;
    _materialDispatchNewResponse = null;

    // 2. Force loading states to true
    isOpenDoLoading = true;
    isMaterialLoading = true;
    safeNotifyListeners(); // 🔹 Updated

    // 3. Fire API calls exactly like refreshAll using await Future.wait
    await Future.wait([
      fetchOpenDoDetails(OpenDoRequest(
          tenantCode: tenantCode, fromDate: dailyFromDate, toDate: dailyToDate)),
      fetchMaterialDispatchNewSummary(MaterialDispatchNewRequest(
          tenantCode: tenantCode, fromDate: dailyFromDate, toDate: dailyToDate)),
      fetchMaterialDispatchSummary(MaterialDispatchRequest(
          tenantCode: tenantCode, fromDate: dailyFromDate, toDate: dailyToDate)),
    ]);

    // 4. Force one final UI rebuild once ALL data has safely arrived
    safeNotifyListeners(); // 🔹 Updated
  }

  // --- 5. DATA RESPONSES & FETCH METHODS ---

  /// Fetch Trip Summary Report
  List<TripSummaryResponse>? _tripSummaryResponse;

  List<TripSummaryResponse>? get tripSummaryResponse => _tripSummaryResponse;

  Future<bool> fetchTripSummary(TripSummaryRequest request) async {
    isTripLoading = true;
    _errorMessage = null;
    safeNotifyListeners(); // 🔹 Updated

    try {
      final response = await _apiService
          .getVehicleTransactionSummaryDashboardReport(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        _tripSummaryResponse =
            data.map((json) => TripSummaryResponse.fromJson(json)).toList();

        return true;
      } else {
        throw Exception("Failed to fetch Trip Summary");
      }
    } catch (e) {
      _tripSummaryResponse = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isTripLoading = false;
      safeNotifyListeners(); // 🔹 Updated
    }
  }

  /// Fetch TAT Summary Report
  List<TatSummaryResponse>? _tatSummaryResponse;

  List<TatSummaryResponse>? get tatSummaryResponse => _tatSummaryResponse;

  Future<bool> fetchTatSummary(TatSummaryRequest request) async {
    isTatLoading = true;
    _errorMessage = null;
    safeNotifyListeners(); // 🔹 Updated

    try {
      final response =
      await _apiService.getVehicleTransactionTATDashboardReport(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        _tatSummaryResponse =
            data.map((json) => TatSummaryResponse.fromJson(json)).toList();
        return true;
      } else {
        throw Exception("Failed to fetch TAT Summary");
      }
    } catch (e) {
      _tatSummaryResponse = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isTatLoading = false;
      safeNotifyListeners(); // 🔹 Updated
    }
  }

  /// Fetch Vehicle Inside Summary
  List<VehicleInsideResponse>? _vehicleInsideResponse;

  List<VehicleInsideResponse>? get vehicleInsideResponse =>
      _vehicleInsideResponse;

  int get totalVehiclesInside {
    int total = 0;

    if (_vehicleInsideResponse != null) {
      for (var item in _vehicleInsideResponse!) {
        final int count = item.transactionCount ?? 0;

        final String direction =
        (item.direction ?? '').trim().toLowerCase();

        final String status =
        (item.transactionStatus ?? '').trim().toLowerCase();

        if (status == 'withinplant' &&
            (direction == 'inbound' || direction == 'outbound')) {
          total += count;
        }
      }
    }

    return total;
  }

  Future<bool> fetchVehicleInsideSummary(
      VehicleInsideRequest request) async {
    isVehicleInsideLoading = true;
    _errorMessage = null;
    safeNotifyListeners();

    try {
      final response = await _apiService
          .getVehicleTransactionSummaryDashboardReportVehicleInside(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        _vehicleInsideResponse = data
            .map((json) => VehicleInsideResponse.fromJson(json))
            .toList();

        return true;
      } else {
        throw Exception("Failed to fetch Vehicle Inside Summary");
      }
    } catch (e) {
      _vehicleInsideResponse = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isVehicleInsideLoading = false;
      safeNotifyListeners();
    }
  }

  /// Hourly dispatch trend
  List<HourlySummaryResponse>? _hourlySummaryResponse;

  List<HourlySummaryResponse>? get hourlySummaryResponse =>
      _hourlySummaryResponse;

  Future<bool> fetchHourlySummary(HourlySummaryRequest request) async {
    isHourlyLoading = true;
    _errorMessage = null;
    safeNotifyListeners(); // 🔹 Updated

    try {
      final response = await _apiService.getHourlyDispatchReport(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        _hourlySummaryResponse =
            data.map((json) => HourlySummaryResponse.fromJson(json)).toList();
        return true;
      } else {
        throw Exception("Failed to fetch Hourly Summary");
      }
    } catch (e) {
      _hourlySummaryResponse = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isHourlyLoading = false;
      safeNotifyListeners(); // 🔹 Updated
    }
  }

  /// Expected vehicles at different stages
  List<VehicleQueueResponse>? _vehicleQueueResponse;

  List<VehicleQueueResponse>? get vehicleQueueResponse => _vehicleQueueResponse;

  Future<bool> fetchVehicleQueueDetails(VehicleQueueRequest request) async {
    isQueueLoading = true;
    _errorMessage = null;
    safeNotifyListeners(); // 🔹 Updated

    try {
      final response = await _apiService.getVehicleQueueDetails(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        _vehicleQueueResponse =
            data.map((json) => VehicleQueueResponse.fromJson(json)).toList();

        return true;
      } else {
        throw Exception("Failed to fetch Vehicle Queue Details");
      }
    } catch (e) {
      _vehicleQueueResponse = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isQueueLoading = false;
      safeNotifyListeners(); // 🔹 Updated
    }
  }

  /// Fetch Open DO Details
  List<OpenDoResponse>? _openDoResponse;

  List<OpenDoResponse>? get openDoResponse => _openDoResponse;

  Future<bool> fetchOpenDoDetails(OpenDoRequest request) async {
    isOpenDoLoading = true;
    _errorMessage = null;
    safeNotifyListeners(); // 🔹 Updated

    try {
      final response = await _apiService.getOpenDODetailsAsync(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        _openDoResponse =
            data.map((json) => OpenDoResponse.fromJson(json)).toList();
        print(
            'OpenDoDetails-request- ${jsonEncode(request.toJson())}- Response - -${jsonEncode(_openDoResponse?.map((e) => e.toJson()).toList())}');

        return true;
      } else {
        throw Exception("Failed to fetch Open DO Details");
      }
    } catch (e) {
      _openDoResponse = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isOpenDoLoading = false;
      safeNotifyListeners(); // 🔹 Updated
    }
  }

  /// Fetch Material Dispatch Summary
  List<MaterialDispatchResponse>? _materialDispatchResponse;

  List<MaterialDispatchResponse>? get materialDispatchResponse =>
      _materialDispatchResponse;

  Future<bool> fetchMaterialDispatchSummary(
      MaterialDispatchRequest request) async {
    isMaterialLoading = true;
    _errorMessage = null;
    safeNotifyListeners(); // 🔹 Updated

    try {
      final response =
      await _apiService.getMaterialDispatchSummaryReport(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;

        _materialDispatchResponse = data
            .map((json) => MaterialDispatchResponse.fromJson(json))
            .toList();
        print(
            'MaterialDispatch-request- ${jsonEncode(request.toJson())}- Response - -${jsonEncode(_materialDispatchResponse?.map((e) => e.toJson()).toList())}');

        return true;
      } else {
        throw Exception("Failed to fetch Material Dispatch Summary");
      }
    } catch (e) {
      _materialDispatchResponse = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isMaterialLoading = false;
      safeNotifyListeners(); // 🔹 Updated
    }
  }

  List<MaterialDispatchNewResponse>? _materialDispatchNewResponse;

  List<MaterialDispatchNewResponse>? get materialDispatchNewResponse =>
      _materialDispatchNewResponse;

  // Assuming isMaterialLoading and _errorMessage are already defined at the top of your ViewModel

  /// Fetch Material Dispatch Summary
  Future<bool> fetchMaterialDispatchNewSummary(
      MaterialDispatchNewRequest request) async {
    isMaterialLoading = true;
    _errorMessage = null;
    safeNotifyListeners(); // 🔹 Updated

    try {
      // Calls the API service method you provided
      final response = await _apiService.getMaterialInOutSummary(request);

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        _materialDispatchNewResponse = data
            .map((json) => MaterialDispatchNewResponse.fromJson(json))
            .toList();
        print(
            'MaterialDispatchNew-request- ${jsonEncode(request.toJson())}- Response - -${jsonEncode(_materialDispatchNewResponse?.map((e) => e.toJson()).toList())}');
        return true;
      } else {
        throw Exception("Failed to fetch Material Dispatch Summary");
      }
    } catch (e) {
      // FIXED: Was previously setting _materialDispatchResponse to null
      _materialDispatchNewResponse = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isMaterialLoading = false;
      safeNotifyListeners(); // 🔹 Updated
    }
  }

  void reset() {
    isTripLoading = false;
    isTatLoading = false;
    isVehicleInsideLoading = false;
    isHourlyLoading = false;
    isQueueLoading = false;
    isOpenDoLoading = false;
    isMaterialLoading = false;

    _tripSummaryResponse = null;
    _tatSummaryResponse = null;
    _vehicleInsideResponse = null;
    _hourlySummaryResponse = null;
    _vehicleQueueResponse = null;
    _openDoResponse = null;
    _materialDispatchResponse = null;
    _errorMessage = null;

    safeNotifyListeners(); // 🔹 Updated
  }
}