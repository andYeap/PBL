import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:admin_pegawai/providers/user_provider.dart';
import 'package:admin_pegawai/providers/akademik_provider.dart';
import 'package:admin_pegawai/providers/kurikulum_provider.dart';
import 'package:admin_pegawai/utils/app_colors.dart';

class AdminDashboard extends StatefulWidget {
  final VoidCallback? onSelengkapnyaTap;

  const AdminDashboard({super.key, this.onSelengkapnyaTap});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _selectedAkademikCategory = 'Tahun Akademik';

  // Menyisakan hanya kategori yang valid digunakan
  final List<String> _akademikCategories = ['Tahun Akademik', 'Kurikulum'];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchDashboardUserData();
      context.read<UserProvider>().profile();
      context.read<AkademikProvider>().fetchAkademikData();
      context.read<KurikulumProvider>().fetchInitialData(perPage: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              height: 35,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.school,
                color: AppColors.primaryColor,
                size: 35,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'SABAR',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Consumer3<UserProvider, AkademikProvider, KurikulumProvider>(
        builder: (context, userProvider, akademikProvider, kurikulumProvider, child) {
          if (userProvider.isLoading ||
              akademikProvider.isLoading ||
              kurikulumProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            );
          }

          final String adminName = userProvider.data?.name ?? "Admin";

          final allYears = List.from(akademikProvider.listTahunAkademik);
          allYears.sort((a, b) => b.id.compareTo(a.id));
          final displayYears = allYears.take(10).toList();
          final displayKurikulum = kurikulumProvider.listKurikulum
              .take(10)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat Datang, $adminName",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Lagi mau ngapain nih?",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.2,
                  children: [
                    _buildStatDateCard(),
                    _buildStatCard(
                      "Total Dosen",
                      userProvider.totalDosen.toString(),
                      Icons.co_present,
                    ),
                    _buildStatCard(
                      "Total Pegawai",
                      userProvider.totalUser.toString(),
                      Icons.badge,
                    ),
                    _buildStatCard("Total Mahasiswa", "120", Icons.school),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  "Fitur Utama",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuGrid(),
                const SizedBox(height: 24),

                Text(
                  "Data Akademik",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedAkademikCategory,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black54,
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      items: _akademikCategories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAkademikCategory = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (_selectedAkademikCategory == 'Tahun Akademik') ...[
                  displayYears.isEmpty
                      ? _buildEmptyState("Tidak ada data tahun akademik")
                      : SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: displayYears.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final ta = displayYears[index];
                              final String tglMulai = ta.tahunAwal.split(
                                'T',
                              )[0];
                              final String tglSelesai = ta.tahunAkhir.split(
                                'T',
                              )[0];

                              final String thnAwalStr = tglMulai.length >= 4
                                  ? tglMulai.substring(0, 4)
                                  : "";
                              final String thnAkhirStr = tglSelesai.length >= 4
                                  ? tglSelesai.substring(0, 4)
                                  : "";
                              final String semFormatted =
                                  ta.tipeSemester.isEmpty
                                  ? ""
                                  : ta.tipeSemester[0].toUpperCase() +
                                        ta.tipeSemester.substring(1);

                              final String cardTitle =
                                  thnAwalStr.isNotEmpty &&
                                      thnAkhirStr.isNotEmpty
                                  ? "Tahun $thnAwalStr/$thnAkhirStr $semFormatted"
                                  : "Tahun ${ta.id} $semFormatted";

                              return Container(
                                width: (screenWidth - 54) / 2,
                                margin: const EdgeInsets.only(right: 12),
                                child: _buildTahunAkademikCard(
                                  cardTitle,
                                  tglMulai,
                                  tglSelesai,
                                  ta.status,
                                ),
                              );
                            },
                          ),
                        ),
                ] else if (_selectedAkademikCategory == 'Kurikulum') ...[
                  displayKurikulum.isEmpty
                      ? _buildEmptyState("Tidak ada data kurikulum")
                      : SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: displayKurikulum.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final kurikulum = displayKurikulum[index];
                              final String formattedProdi = kurikulum.prodi.name
                                  .split('-')
                                  .map(
                                    (word) => word.isEmpty
                                        ? ''
                                        : '${word[0].toUpperCase()}${word.substring(1)}',
                                  )
                                  .join(' ');

                              return Container(
                                width: (screenWidth - 54) / 2,
                                margin: const EdgeInsets.only(right: 12),
                                child: _buildKurikulumCard(
                                  kurikulum.name.toUpperCase(),
                                  "${kurikulum.prodi.jenjang} $formattedProdi",
                                  "Aktif",
                                ),
                              );
                            },
                          ),
                        ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuGrid() {
    final List<Map<String, dynamic>> menus = [
      {"label": "Kurikulum", "icon": Icons.book, "route": "/kurikulum"},
      {"label": "Kelas", "icon": Icons.collections_bookmark, "route": "/kelas"},
      {"label": "KHS", "icon": Icons.assignment, "route": "/khs"},
      {"label": "Dosen", "icon": Icons.co_present, "route": "/dosen"},
      {"label": "Presensi", "icon": Icons.add_task, "route": "/presensi"},
      {
        "label": "Selengkapnya",
        "icon": Icons.double_arrow,
        "route": "/akademik",
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (menus[index]["label"] == "Selengkapnya") {
              if (widget.onSelengkapnyaTap != null) {
                widget.onSelengkapnyaTap!();
              } else {
                Navigator.pushNamed(context, menus[index]["route"]);
              }
            } else {
              Navigator.pushNamed(context, menus[index]["route"]);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  menus[index]["icon"],
                  color: const Color(0xFF1A3A8B),
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  menus[index]["label"],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black45),
        ),
      ),
    );
  }

  Widget _buildStatDateCard() {
    final DateTime now = DateTime.now();
    final String tanggal = DateFormat('d').format(now);
    final String bulan = DateFormat('MMMM', 'id_ID').format(now);
    final String tahun = DateFormat('yyyy').format(now);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tanggal,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A3A8B),
            ),
          ),
          Text(
            bulan,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A3A8B),
            ),
          ),
          Text(
            tahun,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A3A8B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF1A3A8B), size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            count,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A3A8B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTahunAkademikCard(
    String title,
    String tglMulai,
    String tglSelesai,
    String status,
  ) {
    final bool isAktif = status.toLowerCase() == 'aktif';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isAktif ? const Color(0xFF2ECC71) : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isAktif ? "Aktif" : "Nonaktif",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 8, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mulai",
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.black54),
              ),
              Text(
                tglMulai,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selesai",
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.black54),
              ),
              Text(
                tglSelesai,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKurikulumCard(
    String namaKurikulum,
    String prodi,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  namaKurikulum,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: const Color(0xFF1A3A8B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC71),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 8, thickness: 0.5),
          Text(
            "Program Studi",
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            prodi,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
