import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/ordermanagement/deliveryorders/delivery_orders_response_model.dart';
import '../../../../model/ordermanagement/deliveryorders/vehicle_transaction_response_model.dart';
import '../../../../utilities/common_header.dart';
import '../../../../view_model/ordermanagement_view_model.dart';
import 'delivery_vehicaltrip_detailscreen.dart';

class DeliveryOrdersdetailOrdermanagmentScreen extends StatefulWidget {
  final CdoFilterResponseModel order;

  const DeliveryOrdersdetailOrdermanagmentScreen({
    super.key,
    required this.order,
  });

  @override
  State<DeliveryOrdersdetailOrdermanagmentScreen> createState() =>
      _DeliveryOrdersdetailOrdermanagmentScreenState();
}

class _DeliveryOrdersdetailOrdermanagmentScreenState
    extends State<DeliveryOrdersdetailOrdermanagmentScreen> {
  late final CdoFilterResponseModel _order;
  final TextEditingController _tripSearchController = TextEditingController();

  static const List<String> _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // Card expand/collapse states — all open by default.
  final Map<String, bool> _expanded = {
    'do': true,
    'buyer': true,
    'activity': true,
    'trips': true,
  };

  @override
  void initState() {
    super.initState();
    _order = widget.order;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderManagementViewModel>().fetchVehicleTransactions(_order.cdoMasterId);
    });
  }

  // ------------------------------------------------------------------
  // QUANTITY / PROGRESS
  // dispatchQuantity (what's actually been dispatched) drives progress
  // and balance, not allocatedQuantity/doBalanceQty — those two fields
  // can go negative in the source data when a load is slightly over-
  // dispatched, so they're not safe to show or divide by directly.
  // ------------------------------------------------------------------
  double get _quantity => _order.quantity;
  double get _dispatchedQuantity => _order.dispatchQuantity;

  // Capped at the order quantity so the numerator never exceeds the total.
  double get _effectiveDispatched =>
      _dispatchedQuantity > _quantity ? _quantity : _dispatchedQuantity;

  double get _balanceQty {
    final double bal = _quantity - _dispatchedQuantity;
    return bal < 0 ? 0 : bal;
  }

  double get _progressPercent {
    if (_quantity <= 0) return 0;
    return ((_dispatchedQuantity / _quantity) * 100).clamp(0, 100);
  }

  String get _orderDetailsLabel {
    final String type = _order.transactionType.isEmpty ? '-' : _order.transactionType;
    final String number = (_order.stoNumber ?? _order.mdoNumber)?.toString() ?? '-';
    return '$type - $number';
  }

  String get _publishedToLabel =>
      _order.publishRule.isNotEmpty ? _order.publishRule.map((r) => r.name).join(', ') : '-';

  String get _statusLabel => _order.status.isEmpty ? '-' : _order.status;

  // "Publish" (raw status) reads as "PUBLISHED" in the badge/chip, same
  // way the reference screen shows it.
  String get _doStatusDisplay {
    final String s = _order.status.trim();
    if (s.isEmpty) return '-';
    if (s.toLowerCase() == 'publish') return 'Published';
    return s;
  }

  // Header pill reflects isActive, independent of the workflow `status`.
  String get _activeStatusLabel => _order.isActive ? 'Active' : 'Inactive';

  String get _salesContractNumberLabel =>
      _order.salesContractNumber.isEmpty ? '-' : _order.salesContractNumber;
  String get _customerReferenceLabel =>
      _order.customerReference.isEmpty ? '-' : _order.customerReference;
  String get _l1DestinationLabel =>
      (_order.l1Destination == null || _order.l1Destination!.isEmpty)
          ? '-'
          : _order.l1Destination!;

  // The model has no standalone "sales contract date" — contractValidFromDate
  // is the closest match (contract validity start).
  String get _contractDateLabel => _formatDateLong(_order.contractValidFromDate);

  String get _materialNameLabel => _order.materialName.isNotEmpty ? _order.materialName : '-';
  String get _locationLabel => _order.locationName ?? '-';

  // Buyer is shown as the tenant code per request.
  String get _buyerNameLabel => _order.tenantCode ?? '-';

  String _formatDateLong(DateTime? date) {
    if (date == null) return '-';
    final String d = date.day.toString().padLeft(2, '0');
    return '$d ${_monthAbbr[date.month - 1]} ${date.year}';
  }

  String _formatDateTimeLong(DateTime? date) {
    if (date == null) return '-';
    final String datePart = _formatDateLong(date);
    int hour = date.hour;
    final String period = hour >= 12 ? 'pm' : 'am';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    return '$datePart   $hour:$minute $period';
  }

  void _toggle(String key) {
    setState(() {
      _expanded[key] = !(_expanded[key] ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: Column(
          children: [
            CommonPageHeader(title: 'Delivery Order Details'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSummary(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 16),
                    _buildDoDetailsCard(),
                    const SizedBox(height: 14),
                    _buildBuyerDetailsCard(),
                    const SizedBox(height: 14),
                    _buildActivityTimelineCard(),
                    const SizedBox(height: 14),
                    _buildTruckTripsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER SUMMARY
  // ============================================================
  Widget _buildHeaderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'DO: ${_order.cdoNumber}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF131754),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _activePill(_activeStatusLabel),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            _headerMeta('Buyer', _buyerNameLabel),
            _headerDivider(),
            _headerMeta('Material', _materialNameLabel),
            _headerDivider(),
            _headerMeta('Published To', _publishedToLabel),
          ],
        ),
      ],
    );
  }

  Widget _headerMeta(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF667085),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF344054),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerDivider() {
    return const Text(
      '|',
      style: TextStyle(fontSize: 12.5, color: Color(0xFFD0D5DD)),
    );
  }

  Widget _activePill(String label) {
    final bool isActive = label.toLowerCase() == 'active';
    final Color bg = isActive ? const Color(0xFFE8F8EE) : const Color(0xFFFDECEA);
    final Color fg = isActive ? const Color(0xFF27AE60) : const Color(0xFFE74C3C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  // ============================================================
  // STAT HIGHLIGHT CARDS
  // ============================================================
  Widget _buildStatsRow() {
    return Consumer<OrderManagementViewModel>(
      builder: (context, viewModel, child) {
        final int completedCount = viewModel.vehicleTransactionList
            .where((t) => t.status!.trim().toLowerCase() == 'completed')
            .length;

        return Column(
          children: [
            Row(
              children: [
                _statCard(
                  icon: Icons.donut_large,
                  iconColor: const Color(0xFF0D82CA),
                  iconBg: const Color(0xFFEAF3FB),
                  label: 'DO Progress',
                  value: '${_progressPercent.toStringAsFixed(0)}%',
                  subtitle:
                  '${_formatQtyWithCommas(_effectiveDispatched)} / ${_formatQtyWithCommas(_quantity)} MT',
                ),
                const SizedBox(width: 10),
                _statCard(
                  icon: Icons.balance,
                  iconColor: const Color(0xFFE67E22),
                  iconBg: const Color(0xFFFFF3E0),
                  label: 'Balance Quantity',
                  value: '${_formatQty(_balanceQty)} MT',
                  subtitle: 'Pending to be delivered',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _statCard(
                  icon: Icons.local_shipping_outlined,
                  iconColor: const Color(0xFF27AE60),
                  iconBg: const Color(0xFFE8F8EE),
                  label: 'Completed Trips',
                  value: completedCount.toString(),
                  subtitle: 'Total trips completed',
                ),
                const SizedBox(width: 10),
                _statCard(
                  icon: Icons.inventory_2_outlined,
                  iconColor: const Color(0xFF6C5CE7),
                  iconBg: const Color(0xFFF0EEFC),
                  label: 'DO Quantity',
                  value: '${_formatQty(_quantity)} MT',
                  subtitle: 'Total order quantity',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF667085),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF131754),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Color(0xFF98A2B3)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REUSABLE EXPANDABLE CARD SHELL
  // ============================================================
  Widget _cardShell({
    required String sectionKey,
    required IconData icon,
    required String title,
    Widget? badge,
    required Widget child,
  }) {
    final bool isOpen = _expanded[sectionKey] ?? true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _toggle(sectionKey),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: const Color(0xFF0D82CA)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ),
                  if (badge != null) ...[
                    badge,
                    const SizedBox(width: 8),
                  ],
                  Icon(
                    isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 20,
                    color: const Color(0xFF60717E),
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: child,
            ),
        ],
      ),
    );
  }

  Widget _miniBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF27AE60),
        ),
      ),
    );
  }

  // ============================================================
  // DO DETAILS CARD
  // ============================================================
  Widget _buildDoDetailsCard() {
    return _cardShell(
      sectionKey: 'do',
      icon: Icons.description_outlined,
      title: 'DO Details',
      badge: _miniBadge(_doStatusDisplay.toUpperCase()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldRow([
            _Field('DO Number', _order.cdoNumber.toString()),
            _Field('BDO Number', _order.bdoNumber ?? '-'),
          ]),
          const SizedBox(height: 16),
          _fieldRow([
            _Field('Order Details', _orderDetailsLabel),
            _Field('Published To', _publishedToLabel, trailingIcon: Icons.info_outline),
          ]),
          const SizedBox(height: 16),
          _fieldRow([
            _Field('Source', _order.stoSource ?? _order.locationName ?? '-'),
            _Field('Sales Contract No.', _salesContractNumberLabel),
          ]),
          const SizedBox(height: 16),
          _fieldRow([
            _Field('Sales Contract Date', _contractDateLabel),
            _Field(
              'Sales Contract Qty.',
              '${_formatQtyWithCommas(_order.salesContractQuantity)} MT',
            ),
          ]),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _Field('DO Qty.', '${_formatQty(_quantity)} MT').build()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _statusChip(_doStatusDisplay.toUpperCase()),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF0F1F3)),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'DO Progress',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF344054),
                ),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Balance Qty. ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: '${_formatQty(_balanceQty)} MT',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0D82CA),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progressPercent / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFEAECF0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFEE5253),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text('0%', style: TextStyle(fontSize: 11, color: Color(0xFF667085))),
              const Spacer(),
              Text(
                '${_progressPercent.toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D82CA),
                ),
              ),
              const Spacer(),
              const Text('100%', style: TextStyle(fontSize: 11, color: Color(0xFF667085))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF27AE60), width: 1),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF27AE60),
        ),
      ),
    );
  }

  // ============================================================
  // BUYER & MATERIAL DETAILS CARD
  // ============================================================
  Widget _buildBuyerDetailsCard() {
    return _cardShell(
      sectionKey: 'buyer',
      icon: Icons.person_outline,
      title: 'Buyer & Material Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldRow([
            _Field('Buyer Name', _buyerNameLabel),
            _Field('Destination', _order.stoDestination ?? '-'),
          ]),
          const SizedBox(height: 16),
          _fieldRow([
            _Field('Material Name', _materialNameLabel),
            _Field('Location', _locationLabel),
          ]),
          const SizedBox(height: 16),
          _fieldRow([
            _Field('Customer Ref. No.', _customerReferenceLabel),
            _Field('L1 Destination', _l1DestinationLabel),
          ]),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY TIMELINE CARD
  // ============================================================
  Widget _buildActivityTimelineCard() {
    final List<_ActivityEntry> activities = [];

    if (_order.printEWayBill && _order.ewCount > 0) {
      activities.add(
        _ActivityEntry(
          dateLabel: _formatDateTimeLong(_order.modifiedDate ?? _order.publishedOn),
          title: 'E-Way Bill Generated',
          subtitle: '-',
          icon: Icons.local_shipping,
        ),
      );
    }

    if (_order.publishedOn != null) {
      activities.add(
        _ActivityEntry(
          dateLabel: _formatDateTimeLong(_order.publishedOn),
          title: 'CDO Published',
          subtitle: _publishedToLabel,
          icon: Icons.share,
        ),
      );
    }

    return _cardShell(
      sectionKey: 'activity',
      icon: Icons.history,
      title: 'Activity Timeline',
      child: activities.isEmpty
          ? const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No activity recorded yet.',
          style: TextStyle(fontSize: 12, color: Color(0xFF98A2B3)),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < activities.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _activityTile(activities[i]),
          ],
        ],
      ),
    );
  }

  Widget _activityTile(_ActivityEntry entry) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F8EE),
            shape: BoxShape.circle,
          ),
          child: Icon(entry.icon, size: 14, color: const Color(0xFF27AE60)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.dateLabel,
                style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3)),
              ),
              const SizedBox(height: 2),
              Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF344054),
                ),
              ),
              if (entry.subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  entry.subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TRUCK TRIPS CARD
  // ============================================================
  Widget _buildTruckTripsCard() {
    return Consumer<OrderManagementViewModel>(
      builder: (context, viewModel, child) {
        final query = _tripSearchController.text.trim().toLowerCase();

        final transactions = viewModel.vehicleTransactionList.where((txn) {
          if (query.isEmpty) return true;
          return txn.vrn!.toLowerCase().contains(query) ||
              txn.transactionCode!.toLowerCase().contains(query) ||
              txn.driverName!.toLowerCase().contains(query) ||
              (_order.bdoNumber?.toLowerCase().contains(query) ?? false);
        }).toList();

        return _cardShell(
          sectionKey: 'trips',
          icon: Icons.local_shipping_outlined,
          title: 'Truck Trips',
          badge: _miniBadge('${transactions.length}'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF777777), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _tripSearchController,
                        style: const TextStyle(fontSize: 13),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search for order no, BDO no...',
                          hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${transactions.length} Open Orders',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF131754),
                ),
              ),
              const SizedBox(height: 12),
              if (viewModel.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (transactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No vehicle transactions found.',
                      style: TextStyle(color: Color(0xFF667085)),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 20,
                    color: Color(0xFFEAEAEA),
                  ),
                  itemBuilder: (context, index) {
                    return _buildVehicleTransactionCard(transactions[index]);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleTransactionCard(VehicleTransactionResponseModel txn) {
    final bool isCompleted = txn.status?.trim().toLowerCase() == 'completed';

    // Resolving tenantCode from transaction model, fallback to DO order tenantCode, or default 'LKOP'
    final String? resolvedTenantCode = (txn.tenantCode != null && txn.tenantCode!.isNotEmpty)
        ? txn.tenantCode!
        : (_order.tenantCode!.isNotEmpty ? _order.tenantCode : 'LKOP');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleTripScreen(
                transaction:txn,
                // tenantCode: resolvedTenantCode.toString(),
                // transactionCode: txn.transactionCode.toString(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    txn.vrn.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF131754),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _tripChip(
                    resolvedTenantCode.toString(),
                    const Color(0xFFEAF6FC),
                    const Color(0xFF0878B8),
                  ),
                  const SizedBox(width: 8),
                  _tripChip(
                    txn.status.toString(),
                    isCompleted ? const Color(0xFFE4F7E8) : const Color(0xFFEAF6FC),
                    isCompleted ? const Color(0xFF248A3D) : const Color(0xFF0878B8),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Color(0xFF60717E)),
                  const SizedBox(width: 4),
                  Text(
                    txn.driverName.toString(),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF606770)),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF0878B8)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      txn.transporterName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0878B8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text('Txn. No ', style: TextStyle(fontSize: 12, color: Color(0xFF667085))),
                  Text(
                    txn.transactionCode.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0878B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tripChip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  Widget _fieldRow(List<_Field> fields) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < fields.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: fields[i].build()),
        ],
      ],
    );
  }

  String _formatQty(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  String _formatQtyWithCommas(double value) {
    final bool isWhole = value == value.roundToDouble();
    final String numStr = isWhole ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
    final List<String> parts = numStr.split('.');
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final String mathPart = parts[0].replaceAllMapped(reg, (Match m) => '${m[1]},');
    return parts.length > 1 ? '$mathPart.${parts[1]}' : mathPart;
  }

  @override
  void dispose() {
    _tripSearchController.dispose();
    super.dispose();
  }
}

class _Field {
  final String label;
  final String value;
  final IconData? trailingIcon;

  _Field(this.label, this.value, {this.trailingIcon});

  Widget build() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF667085),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 3),
              Icon(trailingIcon, size: 12, color: const Color(0xFF0D82CA)),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF344054),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ActivityEntry {
  final String dateLabel;
  final String title;
  final String subtitle;
  final IconData icon;

  const _ActivityEntry({
    required this.dateLabel,
    required this.title,
    this.subtitle = '',
    this.icon = Icons.share,
  });
}