import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utilities/app_colors.dart';
import '../../../utilities/common.dart';
import '../../../utilities/common_dialog.dart';

import '../../../view_model/home_dashboard_view_model.dart';
import 'daily_summary.dart';
import 'dispatch_trend.dart';
import 'section_title.dart';
import 'site_selector_row.dart';
import 'stage_stepper.dart';
import 'summary_row.dart';
import 'vehicle_inside.dart';
import 'welcome_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardReportViewModel _viewModel = DashboardReportViewModel();

  String _firstName = '';
  String _tenantCode = ''; // Renamed to match your data structure

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _firstName = prefs.getString(Common.firstName) ?? '';
    _tenantCode = prefs.getString(Common.selectedTenant) ?? '';
    print('tenant code --- $_tenantCode');
    if (mounted) setState(() {});
  }

  /// Triggered by the SiteSelectorRow (both initially and on user change).
  void _onTenantChanged(String newTenantCode) {
    if (!mounted) return;
    setState(() {
      _tenantCode = newTenantCode;
    });
    // Fetch all dashboard data for the specific tenant
    _viewModel.refreshAll(_tenantCode);
  }

  Future<void> _onRefresh() async {
    if (_tenantCode.isNotEmpty) {
      await _viewModel.refreshAll(_tenantCode);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = (screenWidth * 0.04).clamp(12.0, 24.0);
    final baseSpacing = (screenWidth * 0.03).clamp(10.0, 20.0);

    return ChangeNotifierProvider<DashboardReportViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Color(0xFFE1E3E8),
                    height: 1,
                    thickness: 1,
                  ),
                  SizedBox(height: baseSpacing),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SiteSelectorRow(
                          onSiteChanged: _onTenantChanged,
                        ),
                        SizedBox(height: baseSpacing),

                        WelcomeHeader(firstName: _firstName),
                        SizedBox(height: baseSpacing),

                        const SummaryRow(),
                        SizedBox(height: baseSpacing),

                        const VehiclesInsideCard(),
                        SizedBox(height: baseSpacing),

                        const SectionTitle(title: 'Hourly Dispatch Trend'),
                        SizedBox(height: baseSpacing * 0.5),
                        const DispatchTrendCard(),
                        SizedBox(height: baseSpacing),

                        SectionTitle(
                          title: 'Expected Vehicles by Stage',
                          trailing: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return ChangeNotifierProvider<DashboardReportViewModel>.value(
                                      value: _viewModel,
                                      child:  ExpectedVehiclesDialog(),
                                    );
                                  }
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: SvgPicture.asset(
                                'assets/images/dash_expected_vehicle_icon.svg',
                                width: (screenWidth * 0.04).clamp(14.0, 16.0),
                                height: (screenWidth * 0.04).clamp(14.0, 16.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: baseSpacing),
                        const StageStepper(),
                        SizedBox(height: baseSpacing),

                        SectionTitle(
                          title: 'Daily Summary',
                          trailing: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => DailyCalendarRangeDialog(
                                  title: 'Daily Summary Filter',
                                  initialSelection: _viewModel.dailySummaryFilter,
                                  onApply: (label, fromDate, toDate) {
                                    _viewModel.updateDailySummaryFilter(
                                        _tenantCode,
                                        label,
                                        fromDate,
                                        toDate
                                    );
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
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: (screenWidth * 0.045).clamp(16.0, 18.0),
                                color: AppColors.headerBlue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: baseSpacing * 0.7),
                        const DailySummaryGrid(),
                        SizedBox(height: baseSpacing),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
