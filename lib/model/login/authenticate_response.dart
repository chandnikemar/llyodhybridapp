class AuthenticateResponse {
  final String userName;
  final String firstName;
  final String lastName;
  final String roleName;
  final String email;
  final String mobileNumber;
  final String? landingPageURL;
  final bool isVerified;
  final String jwtToken;
  final String refreshToken;
  final String tenantGroup;
  final String defaultTenantCode;
  final String? bpCode;

  final List<UserAccess> userAccess;
  final List<MenuAccess> menuAccess;
  final List<UserTenant> userTenants;

  AuthenticateResponse({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.roleName,
    required this.email,
    required this.mobileNumber,
    this.landingPageURL,
    required this.isVerified,
    required this.jwtToken,
    required this.refreshToken,
    required this.tenantGroup,
    required this.defaultTenantCode,
    this.bpCode,
    required this.userAccess,
    required this.menuAccess,
    required this.userTenants,
  });

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticateResponse(
      userName: json['userName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      roleName: json['roleName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      landingPageURL: json['landingPageURL'],
      isVerified: json['isVerified'] ?? false,
      jwtToken: json['jwtToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      tenantGroup: json['tenantGroup'] ?? '',
      defaultTenantCode: json['defaultTenantCode'] ?? '',
      bpCode: json['bpCode'],
      userAccess: (json['userAccess'] as List<dynamic>? ?? [])
          .map((e) => UserAccess.fromJson(e))
          .toList(),
      menuAccess: (json['menuAccess'] as List<dynamic>? ?? [])
          .map((e) => MenuAccess.fromJson(e))
          .toList(),
      userTenants: (json['userTenants'] as List<dynamic>? ?? [])
          .map((e) => UserTenant.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'roleName': roleName,
      'email': email,
      'mobileNumber': mobileNumber,
      'landingPageURL': landingPageURL,
      'isVerified': isVerified,
      'jwtToken': jwtToken,
      'refreshToken': refreshToken,
      'tenantGroup': tenantGroup,
      'defaultTenantCode': defaultTenantCode,
      'bpCode': bpCode,
      'userAccess': userAccess.map((e) => e.toJson()).toList(),
      'menuAccess': menuAccess.map((e) => e.toJson()).toList(),
      'userTenants': userTenants.map((e) => e.toJson()).toList(),
    };
  }
}

class UserAccess {
  final String screenCode;
  final String routingURL;
  final bool canRead;
  final bool canCreate;
  final bool canUpdate;
  final bool canDeactivate;

  UserAccess({
    required this.screenCode,
    required this.routingURL,
    required this.canRead,
    required this.canCreate,
    required this.canUpdate,
    required this.canDeactivate,
  });

  factory UserAccess.fromJson(Map<String, dynamic> json) {
    return UserAccess(
      screenCode: json['screenCode'] ?? '',
      routingURL: json['routingURL'] ?? '',
      canRead: json['canRead'] ?? false,
      canCreate: json['canCreate'] ?? false,
      canUpdate: json['canUpdate'] ?? false,
      canDeactivate: json['canDeactivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'screenCode': screenCode,
    'routingURL': routingURL,
    'canRead': canRead,
    'canCreate': canCreate,
    'canUpdate': canUpdate,
    'canDeactivate': canDeactivate,
  };
}

class MenuAccess {
  final String displayName;
  final int parentId;
  final int screenId;
  final String routingURL;
  final String? menuName;
  final String menuIcon;
  final String screenCode;
  final bool canRead;
  final bool canCreate;
  final bool canUpdate;
  final bool canDeactivate;
  final String? parentCategory;
  final List<MenuAccess> children;

  MenuAccess({
    required this.displayName,
    required this.parentId,
    required this.screenId,
    required this.routingURL,
    this.menuName,
    required this.menuIcon,
    required this.screenCode,
    required this.canRead,
    required this.canCreate,
    required this.canUpdate,
    required this.canDeactivate,
    this.parentCategory,
    required this.children,
  });

  factory MenuAccess.fromJson(Map<String, dynamic> json) {
    return MenuAccess(
      displayName: json['displayName'] ?? '',
      parentId: json['parentId'] ?? 0,
      screenId: json['screenId'] ?? 0,
      routingURL: json['routingURL'] ?? '',
      menuName: json['menuName'],
      menuIcon: json['menuIcon'] ?? '',
      screenCode: json['screenCode'] ?? '',
      canRead: json['canRead'] ?? false,
      canCreate: json['canCreate'] ?? false,
      canUpdate: json['canUpdate'] ?? false,
      canDeactivate: json['canDeactivate'] ?? false,
      parentCategory: json['parentCategory'],
      children: (json['children'] as List<dynamic>? ?? [])
          .map((e) => MenuAccess.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'parentId': parentId,
    'screenId': screenId,
    'routingURL': routingURL,
    'menuName': menuName,
    'menuIcon': menuIcon,
    'screenCode': screenCode,
    'canRead': canRead,
    'canCreate': canCreate,
    'canUpdate': canUpdate,
    'canDeactivate': canDeactivate,
    'parentCategory': parentCategory,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

class UserTenant {
  final String tenantCode;
  final String tgCode;
  final int roleId;
  final bool isDefault;
  final String tenantName;
  final String tgName;

  UserTenant({
    required this.tenantCode,
    required this.tgCode,
    required this.roleId,
    required this.isDefault,
    required this.tenantName,
    required this.tgName,
  });

  factory UserTenant.fromJson(Map<String, dynamic> json) {
    return UserTenant(
      tenantCode: json['tenantCode'] ?? '',
      tgCode: json['tgCode'] ?? '',
      roleId: json['roleId'] ?? 0,
      isDefault: json['isDefault'] ?? false,
      tenantName: json['tenantName'] ?? '',
      tgName: json['tgName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'tenantCode': tenantCode,
    'tgCode': tgCode,
    'roleId': roleId,
    'isDefault': isDefault,
    'tenantName': tenantName,
    'tgName': tgName,
  };
}