import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utilities/common.dart';
import '../../../../view_model/ordermanagement_view_model.dart';

class SostoOrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? order;
  final bool isSO;

  const SostoOrderDetailsScreen({
    super.key,
    this.order,
    this.isSO = true,
  });

  @override
  State<SostoOrderDetailsScreen> createState() =>
      _SostoOrderDetailsScreenState();
}

class _SostoOrderDetailsScreenState extends State<SostoOrderDetailsScreen> {
  static const Color _blue = Color(0xFF0072CE);
  static const Color _dark = Color(0xFF2C3E50);
  static const Color _label = Color(0xFF6B7280);

  final Map<String, bool> _expanded = {
    'order': true,
    'plant': true,
    'shipping': true,
    'payment': true,
    'material': true,
    'delivery': true,
  };

  String _tenantCode = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTenant = prefs.getString(Common.selectedTenant);
    if (savedTenant != null && savedTenant.isNotEmpty) {
      _tenantCode = savedTenant;
    }
    if (mounted && widget.order != null) {
      _fetchMasterData();
    }
  }

  void _fetchMasterData() {
    if (widget.order == null) return;

    final viewModel =
    Provider.of<OrderManagementViewModel>(context, listen: false);
    final data = widget.order!;

    int conditionId = 1;
    final materials = data['materials'] as List?;
    if (materials != null && materials.isNotEmpty) {
      final first = materials.first as Map<String, dynamic>?;
      if (first != null && first['conditionId'] != null) {
        conditionId = int.tryParse(first['conditionId'].toString()) ?? 1;
      }
    }

    int id(String k) => int.tryParse(data[k]?.toString() ?? '1') ?? 1;

    final String currencyCode = data['currency']?.toString() ?? 'INR';
    final String locationCode = data['shippingLocation']?.toString() ?? '';

    String plantCode = data['senderPlant0']?.toString() ?? '';
    if (plantCode.contains('\n')) {
      plantCode = plantCode.split('\n').last.trim();
    }

    final String resolvedTenantCode =
    (data['tenantCode']?.toString().isNotEmpty == true)
        ? data['tenantCode'].toString()
        : _tenantCode;

    viewModel.postFilterConditionType(conditionId);
    viewModel.postFilterCurrencies(id('currencyId'), currencyCode, true);
    viewModel.postFilterPaymentTerms(id('paymentTermsId'));
    viewModel.getPaginatedDistributionChannelList(id('dcId'));
    viewModel.getPaginatedDivisionList(id('divId'));
    viewModel.getPaginatedIncoTermList(id('incId'));
    viewModel.postFilterTaxType(id('taxTypeId'));
    viewModel.getPaginatedOrderTypeList(id('otId'));
    viewModel.postFilterProduct(id('productId'));
    viewModel.getAlltenantgroup();
    viewModel.getAllTenants();
    viewModel.postFilterSingleCustomerDeliveryLocation(locationCode);
    viewModel.postFilterLocationWithPagination(plantCode, resolvedTenantCode);
  }

  void _toggle(String key) =>
      setState(() => _expanded[key] = !(_expanded[key] ?? true));


  /// Returns the first non-empty value among [keys], else '-'.
  String _v(Map data, List<String> keys) {
    for (final k in keys) {
      final val = data[k];
      if (val == null) continue;
      final s = val.toString().trim();
      if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
    }
    return '-';
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty || raw == '-') return '-';
    try {
      final dt = DateTime.parse(raw);
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      if (dt.hour == 0 && dt.minute == 0 && dt.second == 0) {
        return '$d-$m-${dt.year}';
      }
      final h = dt.hour.toString().padLeft(2, '0');
      final mi = dt.minute.toString().padLeft(2, '0');
      return '$d-$m-${dt.year} $h:$mi';
    } catch (_) {
      return raw.replaceFirst('T', ' ');
    }
  }

  String _fmtNum(dynamic value, {int decimals = 2}) {
    if (value == null) return '-';
    final double? n =
    value is num ? value.toDouble() : double.tryParse(value.toString());
    if (n == null) return value.toString();
    final fixed = n == n.roundToDouble() ? n.toInt().toString() : n.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => ',',
    );
    return parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  }

  String _fmtMoney(dynamic value) {
    final s = _fmtNum(value);
    return s == '-' ? '-' : 'Rs. $s';
  }

  /// Normalises the material's condition data into a list of maps.
  List<Map<String, dynamic>> _conditionRows(Map<String, dynamic> material) {
    final dynamic raw = material['conditionDetails'] ??
        material['conditionType'] ??
        material['conditionTypes'];
    if (raw == null) return [];

    if (raw is List) {
      return raw.map<Map<String, dynamic>>((item) {
        if (item is Map) return Map<String, dynamic>.from(item);
        try {
          final d = item as dynamic;
          return {
            'conditionType': d.conditionType,
            'unitPrice': d.conditionPrice,
            'conditionPercentage': d.conditionPercentage,
            'totalValue': d.conditionAmount,
          };
        } catch (_) {
          return {'conditionType': item.toString()};
        }
      }).toList();
    }
    if (raw is Map) return [Map<String, dynamic>.from(raw)];

    final s = raw.toString().trim();
    if (s.isEmpty || s.contains('Instance of')) return [];
    return [
      {
        'conditionType': s,
        'unitPrice': material['unitCost'],
        'conditionPercentage': material['conditionPercentage'],
        'totalValue': material['totalValue'],
      }
    ];
  }

  String _conditionLabel(Map<String, dynamic> material) {
    final rows = _conditionRows(material);
    if (rows.isEmpty) return '-';
    final names = rows
        .map((r) => (r['conditionType'] ?? r['name'] ?? '').toString())
        .where((s) => s.isNotEmpty && !s.contains('Instance of'))
        .toList();
    return names.isEmpty ? '-' : names.join(', ');
  }


  @override
  Widget build(BuildContext context) {
    final data = widget.order ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF0FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 16, color: Color(0xFF1C6DD0)),
            ),
          ),
        ),
        title: Text(
          widget.isSO ? 'SO Details' : 'STO Details',
          style: const TextStyle(
            color: Color(0xFF131754),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<OrderManagementViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: _blue));
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${viewModel.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _fetchMasterData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              children: [
                _buildOrderInformationSection(data),
                const SizedBox(height: 14),
                if (widget.isSO) ...[
                  _buildPartyDetailsSection(data),
                  const SizedBox(height: 14),
                  _buildShippingDetailsSection(data),
                  const SizedBox(height: 14),
                  _buildPaymentDetailsSection(data),
                ] else
                  _buildPlantDetailsSection(data),
                const SizedBox(height: 14),
                _buildMaterialDetailsSection(data),
                const SizedBox(height: 14),
                _buildDeliveryOrderSection(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionShell({
    required String sectionKey,
    required IconData icon,
    required String title,
    required Widget child,
    Widget? trailing,
    bool padChild = true,
  }) {
    final bool isOpen = _expanded[sectionKey] ?? true;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _toggle(sectionKey),
            child: Container(
              color: const Color(0xFFF8F9FA),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: _blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    trailing,
                    const SizedBox(width: 8),
                  ],
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 22,
                    color: _dark,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
            padChild ? Padding(padding: const EdgeInsets.all(14), child: child) : child,
          ],
        ],
      ),
    );
  }

  // ============================================================
  // ORDER INFORMATION
  // ============================================================

  Widget _buildOrderInformationSection(Map<String, dynamic> data) {
    if (!widget.isSO) {
      return _sectionShell(
        sectionKey: 'order',
        icon: Icons.storefront_outlined,
        title: 'Order Information',
        child: Column(
          children: [
            _gridRow([
              _Field('STO Number', _v(data, ['stoNumber', 'soNumber'])),
              _Field('STO Date',
                  _formatDate(_v(data, ['stoDate', 'soDate']))),
            ]),
            const SizedBox(height: 16),
            _gridRow([
              _Field('Order Type', _v(data, ['orderType'])),
              _Field('Purchase Group', _v(data, ['purchaseGroup'])),
            ]),
            const SizedBox(height: 16),
            _gridRow([
              _Field('Purchase Organization',
                  _v(data, ['purchaseOrganization', 'purchaseOrg'])),
              _Field('Sender Plant',
                  _v(data, ['senderPlantName', 'senderPlant'])),
            ]),
          ],
        ),
      );
    }

    return _sectionShell(
      sectionKey: 'order',
      icon: Icons.article_outlined,
      title: 'Order Information',
      child: Column(
        children: [
          _gridRow([
            _Field('SO Number', _v(data, ['soNumber'])),
            _Field('SO Date', _formatDate(_v(data, ['soDate']))),
            _Field('Order Type', _v(data, ['orderType'])),
          ]),
          const SizedBox(height: 16),
          _gridRow([
            _Field('Sales Org.', _v(data, ['senderPlantName'])),
            _Field('Distribution Chnl.', _v(data, ['distributionChnl'])),
            _Field('Sales Contract No.', _v(data, ['salesContractNo'])),
          ]),
        ],
      ),
    );
  }

  // ============================================================
  // STO: PLANT DETAILS
  // ============================================================

  Widget _buildPlantDetailsSection(Map<String, dynamic> data) {
    final String status = _v(data, ['status']) == '-' ? 'OPEN' : _v(data, ['status']);

    return _sectionShell(
      sectionKey: 'plant',
      icon: Icons.description_outlined,
      title: 'Plant Details',
      child: _gridRow([
        _Field('Receiver Plant',
            _v(data, ['receiverPlantName', 'receiverPlant', 'shipToPartyName'])),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status', style: _labelStyle),
            const SizedBox(height: 6),
            _statusPill(status),
          ],
        ),
      ]),
    );
  }


  Widget _buildPartyDetailsSection(Map<String, dynamic> data) {
    return _sectionShell(
      sectionKey: 'party',
      icon: Icons.handshake_outlined,
      title: 'Party Details',
      child: Column(
        children: [
          _gridRow([
            _Field('Sold to Party', _v(data, ['soldToParty'])),
            _Field('Billing Location', _v(data, ['billingLocation'])),
          //   _Field('Ship To Party', _v(data, ['shipToParty'])),
          //   _Field('Customer Reference', _v(data, ['customerReference'])),
          // ]),
          // const SizedBox(height: 16),
          // _gridRow([
          //   _Field('Customer Ref Date',
          //       _formatDate(_v(data, ['customerRefDate']))),
          //   _Field('Order Valid Till',
          //       _formatDate(_v(data, ['orderValidTill']))),
            const SizedBox(),
          ]),
        ],
      ),
    );
  }

  Widget _buildShippingDetailsSection(Map<String, dynamic> data) {
    return _sectionShell(
      sectionKey: 'shipping',
      icon: Icons.local_shipping_outlined,
      title: 'Shipping Details',
      child: _gridRow([
        _Field('Shipping Point', _v(data, ['shipToPartyName'])),
        _Field('Shipping Location', _v(data, ['shipToParty'])),
        // _Field('Required Delivery Start Date',
        //     _formatDate(_v(data, ['requiredDeliveryStartDate']))),
      ]),
    );
  }

  Widget _buildPaymentDetailsSection(Map<String, dynamic> data) {
    final String status = _v(data, ['status']) == '-' ? 'OPEN' : _v(data, ['status']);

    return _sectionShell(
      sectionKey: 'payment',
      icon: Icons.credit_card_outlined,
      title: 'Payment Details',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: _Field('Payment Terms', _v(data, ['paymentTerms']))),
          Expanded(
              flex: 2,
              child: _Field('Aggregate Dis.',
                  _v(data, ['aggregateDis']) == '-' ? '0' : _v(data, ['aggregateDis']))),
          Expanded(
              flex: 2,
              child: _Field('Currency',
                  _v(data, ['currency']) == '-' ? 'INR' : _v(data, ['currency']))),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status', style: _labelStyle),
                const SizedBox(height: 6),
                _statusPill(status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialDetailsSection(Map<String, dynamic> data) {
    final List materials = data['materials'] as List? ?? [];
    debugPrint('[SostoOrderDetails] materials received: ${materials.length}');

    return _sectionShell(
      sectionKey: 'material',
      icon: Icons.inventory_2_outlined,
      title: 'Material Details',
      padChild: false,
      child: materials.isEmpty
          ? Padding(
        padding: const EdgeInsets.all(14),
        child: _emptyBox(Icons.inventory_2_outlined, 'No materials found.'),
      )
          : _buildMaterialTable(
        materials
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
      ),
    );
  }

  Widget _buildMaterialTable(List<Map<String, dynamic>> rows) {
    const headerStyle = TextStyle(
        fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1F2937));
    const cellStyle = TextStyle(fontSize: 12.5, color: Color(0xFF1F2937));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.white),
        headingTextStyle: headerStyle,
        dataTextStyle: cellStyle,
        columnSpacing: 28,
        horizontalMargin: 14,
        headingRowHeight: 46,
        dataRowMinHeight: 56,
        dataRowMaxHeight: 64,
        dividerThickness: 0.8,
        columns: const [
          DataColumn(label: Text('LI No.')),
          DataColumn(label: Text('Material Desc')),
          DataColumn(label: Text('Qty')),
          DataColumn(label: Text('Unit Cost')),
          DataColumn(label: Text('Condition Type')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Pending Qty')),
        ],
        rows: [
          for (int i = 0; i < rows.length; i++) _materialRow(i, rows[i]),
        ],
      ),
    );
  }

  DataRow _materialRow(int index, Map<String, dynamic> m) {
    final String qty = _v(m, ['qty', 'quantity']);
    final String uom = _v(m, ['uom', 'unit']);
    final String qtyText =
    qty == '-' ? '-' : '${_fmtNum(qty)} ${uom == '-' ? 'MTS' : uom}';
    final String status = _v(m, ['status']) == '-' ? 'OPEN' : _v(m, ['status']);
    final String lineNo = _v(m, ['lineNo', 'liNo']);
    final String code = _v(m, ['materialCode', 'code']);

    return DataRow(cells: [
      DataCell(Text(lineNo == '-' ? '${(index + 1) * 10}' : lineNo)),
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _v(m, ['name', 'materialDesc', 'materialDescription']),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          if (code != '-')
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(code,
                  style: const TextStyle(fontSize: 11, color: _label)),
            ),
        ],
      )),
      DataCell(Text(qtyText)),
      DataCell(Text(_fmtMoney(m['unitCost']))),
      DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_conditionLabel(m)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _showConditionDialog(m),
            child: const Icon(Icons.visibility, size: 18, color: Color(0xFF0B6BA8)),
          ),
        ],
      )),
      DataCell(_statusPill(status)),
      DataCell(Text(_fmtNum(m['pendingQty'] ?? m['pendingQuantity'] ?? 0))),
    ]);
  }


  void _showConditionDialog(Map<String, dynamic> material) {
    final rows = _conditionRows(material);

    const head = TextStyle(
        fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF34495E));
    const cell = TextStyle(fontSize: 12, color: _dark);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Condition Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _dark,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(dialogContext),
                      child: const Icon(Icons.close, size: 20, color: _label),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (rows.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('No condition details available.',
                        style: TextStyle(fontSize: 12, color: _label)),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor:
                        WidgetStateProperty.all(Colors.white),
                        dataRowColor: WidgetStateProperty.all(
                            const Color(0xFFF1F1F1)),
                        headingTextStyle: head,
                        dataTextStyle: cell,
                        columnSpacing: 24,
                        horizontalMargin: 12,
                        columns: const [
                          DataColumn(label: Text('Condition Type')),
                          DataColumn(label: Text('Unit Price')),
                          DataColumn(label: Text('Condition Percentage')),
                          DataColumn(label: Text('Total Value')),
                        ],
                        rows: [
                          for (final r in rows)
                            DataRow(cells: [
                              DataCell(Text(_v(r, ['conditionType', 'name']))),
                              DataCell(Text(_fmtNum(r['unitPrice'] ?? r['unitCost']))),
                              DataCell(Text(
                                  '${_fmtNum(r['conditionPercentage'] ?? r['percentage'] ?? 0)} %')),
                              DataCell(Text(_fmtNum(r['totalValue'] ?? r['total']))),
                            ]),
                        ],
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


  ({Color bg, Color fg}) _statusStyle(String status) {
    switch (status.trim().toLowerCase()) {
      case 'closed':
      case 'completed':
      case 'delivered':
        return (bg: const Color(0xFFF1F2F4), fg: const Color(0xFF2C3E50));
      case 'in transit':
      case 'dispatched':
      case 'publish':
      case 'published':
        return (bg: const Color(0xFFE0F2FE), fg: const Color(0xFF0878B8));
      case 'pending':
        return (bg: const Color(0xFFFEF3C7), fg: const Color(0xFFD97706));
      case 'open':
        return (bg: const Color(0xFFE2F7E2), fg: const Color(0xFF27AE60));
      case 'cancelled':
      case 'rejected':
        return (bg: const Color(0xFFFEE2E2), fg: const Color(0xFFDC2626));
      default:
        return (bg: const Color(0xFFEEF0F4), fg: const Color(0xFF6B7280));
    }
  }

  Widget _statusPill(String status) {
    final s = _statusStyle(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase() == status ? status : status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: s.fg,
        ),
      ),
    );
  }

  Widget _buildDeliveryOrderSection(Map<String, dynamic> data) {
    final List deliveryOrders = data['deliveryOrders'] as List? ?? [];

    return _sectionShell(
      sectionKey: 'delivery',
      icon: Icons.local_shipping_outlined,
      title: 'Delivery Order',
      child: deliveryOrders.isEmpty
          ? _emptyBox(Icons.local_shipping_outlined, 'No delivery orders found.')
          : _buildDeliveryOrderTable(deliveryOrders),
    );
  }

  Widget _buildDeliveryOrderTable(List deliveryOrders) {
    final rows = deliveryOrders
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    const headerStyle = TextStyle(
        fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF34495E));
    const cellStyle = TextStyle(fontSize: 12, color: _dark);

    String qty(dynamic v) => _fmtNum(v);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.white),
          headingTextStyle: headerStyle,
          dataTextStyle: cellStyle,
          columnSpacing: 22,
          horizontalMargin: 12,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 52,
          dividerThickness: 0.6,
          columns: const [
            DataColumn(label: Text('DO Number')),
            DataColumn(label: Text('BDO Number')),
            DataColumn(label: Text('Location Name')),
            DataColumn(label: Text('Material Code')),
            DataColumn(label: Text('DO Qty')),
            DataColumn(label: Text('Allocated')),
            DataColumn(label: Text('Bal. Qty')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Created By')),
            DataColumn(label: Text('Created Date')),
          ],
          rows: [
            for (final r in rows)
              DataRow(cells: [
                DataCell(Text(
                  _v(r, ['doNumber']),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0878B8),
                    decoration: TextDecoration.underline,
                  ),
                )),
                DataCell(Text(_v(r, ['bdoNumber']))),
                DataCell(Text(_v(r, ['locationName']))),
                DataCell(Text(_v(r, ['materialCode']))),
                DataCell(Text(qty(r['quantity']))),
                DataCell(Text(qty(
                    r['allocatedQuantity'] ?? r['allocated'] ?? r['dispatchQuantity']))),
                DataCell(Text(qty(r['doBalanceQty']))),
                DataCell(Text(_v(r, ['status']))),
                DataCell(Text(_v(r, ['createdBy']))),
                DataCell(Text(_formatDate(_v(r, ['createdDate'])))),
              ]),
          ],
        ),
      ),
    );
  }

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 12,
    color: _label,
    fontWeight: FontWeight.w600,
  );

  Widget _emptyBox(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: const Color(0xFFC7CBD1)),
          const SizedBox(height: 8),
          Text(text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF95A5A6))),
        ],
      ),
    );
  }

  Widget _gridRow(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((w) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: w,
        ),
      ))
          .toList(),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;

  const _Field(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}