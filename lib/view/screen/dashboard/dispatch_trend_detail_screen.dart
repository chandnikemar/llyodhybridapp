import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../utilities/app_colors.dart';
import '../../../utilities/common_text.dart';

final NumberFormat _tonnageFmt = NumberFormat('#,##0.00');
String _fmt(double v) => _tonnageFmt.format(v); // 2614.98 -> "2,614.98"

class DispatchTrendDetailScreen extends StatefulWidget {
  final String displayDate;
  final List<double> tripsList;
  final List<double> tonnageList;
  final List<double> soTripsList;
  final List<double> stoTripsList;
  final List<double> soTonnageList;
  final List<double> stoTonnageList;

  const DispatchTrendDetailScreen({
    super.key,
    required this.displayDate,
    required this.tripsList,
    required this.tonnageList,
    required this.soTripsList,
    required this.stoTripsList,
    required this.soTonnageList,
    required this.stoTonnageList,
  });

  @override
  State<DispatchTrendDetailScreen> createState() =>
      _DispatchTrendDetailScreenState();
}

class _DispatchTrendDetailScreenState extends State<DispatchTrendDetailScreen> {
  int _tabIndex = 0; // 0: Line, 1: Bar, 2: Table
  bool _isBarTrips = true; // Toggle for Bar Chart: Trips vs Tonnage

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  // Hours are shown as 01..24 (same as the web view)
  String _hourLabel(int idx) => (idx + 1).toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    // Fallback if lists are empty
    final trips =
    widget.tripsList.isEmpty ? List.filled(24, 0.0) : widget.tripsList;
    final tonnage =
    widget.tonnageList.isEmpty ? List.filled(24, 0.0) : widget.tonnageList;
    final soTrips =
    widget.soTripsList.isEmpty ? List.filled(24, 0.0) : widget.soTripsList;
    final stoTrips = widget.stoTripsList.isEmpty
        ? List.filled(24, 0.0)
        : widget.stoTripsList;
    final soTonnage = widget.soTonnageList.isEmpty
        ? List.filled(24, 0.0)
        : widget.soTonnageList;
    final stoTonnage = widget.stoTonnageList.isEmpty
        ? List.filled(24, 0.0)
        : widget.stoTonnageList;

    // Scale calculations
    double maxTrips =
    trips.fold(0.0, (prev, element) => element > prev ? element : prev);
    double maxTonnage =
    tonnage.fold(0.0, (prev, element) => element > prev ? element : prev);

    double maxTripsScale = ((maxTrips * 1.2) / 10).ceil() * 10.0;
    if (maxTripsScale < 10) maxTripsScale = 10.0;

    double maxTonnageScale = ((maxTonnage * 1.2) / 500).ceil() * 500.0;
    if (maxTonnageScale < 500) maxTonnageScale = 500.0;

    double scaleRatio = maxTripsScale / maxTonnageScale;
    List<double> scaledTonnageList =
    tonnage.map((t) => t * scaleRatio).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.kTextDark),
                  ),
                  const SizedBox(width: 10),
                  CommonText.h1(
                      'Hourly Dispatch Trend (${widget.displayDate})',
                      fontSize: 18),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
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
              const SizedBox(height: 12),
              _buildTabsAndLegend(),
              const SizedBox(height: 12),

              // Chart / table fills the remaining landscape height
              Expanded(
                child: _tabIndex == 0
                    ? _buildLineChart(
                    trips, scaledTonnageList, maxTripsScale, scaleRatio)
                    : _tabIndex == 1
                    ? _buildBarChart(
                    _isBarTrips ? soTrips : soTonnage,
                    _isBarTrips ? stoTrips : stoTonnage,
                    _isBarTrips ? maxTripsScale : maxTonnageScale,
                    _isBarTrips)
                    : _buildTable(trips, tonnage, soTrips, stoTrips,
                    soTonnage, stoTonnage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabsAndLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _ChartTab(
                label: 'Line Chart',
                selected: _tabIndex == 0,
                onTap: () => setState(() => _tabIndex = 0)),
            const SizedBox(width: 16),
            _ChartTab(
                label: 'Bar Chart',
                selected: _tabIndex == 1,
                onTap: () => setState(() => _tabIndex = 1)),
            const SizedBox(width: 16),
            _ChartTab(
                label: 'Table',
                selected: _tabIndex == 2,
                onTap: () => setState(() => _tabIndex = 2)),
          ],
        ),
        if (_tabIndex == 0)
          Row(
            children: const [
              _LegendDot(color: AppColors.kOrange, label: 'Total Trips'),
              SizedBox(width: 12),
              _LegendDot(
                  color: AppColors.kPrimaryBlue, label: 'Total Tonnage'),
            ],
          )
        else if (_tabIndex == 1)
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
              const SizedBox(width: 16),
              _LegendDot(
                  color: AppColors.kOrange,
                  label: _isBarTrips ? 'SO Trips' : 'SO Tonnage'),
              const SizedBox(width: 10),
              _LegendDot(
                  color: AppColors.kPrimaryBlue,
                  label: _isBarTrips ? 'STO Trips' : 'STO Tonnage'),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  // ---------- LINE CHART ----------
  Widget _buildLineChart(List<double> trips, List<double> scaledTonnage,
      double maxY, double scaleRatio) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (v) =>
              FlLine(color: AppColors.kCardBorder, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (trips.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        titlesData: FlTitlesData(
          topTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              interval: maxY / 4,
              getTitlesWidget: (v, meta) {
                double realTonnage = v / scaleRatio;
                return Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: CommonText.tiny(realTonnage.toStringAsFixed(2),
                      fontSize: 9, color: AppColors.kPrimaryBlue),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: maxY / 4,
              getTitlesWidget: (v, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: CommonText.tiny(v.toStringAsFixed(2),
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
                if (idx >= 0 && idx < trips.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    angle: -0.78,
                    space: 4,
                    child: CommonText.tiny(_hourLabel(idx), fontSize: 9),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFFE9F2FE),
            tooltipRoundedRadius: 8,
            tooltipBorder:
            const BorderSide(color: AppColors.kCardBorder, width: 1),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                if (spot.barIndex == 0) {
                  return LineTooltipItem(
                    '${_hourLabel(spot.x.toInt())}:00\nTotal Trips: ${spot.y.toInt()} trips',
                    const TextStyle(
                        color: AppColors.kOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  );
                } else {
                  double realTonnage = spot.y / scaleRatio;
                  return LineTooltipItem(
                    'Total Tonnage: ${realTonnage.toStringAsFixed(2)} MT',
                    const TextStyle(
                        color: AppColors.kPrimaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  );
                }
              }).toList();
            },
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
            radius: 2,
            color: Colors.white,
            strokeWidth: 1.5,
            strokeColor: color),
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  // ---------- BAR CHART (stacked, value label on every bar) ----------
  Widget _buildBarChart(
      List<double> soData, List<double> stoData, double maxY, bool isTrips) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Bar width adapts to the screen: ~60% of each hour's slot
        final slot = (constraints.maxWidth - 40) / soData.length;
        final barWidth = (slot * 0.6).clamp(8.0, 24.0);

        String label(double v) =>
            isTrips ? v.toInt().toString() : v.toStringAsFixed(0);

        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            minY: 0,
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY / 4,
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
                  reservedSize: 36,
                  interval: maxY / 4,
                  getTitlesWidget: (v, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: CommonText.tiny(v.toInt().toString(),
                          fontSize: 10, color: AppColors.kTextDark),
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
                    if (idx >= 0 && idx < soData.length) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        angle: -0.78,
                        space: 4,
                        child: CommonText.tiny(_hourLabel(idx), fontSize: 9),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),

            // Permanent value label above each non-zero bar
            // (shown through always-visible, transparent tooltips)
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => Colors.transparent,
                tooltipPadding: EdgeInsets.zero,
                tooltipMargin: 2,
                fitInsideVertically: true,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final total = soData[groupIndex] + stoData[groupIndex];
                  if (total <= 0) return null;
                  return BarTooltipItem(
                    label(total),
                    const TextStyle(
                      color: AppColors.kTextDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),

            barGroups: [
              for (int i = 0; i < soData.length; i++)
                BarChartGroupData(
                  x: i,
                  showingTooltipIndicators:
                  (soData[i] + stoData[i]) > 0 ? [0] : [],
                  barRods: [
                    BarChartRodData(
                      toY: soData[i] + stoData[i],
                      width: barWidth,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3)),
                      rodStackItems: [
                        BarChartRodStackItem(0, soData[i], AppColors.kOrange),
                        BarChartRodStackItem(soData[i], soData[i] + stoData[i],
                            AppColors.kPrimaryBlue),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // ---------- TABLE (same columns as web, sticky header + Total row) ----------
  Widget _buildTable(
      List<double> trips,
      List<double> tonnage,
      List<double> soTrips,
      List<double> stoTrips,
      List<double> soTonnage,
      List<double> stoTonnage,
      ) {
    double sum(List<double> l) => l.fold(0.0, (a, b) => a + b);

    Widget cell(String text,
        {int flex = 2,
          bool bold = false,
          Color? color,
          TextAlign align = TextAlign.right}) {
      return Expanded(
        flex: flex,
        child: Text(
          text,
          textAlign: align,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color ?? AppColors.kTextDark,
          ),
        ),
      );
    }

    Widget header() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFF0F4F8),
          border: Border(bottom: BorderSide(color: AppColors.kCardBorder)),
        ),
        child: Row(
          children: [
            cell('Hour', flex: 1, bold: true, align: TextAlign.left),
            cell('SO Trips', bold: true),
            cell('STO Trips', bold: true),
            cell('SO Tonnage', bold: true),
            cell('STO Tonnage', bold: true),
            cell('Total Trips', bold: true),
            cell('Total Tonnage', bold: true),
          ],
        ),
      );
    }

    return Column(
      children: [
        header(),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: trips.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.kCardBorder),
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    cell(_hourLabel(i),
                        flex: 1, bold: true, align: TextAlign.left),
                    cell(soTrips[i].toInt().toString()),
                    cell(stoTrips[i].toInt().toString()),
                    cell(_fmt(soTonnage[i])),
                    cell(_fmt(stoTonnage[i])),
                    cell(trips[i].toInt().toString(),
                        bold: true, color: AppColors.kOrange),
                    cell(_fmt(tonnage[i]),
                        bold: true, color: AppColors.kPrimaryBlue),
                  ],
                ),
              );
            },
          ),
        ),

        // Pinned Total row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFF0F4F8),
            border: Border(
              top: BorderSide(color: Color(0xFFCBD2DC), width: 1.5),
            ),
          ),
          child: Row(
            children: [
              cell('Total', flex: 1, bold: true, align: TextAlign.left),
              cell(sum(soTrips).toInt().toString(), bold: true),
              cell(sum(stoTrips).toInt().toString(), bold: true),
              cell(_fmt(sum(soTonnage)), bold: true),
              cell(_fmt(sum(stoTonnage)), bold: true),
              cell(sum(trips).toInt().toString(),
                  bold: true, color: AppColors.kOrange),
              cell(_fmt(sum(tonnage)),
                  bold: true, color: AppColors.kPrimaryBlue),
            ],
          ),
        ),
      ],
    );
  }
}

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
      child: Column(
        children: [
          CommonText(
            label,
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? AppColors.kPrimaryBlue : AppColors.kTextGrey,
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 50,
            color: selected ? AppColors.kPrimaryBlue : Colors.transparent,
          ),
        ],
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
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        CommonText.small(label, fontSize: 11),
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