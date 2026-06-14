import 'package:admin_pegawai/screens/akademik_screen.dart';
import 'package:admin_pegawai/screens/admin_dashboard_screen.dart';
import 'package:admin_pegawai/screens/pengguna_screen.dart';
import 'package:admin_pegawai/screens/profile_screen.dart';
import 'package:admin_pegawai/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    AdminDashboard(
      onSelengkapnyaTap: () =>
          _onItemTapped(1),
    ),
    const AkademikScreen(),
    const PenggunaScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar posisi navbar tetap di bawah dan halaman di-render dengan benar
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_outlined,
                  Icons.home_rounded,
                  'Beranda',
                ),
                _buildNavItem(
                  1,
                  Icons.menu_book_outlined,
                  Icons.menu_book_rounded,
                  'Akademik',
                ),
                _buildNavItem(
                  2,
                  Icons.people_outline_rounded,
                  Icons.people_rounded,
                  'Pengguna',
                ),
                _buildNavItem(
                  3,
                  Icons.account_circle_outlined,
                  Icons.account_circle_rounded,
                  'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;

    final itemColor = isSelected
        ? AppColors.primaryColor
        : const Color(0xFF2B4C7E).withOpacity(0.7);

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: itemColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: itemColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              width: 45,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
