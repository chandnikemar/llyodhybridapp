import 'dart:math';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/mainnavigation/menu_model.dart';
import '../view/screen/login_screen.dart';
import 'common.dart';

class DateRangeFilterDialog extends StatefulWidget {
  final String title;
  final bool showSingleCalendar;
  final bool showPredefinedRanges;
  final bool showCustomRange;
  final DateTime? initialDate; // <--- ADD THIS
  final Function(String, String, String) onApply;

  const DateRangeFilterDialog({
    super.key,
    required this.title,
    this.showSingleCalendar = false,
    this.showPredefinedRanges = true,
    this.showCustomRange = true,
    this.initialDate, // <--- ADD THIS
    required this.onApply,
  });

  @override
  State<DateRangeFilterDialog> createState() => _DateRangeFilterDialogState();
}

class _DateRangeFilterDialogState extends State<DateRangeFilterDialog> {
  String _selectedRangeLabel = 'Today';
  late DateTime _selectedDate; // <--- CHANGE TO LATE

  @override
  void initState() {
    super.initState();
    // Initialize with passed date or fallback to today
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  final List<String> _ranges = [
    'Today',
    'Yesterday',
    'Last 7 days',
    'Last 30 days'
  ];

  // Helper to format Date to "yyyy-MM-dd HH:mm:ss"
  String _formatDate(DateTime date, {bool isEndOfDay = false}) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final time = isEndOfDay ? "23:59:59" : "00:00:00";
    return "$y-$m-$d $time";
  }

  void _handleApply() {
    String fromDateStr;
    String toDateStr;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (widget.showSingleCalendar || _selectedRangeLabel == 'Custom') {
      fromDateStr = _formatDate(_selectedDate, isEndOfDay: false);
      toDateStr = _formatDate(_selectedDate, isEndOfDay: true);
    } else {
      switch (_selectedRangeLabel) {
        case 'Yesterday':
          final yesterday = today.subtract(const Duration(days: 1));
          fromDateStr = _formatDate(yesterday, isEndOfDay: false);
          toDateStr = _formatDate(yesterday, isEndOfDay: true);
          break;
        case 'Last 7 days':
          final last7 = today.subtract(const Duration(days: 7));
          fromDateStr = _formatDate(last7, isEndOfDay: false);
          toDateStr = _formatDate(today, isEndOfDay: true);
          break;
        case 'Last 30 days':
          final last30 = today.subtract(const Duration(days: 30));
          fromDateStr = _formatDate(last30, isEndOfDay: false);
          toDateStr = _formatDate(today, isEndOfDay: true);
          break;
        case 'Today':
        default:
          fromDateStr = _formatDate(today, isEndOfDay: false);
          toDateStr = _formatDate(today, isEndOfDay: true);
          break;
      }
    }

    widget.onApply(_selectedRangeLabel, fromDateStr, toDateStr);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Decorative handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF131754))),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Close',
                        style: TextStyle(color: Color(0xFF131754))),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (widget.showSingleCalendar) ...[
                _buildCalendar(),
              ] else ...[
                if (widget.showPredefinedRanges) _buildPredefinedGrid(),
                if (widget.showCustomRange)
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text('Custom range',
                          style: TextStyle(
                              color: Color(0xFF131754),
                              fontWeight: FontWeight.w600)),
                      onExpansionChanged: (expanded) {
                        if (expanded) {
                          setState(() => _selectedRangeLabel = 'Custom');
                        }
                      },
                      children: [_buildCalendar()],
                    ),
                  ),
              ],

              const SizedBox(height: 20),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        _selectedRangeLabel = 'Today';
                        _selectedDate = DateTime.now();
                      }),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.black54)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B65A7),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Apply Filters',
                          style: TextStyle(color: Colors.white)),
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

  Widget _buildPredefinedGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _ranges.length,
      itemBuilder: (context, index) {
        final range = _ranges[index];
        final isSelected = _selectedRangeLabel == range;
        return InkWell(
          onTap: () => setState(() => _selectedRangeLabel = range),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEAF0FA) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  range,
                  style: TextStyle(
                    color:
                    isSelected ? const Color(0xFF1B65A7) : Colors.black87,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, size: 16, color: Color(0xFF1B65A7)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 250,
      child: CalendarDatePicker(
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        onDateChanged: (date) {
          setState(() {
            _selectedDate = date;
            if (!widget.showSingleCalendar) _selectedRangeLabel = 'Custom';
          });
        },
      ),
    );
  }
}



class TripSummaryDialog extends StatelessWidget {
  final int totalTrips;
  final int outboundTotal;
  final int outboundSo;
  final int outboundSto;
  final int inboundTotal;
  final int inboundPo;
  final int inboundSto;
  final String selectedFilter;

  const TripSummaryDialog({
    super.key,
    required this.totalTrips,
    required this.outboundTotal,
    required this.outboundSo,
    required this.outboundSto,
    required this.inboundTotal,
    required this.inboundPo,
    required this.inboundSto,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            // Header: the filter text is Expanded so it can never overflow
            Row(
              children: [
                const Text('Trip Summary',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF131754))),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedFilter,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B65A7)),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Close',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF131754))),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildTripRow(
              iconBgColor: const Color(0xFF009688).withOpacity(0.15),
              iconColor: const Color(0xFF009688),
              icon: Icons.local_shipping,
              title: 'Outbound',
              mainValue: outboundTotal.toString(),
              subLabel1: 'SO',
              subVal1: outboundSo.toString(),
              subLabel2: 'STO',
              subVal2: outboundSto.toString(),
            ),
            const SizedBox(height: 12),

            _buildTripRow(
              iconBgColor: const Color(0xFF1B65A7).withOpacity(0.15),
              iconColor: const Color(0xFF1B65A7),
              icon: Icons.local_shipping,
              title: 'Inbound',
              mainValue: inboundTotal.toString(),
              subLabel1: 'PO',
              subVal1: inboundPo.toString(),
              subLabel2: 'STO',
              subVal2: inboundSto.toString(),
            ),

            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '$totalTrips ',
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF131754))),
                  const TextSpan(
                      text: 'Trips',
                      style: TextStyle(fontSize: 20, color: Color(0xFF131754))),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTripRow({
    required Color iconBgColor,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String mainValue,
    required String subLabel1,
    required String subVal1,
    required String subLabel2,
    required String subVal2,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 25, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn(mainValue, title, isMain: true),
                _buildStatColumn(subVal1, subLabel1),
                _buildStatColumn(subVal2, subLabel2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool isMain = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isMain ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF131754),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: isMain ? 12 : 11,
            color: const Color(0xFF4A5671),
            fontWeight: isMain ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class TatSummaryDialog extends StatelessWidget {
  final String outMin;
  final String outMax;
  final String outAvg;
  final String inMin;
  final String inMax;
  final String inAvg;
  final String overallAvg;
  final double gaugeProgress;
  final String selectedFilter;

  const TatSummaryDialog({
    super.key,
    required this.outMin,
    required this.outMax,
    required this.outAvg,
    required this.inMin,
    required this.inMax,
    required this.inAvg,
    required this.overallAvg,
    required this.gaugeProgress,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Row(
              children: [
                const Text(
                  'TAT Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131754),
                  ),
                ),
                // Flexible chip so long labels shrink instead of overflowing
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4F8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                selectedFilter,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF131754),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 16, color: Color(0xFF1B65A7)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildBadge(
                            'Outbound',
                            const Color(0xFF009688).withOpacity(0.15),
                            const Color(0xFF009688)),
                        const SizedBox(height: 16),
                        _buildTimeRow('Min - ', outMin),
                        const SizedBox(height: 8),
                        _buildTimeRow('Max - ', outMax),
                        const SizedBox(height: 8),
                        _buildTimeRow('Avg - ', outAvg),
                      ],
                    ),
                  ),
                  VerticalDivider(color: Colors.grey.shade300, thickness: 1),
                  Expanded(
                    child: Column(
                      children: [
                        _buildBadge(
                            'Inbound',
                            const Color(0xFF1B65A7).withOpacity(0.15),
                            const Color(0xFF1B65A7)),
                        const SizedBox(height: 16),
                        _buildTimeRow('Min - ', inMin),
                        const SizedBox(height: 8),
                        _buildTimeRow('Max - ', inMax),
                        const SizedBox(height: 8),
                        _buildTimeRow('Avg - ', inAvg),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 60,
                  width: 120,
                  child: CustomPaint(
                    painter: _HalfGaugePainter(
                      progress: gaugeProgress,
                      color: const Color(0xFF1B65A7),
                      backgroundColor: Colors.grey.shade300,
                      strokeWidth: 6.0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -5,
                  child: Text(
                    overallAvg,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_shipping, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String time) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Color(0xFF131754)),
        children: [
          TextSpan(
              text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: time),
        ],
      ),
    );
  }
}

// Custom Painter to draw a 180-degree half circle
class _HalfGaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _HalfGaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()
      ..color = backgroundColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint fgPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Center of the arc is at the bottom middle of the canvas
    Offset center = Offset(size.width / 2, size.height);
    // Radius considers the stroke width so it doesn't clip outside the canvas bounds
    double radius = (size.width / 2) - (strokeWidth / 2);

    Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background arc from 180 degrees (pi) sweeping exactly 180 degrees (pi)
    canvas.drawArc(rect, pi, pi, false, bgPaint);

    // Draw foreground arc based on progress percentage
    double sweepAngle = pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(rect, pi, sweepAngle, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _HalfGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class CalendarPickerDialog extends StatefulWidget {
  final ValueChanged<DateTime> onApply;

  const CalendarPickerDialog({super.key, required this.onApply});

  @override
  State<CalendarPickerDialog> createState() => _CalendarPickerDialogState();
}

class _CalendarPickerDialogState extends State<CalendarPickerDialog> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decorative handle
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),

            // Month Dropdown Mockup (To match UI exactly)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('August , 2026',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF131754))),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF1B65A7)),
                ],
              ),
            ),

            // Calendar
            SizedBox(
              height: 280,
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _selectedDate = DateTime.now()),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Clear',
                        style: TextStyle(color: Colors.black54)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_selectedDate);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B65A7),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Apply Filters',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class MaterialBreakdownDialog extends StatelessWidget {
  // Accept the list directly via constructor
  final List<dynamic> materials; // Use List<MaterialDispatchResponse> if you have the import

  const MaterialBreakdownDialog({
    super.key,
    required this.materials,
  });

  @override
  Widget build(BuildContext context) {
    double totalTonnage = 0.0;
    for (var item in materials) {
      totalTonnage += (item.totalQty ?? 0.0).toDouble();
    }

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Material Breakdown',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131754),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Material List
            Column(
              children: materials.map((material) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildMaterialRow(
                    material.materialName ?? 'Unknown',
                    '${(material.totalQty ?? 0.0).toStringAsFixed(2)} MT',
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Total Section
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${totalTonnage.toStringAsFixed(2)} ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF131754),
                    ),
                  ),
                  const TextSpan(
                    text: 'MT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF131754),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialRow(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5671),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B65A7),
          ),
        ),
      ],
    );
  }
}


// ---------- Open DO Details Dialog ----------

class OpenDoDetailsDialog extends StatelessWidget {
  // Accept the list directly via constructor
  final List<dynamic> doList; // Use List<OpenDoResponse> if you have the import

  const OpenDoDetailsDialog({
    super.key,
    required this.doList,
  });

  @override
  Widget build(BuildContext context) {
    int totalDo = 0;
    for (var item in doList) {
      totalDo += (item.openDoCount as int);
    }

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery Orders',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131754),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Data Rows
            Column(
              children: doList.map((data) {
                return _buildDoRow(
                  data.transactionType ?? 'Unknown',
                  data.openDoCount.toString(),
                  (data.totalPendingQuantity ?? 0.0).toStringAsFixed(2),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Total Section
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$totalDo ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF131754),
                    ),
                  ),
                  const TextSpan(
                    text: 'Total DOs',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF131754),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDoRow(String type, String count, String quantity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FA),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              type,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B65A7),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$count DOs',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5671),
              ),
            ),
          ),
          Text(
            '$quantity MT',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B65A7),
            ),
          ),
        ],
      ),
    );
  }
}


class CalendarRangeDialog extends StatefulWidget {
  final String title;
  final String initialSelection;
  final Function(String label, String fromDate, String toDate) onApply;

  const CalendarRangeDialog({
    super.key,
    required this.title,
    this.initialSelection = 'Today',
    required this.onApply,
  });

  @override
  State<CalendarRangeDialog> createState() => _CalendarRangeDialogState();
}

class _CalendarRangeDialogState extends State<CalendarRangeDialog> {
  late String _selectedRangeLabel;

  // IMPORTANT: This list must perfectly match the labels in _handleApply()
  final List<String> _ranges = [
    'Today',
    'Yesterday',
    'Last 7 days',
    'Last 30 days'
  ];

  @override
  void initState() {
    super.initState();
    _selectedRangeLabel = widget.initialSelection;

    // Ensure initial selection is valid, otherwise default to 'Today'
    if (!_ranges.contains(_selectedRangeLabel)) {
      _selectedRangeLabel = 'Today';
    }
  }

  // Helper to format Date strictly to "yyyy-MM-dd HH:mm:ss"
  String _formatDate(DateTime date, {bool isEndOfDay = false}) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final time = isEndOfDay ? "23:59:59" : "00:00:00";
    return "$y-$m-$d $time";
  }

  void _handleApply() {
    String fromDateStr;
    String toDateStr;

    final now = DateTime.now();
    // Strip time to perfectly calculate midnights
    final today = DateTime(now.year, now.month, now.day);

    switch (_selectedRangeLabel) {
      case 'Yesterday':
        final yesterday = today.subtract(const Duration(days: 1));
        fromDateStr = _formatDate(yesterday, isEndOfDay: false);
        toDateStr = _formatDate(yesterday, isEndOfDay: true);
        break;

      case 'Last 7 days':
        final last7 = today.subtract(const Duration(days: 6));
        fromDateStr = _formatDate(last7, isEndOfDay: false);
        toDateStr = _formatDate(today, isEndOfDay: true);
        break;

      case 'Last 30 days':
        final last30 = today.subtract(const Duration(days: 29));
        fromDateStr = _formatDate(last30, isEndOfDay: false);
        toDateStr = _formatDate(today, isEndOfDay: true);
        break;

      case 'Today':
      default:
        fromDateStr = _formatDate(today, isEndOfDay: false);
        toDateStr = _formatDate(today, isEndOfDay: true);
        break;
    }

    widget.onApply(_selectedRangeLabel, fromDateStr, toDateStr);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent, // Fix for Material 3 tint
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Decorative top drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131754),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE1E3E8), height: 1),
            const SizedBox(height: 16),

            // Predefined Ranges Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5, // Controls the height of the items
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _ranges.length,
              itemBuilder: (context, index) {
                final range = _ranges[index];
                final isSelected = _selectedRangeLabel == range;

                return InkWell(
                  onTap: () => setState(() => _selectedRangeLabel = range),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEAF3FF) : Colors.transparent, // Light blue background
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          range,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? const Color(0xFF1B65A7) : const Color(0xFF4A5671),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check, size: 16, color: Color(0xFF1B65A7)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _selectedRangeLabel = 'Today'; // Resets to default
                    }),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        color: Color(0xFF4A5671),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B65A7),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class DailyCalendarRangeDialog extends StatefulWidget {
  final String title;
  final String initialSelection;
  final String? initialFromDate;
  final String? initialToDate;
  final Function(String label, String fromDate, String toDate) onApply;

  const DailyCalendarRangeDialog({
    super.key,
    required this.title,
    this.initialSelection = 'Today',
    this.initialFromDate,
    this.initialToDate,
    required this.onApply,
  });

  @override
  State<DailyCalendarRangeDialog> createState() =>
      _DailyCalendarRangeDialogState();
}

class _DailyCalendarRangeDialogState extends State<DailyCalendarRangeDialog> {
  late String _selectedRangeLabel;
  bool _isCustomExpanded = false;

  late DateTime _customStartDate;
  late DateTime _customEndDate;

  final List<String> _ranges = [
    'Today',
    'Yesterday',
    'Last 7 days',
    'Last 30 days'
  ];

  @override
  void initState() {
    super.initState();
    _selectedRangeLabel = widget.initialSelection;

    if (!_ranges.contains(_selectedRangeLabel) &&
        _selectedRangeLabel != 'Custom') {
      _selectedRangeLabel = 'Today';
    }

    if (_selectedRangeLabel == 'Custom') {
      _isCustomExpanded = true;
    }

    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    DateTime? strip(String? s) {
      final d = s == null ? null : DateTime.tryParse(s);
      return d == null ? null : DateTime(d.year, d.month, d.day);
    }

    final isCustom = _selectedRangeLabel == 'Custom';
    _customStartDate =
        (isCustom ? strip(widget.initialFromDate) : null) ?? todayDate;
    _customEndDate =
        (isCustom ? strip(widget.initialToDate) : null) ?? todayDate;
  }

  // "yyyy-MM-ddTHH:mm:ss" for API
  String _formatDateForApi(DateTime date, {bool isEndOfDay = false}) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final time = isEndOfDay ? "23:59:59" : "00:00:00";
    return "$y-$m-${d}T$time";
  }

  String _formatDateForUI(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> _pickStartDate() async {
    final today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _customStartDate.isAfter(today) ? today : _customStartDate,
      firstDate: DateTime(2000),
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1B65A7)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked;
        _selectedRangeLabel = 'Custom';
        if (_customEndDate.isBefore(_customStartDate)) {
          _customEndDate = _customStartDate;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _customEndDate.isBefore(_customStartDate)
          ? _customStartDate
          : _customEndDate,
      firstDate: _customStartDate,
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1B65A7)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customEndDate = picked;
        _selectedRangeLabel = 'Custom';
      });
    }
  }

  void _handleApply() {
    String fromDateStr;
    String toDateStr;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_selectedRangeLabel == 'Custom') {
      fromDateStr = _formatDateForApi(_customStartDate, isEndOfDay: false);
      toDateStr = _formatDateForApi(_customEndDate, isEndOfDay: true);
    } else {
      switch (_selectedRangeLabel) {
        case 'Yesterday':
          final yesterday = today.subtract(const Duration(days: 1));
          fromDateStr = _formatDateForApi(yesterday, isEndOfDay: false);
          toDateStr = _formatDateForApi(yesterday, isEndOfDay: true);
          break;
        case 'Last 7 days':
          final last7 = today.subtract(const Duration(days: 6));
          fromDateStr = _formatDateForApi(last7, isEndOfDay: false);
          toDateStr = _formatDateForApi(today, isEndOfDay: true);
          break;
        case 'Last 30 days':
          final last30 = today.subtract(const Duration(days: 29));
          fromDateStr = _formatDateForApi(last30, isEndOfDay: false);
          toDateStr = _formatDateForApi(today, isEndOfDay: true);
          break;
        case 'Today':
        default:
          fromDateStr = _formatDateForApi(today, isEndOfDay: false);
          toDateStr = _formatDateForApi(today, isEndOfDay: true);
          break;
      }
    }

    widget.onApply(_selectedRangeLabel, fromDateStr, toDateStr);
    Navigator.pop(context);
  }

  Widget _dateBox(String label, DateTime date, VoidCallback onTap) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF4A5671))),
          const SizedBox(height: 6),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _formatDateForUI(date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF131754)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: Color(0xFF1B65A7)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF131754),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF131754),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(color: Color(0xFFE1E3E8), height: 1),
              const SizedBox(height: 16),

              // Predefined Ranges Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _ranges.length,
                itemBuilder: (context, index) {
                  final range = _ranges[index];
                  final isSelected = _selectedRangeLabel == range;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRangeLabel = range;
                        _isCustomExpanded = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEAF3FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              range,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected
                                    ? const Color(0xFF1B65A7)
                                    : const Color(0xFF4A5671),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check,
                                size: 16, color: Color(0xFF1B65A7)),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE1E3E8), height: 1),
              const SizedBox(height: 16),

              // Custom Range header
              InkWell(
                onTap: () {
                  setState(() {
                    _isCustomExpanded = !_isCustomExpanded;
                    if (_isCustomExpanded) {
                      _selectedRangeLabel = 'Custom';
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Custom range',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _selectedRangeLabel == 'Custom'
                              ? const Color(0xFF1B65A7)
                              : const Color(0xFF131754),
                        ),
                      ),
                      Icon(
                        _isCustomExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: _selectedRangeLabel == 'Custom'
                            ? const Color(0xFF1B65A7)
                            : const Color(0xFF131754),
                      ),
                    ],
                  ),
                ),
              ),

              if (_isCustomExpanded) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    _dateBox('Start Date', _customStartDate, _pickStartDate),
                    const SizedBox(width: 12),
                    _dateBox('End Date', _customEndDate, _pickEndDate),
                  ],
                ),
              ],

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedRangeLabel = 'Today';
                          _isCustomExpanded = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(0xFF4A5671),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B65A7),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});
  void _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Wipe all user data set during login
    await prefs.remove(Common.userName);
    await prefs.remove(Common.firstName);
    await prefs.remove(Common.lastName);
    await prefs.remove(Common.email);
    await prefs.remove(Common.mobileNumber);
    await prefs.remove(Common.roleName);
    await prefs.remove(Common.isVerified);
    await prefs.remove(Common.jwtToken);
    await prefs.remove(Common.refreshToken);
    await prefs.remove(Common.tenantGroup);
    await prefs.remove(Common.defaultTenantCode);
    await prefs.remove(Common.selectedTenant);
    await prefs.remove(Common.bpCode);
    await prefs.remove(Common.userAccess);
    await prefs.remove(Common.menuAccess);
    await prefs.remove(Common.userTenants);

    await prefs.setBool(Common.isLoggedIn, false);

    // Navigate to LoginScreen using the Global Navigator Key
    // This guarantees it works every time, regardless of what's on the screen
    MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) =>   LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Decorative top drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131754),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE1E3E8), height: 1),
            const SizedBox(height: 20),

            // Dialog Content
            const Text(
              'Are you sure you want to end your session and log out of the application?',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5671),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF4A5671),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleLogout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F), // Standard red for destructive actions
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




  class CommonDateFilterPopup extends StatefulWidget {
  final List<String> filterOptions;
  final String? selectedFilter;
  final DateTime? fromDate;
  final DateTime? toDate;
  final Function(
      String? filter,
      DateTime? fromDate,
      DateTime? toDate,
      ) onApply;

  const CommonDateFilterPopup({
    super.key,
    required this.filterOptions,
    this.selectedFilter,
    this.fromDate,
    this.toDate,
    required this.onApply,
  });

  @override
  State<CommonDateFilterPopup> createState() => _CommonDateFilterPopupState();
}

class _CommonDateFilterPopupState extends State<CommonDateFilterPopup> {
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter;
    // Date range UI removed — fromDate/toDate are no longer collected here.
    // widget.fromDate / widget.toDate are accepted for backward
    // compatibility with callers but are intentionally unused now.
  }

  void clearFilters() {
    setState(() {
      selectedFilter = null;
    });
  }

  void applyFilters() {
    // Date range removed from this dialog — always pass null so existing
    // callers (which still expect a 3-arg callback) keep working without
    // any code changes on their end.
    widget.onApply(
      selectedFilter,
      null,
      null,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Decorative top drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131754),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE1E3E8), height: 1),
            const SizedBox(height: 20),

            // Filter By Dropdown
            const Text(
              "Filter By",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A5671),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE1E3E8)),
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFF4F6F8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  hint: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      "Select a filter",
                      style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                    ),
                  ),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.keyboard_arrow_down, size: 22, color: Color(0xFF4A5671)),
                  ),
                  items: widget.filterOptions.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF131754), fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: clearFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        color: Color(0xFF4A5671),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C6DD0), // App primary blue
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryOrdersFilterPopup extends StatefulWidget {
  final List<String> filterOptions;
  final String? selectedFilter;
  final String? selectedMultiVehicle;

  final Function(
      String? filter,
      String? multiVehicle,
      ) onApply;

  const DeliveryOrdersFilterPopup({
    super.key,
    required this.filterOptions,
    this.selectedFilter,
    this.selectedMultiVehicle,
    required this.onApply,
  });

  @override
  State<DeliveryOrdersFilterPopup> createState() =>
      _DeliveryOrdersFilterPopupState();
}

class _DeliveryOrdersFilterPopupState
    extends State<DeliveryOrdersFilterPopup> {
  String? selectedFilter;
  String? selectedMultiVehicle;

  // Ensure these exact strings match everywhere
  final List<String> multiVehicleOptions = const [
    'ALL',
    'Yes',
    'No',
  ];

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter;

    // Standardize to uppercase 'ALL' to match multiVehicleOptions
    final initialVehicle = widget.selectedMultiVehicle?.toUpperCase();
    if (initialVehicle == 'YES') {
      selectedMultiVehicle = 'Yes';
    } else if (initialVehicle == 'NO') {
      selectedMultiVehicle = 'No';
    } else {
      selectedMultiVehicle = 'ALL';
    }
  }

  void clearFilters() {
    setState(() {
      selectedFilter = null;
      selectedMultiVehicle = 'ALL';
    });
  }

  void applyFilters() {
    widget.onApply(
      selectedFilter,
      selectedMultiVehicle == 'ALL' ? null : selectedMultiVehicle,
    );

    Navigator.pop(context);
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // Safety check: reset to null if value is not present in items
    final bool valueExists = items.contains(value);
    final String? safeValue = valueExists ? value : null;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE1E3E8),
        ),
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFFF4F6F8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          isExpanded: true,
          dropdownColor: Colors.white,
          hint: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              hint,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
            ),
          ),
          icon: const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: Color(0xFF4A5671),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF131754),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HANDLE
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF131754),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF131754),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(
                height: 1,
                color: Color(0xFFE1E3E8),
              ),
              const SizedBox(height: 20),

              // FILTER BY
              const Text(
                'Filter By',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A5671),
                ),
              ),
              const SizedBox(height: 8),

              _buildDropdown(
                hint: 'Select a filter',
                value: selectedFilter,
                items: widget.filterOptions,
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              // MULTI VEHICLE
              const Text(
                'Multi Vehicle',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A5671),
                ),
              ),
              const SizedBox(height: 8),

              _buildDropdown(
                hint: 'Select Multi Vehicle',
                value: selectedMultiVehicle,
                items: multiVehicleOptions,
                onChanged: (value) {
                  setState(() {
                    selectedMultiVehicle = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              // BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: clearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(0xFF4A5671),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C6DD0),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}

///////////////////order filter


class CommonDateOrderFilterPopup extends StatefulWidget {
  final List<String> filterOptions;
  final String? selectedFilter;
  final DateTime? fromDate;
  final DateTime? toDate;

  final Function(
      String? filter,
      DateTime? fromDate,
      DateTime? toDate,
      ) onApply;

  const CommonDateOrderFilterPopup({
    super.key,
    required this.filterOptions,
    this.selectedFilter,
    this.fromDate,
    this.toDate,
    required this.onApply,
  });

  @override
  State<CommonDateOrderFilterPopup> createState() =>
      _CommonDateOrderFilterPopupState();
}

class _CommonDateOrderFilterPopupState
    extends State<CommonDateOrderFilterPopup> {
  String? selectedFilter;

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();

    selectedFilter = widget.selectedFilter;
    fromDate = widget.fromDate ?? DateTime.now();
    toDate = widget.toDate ?? DateTime.now();
  }

  // ------------------------------------------------------------
  // CLEAR FILTERS
  // ------------------------------------------------------------
  void clearFilters() {
    setState(() {
      selectedFilter = null;
      fromDate = null;
      toDate = null;
    });
  }

  // ------------------------------------------------------------
  // SELECT FROM DATE
  // ------------------------------------------------------------
  Future<void> selectFromDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        fromDate = picked;

        // If From Date becomes greater than To Date,
        // clear the To Date.
        if (toDate != null && fromDate!.isAfter(toDate!)) {
          toDate = null;
        }
      });
    }
  }

  // ------------------------------------------------------------
  // SELECT TO DATE
  // ------------------------------------------------------------
  Future<void> selectToDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? fromDate ?? DateTime.now(),
      firstDate: fromDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        toDate = picked;
      });
    }
  }

  // ------------------------------------------------------------
  // FORMAT DATE
  // ------------------------------------------------------------
  String formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ------------------------------------------------------------
  // APPLY FILTERS
  // ------------------------------------------------------------
  void applyFilters() {
    widget.onApply(
      selectedFilter,
      fromDate,
      toDate,
    );

    Navigator.pop(context);
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================================================
            // DRAG HANDLE
            // ==================================================
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ==================================================
            // HEADER
            // ==================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF131754),
                  ),
                ),

                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF131754),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Divider(
              color: Color(0xFFE1E3E8),
              height: 1,
            ),

            const SizedBox(height: 20),

            // ==================================================
            // FILTER BY
            // ==================================================
            const Text(
              "Filter By",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A5671),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE1E3E8),
                ),
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFF4F6F8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  isExpanded: true,
                  dropdownColor: Colors.white,

                  hint: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      "Select a filter",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),

                  icon: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 22,
                      color: Color(0xFF4A5671),
                    ),
                  ),

                  items: widget.filterOptions.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF131754),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // FROM DATE + TO DATE
            // ==================================================
            Row(
              children: [

                // ---------------- FROM DATE ----------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "From Date",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A5671),
                        ),
                      ),

                      const SizedBox(height: 8),

                      InkWell(
                        onTap: selectFromDate,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE1E3E8),
                            ),
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xFFF4F6F8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  formatDate(fromDate),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fromDate == null
                                        ? const Color(0xFF999999)
                                        : const Color(0xFF131754),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Color(0xFF4A5671),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ---------------- TO DATE ----------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "To Date",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A5671),
                        ),
                      ),

                      const SizedBox(height: 8),

                      InkWell(
                        onTap: selectToDate,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE1E3E8),
                            ),
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xFFF4F6F8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  formatDate(toDate),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: toDate == null
                                        ? const Color(0xFF999999)
                                        : const Color(0xFF131754),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Color(0xFF4A5671),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ==================================================
            // ACTION BUTTONS
            // ==================================================
            Row(
              children: [

                // ---------------- CLEAR ----------------
                Expanded(
                  child: OutlinedButton(
                    onPressed: clearFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        color: Color(0xFF4A5671),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // ---------------- APPLY ----------------
                Expanded(
                  child: ElevatedButton(
                    onPressed: applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C6DD0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


///search quick access menu dialog

// Helper class to flatten the nested menu for easy searching
class FlatMenuItem {
  final String title;
  final String route;
  final String iconString;
  final bool isChild;

  FlatMenuItem({
    required this.title,
    required this.route,
    required this.iconString,
    this.isChild = false,
  });
}

class SearchMenuDialog extends StatefulWidget {
  final List<MenuModel> menuItems;
  final Function(String routingUrl) onSelected;
  final IconData Function(String iconString) getIconMapper;

  const SearchMenuDialog({
    super.key,
    required this.menuItems,
    required this.onSelected,
    required this.getIconMapper,
  });

  @override
  State<SearchMenuDialog> createState() => _SearchMenuDialogState();
}

class _SearchMenuDialogState extends State<SearchMenuDialog> {
  final TextEditingController _searchController = TextEditingController();
  final List<FlatMenuItem> _allItems = [];
  List<FlatMenuItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _flattenMenuItems();
  }

  // Flattens parents and children into a single list
  void _flattenMenuItems() {
    for (var parent in widget.menuItems) {
      if (parent.children.isEmpty && parent.routingURL.isNotEmpty) {
        _allItems.add(FlatMenuItem(
          title: parent.displayName,
          route: parent.routingURL,
          iconString: parent.menuIcon,
        ));
      } else {
        for (var child in parent.children) {
          if (child.routingURL.isNotEmpty) {
            _allItems.add(FlatMenuItem(
              title: '${parent.displayName} > ${child.displayName}', // Shows hierarchy
              route: child.routingURL,
              iconString: parent.menuIcon,
              isChild: true,
            ));
          }
        }
      }
    }
    _filteredItems = List.from(_allItems);
  }

  void _filterList(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(_allItems);
      } else {
        _filteredItems = _allItems
            .where((item) =>
            item.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search Input Box
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterList,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search menu...',
                  hintStyle: TextStyle(color: Colors.blue.shade700),
                  prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _filterList('');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search Results List
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                child: Text(
                  'No results found',
                  style:TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.separated(
                itemCount: _filteredItems.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      item.isChild ? Icons.subdirectory_arrow_right : widget.getIconMapper(item.iconString),
                      color: const Color(0xFF1C6DD0),
                      size: 20,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF131754),
                      ),
                    ),
                    onTap: () {
                      widget.onSelected(item.route);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}