import 'package:admin_pegawai/components/header.dart';
import 'package:admin_pegawai/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPengguna extends StatelessWidget {
  final UserResponse userResponse;
  const DetailPengguna({super.key, required this.userResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios,
                      size: 14,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Kembali",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Detail ${userResponse.roleName}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 15),
              Text("Informasi Data ${userResponse.roleName}"),
              SizedBox(height: 15),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(12),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Nama:"), Text(userResponse.name)],
                      ),
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Role:"), Text(userResponse.roleName)],
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
