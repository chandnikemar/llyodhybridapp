import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utilities/common_dialog.dart';
import '../../../utilities/common_text.dart';
import '../../../view_model/home_dashboard_view_model.dart';


class DailySummaryGrid extends StatelessWidget {
  const DailySummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. WRAPPED IN CONSUMER TO GUARANTEE REBUILDS
    return Consumer<DashboardReportViewModel>(
      builder: (context, viewModel, child) {

        double totalOutboundMaterial = 0.0;
        double totalInboundMaterial = 0.0;

        if (viewModel.materialDispatchNewResponse != null) {
          for (var item in viewModel.materialDispatchNewResponse!) {
            String direction = (item.direction ?? '').trim().toLowerCase();

            if (direction == 'outbound') {
              totalOutboundMaterial += item.totalActualWeight ?? 0.0;
            } else if (direction == 'inbound') {
              totalInboundMaterial += item.totalActualWeight ?? 0.0;
            }
          }
        }

        int totalDo = 0;
        if (viewModel.openDoResponse != null) {
          for (var item in viewModel.openDoResponse!) {
            totalDo += item.openDoCount ?? 0;
          }
        }

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 0,
          childAspectRatio: 2.6,
          children: [
            _SummaryTile(
              isLoading: viewModel.isMaterialLoading,
              icon: SvgPicture.asset(
                'assets/images/dash_material_dispatched_icon.svg',
                width: 16,
                height: 16,
              ),
              value: '${totalOutboundMaterial.toStringAsFixed(2)} MT',
              label: 'Material Dispatched',
              onIconTap: () {
                showDialog(
                  context: context,
                  builder: (_) => MaterialBreakdownDialog(
                    materials: viewModel.materialDispatchResponse ?? [],
                  ),
                );
              },
            ),
            _SummaryTile(
              isLoading: viewModel.isMaterialLoading,
              icon: SvgPicture.asset(
                'assets/images/dash_material_received_icon.svg',
                width: 16,
                height: 16,
              ),
              value: '${totalInboundMaterial.toStringAsFixed(2)} MT',
              label: 'Material Received',
            ),
            _SummaryTile(
              isLoading: viewModel.isOpenDoLoading,
              icon: SvgPicture.asset(
                'assets/images/dash_delivery_order_icon.svg',
                width: 16,
                height: 16,
              ),
              value: totalDo.toString(),
              label: 'Delivery Orders',
              onIconTap: () {
                showDialog(
                  context: context,
                  builder: (_) => OpenDoDetailsDialog(
                    doList: viewModel.openDoResponse ?? [],
                  ),
                );
              },
            ),
            _SummaryTile(
              icon: SvgPicture.asset(
                'assets/images/dash_vehicle_on_trip_icon.svg',
                width: 16,
                height: 16,
              ),
              value: '0',
              label: 'Vehicles on Trip',
            ),
          ],
        );
      },
    );
  }
}

// Ensure _SummaryTile is right here just like before
class _SummaryTile extends StatelessWidget {
  final Widget icon;
  final String value;
  final String label;
  final VoidCallback? onIconTap;
  final bool isLoading;

  const _SummaryTile({
    required this.icon,
    required this.value,
    required this.label,
    this.onIconTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: icon,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  CommonText(
                    value,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF131754),
                  ),
                Row(
                  children: [
                    Flexible(
                      child: CommonText.tiny(
                        label,
                        fontSize: 10,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xFF4A5671),
                      ),
                    ),
                    if (onIconTap != null) ...[
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: onIconTap,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.visibility_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}