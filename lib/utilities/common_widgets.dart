import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'app_colors.dart';
import 'common_text.dart';

/// Skeleton Loader Widget
class SkeletonLoader extends StatelessWidget {
  final double boxHeight;
  final double boxWidth;
  final double line1Width;
  final double line2Width;

  const SkeletonLoader({
    super.key,
    this.boxHeight = 70,
    this.boxWidth = 70,
    this.line1Width = 0.45,
    this.line2Width = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Shimmer.fromColors(
        highlightColor: Colors.grey[100] ?? Colors.grey,
        baseColor: Colors.grey[300] ?? Colors.grey,
        child: Row(
          children: <Widget>[
            // Left grey box
            Container(
              height: boxHeight,
              width: boxWidth,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            // Right grey lines
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * line1Width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * line2Width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.white,
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

/// Another Example Widget
class CircularLoader extends StatelessWidget {
  final double size;
  final Color color;

  const CircularLoader({
    super.key,
    this.size = 50.0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

/// Another Example Widget for Shimmering Text
class ShimmerText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const ShimmerText({
    super.key,
    required this.text,
    this.style = const TextStyle(fontSize: 16, color: Colors.black),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
Route createCombinedTransitionRoute(Widget destinationPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Return the child directly without any transition
      return child;
    },
    transitionDuration: Duration.zero, // No duration
    reverseTransitionDuration: Duration.zero, // No reverse duration
  );
}
class CommonTabBar<T> extends StatelessWidget {
  final T selectedTab;
  final Map<T, String> tabs;
  final ValueChanged<T> onTabChanged;

  final double tabSpacing;
  final double verticalPadding;

  const CommonTabBar({
    super.key,
    required this.selectedTab,
    required this.tabs,
    required this.onTabChanged,
    this.tabSpacing = 22,
    this.verticalPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in tabs.entries) ...[
            _CommonTabItem(
              label: entry.value,
              selected: selectedTab == entry.key,
              onTap: () {
                onTabChanged(entry.key);
              },
              verticalPadding: verticalPadding,
            ),
            SizedBox(width: tabSpacing),
          ],
        ],
      ),
    );
  }
}


class _CommonTabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double verticalPadding;

  const _CommonTabItem({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
              label,
              fontSize: 14,
              fontWeight:
              selected ? FontWeight.bold : FontWeight.normal,
              color:
              selected
                  ? AppColors.kPrimaryBlue
                  : AppColors.kTextGrey,
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: label.length * 6.5,
              color:
              selected
                  ? AppColors.kPrimaryBlue
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
class CommonSearchFilterRow extends StatefulWidget {
  final TextEditingController searchController;

  final VoidCallback onSearch;

  final VoidCallback? onClear;
  final VoidCallback onFilterTap;

  final String hintText;

  const CommonSearchFilterRow({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onFilterTap,
    this.onClear,
    this.hintText = 'Search...',
  });

  @override
  State<CommonSearchFilterRow> createState() =>
      _CommonSearchFilterRowState();
}

class _CommonSearchFilterRowState
    extends State<CommonSearchFilterRow> {

  @override
  void initState() {
    super.initState();

    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSearchText =
        widget.searchController.text.trim().isNotEmpty;

    return Row(
      children: [

        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.only(
              left: 12,
              right: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: widget.searchController,
                    textInputAction: TextInputAction.search,

                    onSubmitted: (_) {
                      widget.onSearch();
                    },

                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),

                if (hasSearchText)
                  InkWell(
                    onTap: () {
                      widget.searchController.clear();

                      if (widget.onClear != null) {
                        widget.onClear!();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        InkWell(
          onTap: widget.onSearch,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FA),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.search,
              color: Color(0xFF1C6DD0),
              size: 20,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // ============================================================
        // FILTER BUTTON
        // ============================================================
        InkWell(
          onTap: widget.onFilterTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FA),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/filter.png',
              width: 18,
              height: 18,
              color: const Color(0xFF1C6DD0),
            ),
          ),
        ),
      ],
    );
  }
}
