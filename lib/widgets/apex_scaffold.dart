import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class ApexScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ApexScaffold({super.key, required this.navigationShell});

  @override
  State<ApexScaffold> createState() => _ApexScaffoldState();
}

class _ApexScaffoldState extends State<ApexScaffold> {
  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.grid_view_rounded, label: 'Trackers'),
    _NavItem(icon: Icons.checklist_rounded, label: 'Tasks'),
    _NavItem(icon: Icons.book_rounded, label: 'Journal'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.surfaceBright, width: 1),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_items.length, (index) {
                final isSelected =
                    widget.navigationShell.currentIndex == index;
                final item = _items[index];
                return Expanded(
                  child: InkWell(
                    onTap: () => widget.navigationShell.goBranch(
                      index,
                      initialLocation:
                          index == widget.navigationShell.currentIndex,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 24,
                          color: isSelected
                              ? AppColors.accentGold
                              : Colors.grey[600],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.accentGold
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
