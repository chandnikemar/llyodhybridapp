class CommonConfig{

  ///common String for all app
  static const String poweredByText = "Powered By Kemar Port Automation Pvt. Ltd.";
///Image Strings
  //Login
  static const String loginHeader = "assets/images/loginlogo.png";
  static const String loginBg = "assets/images/login_page_bg.png";

  //Home
  static const String changePasswordIcon = "assets/images/change_password_icon.png";

  //Assembly In
  static const String tractorIcon = "assets/images/tractor_new.png";
  //Park/Repark
  static const String navigationArr = "assets/images/navigation_arr.png";
  static const String locationIcon = "assets/images/google_location_icon_blue.png";
  static const String submissionIcon = "assets/images/submission.png";

///Text Strings
    //Login
  static const String login = "LOGIN";
  static const String userNameLabel = "Username";
  static const String passwordLabel = "Password";
  static const String deviceIdNotFound = "Failed To Load Device ID.";

    //Home
  static const String logoutIcon ="assets/images/logout.png";
  static const String isInsideGeofenceIcon ="assets/images/is_inside_geofence.png";
  static const String liveData ="Live Data";
  static const String adminSetting ="ADMIN SETTING";
    //Assembly In
  static const String assemblyIn ="Assembly In";
  static const String parkRepark ="Park/Repark";
    //Park/Repark
  static const String scan ="SCAN";

  //set geofence
  static const String setGeofence ="Set Geofence";


///Hint String

    //Login
  static const String userNameHint = "Enter your username";
  static const String passwordHint = "Enter your password";
  static const String scanBarcodeRfid = "Scan QR/RFID...";

  static const String assemblyInSearchHint = "Search...";

///Button Strings
    //Login

  static const String loginSubmit = "Submit";



///Dialog Helper Messages]

  static const String unexpextedErrorOccured = "An unexpected error occurred.";
  static const String sessionExpired = "Session Expired ! Please relogin";
  static const String pleaseFillTheDetails = "Please Fill the details..!";
  static const String transactionFailed = "Transaction Failed..!";
  //Login
  static const String userNamePasswordEmpty = "Please fill in both username and password.";

  static const String doYouWishToLogOut = "Do you want to logout?";






  static Map<String, List<String>> allowedMenus = {
    'Dashboard': [],
    'Reports': [
      'SCR_SALES_REPORT',
      'SCR_VTR_OUTBOUND',
      'SCR_VTR_INBOUND',
      'SCR_DAILY_DISPATCH'
    ],
    'Order Management': [
      'SCR_MDO', // SO/STO
      'SCR_CDO', // Delivery Orders
      'SCR_BDO', // Bulk Demands
      'SCR_PO_ITEMS' // Purchase Orders
    ],
    'Management Reports': [
      'SCR_MANAGEMENT_DAILY_DISPATCH',
      'SCR_MANAGEMENT_VTR_OUTBOUND',
      'SCR_MANAGEMENT_VTR_INBOUND',
      'SCR_MANAGEMENT_SALES_REPORT'
    ],
  };
}