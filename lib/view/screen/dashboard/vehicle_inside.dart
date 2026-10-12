import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utilities/app_colors.dart';
import '../../../utilities/common_text.dart';
import '../../../view_model/home_dashboard_view_model.dart';


// ---------- Vehicles Inside card ----------
class VehiclesInsideCard extends StatelessWidget {
  const VehiclesInsideCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. WATCH the ViewModel
    final viewModel = context.watch<DashboardReportViewModel>();
    final totalVehiclesInside = viewModel.totalVehiclesInside;
    // 2. PARSE DATA DYNAMICALLY
    int outboundTotal = 0;
    int outboundSo = 0;
    int outboundSto = 0;

    int inboundTotal = 0;
    int inboundPo = 0;
    int inboundSto = 0;

    if (viewModel.vehicleInsideResponse != null) {
      for (var item in viewModel.vehicleInsideResponse!) {
        int count = item.transactionCount ?? 0;

        // Safely extract and format strings to prevent casing/spacing bugs
        String direction = (item.direction ?? '').trim().toLowerCase();
        String category = (item.category ?? '').trim().toUpperCase();
        String status = (item.transactionStatus ?? '').trim().toLowerCase();

        // ONLY process items where the status is 'withinplant'
        if (status == 'withinplant') {
          if (direction == 'outbound') {
            outboundTotal += count;
            if (category == 'SO') outboundSo += count;
            if (category == 'STO') outboundSto += count;
          } else if (direction == 'inbound') {
            inboundTotal += count;
            if (category == 'PO' || category == 'INBOUND') inboundPo += count;
            if (category == 'STO') inboundSto += count;
          }
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/images/dash_vehicle_inside_icon.svg',
                  width: 16,
                  height: 16,
                ),
              ),
              const SizedBox(width: 8),
              CommonText.h3('Vehicles Inside',
                  fontSize: 14, fontWeight: FontWeight.w600),
            ],
          ),
          const SizedBox(height: 14),

          // 3. SHOW LOADER OR DATA
          if (viewModel.isVehicleInsideLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else ...[
            _VehicleRow(
              icon: SvgPicture.asset(
                'assets/images/dash_outbound_icon.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.kTealGreen,
                  BlendMode.srcIn,
                ),
              ),
              iconBgColor: AppColors.kTealGreen.withOpacity(0.15),
              label: 'Outbound',
              total: outboundTotal.toString(), // <-- Bound to total outbound
              tags: [
                _Tag(label: 'SO', value: outboundSo.toString()), // <-- Bound to SO
                _Tag(label: 'STO', value: outboundSto.toString()) // <-- Bound to STO
              ],
            ),
            const SizedBox(height: 10),
            _VehicleRow(
              icon: SvgPicture.asset(
                'assets/images/dash_inbound_icon.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.kPrimaryBlue,
                  BlendMode.srcIn,
                ),
              ),
              iconBgColor: AppColors.kPrimaryBlue.withOpacity(0.15),
              label: 'Inbound',
              total: inboundTotal.toString(), // <-- Bound to total inbound
              tags: [
                _Tag(label: 'PO', value: inboundPo.toString()), // <-- Bound to PO
                _Tag(label: 'STO', value: inboundSto.toString()) // <-- Bound to STO
              ],
            ),
            const SizedBox(height: 14),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.caption(
                    'Total Vehicles Inside',
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4A5671),
                  ),
                  CommonText.h4(
                    '$totalVehiclesInside Trucks',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF131754),
                  ),
                ],
              ),
            ),

          ],
        ],
      ),
    );
  }
}

class _VehicleRow extends StatelessWidget {
  final Widget icon;
  final Color iconBgColor;
  final String label;
  final String total;
  final List<_Tag> tags;

  const _VehicleRow({
    required this.icon,
    required this.iconBgColor,
    required this.label,
    required this.total,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 26,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: icon,
          ),
          const SizedBox(width: 10),
          CommonText.caption(label, color: const Color(0xFF4A5671)),
          const SizedBox(width: 12),
          CommonText.h4(total,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF131754)),
          const Spacer(),
          ...tags,
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final String value;

  const _Tag({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label : ',
              style: const TextStyle(fontSize: 10, color: AppColors.kTextGrey),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextDark),
            ),
          ],
        ),
      ),
    );
  }
}