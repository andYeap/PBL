import 'package:admin_pegawai/components/header.dart';
import 'package:admin_pegawai/models/pengguna_model.dart';
import 'package:admin_pegawai/providers/user_provider.dart';
import 'package:admin_pegawai/screens/detail_pengguna.dart';
import 'package:admin_pegawai/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PegawaiScreen extends StatefulWidget {
  final PenggunaModel? penggunaModel;
  const PegawaiScreen({super.key, required this.penggunaModel});
  @override
  State<PegawaiScreen> createState() => _PegawaiScreenState();
}

class _PegawaiScreenState extends State<PegawaiScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<UserProvider>().getDataPengguna(widget.penggunaModel!.role);
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: header(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: InkWell(
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
            ),
            SliverPadding(
              padding: EdgeInsetsGeometry.only(top: 20, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.penggunaModel!.tipe,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Kumpulan data ${widget.penggunaModel!.tipe} yang melayani",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Cari',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsetsGeometry.only(top: 20),
              sliver: SliverSkeletonizer(
                enabled: userProvider.isLoading,
                child: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = userProvider.listUser[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPengguna(userResponse: data),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.person, size: 58),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.name),
                                    Text("NIP: DASDOPAKSDA23123123"),
                                    Text(data.roleName),
                                  ],
                                ),
                              ),
                              Container(
                                width: 70,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Aktif",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: userProvider.listUser.length),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
