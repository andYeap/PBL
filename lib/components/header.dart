import 'package:admin_pegawai/providers/auth_provider.dart';
import 'package:admin_pegawai/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pegawai/utils/app_colors.dart';
import 'package:provider/provider.dart';

AppBar header(BuildContext context) {
  void doLogout() async {
    bool isSuccess = await context.read<AuthProvider>().logout();

    if (isSuccess) {
      context.read<UserProvider>().clearUserData();
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat logout")),
      );
    }
  }

  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Row(
      children: [
        Image.asset('assets/logo/logo.png', height: 50, fit: BoxFit.contain),
        SizedBox(width: 8),
        Text(
          'SABAR',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.black87),
        onPressed: () => doLogout(),
      ),
    ],
  );
}
