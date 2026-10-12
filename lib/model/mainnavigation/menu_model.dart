class MenuModel {
  final String displayName;
  final String routingURL;
  final String menuIcon;
  final String screenCode; // Added screenCode
  final List<MenuModel> children;

  MenuModel({
    required this.displayName,
    required this.routingURL,
    required this.menuIcon,
    required this.screenCode, // Added to constructor
    required this.children,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    var list = json['children'] as List? ?? [];
    List<MenuModel> childrenList = list.map((i) => MenuModel.fromJson(i)).toList();

    return MenuModel(
      displayName: json['displayName'] ?? '',
      routingURL: json['routingURL'] ?? '',
      menuIcon: json['menuIcon'] ?? '',
      screenCode: json['screenCode'] ?? '', // Parsing from JSON
      children: childrenList,
    );
  }
}