import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/ordermanagement/sosto/mdo_response.dart';
import '../../../../model/ordermanagement/sosto/sostodetail/customer_location_response_model.dart';
import '../../../../model/ordermanagement/sosto/sostodetail/customer_response_model.dart';
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
    'additional': true,
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
    viewModel.clearCustomerLocationCache();
    if (locationCode.isNotEmpty && locationCode != '-') {
      viewModel.postFilterSingleCustomerDeliveryLocation(locationCode);
    }
    viewModel.postFilterLocationWithPagination(plantCode, resolvedTenantCode);

    // Billing location address (fetched separately from the shipping location)
    final String billingLocationCode =
        data['billingLocation']?.toString().trim() ?? '';
    if (billingLocationCode.isNotEmpty &&
        billingLocationCode != '-' &&
        billingLocationCode != locationCode) {
      viewModel.postFilterSingleCustomerDeliveryLocation(billingLocationCode);
    }

    // Call fetchCustomerByCode to get ship to party details (for shipping section)
    final String shipToPartyCode = data['shipToParty']?.toString() ?? '';
    if (shipToPartyCode.isNotEmpty) {
      viewModel.fetchCustomerByCode(shipToPartyCode, isSoldToParty: false);
    }

    // Call fetchCustomerByCode to get sold to party details (for PAN number)
    final String soldToPartyCode = data['soldToParty']?.toString() ?? '';
    if (soldToPartyCode.isNotEmpty) {
      viewModel.fetchCustomerByCode(soldToPartyCode, isSoldToParty: true);
    }

    // Call fetchSingleMdoMaster to get detailed order information
    final String mdoNumberStr = data['mdoNumber']?.toString() ?? '';
    if (mdoNumberStr.isNotEmpty) {
      final int? mdoNumber = int.tryParse(mdoNumberStr);
      if (mdoNumber != null) {
        viewModel.fetchSingleMdoMaster(mdoNumber, resolvedTenantCode);
      }
    }
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
                  _buildAdditionalDetailsSection(data),
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
    final viewModel = Provider.of<OrderManagementViewModel>(context, listen: false);
    final String soldToPartyCode = _v(data, ['soldToParty']);
    final String soldToPartyName = _v(data, ['soldToPartyName']);
    final String billingLocation = _v(data, ['billingLocation']);

    // Get sold to party customer details from API response
    final CustomerResponseModel? soldToCustomerDetails = viewModel.soldToPartyCustomer;

    // Get billing location details from API response (exact match only, so we
    // never display another location's address).
    final billingLocationDetails =
        viewModel.customerLocationFor(billingLocation);

    return _sectionShell(
      sectionKey: 'party',
      icon: Icons.handshake_outlined,
      title: 'Party Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sold To Party Section
          const Text(
            'Sold To Party',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  soldToPartyName != '-' ? '$soldToPartyName - $soldToPartyCode' : soldToPartyCode,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Customer Code', soldToCustomerDetails?.customerCode ?? soldToPartyCode),
                _buildDetailRow('Address', soldToCustomerDetails?.address ?? '-'),
                _buildDetailRow('PAN No', soldToCustomerDetails?.panNo ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Billing Location Section
          const Text(
            'Billing Location',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _billingLocationHeading(billingLocation, billingLocationDetails),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Customer Code',
                   billingLocation),
                _buildDetailRow('Address',
                    _locationAddress(billingLocationDetails)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetailsSection(Map<String, dynamic> data) {
    final viewModel = Provider.of<OrderManagementViewModel>(context, listen: false);
    final String shipToPartyCode = _v(data, ['shipToParty']);
    final String shipToPartyName = _v(data, ['shipToPartyName']);
    final String shippingLocation = _v(data, ['shippingLocation']);


    final CustomerResponseModel? customerDetails = viewModel.shipToPartyCustomer;

    final locationDetails = viewModel.customerLocationFor(shippingLocation);

    return _sectionShell(
      sectionKey: 'shipping',
      icon: Icons.local_shipping_outlined,
      title: 'Shipping Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ship To Party Section
          const Text(
            'Ship To Party',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shipToPartyName != '-' ? '$shipToPartyName - $shipToPartyCode' : shipToPartyCode,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Customer Code', customerDetails?.customerCode ?? shipToPartyCode),
                _buildDetailRow('Address', customerDetails?.address ?? '-'),
                _buildDetailRow('PAN No', customerDetails?.panNo ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Shipping Location Section
          const Text(
            'Shipping Location',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shippingLocation != '-' ? shippingLocation : '-',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 8),
                if (locationDetails != null) ...[
                  _buildDetailRow('Address', locationDetails.addressLine1 ?? '-'),
                  _buildDetailRow('City', locationDetails.city ?? '-'),
                  _buildDetailRow('State', locationDetails.state ?? '-'),
                  _buildDetailRow('Pin Code', locationDetails.pincode ?? '-'),
                  _buildDetailRow('GST No', locationDetails.gstNo ?? '-'),
                ] else ...[
                  _buildDetailRow('Address', '-'),
                  _buildDetailRow('City', '-'),
                  _buildDetailRow('State', '-'),
                  _buildDetailRow('Pin Code', '-'),
                  _buildDetailRow('GST No', '-'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _billingLocationHeading(
    String fallbackCode,
    CustomerLocationResponseModel? details,
  ) {
    final String city = details?.city?.trim() ?? '';
    final String locationType = details?.locationType?.trim() ?? '';
    final String apiCode = details?.locationCode?.trim() ?? '';
    final String code = apiCode.isNotEmpty
        ? apiCode
        : (fallbackCode != '-' ? fallbackCode.trim() : '');

    final String typeAndCode = locationType.isNotEmpty
        ? (code.isNotEmpty ? '$locationType($code)' : locationType)
        : code;

    final String heading = [city, typeAndCode]
        .where((part) => part.isNotEmpty)
        .join(' - ');
    return heading.isEmpty ? '-' : heading;
  }

  String _locationAddress(CustomerLocationResponseModel? details) {
    if (details == null) return '-';
    final List<String> parts = [
      if (details.addressLine1?.trim().isNotEmpty ?? false)
        details.addressLine1!.trim(),
      if (details.addressLine2?.trim().isNotEmpty ?? false)
        details.addressLine2!.trim(),
    ];
    return parts.isEmpty ? '-' : parts.join(', ');
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                color: _label,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: _dark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetailsSection(Map<String, dynamic> data) {
    final viewModel = Provider.of<OrderManagementViewModel>(context, listen: false);
    final mdoMaster = viewModel.singleMdoMaster;

    // Use MDO master data if available, otherwise fall back to data
    final String customerRef = mdoMaster?.customerReference ?? _v(data, ['customerReference']);
    final String customerRefDate = mdoMaster?.customerReferenceDate ?? _v(data, ['customerRefDate']);
    final String currency = mdoMaster?.currency ?? _v(data, ['currency']);
    final String paymentTerms = mdoMaster?.paymentTerms ?? _v(data, ['paymentTerms']);
    final String orderValidTill = mdoMaster?.orderValidTillDate ?? _v(data, ['orderValidTill']);
    final String requiredDeliveryStartDate = mdoMaster?.requiredDeliveryStartdate ?? _v(data, ['requiredDeliveryStartDate']);
    final bool? isTolerance = mdoMaster?.isTolerance;

    return _sectionShell(
      sectionKey: 'additional',
      icon: Icons.note_add_outlined,
      title: 'Additional Details',
      child: Column(
        children: [
          _gridRow([
            _Field('Customer Ref', customerRef),
            _Field('Customer Ref Date', _formatDate(customerRefDate)),
            _Field('Currency', currency == '-' ? 'INR' : currency),
            _Field('Payment Terms', paymentTerms),
          ]),
          const SizedBox(height: 16),
          _gridRow([
            _Field('Order Valid Till', _formatDate(orderValidTill)),
            _Field('Required Delivery Start Date', _formatDate(requiredDeliveryStartDate)),
            _Field('Is Tolerance', isTolerance == true ? 'Yes' : (isTolerance == false ? 'No' : '-')),
            const SizedBox(),
          ]),
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
    final viewModel = Provider.of<OrderManagementViewModel>(context, listen: false);
    // Only SOs have an MDO master; avoid reusing the previous SO's data on STO.
    final mdoMaster = widget.isSO ? viewModel.singleMdoMaster : null;

    // Get CDO list from MDO master
    List<Map<String, dynamic>> cdoList = [];

    if (mdoMaster != null && mdoMaster.mdoDetails != null) {
      for (final mdoDetail in mdoMaster.mdoDetails!) {
        if (mdoDetail.cdOs != null) {
          for (final cdo in mdoDetail.cdOs!) {
            cdoList.add({
              'cdo': cdo,
              'materialCode': mdoDetail.materialCode,
              'materialName': mdoDetail.productName,
              'uom': mdoDetail.productUOM,
            });
          }
        }
      }
    }

    // Fallback to deliveryOrders from data if no CDO data
    if (cdoList.isEmpty) {
      final List deliveryOrders = data['deliveryOrders'] as List? ?? [];
      cdoList = deliveryOrders.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }

    return _sectionShell(
      sectionKey: 'delivery',
      icon: Icons.local_shipping_outlined,
      title: 'Delivery Order',
      child: cdoList.isEmpty
          ? _emptyBox(Icons.local_shipping_outlined, 'No delivery orders found.')
          : _buildDeliveryOrderTable(cdoList),
    );
  }

  Widget _buildDeliveryOrderTable(List<Map<String, dynamic>> deliveryOrders) {
    const headerStyle = TextStyle(
        fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF34495E));
    const cellStyle = TextStyle(fontSize: 12, color: _dark);

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
            for (final r in deliveryOrders)
              DataRow(cells: [
                DataCell(InkWell(
                  onTap: () => _showViewDeliveryOrderDialog(r),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _getCdoValue(r, 'cdoNumber'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0878B8),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )),
                DataCell(Text(_getCdoValue(r, 'bdoNumber'))),
                DataCell(Text(_getCdoValue(r, 'locationName'))),
                DataCell(Text(_getMaterialCode(r))),
                DataCell(Text(_getQtyWithUom(r, 'quantity'))),
                DataCell(Text(_getQtyWithUom(r, 'allocatedQuantity'))),
                DataCell(Text(_getQtyWithUom(r, 'doBalanceQty'))),
                DataCell(Text(_getCdoValue(r, 'status'))),
                DataCell(Text(_getCdoValue(r, 'createdBy'))),
                DataCell(Text(_formatDate(_getCdoValue(r, 'createdDate')))),
              ]),
          ],
        ),
      ),
    );
  }

  String _getCdoValue(Map<String, dynamic> data, String key) {
    final dynamic cdo = data['cdo'];
    if (cdo is CdoMaster) {
      final dynamic value = switch (key) {
        'cdoNumber' => cdo.cdoNumber,
        'bdoNumber' => cdo.bdoNumber,
        'locationName' => cdo.locationName,
        'materialCode' => cdo.materialCode,
        'status' => cdo.status,
        'createdBy' => cdo.createdBy,
        'createdDate' => cdo.createdDate,
        _ => null,
      };
      return value?.toString() ?? '-';
    }
    if (cdo is Map) {
      return cdo[key]?.toString() ?? '-';
    }
    // Fallback to direct data (legacy map uses doNumber, not cdoNumber)
    if (key == 'cdoNumber') {
      return _v(data, ['doNumber', 'cdoNumber']);
    }
    return _v(data, [key]);
  }

  String _getMaterialCode(Map<String, dynamic> data) {
    // Get material code from MDO detail if available
    final materialCode = data['materialCode']?.toString();
    if (materialCode != null && materialCode.isNotEmpty) {
      return materialCode;
    }
    // Fallback to CDO object
    return _getCdoValue(data, 'materialCode');
  }

  String _getQtyWithUom(Map<String, dynamic> data, String key) {
    final dynamic cdo = data['cdo'];
    dynamic value;

    if (cdo is CdoMaster) {
      value = switch (key) {
        'quantity' => cdo.quantity,
        'allocatedQuantity' => cdo.allocatedQuantity ?? cdo.dispatchQuantity,
        'doBalanceQty' => cdo.doBalanceQty,
        'dispatchQuantity' => cdo.dispatchQuantity,
        _ => null,
      };
    } else if (cdo is Map) {
      value = cdo[key];
    } else {
      value = data[key];
    }

    final uom = data['uom']?.toString() ?? 'MTS';

    if (value == null) return '-';
    final qty = _fmtNum(value);
    return '$qty $uom';
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  String _rawCdoValue(Map<String, dynamic> row, String key) {
    final dynamic cdo = row['cdo'];
    if (cdo is Map) {
      final dynamic value = cdo[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    final dynamic value = row[key];
    if (value == null) return '';
    final String text = value.toString().trim();
    return text == 'null' ? '' : text;
  }

  dynamic _firstRouteStep(Map<String, dynamic> row) {
    final dynamic cdo = row['cdo'];
    final dynamic raw = cdo is Map
        ? cdo['cdoDeliveryRouteSteps']
        : (cdo == null ? row['cdoDeliveryRouteSteps'] : null);
    if (raw is List && raw.isNotEmpty) return raw.first;
    return null;
  }


  String _deliveryStateName(int? stateCode, String? shippingLocationCode) {
    final viewModel =
        Provider.of<OrderManagementViewModel>(context, listen: false);
    final location = viewModel.customerLocationFor(shippingLocationCode);

    if (stateCode != null) {
      if (location != null &&
          location.stateCode?.trim() == stateCode.toString() &&
          (location.state?.trim().isNotEmpty ?? false)) {
        return location.state!.trim();
      }
      return stateCode.toString();
    }


    if (location != null && (location.state?.trim().isNotEmpty ?? false)) {
      return location.state!.trim();
    }
    return '-';
  }

  void _showViewDeliveryOrderDialog(Map<String, dynamic> row) {
    final dynamic cdo = row['cdo'];
    final CdoMaster? master = cdo is CdoMaster ? cdo : null;

    final String materialCode = _getMaterialCode(row);
    final String materialDescription =
        (row['materialName']?.toString().trim().isNotEmpty ?? false)
            ? row['materialName'].toString().trim()
            : (master?.materialName?.trim().isNotEmpty == true
                ? master!.materialName!.trim()
                : _rawCdoValue(row, 'materialName'));

    final double? quantity = master?.quantity ??
        _parseDouble(cdo is Map ? cdo['quantity'] : row['quantity']);
    final String uom = (row['uom']?.toString().trim().isNotEmpty ?? false)
        ? row['uom'].toString().trim()
        : 'MTS';

    final String locationName = master?.locationName?.trim().isNotEmpty == true
        ? master!.locationName!.trim()
        : _rawCdoValue(row, 'locationName');
    final String priority = master?.priority?.trim().isNotEmpty == true
        ? master!.priority!.trim()
        : _rawCdoValue(row, 'priority');
    final bool isMultiModel = master?.isMultiVehicle ??
        (cdo is Map
            ? cdo['isMultiVehicle'] == true
            : row['isMultiVehicle'] == true);

    final List<String> publishOptions = <String>[];
    final List<PublishRule> rules =
        master?.publishRule ?? const <PublishRule>[];
    if (rules.isNotEmpty) {
      for (final rule in rules) {
        final label = (rule.name ?? rule.code ?? rule.type ?? '').trim();
        if (label.isNotEmpty && !publishOptions.contains(label)) {
          publishOptions.add(label);
        }
      }
    } else {
      final dynamic rawRules =
          cdo is Map ? cdo['publishRule'] : row['publishRule'];
      if (rawRules is List) {
        for (final rule in rawRules) {
          final label = rule is Map
              ? (rule['name'] ?? rule['code'] ?? rule['type'] ?? '')
                  .toString()
                  .trim()
              : rule.toString().trim();
          if (label.isNotEmpty && !publishOptions.contains(label)) {
            publishOptions.add(label);
          }
        }
      }
    }

    final dynamic rawStep = master?.cdoDeliveryRouteSteps?.isNotEmpty == true
        ? master!.cdoDeliveryRouteSteps!.first
        : _firstRouteStep(row);

    String stepNo = '';
    String mode = '';
    String destination = '';
    int? stateCode;
    bool invoicing = false;

    if (rawStep is CdoDeliveryRouteStep) {
      stepNo = rawStep.deliveryStepNo?.toString() ?? '';
      mode = rawStep.mode?.trim() ?? '';
      destination = rawStep.destination?.trim() ?? '';
      stateCode = rawStep.destinationStateCode;
      invoicing = rawStep.invoiceGeneration ?? false;
    } else if (rawStep is Map) {
      stepNo = rawStep['deliveryStepNo']?.toString() ?? '';
      mode = rawStep['mode']?.toString().trim() ?? '';
      destination = rawStep['destination']?.toString().trim() ?? '';
      stateCode = _parseInt(rawStep['destinationStateCode']);
      invoicing = rawStep['invoiceGeneration'] == true;
    }

    final String state = _deliveryStateName(
      stateCode,
      widget.order?['shippingLocation']?.toString(),
    );

    // Billing location is resolved from the Customer Delivery Location API
    // response that was cached while loading this order.
    final String billingLocation =
        widget.order?['billingLocation']?.toString().trim() ?? '-';

    String? selectedPublish;
    bool multiModel = isMultiModel;
    bool invoice = invoicing;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'View Delivery Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _dark,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(dialogContext),
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child:
                                  Icon(Icons.close, size: 20, color: _label),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 22, color: Color(0xFFE9EDF2)),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final bool narrow = constraints.maxWidth < 520;
                          const Widget gap = SizedBox(width: 18);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _dialogField(
                                        'Material Code', materialCode),
                                  ),
                                  gap,
                                  Expanded(
                                    child: _dialogField(
                                      'Material Description',
                                      materialDescription.isEmpty
                                          ? '-'
                                          : materialDescription,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _dialogField(
                                      'Quantity',
                                      quantity == null
                                          ? '-'
                                          : _fmtNum(quantity),
                                      trailing: Text(
                                        uom,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _label,
                                        ),
                                      ),
                                    ),
                                  ),
                                  gap,
                                  Expanded(
                                    child: _dialogField(
                                      'Location Name',
                                      locationName.isEmpty
                                          ? '-'
                                          : locationName,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _dialogField(
                                      'Priority',
                                      priority.isEmpty ? '-' : priority,
                                    ),
                                  ),
                                  gap,
                                  Expanded(
                                    child: _dialogPublishField(
                                      options: publishOptions,
                                      selected: selectedPublish,
                                      onChanged: (value) => setDialogState(
                                        () => selectedPublish = value,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _dialogCheck(
                                label: 'Multi Model',
                                value: multiModel,
                                onChanged: (value) => setDialogState(
                                  () => multiModel = value,
                                ),
                              ),
                              const SizedBox(height: 18),
                              if (narrow) ...[
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _dialogField('Step', stepNo),
                                    ),
                                    gap,
                                    Expanded(
                                      child: _dialogField('Mode', mode),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _dialogField(
                                          'Destination', destination),
                                    ),
                                    gap,
                                    Expanded(
                                      child: _dialogField('State', state),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _dialogCheck(
                                  label: 'Invoicing',
                                  value: invoice,
                                  onChanged: (value) => setDialogState(
                                    () => invoice = value,
                                  ),
                                ),
                              ] else
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _dialogField('Step', stepNo),
                                    ),
                                    gap,
                                    Expanded(
                                      flex: 2,
                                      child: _dialogField('Mode', mode),
                                    ),
                                    gap,
                                    Expanded(
                                      flex: 5,
                                      child: _dialogField(
                                          'Destination', destination),
                                    ),
                                    gap,
                                    Expanded(
                                      flex: 5,
                                      child: _dialogField('State', state),
                                    ),
                                    gap,
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18),
                                      child: _dialogCheck(
                                        label: 'Invoicing',
                                        value: invoice,
                                        onChanged: (value) => setDialogState(
                                          () => invoice = value,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 18),
                              const Divider(
                                  height: 1, color: Color(0xFFE9EDF2)),
                              const SizedBox(height: 14),
                              Consumer<OrderManagementViewModel>(
                                builder: (context, vm, child) {
                                  final details =
                                      vm.customerLocationFor(billingLocation);
                                  final address = _locationAddress(details);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _dialogField(
                                        'Billing Location',
                                        _billingLocationHeading(
                                            billingLocation, details),
                                      ),
                                      if (address != '-') ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          address,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: _label,
                                            height: 1.35,
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dialogField(String label, String value, {Widget? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: _label,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? '-' : value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _dark,
                  height: 1.3,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
          ],
        ),
      ],
    );
  }

  Widget _dialogPublishField({
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onChanged,
  }) {
    const valueStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: _dark,
    );
    const hintStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFF98A2B3),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Publish To',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: _label,
          ),
        ),
        const SizedBox(height: 1),
        if (options.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(child: Text('Select', style: hintStyle)),
                Icon(Icons.keyboard_arrow_down,
                    size: 18, color: Color(0xFF98A2B3)),
              ],
            ),
          )
        else
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selected,
              isExpanded: true,
              isDense: true,
              hint: const Text('Select', style: hintStyle),
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 18, color: _label),
              style: valueStyle,
              items: options
                  .map(
                    (option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: valueStyle,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
      ],
    );
  }

  Widget _dialogCheck({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              activeColor: _blue,
              side: const BorderSide(color: Color(0xFF98A2B3), width: 1.3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: _dark,
            ),
          ),
        ],
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