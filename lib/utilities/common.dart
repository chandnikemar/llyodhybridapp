class Common {
  static const String navigateBaseUrl = "http://router.project-osrm.org/";
  //sharedPrefConstants
  static const String jwtToken = "jwtToken";
  static const String refreshToken = "refreshToken";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String email = "email";
  static const String roleName = "roleName";
  static const String userName = "userName";
  static const String userId = "userId";
  static const String mobileNumber = "mobileNumber";
  static const String isVerified = "isVerified";
  static const String coordinates = "coordinates";
  static const String defaultSetCoordinates = "defaultSetCoordinates";
  static const String isLoggedIn = "isLoggedIn";
  static const String screensAllowed = "screensAllowed";
  static const String plantIds = "plantIds";

  //DataView
  static const String baseUrl = "https://testflow.lloyds.in/";


  static const String tenantGroup = "tenantGroup";
  static const String defaultTenantCode = "defaultTenantCode";
  static const String bpCode = "bpCode";

  static const String userAccess = "userAccess";
  static const String menuAccess = "menuAccess";
  static const String userTenants = "userTenants";
  static const String selectedTenant = "selectedTenant";


  static const String qrScannerDatawedge = "kymsusav1";



  //Authenticate
  static  String postAuthenticate = "apgw/tgs/AuthService/authenticate";
  static  String getRefreshToken = "apgw/UserManagement/refreshtoken";
  static  String changePassword = "apgw/tgs/UserManager/change-password";
  static  String forgotPassword="apgw/tgs/AuthService/forgot-password";
  static  String resetPassword="apgw/tgs/AuthService/reset-password";



  ///Home Dashboard
    //trip summary
    static const String getVehicleTransactionSummaryDashboardReport = "apgw/vc/VehicleReport/getVehicleTransactionSummaryDashboardReport";
    //tat summary
    static const String getVehicleTransactionTATDashboardReport = "apgw/vc/VehicleReport/getVehicleTransactionTATDashboardReport";
    //vehicle inside
    static const String getVehicleTransactionSummaryDashboardReportVehicleInside = "apgw/vc/VehicleReport/getVehicleTransactionSummaryDashboardReport";
    //hourly dispatch
    static const String getHourlyDispatchReport = "apgw/vc/VehicleReport/getHourlyDispatchReport";

    //Expected vehicles at different stages
    static const String getVehicleQueueDetails = "apgw/vc/VehicleReport/getVehicleQueueDetails";

    //Daily Summary

    static const String getMaterialDispatchSummaryReport = "apgw/vc/VehicleReport/getMaterialDispatchSummaryReport";
    static const String getMaterialInOutSummary = "apgw/vc/VehicleReport/getMaterialInOutSummary";
    static const String getOpenDODetailsAsync = "apgw/vc/VehicleReport/getOpenDODetailsAsync";
///reports
  //sales report
  static const String getSalesReport = "apgw/vc/VehicleReport/getSalesReport";
  static const String getSalesReportSOSCPO = "apgw/vc/VehicleReport/getSalesReportSOSCPO";

  //Vtr outbound
  static const String getReportsOutboundVTRView = "apgw/vc/VehicleReport/getOutboundVTRView";

  //vtr inbound
  static const String getReportsInBoundVTRView = "apgw/vc/VehicleReport/getInboundVTRView";

  //daily dispatch report
  static const String getDayDispatchReport = "apgw/vc/VehicleReport/getDayDispatchReport";
  ///Order Management
  //BDO List order management
  static const String  getPaginatedBdoList = "apgw/vc/BulkDemandOrder/getPaginatedBdoList";
//BDO Filter order management
  static const String postFilterRouteMaster = "apgw/mdm/RouteMaster/FilterRouteMaster";

//Delivery Filter order management
  static const String postFilterCDODetails = "apgw/vc/CDO/filterCDODetails";
//Delivery Active Transport List order management
  static const String getActiveTransporterList="apgw/mdm/TransporterMaster/getActiveTransporterList";
//Delivery ALL Transporter Region Mapping List  order management
  static const String getAllTransporterRegionMapping = "apgw/mdm/TransporterRegionMapping/getAllTransporterRegionMapping";
  static const String postFilterVehicleTransaction = "apgw/vc/VehicleTransaction/filterVehicleTransaction";

//Delivery Invoice Transaction
  static const String postFilterInvoiceTransaction= "apgw/vc/InvoiceTransaction/filterInvoiceTransaction";
//Delivery Pagination WAY List
  static const String getPaginatedEWayBillList="apgw/vc/EWayBill/getPaginatedEWayBillList";
  //vehical Detail
  static const String getVehicleMilestoneDetails="apgw/vc/VehicleTransaction/getVehicleMilestoneDetails";
//Single DH
  static const String postFilterSingleDH="apgw/mdm/DHM/filterSingleDH";
//Milstone Plan
  static const String postGetMilestonePlan="apgw/jamc/MilestonePlan/getMilestonePlan";
//SO/STO
  //Purchase Orders
  static const String postFilterPOMasters = "apgw/vc/POMaster/filterPOMasters";
  //MDO Masters
  static const String postFilterMDOMasters="apgw/vc/MDOMaster/filterMDOMasters";
//STO Masters
  static String postFilterSTOMasters= "apgw/vc/STOMaster/filterSTOMasters";
  //SO?STO Detail
  static String postFilterConditionType="apgw/mdm/ConditionTypeMaster/filterConditionType";
  static String postFilterCurrencies="apgw/mdm/CurrencyMaster/filterCurrencies";
  static String postFilterPaymentTerms="apgw/mdm/PaymentTerms/filterPaymentTerms";
  static String postFilterCustomers="apgw/mdm/CustomerMaster/filterCustomers";
  static String getPaginatedDistributionChannelList="apgw/mdm/DistributionChannel/getPaginatedDistributionChannelList";
  static String getPaginatedDivisionList="apgw/mdm/DivisionMaster/getPaginatedDivisionList";
  static String getPaginatedIncoTermList="apgw/mdm/IncoTerm/getPaginatedIncoTermList";
  static String postFilterTaxType="apgw/mdm/TaxTypeMaster/filterTaxType";
  static String getPaginatedOrderTypeList= "apgw/mdm/OrderType/getPaginatedOrderTypeList";
  static String postFilterProduct="apgw/mdm/ProductMaster/filterProduct";
  static String getalltenantgroup ="apgw/tgs/TenantGroup/getalltenantgroup";
  static String getAllTenants="apgw/tgs/TenantMaster/getAllTenants";
  static String postFilterSingleCustomerDeliveryLocation="apgw/mdm/CustomerDeliveryLocation/filterSingleCustomerDeliveryLocation";
  static String postFilterLocationWithPagination="apgw/mdm/Location/filterLocationWithPagination";



}
//sales report
enum SalesReportTab {
  doWise,
  soWise,
  scWise,
  customerPoWise,
}