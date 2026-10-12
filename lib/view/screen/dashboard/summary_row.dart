import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utilities/app_colors.dart';
import '../../../utilities/common_dialog.dart';
import '../../../utilities/common_text.dart';
import '../../../view_model/home_dashboard_view_model.dart';

/// Shows "Custom" as the actual dates (e.g. "01 Oct - 07 Oct"); presets unchanged.
String _rangeLabel(String label, String from, String to) {
  if (label != 'Custom') return label;
  final f = DateTime.tryParse(from);
  final t = DateTime.tryParse(to);
  if (f == null || t == null) return label;
  final fmt = DateFormat('dd MMM');
  final same = f.year == t.year && f.month == t.month && f.day == t.day;
  return same ? fmt.format(f) : '${fmt.format(f)} - ${fmt.format(t)}';
}

// ---------- Trip Summary + TAT Summary ----------
class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardReportViewModel>();

    // --- 1. PARSE TRIP SUMMARY DATA ---
    int totalTrips = 0;
    int outboundTrips = 0;
    int inboundTrips = 0;
    int outboundSo = 0;
    int outboundSto = 0;
    int inboundPo = 0;
    int inboundSto = 0;

    if (viewModel.tripSummaryResponse != null) {
      for (var item in viewModel.tripSummaryResponse!) {
        int count = item.transactionCount ?? 0;

        String direction = (item.direction ?? '').trim().toLowerCase();
        String category = (item.category ?? '').trim().toUpperCase();
        String status = (item.transactionStatus ?? '').trim().toLowerCase();

        if (status == 'completed' || status.isEmpty) {
          totalTrips += count;

          if (direction == 'outbound') {
            outboundTrips += count;
            if (category == 'SO') outboundSo += count;
            if (category == 'STO') outboundSto += count;
          } else if (direction == 'inbound') {
            inboundTrips += count;
            if (category == 'PO' || category == 'INBOUND') inboundPo += count;
            if (category == 'STO') inboundSto += count;
          }
        }
      }
    }

    // --- 2. PARSE TAT SUMMARY DATA ---
    String outMin = '00:00';
    String outMax = '00:00';
    String outAvg = '00:00';

    String inMin = '00:00';
    String inMax = '00:00';
    String inAvg = '00:00';

    String overallAvg = '00:00';

    if (viewModel.tatSummaryResponse != null) {
      for (var item in viewModel.tatSummaryResponse!) {
        String direction = (item.direction ?? '').trim().toLowerCase();

        if (direction == 'outbound') {
          outMin = item.minTat ?? '00:00';
          outMax = item.maxTat ?? '00:00';
          outAvg = item.avgTat ?? '00:00';
        } else if (direction == 'inbound') {
          inMin = item.minTat ?? '00:00';
          inMax = item.maxTat ?? '00:00';
          inAvg = item.avgTat ?? '00:00';
        } else if (direction == 'total') {
          overallAvg = item.avgTat ?? '00:00';
        }
      }
    }

    String formattedTatValue = overallAvg;
    if (formattedTatValue.contains(':')) {
      final parts = formattedTatValue.split(':');
      if (parts.length == 2) {
        formattedTatValue = '${parts[0]}h${parts[1]}m';
      }
    }

    final tripLabel = _rangeLabel(
        viewModel.tripFilter, viewModel.tripFromDate, viewModel.tripToDate);
    final tatLabel = _rangeLabel(
        viewModel.tatFilter, viewModel.tatFromDate, viewModel.tatToDate);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- TRIP SUMMARY CARD ---
          Expanded(
            child: _StatCard(
              isLoading: viewModel.isTripLoading,
              icon: SvgPicture.asset(
                'assets/images/dash_trip_summary_icon.svg',
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                    AppColors.kTealGreen, BlendMode.srcIn),
              ),
              title: 'Trip Summary',
              value: totalTrips.toString(),
              subtitle: 'Total trips $tripLabel',
              onInfoTap: () {
                showDialog(
                  context: context,
                  builder: (context) => TripSummaryDialog(
                    totalTrips: totalTrips,
                    outboundTotal: outboundTrips,
                    outboundSo: outboundSo,
                    outboundSto: outboundSto,
                    inboundTotal: inboundTrips,
                    inboundPo: inboundPo,
                    inboundSto: inboundSto,
                    selectedFilter: tripLabel,
                  ),
                );
              },
              onCalendarTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => DailyCalendarRangeDialog(
                    title: 'Trip Summary Filter',
                    initialSelection: viewModel.tripFilter,
                    initialFromDate: viewModel.tripFromDate,
                    initialToDate: viewModel.tripToDate,
                    onApply: (label, fromDate, toDate) {
                      viewModel.updateTripFilter(
                          viewModel.currentTenantCode, label, fromDate, toDate);
                    },
                  ),
                );
              },
              footer: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText.tiny('Outbound ', fontSize: 9),
                    CommonText.small(outboundTrips.toString(),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kTextDark),
                    const SizedBox(width: 5),
                    const SizedBox(
                      height: 12,
                      child: VerticalDivider(
                          color: Colors.grey, thickness: 1, width: 1),
                    ),
                    const SizedBox(width: 5),
                    CommonText.tiny('Inbound ', fontSize: 9),
                    CommonText.small(inboundTrips.toString(),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kTextDark),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // --- TAT SUMMARY CARD ---
          Expanded(
            child: _StatCard(
              isLoading: viewModel.isTatLoading,
              icon: SvgPicture.asset(
                'assets/images/dash_tat_summary_icon.svg',
                width: 18,
                height: 18,
                colorFilter:
                const ColorFilter.mode(AppColors.kPurple, BlendMode.srcIn),
              ),
              title: 'TAT Summary',
              value: formattedTatValue,
              subtitle: 'Avg turn around time',
              onInfoTap: () {
                showDialog(
                    context: context,
                    builder: (context) => TatSummaryDialog(
                      outMin: outMin,
                      outMax: outMax,
                      outAvg: outAvg,
                      inMin: inMin,
                      inMax: inMax,
                      inAvg: inAvg,
                      overallAvg: overallAvg,
                      gaugeProgress: 0.55,
                      selectedFilter: tatLabel,
                    ));
              },
              onCalendarTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => DailyCalendarRangeDialog(
                    title: 'TAT Summary Filter',
                    initialSelection: viewModel.tatFilter,
                    initialFromDate: viewModel.tatFromDate,
                    initialToDate: viewModel.tatToDate,
                    onApply: (label, fromDate, toDate) {
                      viewModel.updateTatFilter(
                          viewModel.currentTenantCode, label, fromDate, toDate);
                    },
                  ),
                );
              },
              footer: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.55,
                  minHeight: 6,
                  backgroundColor: AppColors.kPurple.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation(AppColors.kPurple),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;
  final String subtitle;
  final Widget footer;
  final VoidCallback onInfoTap;
  final VoidCallback onCalendarTap;
  final bool isLoading;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.footer,
    required this.onInfoTap,
    required this.onCalendarTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            children: [
              icon,
              const SizedBox(width: 8),
              Expanded(
                child: CommonText(
                  title,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF131754),
                ),
              ),
              InkWell(
                onTap: onCalendarTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF0FA),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.headerBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else ...[
            // VALUE ROW (Centered)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonText(
                  value,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF131754),
                ),
                const SizedBox(width: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onInfoTap,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.kPrimaryBlue,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 2),

            // SUBTITLE: single line, scales down so "Last 30 days" can't wrap
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CommonText.small(
                  subtitle,
                  fontSize: 10,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],

          const Spacer(),
          const SizedBox(height: 12),
          footer,
        ],
      ),
    );
  }
}