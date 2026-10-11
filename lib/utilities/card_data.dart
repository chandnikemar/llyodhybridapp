import 'package:flutter/material.dart';
import 'app_colors.dart';


// Card background colors
final List<Color> cardColors = [
  AppColors.prd_out_vehicle_box_bg,
  AppColors.park_repark_box_bg,
  AppColors.search_vehicle_box_bg,
  AppColors.my_transaction_vehicle_box_bg,
  AppColors.dipatch_vehicle_box_bg,
  AppColors.set_geofence_box_bg,
  AppColors.printing_label_vehicle_box_bg,
  AppColors.driver_assigned_task_box_bg,
];

// Circle background colors for icons
final List<Color> circleColors = [
  AppColors.prd_out_vehicle_box_circl_bg,
  AppColors.park_repark_box_circl_bg,
  AppColors.search_vehicle_box_circl_bg,
  AppColors.my_transaction_box_circl_bg,
  AppColors.dispatch_vehicle_box_circl_bg,
  AppColors.set_geofence_vehicle_box_circl_bg,
  AppColors.printing_label_vehicle_box_circl_bg,
  AppColors.driver_assigned_task_circl_bg,
];

// Icons for cards
final List<String> cardIcons = [
  'assets/images/prd_out_list.png',
  'assets/images/parking_icon.png',
  'assets/images/search_car_icon.png',
  'assets/images/my_transaction.png',
  'assets/images/dispatch_car_icon.png',
  'assets/images/sitting_icon.png',
  'assets/images/printer_label.png',
  'assets/images/assign_task.png',
];

// Card text labels
final List<String> cardText = [
  'ASSEMBLY IN',
  'PARK/REPARK',
  'SEARCH VEHICLE',
  'MY TRANSACTION',
  'DISPATCH VEHICLE',
  'ADMIN SETTING',
  'RFID PRINT',
  'ASSIGNED TASK'
];

// Map of card routes
/*final Map<String, Widget> cardRoutes = {
  'ASSEMBLY IN': ProductionOutScreen(),
  'PARK/REPARK': ParkReparkScreen(vehicle: null,),
  'SEARCH VEHICLE': SearchVehicleScreen(),
  'MY TRANSACTION': MyTransactionScreen(),
  'DISPATCH VEHICLE': DispatchPlantNewScreen(),
  'ADMIN SETTING': SetYardGeofenceScreen(),
  'RFID PRINT': PrintRfidLabelNewScreen(),
  'ASSIGNED TASK': DriverTaskAssignedScreen(),
};*/
