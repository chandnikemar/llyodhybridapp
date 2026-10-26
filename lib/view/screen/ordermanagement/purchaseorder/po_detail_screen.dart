import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_lloyd_web_app/model/ordermanagement/purchaseorder/po_master_response.dart';
import 'package:ut_lloyd_web_app/utilities/common.dart';
import 'package:ut_lloyd_web_app/view_model/ordermanagement_view_model.dart';

class PoDetailsScreen extends StatefulWidget {
  final PoMasterResponse? poMaster;

  const PoDetailsScreen({
    super.key,
    this.poMaster,
  });

  @override
  State<PoDetailsScreen> createState() => _PoDetailsScreenState();
}

class _PoDetailsScreenState extends State<PoDetailsScreen> {
  // Main Section Expansion States: Collapsed by default (false)
  final Map<String, bool> _expanded = {
    'order': true,
    'party': true,
    'lineItems': true,
  };

  // Expanded State for Individual Line Items: Collapsed by default (false)
  final Map<int, bool> _lineItemExpanded = {};

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

    if (mounted && widget.poMaster != null) {
      _fetchMasterData();
    }
  }

  void _fetchMasterData() {
    final master = widget.poMaster;
    if (master == null) return;

    final viewModel = Provider.of<OrderManagementViewModel>(context, listen: false);

    int conditionId = 1;
    if (master.poLineItemDetails.isNotEmpty &&
        master.poLineItemDetails.first.conditionTypeMappings.isNotEmpty) {
      conditionId = master.poLineItemDetails.first.conditionTypeMappings.first.conditionMDODetailMappingId;
    }

    const int currencyId = 1;
    const String currencyCode = 'INR';
    const int paymentTermsId = 1;
    const bool isActive = true;
    const int dcId = 1;
    const int divId = 1;
    const int incId = 1;
    const int taxTypeId = 1;
    const int otId = 1;
    const int productId = 1;

    const String locationCode = '';

    String plantCode = master.receiverPlant;
    if (plantCode.contains('\n')) {
      plantCode = plantCode.split('\n').last.trim();
    }

    final String resolvedTenantCode = master.tenantCode.isNotEmpty
        ? master.tenantCode
        : _tenantCode;

    viewModel.postFilterConditionType(conditionId);
    viewModel.postFilterCurrencies(currencyId, currencyCode, isActive);
    viewModel.postFilterPaymentTerms(paymentTermsId);
    viewModel.getPaginatedDistributionChannelList(dcId);
    viewModel.getPaginatedDivisionList(divId);
    viewModel.getPaginatedIncoTermList(incId);
    viewModel.postFilterTaxType(taxTypeId);
    viewModel.getPaginatedOrderTypeList(otId);
    viewModel.postFilterProduct(productId);
    viewModel.getAlltenantgroup();
    viewModel.getAllTenants();
    // viewModel.postFilterSingleCustomerDeliveryLocation(locationCode);
    viewModel.postFilterLocationWithPagination(plantCode, resolvedTenantCode);
  }

  void _toggle(String key) {
    setState(() {
      _expanded[key] = !(_expanded[key] ?? true);
    });
  }

  // ============================================================
  // DATE FORMATTING HELPER
  // ============================================================
  // The API returns dates as raw ISO strings (e.g. "2024-06-12T00:00:00Z"
  // or with a time component). Previously these were rendered as-is, so
  // the UI showed the raw ISO string instead of a readable date. This
  // formats to dd-mm-yyyy, including the time only when one is present
  // and non-zero, and falls back to '-' for empty/placeholder values.
  String _formatDate(Object? value) {
    final raw = value?.toString().trim() ?? '';
    if (raw.isEmpty || raw == '-' || raw == 'null') return '-';

    final DateTime? parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.split('T').first;
    if (parsed.year <= 1) return '-'; // placeholder/empty dates from the API

    final String d = parsed.day.toString().padLeft(2, '0');
    final String m = parsed.month.toString().padLeft(2, '0');
    final String y = parsed.year.toString();

    if (parsed.hour == 0 && parsed.minute == 0 && parsed.second == 0) {
      return '$d-$m-$y';
    }

    final String h = parsed.hour.toString().padLeft(2, '0');
    final String min = parsed.minute.toString().padLeft(2, '0');
    return '$d-$m-$y $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final master = widget.poMaster;

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
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Color(0xFF1C6DD0)),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PO Details',
              style: const TextStyle(
                color: Color(0xFF131754),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<OrderManagementViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0072CE),
              ),
            );
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
                        backgroundColor: const Color(0xFF0072CE),
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

          return Column(
            children: [
              const Divider(height: 16, thickness: 1, color: Color(0xFFEAEAEA)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildOrderInformationSection(master),
                      const Divider(height: 24, thickness: 1, color: Color(0xFFEAEAEA)),
                      _buildPartyDetailsSection(master),
                      const Divider(height: 24, thickness: 1, color: Color(0xFFEAEAEA)),
                      _buildLineItemsSection(master),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
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
  }) {
    final bool isOpen = _expanded[sectionKey] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _toggle(sectionKey),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F2FA),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFF0072CE)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 22,
                  color: const Color(0xFF0072CE),
                ),
              ],
            ),
          ),
        ),
        if (isOpen) ...[
          const SizedBox(height: 16),
          child,
        ],
      ],
    );
  }

  Widget _buildOrderInformationSection(PoMasterResponse? master) {
    final String status = master?.status.isNotEmpty == true ? master!.status : 'OPEN';

    return _sectionShell(
      sectionKey: 'order',
      icon: Icons.article_outlined,
      title: 'Order Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _gridRow([
            _Field('PO Number', master?.poNumber.toString() ?? '-'),
            _Field('PO Date', _formatDate(master?.poDate)),
            _Field('Order Type', master?.orderType ?? '-'),
          ]),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF34495E),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F7E2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF27AE60),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartyDetailsSection(PoMasterResponse? master) {
    return _sectionShell(
      sectionKey: 'party',
      icon: Icons.business_outlined,
      title: 'Party & Organisation Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _gridRow([
            _Field('Supplier Name', master?.supplierName.isNotEmpty == true ? master!.supplierName : (master?.supplier ?? '-')),
            _Field('Company Name', master?.companyName.isNotEmpty == true ? master!.companyName : (master?.companyCode ?? '-')),
            _Field('Purchase Org', master?.purchaseOrganizationName.isNotEmpty == true ? master!.purchaseOrganizationName : (master?.purchaseOrganization ?? '-')),
          ]),
          const SizedBox(height: 16),
          _gridRow([
            _Field('Purchase Grp', master?.purchaseGroupName.isNotEmpty == true ? master!.purchaseGroupName : (master?.purchaseGroup ?? '-')),
            _Field('Plant Name', master?.receiverPlantName.isNotEmpty == true ? master!.receiverPlantName : (master?.receiverPlant ?? '-')),
            _Field('Tenant Code', master?.tenantCode ?? '-'),
          ]),
        ],
      ),
    );
  }

  Widget _buildLineItemsSection(PoMasterResponse? master) {
    final List<PoLineItemDetail> lineItems = master?.poLineItemDetails ?? [];

    return _sectionShell(
      sectionKey: 'lineItems',
      icon: Icons.inventory_2_outlined,
      title: 'Line Items',
      child: Column(
        children: [
          if (lineItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('No line items available', style: TextStyle(color: Colors.grey)),
            ),
          for (int index = 0; index < lineItems.length; index++) ...[
            if (index > 0) const SizedBox(height: 10),
            _buildLineItemCard(index, lineItems[index]),
          ],
        ],
      ),
    );
  }

  Widget _buildLineItemCard(int index, PoLineItemDetail item) {
    final bool isExpanded = _lineItemExpanded[index] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isExpanded ? const Color(0xFF0072CE) : const Color(0xFFE0E0E0),
          width: isExpanded ? 1.2 : 1,
        ),
        boxShadow: isExpanded
            ? [
          BoxShadow(
            color: const Color(0xFF0072CE).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _lineItemExpanded[index] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0072CE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.lineItemNumber.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.materialCode,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0072CE),
                                ),
                              ),
                            ),
                            _statusChip(item.status),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.materialDescription,
                          maxLines: isExpanded ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Quick-glance summary visible even when collapsed
                        Text(
                          '${item.quantity} ${item.uom}  \u2022  Due ${_formatDate(item.deliveryDate)}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF7A8699),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 20,
                    color: const Color(0xFF0072CE),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFEFEFEF)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _groupHeader(Icons.inventory_2_outlined, 'Quantity'),
                  const SizedBox(height: 10),
                  _quantityStrip(item),
                  const SizedBox(height: 12),
                  _gridRow([
                    _Field('Material Grp', item.materialGroup),
                    _Field('UOM', item.uom),
                    _Field('Storage Loc', item.storageLocation),
                  ]),

                  const SizedBox(height: 18),
                  _groupHeader(Icons.currency_rupee, 'Pricing'),
                  const SizedBox(height: 10),
                  _gridRow([
                    _Field('Unit Cost', item.unitCost.toString()),
                    _Field('Net Price', item.netPrice.toString()),
                    const SizedBox.shrink(),
                  ]),

                  const SizedBox(height: 18),
                  _groupHeader(Icons.local_shipping_outlined, 'Delivery'),
                  const SizedBox(height: 10),
                  _gridRow([
                    _Field('Del. Date', _formatDate(item.deliveryDate)),
                    _Field('Status', item.status),
                    const SizedBox.shrink(),
                  ]),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Section label with icon, used to visually separate groups of fields
  Widget _groupHeader(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF0072CE)),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0072CE),
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  // Ordered -> Allocated -> Received -> Pending shown as a single readable
  // strip instead of a plain grid, so the quantity flow reads left to right.
  Widget _quantityStrip(PoLineItemDetail item) {
    Widget qtyBlock(String label, String value, Color color) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF8B95A5),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          qtyBlock('ORDERED', item.quantity.toString(), const Color(0xFF2C3E50)),
          qtyBlock('ALLOCATED', item.allocatedQuantity.toString(), const Color(0xFF0072CE)),
          qtyBlock('RECEIVED', item.receivedQuantity.toString(), const Color(0xFF27AE60)),
          qtyBlock('PENDING', item.pendingQuantity.toString(), const Color(0xFFE67E22)),
        ],
      ),
    );
  }

  // Colored chip so status is scannable without reading text
  Widget _statusChip(String status) {
    final String s = status.toLowerCase();
    Color bg = const Color(0xFFE2F7E2);
    Color fg = const Color(0xFF27AE60);

    if (s.contains('pending') || s.contains('open')) {
      bg = const Color(0xFFFFF3E0);
      fg = const Color(0xFFE67E22);
    } else if (s.contains('cancel') || s.contains('reject')) {
      bg = const Color(0xFFFDECEA);
      fg = const Color(0xFFE74C3C);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status.isNotEmpty ? status.toUpperCase() : '-',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  Widget _gridRow(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map(
            (widget) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: widget,
          ),
        ),
      )
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
            color: Color(0xFF34495E),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : '-',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}