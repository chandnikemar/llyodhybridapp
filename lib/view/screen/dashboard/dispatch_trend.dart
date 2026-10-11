import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utilities/app_colors.dart';
import '../../../utilities/common_dialog.dart';
import '../../../utilities/common_text.dart';

import '../../../view_model/home_dashboard_view_model.dart';
import 'dispatch_trend_detail_screen.dart';

/// 2614.98 -> "2,614.98" (same format as the web view)
final NumberFormat _tonnageFmt = NumberFormat('#,##0.00');
String formatTonnage(double v) => _tonnageFmt.format(v);

// ---------- Hourly dispatch trend chart ----------
class DispatchTrendCard extends StatefulWidget {
  const DispatchTrendCard({super.key});

  @override
  State<DispatchTrendCard> createState() => DispatchTrendCardState();
}

class DispatchTrendCardState extends State<DispatchTrendCard> {
  int _tabIndex = 0; // 0: Line, 1: Bar, 2: Table
  bool _isBarTrips = true; // Toggle for Bar Chart: Trips vs Tonnage
  DateTime _displayDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardReportViewModel>();
    String formattedDate =
        "${_displayDate.day.toString().padLeft(2, '0')}-${_displayDate.month.toString().padLeft(2, '0')}-${_displayDate.year}";

    // 1. DATA LISTS
    List<double> totalTripsList = [];
    List<double> totalTonnageList = [];

    // Stacked Bar Data
    List<double> soTripsList = [];
    List<double> stoTripsList = [];
    List<double> soTonnageList = [];
    List<double> stoTonnageList = [];

    List<String> hoursList = [];

    double maxTrips = 0;
    double maxTonnage = 0;

    // 2. PARSE DATA DYNAMICALLY
    if (viewModel.hourlySummaryResponse != null) {
      for (var item in viewModel.hourlySummaryResponse!) {
        // The API's own 'Total' row is skipped; the total is computed from
        // the hourly rows in _buildTable so it always matches what is shown.
        if (item.hour == 'Total' || item.hour == null) continue;

        double soTrips = (item.soTrips ?? 0).toDouble();
        double stoTrips = (item.stoTrips ?? 0).toDouble();
        double soTonnage = (item.soTonnage ?? 0).toDouble();
        double stoTonnage = (item.stoTonnage ?? 0).toDouble();

        double totalTrips = soTrips + stoTrips;
        double totalTonnage = soTonnage + stoTonnage;

        soTripsList.add(soTrips);
        stoTripsList.add(stoTrips);
        soTonnageList.add(soTonnage);
        stoTonnageList.add(stoTonnage);

        totalTripsList.add(totalTrips);
        totalTonnageList.add(totalTonnage);
        hoursList.add(item.hour!);

        if (totalTrips > maxTrips) maxTrips = totalTrips;
        if (totalTonnage > maxTonnage) maxTonnage = totalTonnage;
      }
    }

    // Default empty state
    if (totalTripsList.isEmpty) {
      totalTripsList = List.filled(24, 0.0);
      totalTonnageList = List.filled(24, 0.0);
      soTripsList = List.filled(24, 0.0);
      stoTripsList = List.filled(24, 0.0);
      soTonnageList = List.filled(24, 0.0);
      stoTonnageList = List.filled(24, 0.0);
      hoursList = List.generate(24, (i) => (i + 1).toString().padLeft(2, '0'));
    }

    // 3. SCALE CALCULATIONS
    double maxTripsScale = ((maxTrips * 1.2) / 10).ceil() * 10.0;
    if (maxTripsScale < 10) maxTripsScale = 10.0;

    double maxTonnageScale = ((maxTonnage * 1.2) / 500).ceil() * 500.0;
    if (maxTonnageScale < 500) maxTonnageScale = 500.0;

    double scaleRatio = maxTripsScale / maxTonnageScale;
    List<double> scaledTonnageList =
    totalTonnageList.map((t) => t * scaleRatio).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _ChartTab(
                      label: 'Line Chart',
                      selected: _tabIndex == 0,
                      onTap: () => setState(() => _tabIndex = 0)),
                  const SizedBox(width: 10),
                  _ChartTab(
                      label: 'Bar Chart',
                      selected: _tabIndex == 1,
                      onTap: () => setState(() => _tabIndex = 1)),
                  const SizedBox(width: 10),
                  _ChartTab(
                      label: 'Table',
                      selected: _tabIndex == 2,
                      onTap: () => setState(() => _tabIndex = 2)),
                ],
              ),

              // CALENDAR & ROTATE ICONS WITH DATE BELOW
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => DateRangeFilterDialog(
                              title: 'Dispatch Trend Date',
                              showSingleCalendar: true,
                              initialDate: _displayDate,
                              onApply: (label, fromDate, toDate) {
                                setState(() {
                                  _displayDate = DateTime.parse(fromDate);
                                });
                                viewModel.updateHourlyFilter(
                                    viewModel.currentTenantCode,
                                    label,
                                    fromDate,
                                    toDate);
                              },
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAF0FA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: AppColors.kPrimaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DispatchTrendDetailScreen(
                                displayDate: formattedDate,
                                tripsList: totalTripsList,
                                tonnageList: totalTonnageList,
                                soTripsList: soTripsList,
                                stoTripsList: stoTripsList,
                                soTonnageList: soTonnageList,
                                stoTonnageList: stoTonnageList,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF4FF),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/dash_hourly_dispatch_rotate_icon.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CommonText.small(formattedDate,
                      fontSize: 10, color: const Color(0xFF131754)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 4. DYNAMIC LEGEND & TOGGLE
          _tabIndex == 1
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _ToggleBtn(
                      label: 'Trips',
                      isSelected: _isBarTrips,
                      isLeft: true,
                      onTap: () => setState(() => _isBarTrips = true)),
                  _ToggleBtn(
                      label: 'Tonnage',
                      isSelected: !_isBarTrips,
                      isLeft: false,
                      onTap: () => setState(() => _isBarTrips = false)),
                ],
              ),
              Row(
                children: const [
                  _LegendDot(color: AppColors.kOrange, label: 'SO Trips'),
                  SizedBox(width: 10),
                  _LegendDot(
                      color: AppColors.kPrimaryBlue, label: 'STO Trips'),
                ],
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              _LegendDot(color: AppColors.kOrange, label: 'Total Trips'),
              SizedBox(width: 14),
              _LegendDot(
                  color: AppColors.kPrimaryBlue, label: 'Total Tonnage'),
            ],
          ),

          const SizedBox(height: 8),

          // 5. SHOW LOADER OR CHARTS
          SizedBox(
            height: 220,
            child: viewModel.isHourlyLoading
                ? const Center(child: CircularProgressIndicator())
                : _tabIndex == 0
                ? _buildLineChart(totalTripsList, scaledTonnageList,
                hoursList, maxTripsScale, scaleRatio)
                : _tabIndex == 1
                ? _buildBarChart(
                _isBarTrips ? soTripsList : soTonnageList,
                _isBarTrips ? stoTripsList : stoTonnageList,
                hoursList,
                _isBarTrips ? maxTripsScale : maxTonnageScale,
                _isBarTrips)
                : _buildTable(
                totalTripsList, totalTonnageList, hoursList),
          ),
        ],
      ),
    );
  }

  // ---------- LINE CHART ----------
  Widget _buildLineChart(List<double> trips, List<double> scaledTonnage,
      List<String> hours, double maxY, double scaleRatio) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white,
            tooltipRoundedRadius: 8,
            tooltipBorder:
            const BorderSide(color: AppColors.kCardBorder, width: 1),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final isTrips = touchedSpot.barIndex == 0;
                if (isTrips) {
                  return LineTooltipItem(
                      'Trips: ${touchedSpot.y.toInt()}',
                      const TextStyle(
                          color: AppColors.kOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12));
                } else {
                  double realTonnage = touchedSpot.y / scaleRatio;
                  return LineTooltipItem(
                      'Tonnage: ${formatTonnage(realTonnage)}',
                      const TextStyle(
                          color: AppColors.kPrimaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12));
                }
              }).toList();
            },
          ),
        ),
        minX: 0,
        maxX: (trips.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (v) =>
              FlLine(color: AppColors.kCardBorder, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: maxY / 5,
              getTitlesWidget: (v, meta) {
                if (v == 0 || v == maxY) return const SizedBox();
                double realTonnage = v / scaleRatio;
                return Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: CommonText.tiny(realTonnage.toStringAsFixed(0),
                      fontSize: 9, color: AppColors.kPrimaryBlue),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: maxY / 5,
              getTitlesWidget: (v, meta) {
                if (v == 0 || v == maxY) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: CommonText.tiny(v.toInt().toString(),
                      fontSize: 9, color: AppColors.kOrange),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (v, meta) {
                int idx = v.toInt();
                if (idx >= 0 && idx < hours.length) {
                  String hourLabel = int.parse(hours[idx]).toString();

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    angle: -0.78,
                    space: 4,
                    child: CommonText.tiny(hourLabel, fontSize: 9),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        lineBarsData: [
          _lineBar(trips, AppColors.kOrange),
          _lineBar(scaledTonnage, AppColors.kPrimaryBlue),
        ],
      ),
    );
  }

  LineChartBarData _lineBar(List<double> data, Color color) {
    return LineChartBarData(
      spots: [
        for (int i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i])
      ],
      isCurved: true,
      curveSmoothness: 0.25,
      color: color,
      barWidth: 2,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 2, color: Colors.white, strokeWidth: 1.5, strokeColor: color),
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  // ---------- STACKED BAR CHART ----------
  Widget _buildBarChart(List<double> soData, List<double> stoData,
      List<String> hours, double maxY, bool isTrips) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.white,
            tooltipRoundedRadius: 8,
            tooltipBorder:
            const BorderSide(color: AppColors.kCardBorder, width: 1),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              double soVal = soData[groupIndex];
              double stoVal = stoData[groupIndex];
              double total = soVal + stoVal;

              return BarTooltipItem(
                'Hour ${int.parse(hours[groupIndex])}\n',
                const TextStyle(
                    color: AppColors.kTextDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                children: [
                  TextSpan(
                    text:
                    'SO: ${isTrips ? soVal.toInt() : formatTonnage(soVal)}\n',
                    style: const TextStyle(
                        color: AppColors.kOrange,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                  TextSpan(
                    text:
                    'STO: ${isTrips ? stoVal.toInt() : formatTonnage(stoVal)}\n',
                    style: const TextStyle(
                        color: AppColors.kPrimaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                  TextSpan(
                    text:
                    'Total: ${isTrips ? total.toInt() : formatTonnage(total)}',
                    style: const TextStyle(
                        color: AppColors.kTextGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 11),
                  ),
                ],
              );
            },
          ),
        ),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (v) =>
              FlLine(color: AppColors.kCardBorder, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: maxY / 5,
              getTitlesWidget: (v, meta) {
                if (v == 0 || v == maxY) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: CommonText.tiny(v.toInt().toString(),
                      fontSize: 9, color: AppColors.kTextGrey),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (v, meta) {
                int idx = v.toInt();
                if (idx >= 0 && idx < hours.length) {
                  String hourLabel = int.parse(hours[idx]).toString();

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    angle: -0.78,
                    space: 4,
                    child: CommonText.tiny(hourLabel, fontSize: 9),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        barGroups: [
          for (int i = 0; i < soData.length; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                  toY: soData[i] + stoData[i],
                  width: 8,
                  borderRadius: BorderRadius.circular(2),
                  rodStackItems: [
                    BarChartRodStackItem(0, soData[i], AppColors.kOrange),
                    BarChartRodStackItem(soData[i], soData[i] + stoData[i],
                        AppColors.kPrimaryBlue),
                  ]),
            ]),
        ],
      ),
    );
  }

  // ---------- TABLE (with pinned Total row) ----------
  Widget _buildTable(
      List<double> trips, List<double> rawTonnage, List<String> hours) {
    // Sum raw values; round only when displaying.
    final double sumTrips = trips.fold(0.0, (a, b) => a + b);
    final double sumTonnage = rawTonnage.fold(0.0, (a, b) => a + b);

    return Column(
      children: [
        // Scrolling hourly rows
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: trips.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.kCardBorder),
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CommonText.small('${hours[i]}:00', fontSize: 11),
                    ),
                    Expanded(
                      flex: 3,
                      child: CommonText.small(
                        'Trips: ${trips[i].toInt()}',
                        fontSize: 11,
                        color: AppColors.kOrange,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: CommonText.small(
                        'Tonnage: ${formatTonnage(rawTonnage[i])}',
                        fontSize: 11,
                        color: AppColors.kPrimaryBlue,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Pinned Total row (stays visible while the list scrolls)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFF0F4F8),
            border: Border(
              top: BorderSide(color: Color(0xFFCBD2DC), width: 1.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CommonText.small(
                  'Total',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextDark,
                ),
              ),
              Expanded(
                flex: 3,
                child: CommonText.small(
                  'Trips: ${sumTrips.toInt()}',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kOrange,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 4,
                child: CommonText.small(
                  'Tonnage: ${formatTonnage(sumTonnage)}',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kPrimaryBlue,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------- HELPER WIDGETS ----------

class _ChartTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChartTab(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CommonText(
                  label,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color:
                  selected ? AppColors.kPrimaryBlue : AppColors.kTextGrey,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                decoration: BoxDecoration(
                  color: selected ? AppColors.kPrimaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        CommonText.small(label, fontSize: 10),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLeft;

  const _ToggleBtn(
      {required this.label,
        required this.isSelected,
        required this.onTap,
        required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryBlue : Colors.white,
          border: Border.all(color: AppColors.kPrimaryBlue),
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(4) : Radius.zero,
            right: !isLeft ? const Radius.circular(4) : Radius.zero,
          ),
        ),
        child: CommonText.small(
          label,
          fontSize: 10,
          color: isSelected ? Colors.white : AppColors.kPrimaryBlue,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }
}