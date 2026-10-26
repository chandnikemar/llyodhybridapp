import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/app_colors.dart';
import '../../../utilities/common_text.dart';
import '../../../view_model/home_dashboard_view_model.dart';


// ---------- Expected Vehicles Dialog ----------
class ExpectedVehiclesDialog extends StatelessWidget {
  const ExpectedVehiclesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. WATCH the ViewModel
    final viewModel = context.watch<DashboardReportViewModel>();

    // 2. Initialize maps to hold the parsed counts for each stage
    final Map<String, int> inboundCounts = {
      "Gate In": 0,
      "Tare Weight": 0,
      "Gross Weight": 0,
      "Gate Out": 0,
    };

    final Map<String, int> outboundCounts = {
      "Gate In": 0,
      "Tare Weight": 0,
      "Gross Weight": 0,
      "Gate Out": 0,
    };

    // 3. Parse the API data
    if (viewModel.vehicleQueueResponse != null) {
      for (var item in viewModel.vehicleQueueResponse!) {
        final stage = item.stage ?? '';
        final type = item.transactionType?.toLowerCase() ?? '';
        final count = item.vehicleCount ?? 0;

        if (type == 'inbound') {
          inboundCounts[stage] = (inboundCounts[stage] ?? 0) + count;
        } else if (type == 'outbound') {
          outboundCounts[stage] = (outboundCounts[stage] ?? 0) + count;
        }
      }
    }

    // Helper to generate a TableRow dynamically using the parsed maps
    TableRow buildRow(String stageName) {
      int outb = outboundCounts[stageName] ?? 0;
      int inb = inboundCounts[stageName] ?? 0;
      int total = outb + inb;

      return _tableRow(values: [
        stageName,
        outb.toString(),
        inb.toString(),
        total.toString()
      ]);
    }

    final media = MediaQuery.of(context);
    final bool isLandscape = media.orientation == Orientation.landscape;

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 80 : 20,
        vertical: isLandscape ? 12 : 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        // Never taller than the visible screen (minus keyboard/safe areas)
        constraints: BoxConstraints(
          maxHeight: media.size.height - media.padding.vertical - 24,
          maxWidth: 520,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header stays fixed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expected Vehicles",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF131754),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Body scrolls when there isn't enough height
              Flexible(
                child: SingleChildScrollView(
                  child: viewModel.isQueueLoading
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : Table(
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(2.6),
                      1: FlexColumnWidth(2.0),
                      2: FlexColumnWidth(2.0),
                      3: FlexColumnWidth(1.5),
                    },
                    children: [
                      _tableRow(
                        isHeader: true,
                        values: [
                          "Stages",
                          "Outbound",
                          "Inbound",
                          "Total"
                        ],
                      ),
                      buildRow("Gate In"),
                      buildRow("Tare Weight"),
                      buildRow("Gross Weight"),
                      buildRow("Gate Out"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _tableRow({
    required List<String> values,
    bool isHeader = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xffEAF3FF) : Colors.transparent,
      ),
      children: values.map((text) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 4, // Reduced from 8 to prevent text cutoffs
          ),

          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
                color: const Color(0xFF131754),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------- Expected vehicles by stage stepper ----------
class StageStepper extends StatelessWidget {
  const StageStepper({super.key});

  static const stages = [
    'Gate In',
    'Tare Weight',
    'Gross Weight',
    'Gate Out',
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardReportViewModel>();

    // Calculate total count for each stage
    final Map<String, int> stageCounts = {
      'Gate In': 0,
      'Tare Weight': 0,
      'Gross Weight': 0,
      'Gate Out': 0,
    };

    if (viewModel.vehicleQueueResponse != null) {
      for (var item in viewModel.vehicleQueueResponse!) {
        final stage = item.stage ?? '';
        final count = item.vehicleCount ?? 0;

        if (stageCounts.containsKey(stage)) {
          stageCounts[stage] = stageCounts[stage]! + count;
        }
      }
    }

    return Row(
      children: [
        for (int i = 0; i < stages.length; i++) ...[
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == 0
                      ? const Color(0xFFEAF0FA)
                      : const Color(0xFFEFF1F5),
                ),
                alignment: Alignment.center,
                child: CommonText(
                  '${stageCounts[stages[i]] ?? 0}',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: i == 0
                      ? AppColors.kPrimaryBlue
                      : AppColors.kTextGrey,
                ),
              ),

              const SizedBox(height: 6),

              CommonText(
                stages[i],
                fontSize: 10,
                fontWeight:
                i == 0 ? FontWeight.bold : FontWeight.normal,
                color: i == 0
                    ? AppColors.kPrimaryBlue
                    : AppColors.kTextGrey,
              ),
            ],
          ),

          if (i != stages.length - 1)
            Expanded(
              child: Container(
                height: 1.5,
                margin: const EdgeInsets.only(bottom: 18),
                color: const Color(0xFFEFF1F5),
              ),
            ),
        ],
      ],
    );
  }
}