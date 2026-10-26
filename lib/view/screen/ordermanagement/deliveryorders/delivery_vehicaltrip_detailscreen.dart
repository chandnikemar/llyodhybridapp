import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../model/ordermanagement/deliveryorders/milestoneplan_model.dart';
import '../../../../model/ordermanagement/deliveryorders/singledh_model.dart';
import '../../../../model/ordermanagement/deliveryorders/vehical_milstone_response_model.dart'
    show MilestoneDetail, MilestonePlan, MilestonePlanV, VehicleMilestoneResponse;
import '../../../../model/ordermanagement/deliveryorders/vehicle_transaction_response_model.dart' hide MilestoneDetail;
import '../../../../view_model/ordermanagement_view_model.dart';

class VehicleTripScreen extends StatefulWidget {
  final VehicleTransactionResponseModel transaction;

  const VehicleTripScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<VehicleTripScreen> createState() => _VehicleTripScreenState();
}

class _VehicleTripScreenState extends State<VehicleTripScreen> {
  final Set<int> _expandedIndices = {};
  bool _triedFallbackCode = false;

  VehicleTransactionResponseModel get txn => widget.transaction;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTripDetailsSequentially();
    });
  }

  Future<void> _loadTripDetailsSequentially() async {
    if (!mounted) return;
    final viewModel = context.read<OrderManagementViewModel>();

    final String txCode = _clean(txn.transactionCode);
    final String initialDhCode = _clean(txn.driverCode);

    final String tenantCode =
    _clean(txn.tenantCode).isNotEmpty ? _clean(txn.tenantCode) : viewModel.currentTenantCode;

    if (txCode.isEmpty) {
      debugPrint('Warning: Transaction code is empty.');
      return;
    }

    debugPrint('Step 1: Fetching Vehicle Milestone Details for txCode="$txCode"...');
    await viewModel.fetchVehicleMilestoneDetails(
      tenantCode: tenantCode,
      transactionCode: txCode,
    );

    if (!mounted) return;

    String resolvedDhCode = initialDhCode;
    final details = viewModel.vehicleMilestoneDetail;
    if (details.isNotEmpty) {
      final detailItem = details.first;
      final altDh = _clean(detailItem.driverCode);
      if (altDh.isNotEmpty) {
        resolvedDhCode = altDh;
      }
    }

    if (resolvedDhCode.isNotEmpty) {
      debugPrint('Step 2: Fetching Single DH API using code="$resolvedDhCode"...');
      await viewModel.fetchSingleDH(resolvedDhCode);
    } else {
      debugPrint('Step 2: Skipped — no driver/DH code available for this trip.');
    }

    if (!mounted) return;

    debugPrint('Step 3: Fetching Milestone Plan API for txCode="$txCode"...');
    await viewModel.fetchMilestonePlan(transactionCode: txCode);

    if (!mounted) return;
    await _tryFallbackMilestoneFetch(viewModel, txCode);
  }

  Future<void> _tryFallbackMilestoneFetch(
      OrderManagementViewModel viewModel,
      String triedCode,
      ) async {
    if (_triedFallbackCode) return;
    if (viewModel.milestonePlanList.isNotEmpty) return;

    final detail = viewModel.vehicleMilestoneDetail;
    if (detail.isEmpty) return;

    final String altCode = _clean(detail.first.transactionCode);
    if (altCode.isEmpty || altCode == triedCode) return;

    _triedFallbackCode = true;
    debugPrint(
      'Milestone Plan: primary transactionCode="$triedCode" returned nothing — '
          'retrying with detail.transactionCode="$altCode".',
    );
    await viewModel.fetchMilestonePlan(transactionCode: altCode);
  }

  void _retryMilestones() {
    final String txCode = _clean(txn.transactionCode);
    if (txCode.isEmpty) return;
    _triedFallbackCode = false;
    _loadTripDetailsSequentially();
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  String _clean(String? value) {
    final String t = value?.trim() ?? '';
    return t.toLowerCase() == 'null' ? '' : t;
  }

  String _firstNonEmpty(List<String?> values) {
    for (final String? v in values) {
      final String c = _clean(v);
      if (c.isNotEmpty) return c;
    }
    return '-';
  }

  String _formatNumber(double value) =>
      value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(2);

  DateTime? _parseDate(String? value) {
    final String v = _clean(value);
    if (v.isEmpty) return null;
    return DateTime.tryParse(v);
  }

  String _formatStageDateTime(String? value) {
    final DateTime? date = _parseDate(value);
    return date == null ? '-' : DateFormat('dd-MM-yyyy HH:mm').format(date);
  }

  String? _bestTimeValue(String? completion, String? begin) {
    final String c = _clean(completion);
    if (c.isNotEmpty) return c;
    final String b = _clean(begin);
    return b.isEmpty ? null : b;
  }

  String _formatDateOnly(DateTime? date) =>
      date == null ? '-' : DateFormat('dd-MM-yyyy').format(date);

  String _titleCase(String input) {
    final String t = input.trim();
    if (t.isEmpty) return t;
    return t
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  String? _eventFromCode(String? milestoneCode) {
    final String code = _clean(milestoneCode);
    if (code.isEmpty) return null;
    final int idx = code.lastIndexOf('_');
    if (idx == -1 || idx == code.length - 1) return null;
    return code.substring(idx + 1);
  }

  List<MilestonePlanResponseModel> _convertDetailsToMilestones(List<VehicleMilestoneResponse> details) {
    if (details.isEmpty) return const [];

    final List<MilestonePlanV> items = details.first.milestonePlan ?? const [];
    final List<MilestonePlanResponseModel> converted = [];

    for (final MilestonePlanV item in items) {
      converted.add(
        MilestonePlanResponseModel(
          milestoneSequence: item.sequence,
          milestoneCode: item.milestoneCode,
          milestone: _clean(item.milestoneName).isNotEmpty ? item.milestoneName : item.milestoneCode,
          milestioneEvent: _eventFromCode(item.milestoneCode),
          locationName: item.locationCode,
          status: item.status,
          milestoneBeginTime: item.completionTime,
          milestoneCompletionTime: item.completionTime,
          imagePath: item.imagePath,
          milestoneActionsTracking: const [],
        ),
      );
    }

    return converted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Subtle background upgrade for mobile apps
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context),
            Expanded(
              child: Consumer<OrderManagementViewModel>(
                builder: (context, viewModel, child) {
                  final SingleDhModel? dhModel = viewModel.singleDHData != null
                      ? SingleDhModel.fromJson(viewModel.singleDHData!)
                      : null;

                  final List<VehicleMilestoneResponse> detail = viewModel.vehicleMilestoneDetail;

                  List<MilestonePlanResponseModel> effectiveMilestones = viewModel.milestonePlanList;
                  bool usingFallback = false;

                  if (effectiveMilestones.isEmpty && detail.isNotEmpty) {
                    final converted = _convertDetailsToMilestones(detail);
                    if (converted.isNotEmpty) {
                      usingFallback = true;
                      effectiveMilestones = converted;
                    }
                  }

                  final Widget timeline;
                  if (viewModel.isMilestoneLoading) {
                    timeline = const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (effectiveMilestones.isEmpty && viewModel.errorMessage != null) {
                    timeline = _buildTimelineMessage(
                      'Could not load the trip timeline.\n${viewModel.errorMessage}',
                      isError: true,
                    );
                  } else if (effectiveMilestones.isEmpty) {
                    timeline = _buildTimelineMessage(
                      'No milestone timeline available for this trip.\n'
                          '${_clean(txn.transactionCode)}',
                    );
                  } else {
                    timeline = _buildMilestoneTimeline(
                      effectiveMilestones,
                      detail,
                      usingFallback: usingFallback,
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoChipsGrid(dhModel, detail.isNotEmpty ? detail.first : null),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.timeline,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Trip Timeline',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        timeline,
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    final status = txn.status ?? '';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F1F8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: Color(0xFF0878B8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Vehicle Trip - ${status.isEmpty ? "Outbound" : status}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D2939),
            ),
          ),
        ],
      ),
    );
  }

  String _doNumberLabel(VehicleMilestoneResponse? detail) {
    final detailMap = detail?.vehicleTransactionCDOMapping;
    if (detailMap != null && detailMap.isNotEmpty) {
      final int? n = detailMap.first.cdo?.cdoNumber;
      if (n != null && n != 0) return n.toString();
    }

    final txnMap = txn.vehicleTransactionCDOMapping;
    if (txnMap != null && txnMap.isNotEmpty) {
      final cdo = txnMap[0].cdo;
      if (cdo != null && cdo.cdoNumber != null && cdo.cdoNumber != 0) {
        return cdo.cdoNumber.toString();
      }
    }

    final int? d = detail?.doNumber;
    if (d != null && d != 0) return d.toString();

    if (txn.cdoMasterId != null) return txn.cdoMasterId.toString();
    return '-';
  }

  String _allocatedWeightLabel(VehicleMilestoneResponse? detail) {
    double? w;
    final detailMap = detail?.vehicleTransactionCDOMapping;
    if (detailMap != null && detailMap.isNotEmpty) {
      w = detailMap.first.allocatedWeight;
    }
    if (w == null || w <= 0) {
      final txnMap = txn.vehicleTransactionCDOMapping;
      if (txnMap != null && txnMap.isNotEmpty) {
        w = txnMap[0].allocatedWeight;
      }
    }
    return (w != null && w > 0) ? _formatNumber(w) : '-';
  }

  String _ewayBillLabel(VehicleMilestoneResponse? detail) {
    final List<String> numbers = [];

    final detailBills = detail?.ewayBill;
    if (detailBills != null) {
      for (final bill in detailBills) {
        final String n = _clean(bill.eWayBillNo);
        if (n.isNotEmpty) numbers.add(n);
      }
    }

    if (numbers.isEmpty) {
      final txnBills = txn.ewayBill;
      if (txnBills != null) {
        for (final bill in txnBills) {
          final String n = _clean(bill.eWayBillNo);
          if (n.isNotEmpty) numbers.add(n);
        }
      }
    }

    return numbers.isEmpty ? '-' : numbers.join(', ');
  }

  // Mobile-optimized grid for trip metadata - only shows items with values.
  // Flat design: no borders, no shadows.
  Widget _buildInfoChipsGrid(SingleDhModel? dhModel, VehicleMilestoneResponse? detail) {
    final String sapInvoice = _firstNonEmpty([detail?.sapInvoiceNo, txn.sapInvoiceNo]);

    final List<Map<String, String>> allInfoItems = [
      {'label': 'VRN', 'value': _firstNonEmpty([detail?.vrn, txn.vrn])},
      {'label': 'Driver', 'value': _firstNonEmpty([dhModel?.name, detail?.driverName, txn.driverName])},
      {'label': 'Mobile', 'value': _firstNonEmpty([dhModel?.mobileNo, detail?.driverMobileNo])},
      {'label': 'Txn Code', 'value': _firstNonEmpty([detail?.transactionCode, txn.transactionCode])},
      {'label': 'Transporter', 'value': _firstNonEmpty([detail?.transporterName, txn.transporterName])},
      {'label': 'DO No', 'value': _doNumberLabel(detail)},
      {'label': 'Cust Loc', 'value': _firstNonEmpty([detail?.customerLocationName, txn.customerLocationName])},
      {'label': 'Allocated Weight', 'value': _allocatedWeightLabel(detail)},
      {'label': 'E-way Bill', 'value': _ewayBillLabel(detail)},
      {'label': 'Invoice No', 'value': sapInvoice},
      {'label': 'OBD No', 'value': _firstNonEmpty([detail?.obdNumber, txn.obdNumber])},
      {'label': 'DC No', 'value': _firstNonEmpty([detail?.dcNumber, txn.dcNumber?.toString()])},
      {'label': 'LR Date', 'value': _formatDateOnly(_parseDate(detail?.lrDate))},
      {'label': 'LR Number', 'value': _firstNonEmpty([detail?.lrNo])},
      {'label': 'SAP PGI', 'value': _firstNonEmpty([detail?.pgiNo])},
      {'label': 'Quantity', 'value': '${_formatNumber(detail?.totalNW ?? 0)} MTS'},
    ];

    // Filter out items with empty values
    final List<Map<String, String>> infoItems = allInfoItems
        .where((item) => item['value'] != null && item['value']!.isNotEmpty && item['value'] != '-')
        .toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: infoItems.length,
        itemBuilder: (context, index) {
          return _infoChip(infoItems[index]['label']!, infoItems[index]['value']!);
        },
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // soft tinted fill instead of border/shadow
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineMessage(String message, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: isError ? const Color(0xFFD92D20) : const Color(0xFF667085),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _retryMilestones,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Reload timeline'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0878B8),
                side: const BorderSide(color: Color(0xFF0878B8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneTimeline(
      List<MilestonePlanResponseModel> milestones,
      List<VehicleMilestoneResponse>? details, {
        required bool usingFallback,
      }) {
    final List<MilestonePlanResponseModel> steps = List<MilestonePlanResponseModel>.from(milestones);

    if (steps.isEmpty) {
      return _buildTimelineMessage('No milestone timeline available for this trip.');
    }

    steps.sort(
          (a, b) => (a.milestoneSequence ?? (1 << 30)).compareTo(b.milestoneSequence ?? (1 << 30)),
    );

    final String tripTat = _tripTat(steps);
    final VehicleMilestoneResponse? detailObj =
    (details != null && details.isNotEmpty) ? details.first : null;

    // Calculate current step (first incomplete milestone)
    int currentStep = 0;
    if (steps.isNotEmpty) {
      final firstIncompleteIndex = steps.indexWhere((step) =>
      (step.status ?? '').trim().toLowerCase() != 'completed'
      );
      currentStep = firstIncompleteIndex == -1 ? steps.length - 1 : firstIncompleteIndex;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stepper(
          currentStep: currentStep,
          physics: const NeverScrollableScrollPhysics(),
          // NOTE: connector colour is now set per step via StepStyle below.
          steps: steps.asMap().entries.map((entry) {
            final step = entry.value;
            final index = entry.key;
            final String status = (step.status ?? '').trim().toLowerCase();
            final bool isCompleted = status == 'completed';
            final bool isLive = !isCompleted &&
                (status == 'in progress' ||
                    status == 'in-progress' ||
                    status == 'active' ||
                    (status.isEmpty &&
                        _clean(step.milestoneBeginTime).isNotEmpty &&
                        _clean(step.milestoneCompletionTime).isEmpty));

            final String name = _clean(step.milestone);
            final String event = _clean(step.milestioneEvent);
            final String title = name.isEmpty
                ? 'Milestone'
                : (event.isEmpty ? _titleCase(name) : '${_titleCase(name)} - ${_titleCase(event)}');

            final String location = _clean(step.locationName);
            final String? weight = _stageWeightLabel(step, detailObj, details);

            final String perStage = _clean(step.timeTakenToCompleteMilestone);
            final String duration =
            perStage.isNotEmpty ? perStage : _clean(step.timeTakenToCompleteMilestoneTransaction);

            final List<MilestoneActionsTracking> subActions = List<MilestoneActionsTracking>.from(
              step.milestoneActionsTracking ?? <MilestoneActionsTracking>[],
            )..sort(
                  (a, b) => (a.sequence ?? (1 << 30)).compareTo(b.sequence ?? (1 << 30)),
            );

            final bool isExpanded = _expandedIndices.contains(index);

            return Step(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF027A48),
                            ),
                          ),
                        ),
                      if (isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B82F6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Live',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? const Color(0xFF027A48) : const Color(0xFF1E293B),
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (location.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCompleted
                            ? _formatStageDateTime(
                          _bestTimeValue(step.milestoneCompletionTime, step.milestoneBeginTime),
                        )
                            : isLive
                            ? _formatStageDateTime(step.milestoneBeginTime)
                            : 'Not started',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      if (weight != null) ...[
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.scale,
                          size: 14,
                          color: Color(0xFF6366F1),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$weight MTS',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (duration.isNotEmpty && duration != '-')
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Duration: $duration',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              // Completed steps get the check icon + green fill.
              state: isCompleted ? StepState.complete : StepState.indexed,
              isActive: isCompleted || isLive,
              stepStyle: StepStyle(
                color: isCompleted
                    ? const Color(0xFF10B981) // green when completed
                    : isLive
                    ? const Color(0xFF3B82F6) // blue when live
                    : const Color(0xFFCBD5E1), // grey when pending
                connectorColor: isCompleted
                    ? const Color(0xFF10B981)
                    : const Color(0xFFE2E8F0),
                connectorThickness: 2,
              ),
              content: subActions.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _toggleExpansion(index),
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6366F1).withOpacity(0.1),
                            const Color(0xFF8B5CF6).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.task_alt,
                            size: 16,
                            color: Color(0xFF6366F1),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'View ${subActions.length} Action${subActions.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            size: 20,
                            color: const Color(0xFF6366F1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 12),
                    _buildMilestoneActionsStepper(step, subActions),
                  ],
                ],
              ),
            );
          }).toList(),
          controlsBuilder: (context, details) {
            return const SizedBox.shrink();
          },
        ),
        if (tripTat.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.1),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Trip Time',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      tripTat,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _tripTat(List<MilestonePlanResponseModel> steps) {
    for (int i = steps.length - 1; i >= 0; i--) {
      final String v = _clean(steps[i].totalTimeTakenToCompleteTransaction);
      if (v.isNotEmpty) return v;
    }
    return '';
  }

  String? _weightFromEmbeddedDetails(
      MilestonePlanResponseModel step,
      List<VehicleMilestoneResponse>? details,
      ) {
    final String code = _clean(step.milestoneCode);
    if (code.isEmpty || details == null || details.isEmpty) return null;

    final List<MilestonePlanV> items = details.first.milestonePlan ?? const [];
    for (final MilestonePlanV item in items) {
      if (_clean(item.milestoneCode) != code) continue;
      final List<MilestoneDetail> dets = item.milestoneDetails ?? const [];
      for (final MilestoneDetail d in dets) {
        if ((d.detailKey ?? '').toLowerCase() == 'weightinkg') {
          final double? kg = double.tryParse(_clean(d.value));
          if (kg != null && kg > 0) return _formatNumber(kg / 1000);
        }
      }
    }
    return null;
  }

  String? _stageWeightLabel(
      MilestonePlanResponseModel step,
      VehicleMilestoneResponse? detail,
      List<VehicleMilestoneResponse>? allDetails,
      ) {
    final String name = (step.milestone ?? '').toLowerCase();
    if (!name.contains('weigh')) return null;

    final String? fromEmbedded = _weightFromEmbeddedDetails(step, allDetails);
    if (fromEmbedded != null) return fromEmbedded;

    if (detail == null) return null;
    final String event = (step.milestioneEvent ?? '').toLowerCase();
    double? weight;
    if (event.contains('tare')) {
      weight = detail.tareWeight;
    } else if (event.contains('gross')) {
      weight = detail.grossWeight;
    }
    return (weight == null || weight == 0) ? null : _formatNumber(weight);
  }

  Widget _buildMilestoneStageCard(
      MilestonePlanResponseModel step,
      int index,
      VehicleMilestoneResponse? detail,
      ) {
    final bool isExpanded = _expandedIndices.contains(index);

    final String status = (step.status ?? '').trim().toLowerCase();
    final bool isCompleted = status == 'completed';
    final bool isLive = !isCompleted &&
        (status == 'in progress' ||
            status == 'in-progress' ||
            status == 'active' ||
            (status.isEmpty &&
                _clean(step.milestoneBeginTime).isNotEmpty &&
                _clean(step.milestoneCompletionTime).isEmpty));

    final String name = _clean(step.milestone);
    final String event = _clean(step.milestioneEvent);
    final String title = name.isEmpty
        ? 'Milestone'
        : (event.isEmpty ? _titleCase(name) : '${_titleCase(name)} - ${_titleCase(event)}');

    final String location = _clean(step.locationName);
    final String? weight = _stageWeightLabel(step, detail, detail == null ? null : [detail]);

    final String perStage = _clean(step.timeTakenToCompleteMilestone);
    final String duration =
    perStage.isNotEmpty ? perStage : _clean(step.timeTakenToCompleteMilestoneTransaction);

    final List<MilestoneActionsTracking> subActions = List<MilestoneActionsTracking>.from(
      step.milestoneActionsTracking ?? <MilestoneActionsTracking>[],
    )..sort(
          (a, b) => (a.sequence ?? (1 << 30)).compareTo(b.sequence ?? (1 << 30)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: isExpanded ? const Color(0xFF0878B8) : const Color(0xFFEAECF0)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _toggleExpansion(index),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D2939),
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 20,
                        color: const Color(0xFF667085),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          location.isEmpty ? '-' : location,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                        ),
                      ),
                      if (weight != null)
                        Text(
                          '$weight MTS',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0878B8),
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 16, color: Color(0xFFEAECF0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isCompleted
                            ? _formatStageDateTime(
                          _bestTimeValue(step.milestoneCompletionTime, step.milestoneBeginTime),
                        )
                            : isLive
                            ? _formatStageDateTime(step.milestoneBeginTime)
                            : '-',
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF667085)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFFECFDF3)
                              : isLive
                              ? const Color(0xFFEFF8FF)
                              : const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isCompleted
                              ? (duration.isEmpty ? 'Completed' : duration)
                              : isLive
                              ? 'In Progress'
                              : 'Pending',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isCompleted
                                ? const Color(0xFF027A48)
                                : isLive
                                ? const Color(0xFF175CD3)
                                : const Color(0xFF344054),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(12),
              child: subActions.isEmpty
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No sub-actions recorded for this milestone.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF98A2B3)),
                ),
              )
                  : _buildMilestoneActionsStepper(step, subActions),
            ),
        ],
      ),
    );
  }

  // Mobile vertical card layout for sub-actions replacing awkward table scrolling
  Widget _buildMobileSubActionCard(
      MilestonePlanResponseModel step,
      MilestoneActionsTracking sub,
      int index,
      ) {
    final String actionName = _clean(sub.milestoneAction);
    final String status = _clean(sub.status);
    final bool isCompleted = status.toLowerCase() == 'completed';
    final String remark = _clean(sub.remarks);

    final String lowerName = actionName.toLowerCase();
    final bool hasImage = lowerName.contains('camera');
    final bool hasNotify = lowerName.contains('notify');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEAECF0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$index. ${actionName.isEmpty ? "Action" : actionName}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2939),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFFECFDF3) : const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.isEmpty ? 'Pending' : status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? const Color(0xFF027A48) : const Color(0xFF344054),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatStageDateTime(sub.completionTime),
                style: const TextStyle(fontSize: 11, color: Color(0xFF667085)),
              ),
              if (remark.isNotEmpty && remark != '-')
                Text(
                  'Remark: $remark',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF667085)),
                ),
            ],
          ),
          if (hasImage || hasNotify) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Divider(height: 1, color: Color(0xFFF2F4F7)),
            ),
            Row(
              children: [
                if (hasImage)
                  OutlinedButton.icon(
                    onPressed: () => _showMilestoneImage(step),
                    icon: const Icon(Icons.image, size: 14, color: Color(0xFF0878B8)),
                    label: const Text('View Image', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0878B8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      minimumSize: const Size(0, 28),
                      side: const BorderSide(color: Color(0xFF0878B8)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                if (hasNotify) ...[
                  if (hasImage) const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications, size: 14, color: Color(0xFF344054)),
                    label: const Text('Notify', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF344054),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      minimumSize: const Size(0, 28),
                      side: const BorderSide(color: Color(0xFFD0D5DD)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showMilestoneImage(MilestonePlanResponseModel step) {
    final String path = _clean(step.imagePath);
    if (path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image available for this milestone.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                path,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Unable to load image.\n$path',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // LIST UI FOR MILESTONE ACTIONS (No nested Stepper)
  // ==========================================
  Widget _buildMilestoneActionsStepper(
      MilestonePlanResponseModel step,
      List<MilestoneActionsTracking> subActions) {
    // Sort actions by sequence
    final sortedActions = List<MilestoneActionsTracking>.from(subActions)
      ..sort((a, b) => (a.sequence ?? (1 << 30)).compareTo(b.sequence ?? (1 << 30)));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF8F9FA),
            const Color(0xFFF1F5F9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedActions.asMap().entries.map((entry) {
          final action = entry.value;
          final index = entry.key;
          final String actionName = _clean(action.milestoneAction);
          final String status = _clean(action.status);
          final bool isCompleted = status.toLowerCase() == 'completed';
          final String remark = _clean(action.remarks);
          final String lowerName = actionName.toLowerCase();
          final bool hasImage = lowerName.contains('camera');

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCompleted
                    ? [Colors.white, const Color(0xFFECFDF3)]
                    : [Colors.white, const Color(0xFFF8F9FA)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCompleted ? const Color(0xFF6EE7B7) : const Color(0xFFE2E8F0),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status icon with animated background
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: isCompleted
                        ? const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    )
                        : const LinearGradient(
                      colors: [Color(0xFFCBD5E1), Color(0xFF94A3B8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isCompleted
                            ? const Color(0xFF10B981).withOpacity(0.3)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                // Action details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actionName.isEmpty ? "Action" : actionName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isCompleted ? const Color(0xFF059669) : const Color(0xFF1E293B),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatStageDateTime(action.completionTime),
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      if (remark.isNotEmpty && remark != '-')
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.comment_outlined,
                                size: 12,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  remark,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hasImage)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _showMilestoneImage(step),
                                borderRadius: BorderRadius.circular(6),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.image, size: 14, color: Colors.white),
                                      SizedBox(width: 6),
                                      Text(
                                        'View Image',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}