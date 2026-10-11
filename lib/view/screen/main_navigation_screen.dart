import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ut_lloyd_web_app/view/screen/dashboard/dashboard_screen.dart';
import 'package:ut_lloyd_web_app/view/screen/managementreports/mgmvtroutbound/mgm_vtr_outbound_screen.dart';
import 'package:ut_lloyd_web_app/view/screen/profile/profile_screen.dart';
import 'package:ut_lloyd_web_app/view/screen/reports/dailydispatchreport/daily_dispatch_report_screen.dart';
import 'package:ut_lloyd_web_app/view/screen/reports/salesreport/sales_resport_screen.dart';
import 'package:ut_lloyd_web_app/view/screen/reports/vtrinbound/vtr_inbound_screen.dart';
import 'package:ut_lloyd_web_app/view/screen/reports/vtroutbound/vtr_outbound_screen.dart';

import '../../model/mainnavigation/menu_model.dart';
import '../../utilities/common.dart';
import '../../utilities/common_config.dart';
import '../../utilities/common_dialog.dart';

import 'managementreports/managedailydispatchreport/mgm_daily_dispatch_report_screen.dart';
import 'managementreports/mgmsalesreport/mgm_sales_resport_screen.dart';
import 'managementreports/mgmvtrinbound/mgm_vtr_inbound_screen.dart';
import 'ordermanagement/bulkdemands/bulkdemands_ordermanagment_screen.dart';
import 'ordermanagement/deliveryorders/delivery_orders_ordermanagment_screen.dart';
import 'ordermanagement/purchaseorder/purchase_orders_screen.dart';
import 'ordermanagement/sostoorders/sosto_ordermanagement_screen.dart';

// Dummy screen for demonstration
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Notifications View'));
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  String _userName = "";
  String _userInitials = "";
  String _userRole = "";
  List<MenuModel> _menuItems = [];
  String _activeRoute = '/dashboards/dashboard1'; // Default active route

  // --- Added Tenant Variables ---
  List<Map<String, dynamic>> _tenants = [];
  Map<String, dynamic>? _selectedTenant;
  bool _isLoadingTenants = true;

  @override
  void initState() {
    super.initState();
    _loadMenusFromPrefs();
    _loadTenants(); // <-- Load Tenants on init
  }

  // --- Added Tenant Loading Logic ---
  Future<void> _loadTenants() async {
    final prefs = await SharedPreferences.getInstance();

    final tenantsString = prefs.getString(Common.userTenants);
    final savedTenantCode = prefs.getString(Common.selectedTenant);

    if (tenantsString != null && tenantsString.isNotEmpty) {
      try {
        final List<dynamic> decodedList = jsonDecode(tenantsString);

        // Filter out duplicate tenantCodes
        final Map<String, Map<String, dynamic>> uniqueTenants = {};
        for (var item in decodedList) {
          if (item['tenantCode'] != null) {
            uniqueTenants[item['tenantCode']] = item as Map<String, dynamic>;
          }
        }

        final tenants = uniqueTenants.values.toList();
        Map<String, dynamic>? defaultTenant;

        // 1. Try to load the previously saved tenant first
        if (savedTenantCode != null && savedTenantCode.isNotEmpty) {
          try {
            defaultTenant = tenants.firstWhere((t) =>
            (t['tenantCode'] ?? '').toString().trim().toUpperCase() == savedTenantCode.trim().toUpperCase()
            );
          } catch (_) {}
        }

        // 2. Fallback to default
        if (defaultTenant == null) {
          for (var t in tenants) {
            if (t['isDefault'] == true) {
              defaultTenant = t;
              break;
            }
          }
        }

        // 3. Fallback to first
        if (defaultTenant == null && tenants.isNotEmpty) {
          defaultTenant = tenants.first;
        }

        setState(() {
          _tenants = tenants;
          _selectedTenant = defaultTenant;
          _isLoadingTenants = false;
        });

        // Ensure the pref is up to date with initial selection
        if (_selectedTenant != null) {
          await prefs.setString(Common.selectedTenant, _selectedTenant!['tenantCode']);
        }
      } catch (e) {
        debugPrint("Error parsing tenants: $e");
        setState(() => _isLoadingTenants = false);
      }
    } else {
      setState(() => _isLoadingTenants = false);
    }
  }

  String _getPageTitle() {
    if (_currentIndex == 2) return 'Search';
    if (_activeRoute == '/dashboards/dashboard1') return 'Dashboard';

    for (var parent in _menuItems) {
      if (parent.routingURL == _activeRoute && parent.routingURL.isNotEmpty) {
        return parent.displayName;
      }
      for (var child in parent.children) {
        if (child.routingURL == _activeRoute && child.routingURL.isNotEmpty) {
          return child.displayName;
        }
      }
    }
    return 'Dashboard';
  }

  List<MenuModel> _filterAllowedMenus(List<MenuModel> rawMenus) {
    List<MenuModel> filteredList = [];

    for (var parent in rawMenus) {
      if (parent.displayName.trim().toLowerCase().contains('dashboard')) {
        continue;
      }

      String parentKey = CommonConfig.allowedMenus.keys.firstWhere(
            (key) => key.toLowerCase() == parent.displayName.trim().toLowerCase(),
        orElse: () => '',
      );

      if (parentKey.isNotEmpty) {
        List<String> allowedScreenCodes = CommonConfig.allowedMenus[parentKey]!;

        if (allowedScreenCodes.isEmpty) {
          filteredList.add(parent);
          continue;
        }

        List<MenuModel> filteredChildren = parent.children.where((child) {
          return allowedScreenCodes.contains(child.screenCode);
        }).toList();

        if (filteredChildren.isNotEmpty) {
          filteredList.add(MenuModel(
              displayName: parent.displayName,
              menuIcon: parent.menuIcon,
              routingURL: parent.routingURL,
              children: filteredChildren,
              screenCode: parent.screenCode));
        }
      }
    }

    filteredList.insert(0, MenuModel(
      displayName: 'Dashboard',
      menuIcon: 'fa fa-home',
      routingURL: '/dashboards/dashboard1',
      children: [],
      screenCode: '',
    ));

    return filteredList;
  }

  Future<void> _loadMenusFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final String? menuJsonStr = prefs.getString(Common.menuAccess);
    final String userName = prefs.getString(Common.userName) ?? "";
    final String firstName = prefs.getString(Common.firstName) ?? "";
    final String lastName = prefs.getString(Common.lastName) ?? "";
    final String userRole = prefs.getString(Common.roleName) ?? "";

    if (menuJsonStr != null && menuJsonStr.isNotEmpty) {
      final List<dynamic> parsedList = jsonDecode(menuJsonStr);

      final List<MenuModel> rawMenus = parsedList
          .map((json) => MenuModel.fromJson(json))
          .toList();

      setState(() {
        _userName = userName;
        _userInitials =
        "${firstName.isNotEmpty ? firstName[0] : ""}"
            "${lastName.isNotEmpty ? lastName[0] : ""}";
        _userRole = userRole;
        _menuItems = _filterAllowedMenus(rawMenus);
      });
    }
  }

  IconData _getIcon(String iconString) {
    if (iconString.contains('home')) return Icons.home_outlined;
    if (iconString.contains('user') && !iconString.contains('users')) return Icons.person_outline;
    if (iconString.contains('users')) return Icons.group_outlined;
    if (iconString.contains('chart')) return Icons.stacked_line_chart;
    if (iconString.contains('cog')) return Icons.settings_outlined;
    if (iconString.contains('server')) return Icons.dns_outlined;
    if (iconString.contains('truck')) return Icons.local_shipping_outlined;
    if (iconString.contains('building')) return Icons.business_outlined;
    return Icons.circle_outlined;
  }

  void _onBottomNavTapped(int index) {
    if (index == 0 || index == 1) {
      setState(() {
        _currentIndex = index;
      });
    } else if (index == 2) {
      _showSearchModal();
    } else if (index == 3) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  void _showSearchModal() {
    showDialog(
      context: context,
      builder: (context) {
        return SearchMenuDialog(
          menuItems: _menuItems,
          getIconMapper: _getIcon,
          onSelected: (String selectedRoute) {
            Navigator.pop(context);
            setState(() {
              _activeRoute = selectedRoute;
              _currentIndex = 0;
            });
          },
        );
      },
    );
  }

  Widget _buildActiveScreen() {
    if (_currentIndex == 1) return NotificationScreen();

    switch (_activeRoute) {
      case '/dashboards/dashboard1':
        return const DashboardScreen();
      case '/salesReport':
        return const SalesReportScreen();
      case '/vtrOutbound':
        return const VtrOutBoundListScreen(title: 'Vtr - Outbound');
      case '/vtrInbound':
        return const VtrInBoundListScreen(title: 'Vtr - Inbound');
      case '/dailyDispatch':
        return const DailyDispatchReportScreen(title: 'Daily Dispatch Report');
      case '/mdo':
        return const SostoOrdermanagementScreen();
      case '/cdo':
        return const DeliveryOrderListScreen();
      case '/bdo':
        return const BulkDemandBdoScreen();
      case '/poItems':
        return const PurchaseOrdersScreen();
      case '/management-daily-dispatch':
        return const MGMDailyDispatchReportScreen(title: 'MGM Daily Dispatch Report');
      case '/management-vtr-outbound':
        return const MGMVtrOutBoundListScreen(title: 'MGM Vtr - Outbound');
      case '/management-vtr-inbound':
        return const MGMVtrInBoundListScreen(title: 'MGM Vtr - Inbound');
      case '/management-sales-report':
        return const MGMSalesReportScreen();
      case '/profile':
        return ProfileScreen(
          onBackPressed: () {
            setState(() {
              _activeRoute = '/dashboards/dashboard1';
              _currentIndex = 0;
            });
          },
        );
      default:
        return Center(
          child: Text(
            'Screen Not Yet Implemented:\n$_activeRoute',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: _activeRoute == '/profile'
          ? null // Hides standard header on the profile page
          : AppBar(
        backgroundColor: const Color(0xFFF4F7FC),
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/ut_logo_without_bg.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          _getPageTitle(),
          style:TextStyle(
            color: const Color(0xFF131754),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [

          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF1C6DD0),
                radius: 18,
                child: Text(
                  _userInitials,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: _buildActiveScreen(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1C6DD0),
                    radius: 24,
                    child: Text(_userInitials,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF131754)),
                        ),
                        Text(
                          _userRole,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        useRootNavigator: true,
                        builder: (context) => const LogoutDialog(),
                      );
                    },
                  )
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                children: [

                  // ==========================================
                  // 🔹 TENANT DROPDOWN (ONLY SHOWS IF NOT ON DASHBOARD) 🔹
                  // ==========================================
                  if (_activeRoute != '/dashboards/dashboard1' && _activeRoute != '/profile')
                    _isLoadingTenants
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                        : Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF0FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/dash_switch_tenant_dropdown_icon.svg',
                            width: 18,
                            height: 18,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF131754),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedTenant?['tenantCode'],
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF131754)),
                                isExpanded: true,
                                isDense: false,
                                dropdownColor: Colors.white,
                                onChanged: (String? newTenantCode) async {
                                  if (newTenantCode != null) {
                                    setState(() {
                                      _selectedTenant = _tenants.firstWhere((t) => t['tenantCode'] == newTenantCode);
                                    });
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString(Common.selectedTenant, newTenantCode);
                                  }
                                },
                                items: _tenants.map<DropdownMenuItem<String>>((Map<String, dynamic> tenant) {
                                  return DropdownMenuItem<String>(
                                    value: tenant['tenantCode'],
                                    child: Text(
                                      tenant['tenantName'] ?? 'Unknown Site',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF131754),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // ==========================================

                  ..._menuItems.map((menu) => _buildMenuNode(menu)),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.person_outline, color: Colors.black87),
                    title: Text(
                      'My profile',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    onTap: () {
                      setState(() {
                        _activeRoute = '/profile';
                        _currentIndex = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuNode(MenuModel menu) {
    bool hasChildren = menu.children.isNotEmpty;
    bool isActive = _activeRoute == menu.routingURL && menu.routingURL.isNotEmpty;
    bool isAnyChildActive = hasChildren &&
        menu.children.any((child) =>
        _activeRoute == child.routingURL && child.routingURL.isNotEmpty);

    if (!hasChildren) {
      return Container(
        margin: const EdgeInsets.only(bottom: 6),
        child: Stack(
          children: [
            if (isActive)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C6DD0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(left: isActive ? 6.0 : 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFF0F4F8) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: Icon(
                    _getIcon(menu.menuIcon),
                    color: isActive ? const Color(0xFF1C6DD0) : Colors.black87,
                  ),
                  title: Text(
                    menu.displayName,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? const Color(0xFF131754) : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () {
                    setState(() {
                      _activeRoute = menu.routingURL;
                      _currentIndex = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: isAnyChildActive,
          tilePadding: EdgeInsets.zero,
          trailing: const SizedBox.shrink(),
          title: Stack(
            children: [
              if (isAnyChildActive)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  right: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C6DD0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(left: isAnyChildActive ? 6.0 : 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isAnyChildActive ? const Color(0xFFF0F4F8) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          _getIcon(menu.menuIcon),
                          color: isAnyChildActive ? const Color(0xFF1C6DD0) : Colors.black87,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            menu.displayName,
                            style: TextStyle(
                                fontWeight: isAnyChildActive ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 15,
                                color: isAnyChildActive ? const Color(0xFF131754) : Colors.black87),
                          ),
                        ),
                        Icon(
                          Icons.expand_more,
                          color: isAnyChildActive ? const Color(0xFF1C6DD0) : Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.only(left: 54, bottom: 10),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: menu.children.map((child) {
            bool isChildActive = _activeRoute == child.routingURL && child.routingURL.isNotEmpty;
            return InkWell(
              onTap: () {
                setState(() {
                  _activeRoute = child.routingURL;
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  child.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isChildActive ? FontWeight.w600 : FontWeight.w400,
                    color: isChildActive ? const Color(0xFF1C6DD0) : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //_buildBottomNavItem(icon: Icons.home_outlined, label: 'Home', index: 0),
          _buildBottomNavItem(icon: Icons.search, label: 'Search', index: 2),
          _buildBottomNavItem(icon: Icons.menu, label: 'Menu', index: 3),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({required IconData icon, required String label, required int index}) {
    bool isSelected = _currentIndex == index;
    Color activeColor = const Color(0xFF1C6DD0);
    Color inactiveColor = Colors.grey.shade600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onBottomNavTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 26,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SEARCH DIALOG WIDGETS
// ==========================================

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
              title: '${parent.displayName} > ${child.displayName}',
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
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.grey),
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
                    onTap: () => widget.onSelected(item.route),
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