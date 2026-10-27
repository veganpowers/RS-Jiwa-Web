<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Pasien - RS Khusus ODGJ</title>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f1f5f9; color: #1e293b; }
        
        /* SIDEBAR STYLES */
        .sidebar { width: 260px; background-color: #0f172a; color: #f8fafc; display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-header { padding: 22px 20px; background-color: #1e293b; border-bottom: 1px solid #334155; }
        .sidebar-header h2 { font-size: 16px; color: #38bdf8; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; display: flex; align-items: center; gap: 8px; }
        .sidebar-header p { font-size: 12px; color: #94a3b8; margin-top: 4px; }
        .sidebar-menu { list-style: none; padding: 15px 0; flex-grow: 1; overflow-y: auto; }
        .sidebar-menu li a { display: flex; align-items: center; gap: 12px; padding: 11px 20px; color: #cbd5e1; text-decoration: none; font-size: 13.5px; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { width: 18px; text-align: center; font-size: 14px; color: #94a3b8; }
        .sidebar-menu li a:hover { background-color: rgba(255, 255, 255, 0.05); color: #ffffff; border-left-color: #0284c7; }
        .sidebar-menu li a:hover i { color: #38bdf8; }
        .sidebar-menu li a.active { background-color: #1e293b; color: #ffffff; border-left-color: #0284c7; font-weight: 600; }
        .sidebar-menu li a.active i { color: #38bdf8; }
        .sidebar-footer { padding: 15px 20px; border-top: 1px solid #334155; }
        .logout-btn { display: flex; align-items: center; justify-content: center; gap: 8px; background-color: #ef4444; color: white; padding: 10px 12px; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600; transition: background 0.2s; }
        .logout-btn:hover { background-color: #dc2626; }
        
        /* MAIN CONTENT LAYOUT */
        .main-content { flex-grow: 1; display: flex; flex-direction: column; overflow-x: hidden; }
        .topbar { background-color: #ffffff; padding: 16px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border-bottom: 1px solid #e2e8f0; }
        .topbar .brand { font-size: 14px; font-weight: 600; color: #475569; display: flex; align-items: center; gap: 10px; }
        .topbar .user-pill { font-size: 13px; color: #334155; background: #f8fafc; border: 1px solid #cbd5e1; padding: 6px 14px; border-radius: 20px; display: flex; align-items: center; gap: 8px; }
        .user-pill .status-dot { width: 8px; height: 8px; background-color: #22c55e; border-radius: 50%; }
        .content-body { padding: 25px 30px; flex-grow: 1; }
        
        /* PAGE HEADER */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 22px; flex-wrap: wrap; gap: 12px; }
        .page-header h1 { font-size: 22px; color: #0f172a; font-weight: 700; }
        .page-header p { font-size: 13px; color: #64748b; margin-top: 2px; }

        /* BUTTONS */
        .btn { display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; border: none; transition: all 0.2s; }
        .btn-primary { background-color: #0284c7; color: white; }
        .btn-primary:hover { background-color: #0369a1; }
        .btn-secondary { background-color: #e2e8f0; color: #334155; }
        .btn-secondary:hover { background-color: #cbd5e1; }

        /* FORM CONTAINER */
        .form-card { background: #ffffff; border-radius: 10px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.04); padding: 28px; margin-bottom: 30px; }
        .section-header { font-size: 15px; font-weight: 700; color: #0f172a; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-bottom: 24px; }
        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
        }
        .form-full { grid-column: 1 / -1; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 7px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13.5px; outline: none; transition: border-color 0.2s; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: #0284c7; }
        
        .alert-info-box { background: #eff6ff; border-left: 4px solid #3b82f6; border-radius: 6px; padding: 12px 16px; margin-bottom: 20px; font-size: 13px; color: #1e40af; }
    </style>
    <jsp:include page="inc_theme.jsp" />
</head>
<body>
    <!-- SIDEBAR UTAMA ADMIN -->
    <aside class="sidebar">
        <jsp:include page="inc_sidebar_header.jsp" />
        <ul class="sidebar-menu">
            <li><a href='dashboard.jsp'><i class="fa-solid fa-gauge-high"></i> Dashboard Admin</a></li>
            <li><a href='data_dokter.jsp'><i class="fa-solid fa-user-doctor"></i> Data Dokter</a></li>
            <li><a href='data_perawat.jsp'><i class="fa-solid fa-user-nurse"></i> Data Perawat</a></li>
            <li><a href='data_pasien.jsp'><i class="fa-solid fa-users"></i> Data Pasien</a></li>
            <li><a href='data_kamar_isolasi.jsp'><i class="fa-solid fa-bed"></i> Data Kamar Isolasi</a></li>
            <li><a href='jadwal_dokter.jsp'><i class="fa-regular fa-calendar-check"></i> Jadwal Dokter</a></li>
            <li><a href='rekam_medis_master.jsp'><i class="fa-solid fa-notes-medical"></i> Rekam Medis Master</a></li>
            <li><a href='laporan_bulanan.jsp'><i class="fa-solid fa-chart-line"></i> Laporan Bulanan</a></li>
            <li><a href='tambah_pasien.jsp' class='active'><i class="fa-solid fa-user-plus"></i> Tambah Pasien</a></li>
            <li><a href='pengaturan_sistem.jsp'><i class="fa-solid fa-gear"></i> Pengaturan Sistem</a></li>
        </ul>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/LoginServlet?action=logout" class="logout-btn">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Keluar (Logout)
            </a>
        </div>
    </aside>

    <!-- CONTENT WRAPPER -->
    <div class="main-content">
        <!-- TOPBAR -->
        <header class="topbar">
            <div class="brand">
                <i class="fa-solid fa-hospital-user text-primary"></i>
                Sistem Informasi Terpadu Pelayanan Jiwa RS ODGJ
            </div>
            <div class="user-pill">
                <span class="status-dot"></span>
                Masuk sebagai: <strong><%= session.getAttribute("username") != null ? session.getAttribute("username") : "Administrator" %></strong>
            </div>
        </header>

        <!-- CONTENT BODY -->
        <main class="content-body">
            <!-- PAGE TITLE -->
            <div class="page-header">
                <div>
                    <h1>Pendaftaran & Registrasi Pasien ODGJ Baru</h1>
                    <p>Formulir rekam medis awal, penentuan DPJP psikiatri, dan data informed consent keluarga/wali.</p>
                </div>
            </div>

            <!-- FORM CARD -->
            <div class="form-card">
                <div class="alert-info-box">
                    <i class="fa-solid fa-circle-info"></i> <strong>Prosedur Keselamatan:</strong> Untuk pasien dengan kondisi gaduh gelisah ekstrem, pastikan mencantumkan kontak wali sah untuk persetujuan tindakan isolasi medis atau fiksasi sementara.
                </div>

                <!-- FORM ACTION MENUJU SERVLET:
                     action="<%= request.getContextPath() %>/PasienServlet?action=register"
                -->
                <form action="<%= request.getContextPath() %>/PasienServlet?action=register" method="POST">
                    
                    <!-- 1. DATA IDENTITAS PASIEN (Tabel `pasien`) -->
                    <div class="section-header">
                        <i class="fa-solid fa-id-card text-primary"></i> 1. Identitas Pasien
                    </div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="no_rekam_medis">Nomor Rekam Medis (Auto/Manual) <span style="color:red;">*</span></label>
                            <input type="text" id="no_rekam_medis" name="no_rekam_medis" value="RM-2026-0004" required>
                        </div>

                        <div class="form-group">
                            <label for="nik">NIK KTP Pasien <span style="color:red;">*</span></label>
                            <input type="text" id="nik" name="nik" placeholder="16 digit NIK" maxlength="16" required>
                        </div>

                        <div class="form-group">
                            <label for="nama">Nama Lengkap Pasien <span style="color:red;">*</span></label>
                            <input type="text" id="nama" name="nama" placeholder="Nama lengkap sesuai KTP" required>
                        </div>

                        <div class="form-group">
                            <label for="jenis_kelamin">Jenis Kelamin <span style="color:red;">*</span></label>
                            <select id="jenis_kelamin" name="jenis_kelamin" required>
                                <option value="" disabled selected>-- Pilih Jenis Kelamin --</option>
                                <option value="Laki-laki">Laki-laki</option>
                                <option value="Perempuan">Perempuan</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="tgl_lahir">Tanggal Lahir <span style="color:red;">*</span></label>
                            <input type="date" id="tgl_lahir" name="tgl_lahir" required>
                        </div>

                        <div class="form-group">
                            <label for="status_perawatan">Status Penerimaan Awal <span style="color:red;">*</span></label>
                            <select id="status_perawatan" name="status_perawatan" required>
                                <option value="Rawat Inap">Rawat Inap (Bangsal Reguler)</option>
                                <option value="Isolasi Khusus">Isolasi Khusus (Pengawasan Intensif / Agitasi)</option>
                                <option value="Rawat Jalan">Rawat Jalan (Poliklinik Psikiatri)</option>
                            </select>
                        </div>

                        <div class="form-group-full form-full">
                            <label for="alamat">Alamat Domisili Pasien</label>
                            <textarea id="alamat" name="alamat" rows="2" placeholder="Alamat lengkap tempat tinggal pasien"></textarea>
                        </div>
                    </div>

                    <!-- 2. STATUS KLINIS & PENEMPATAN (Tabel `pasien` & `kamar`) -->
                    <div class="section-header">
                        <i class="fa-solid fa-stethoscope text-primary"></i> 2. Penempatan Dokter (DPJP) & Kamar Inap
                    </div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="id_dokter_dpjp">Dokter Penanggung Jawab (DPJP) <span style="color:red;">*</span></label>
                            <!-- KONEKSI DATABASE: Opsi dokter dari tabel dokter -->
                            <select id="id_dokter_dpjp" name="id_dokter_dpjp" required>
                                <option value="" disabled selected>-- Pilih Psikiater --</option>
                                <option value="1">dr. Budi Santoso, Sp.KJ (Psikiatri Umum & Agitasi)</option>
                                <option value="2">dr. Siti Rahmawati, Sp.KJ (K) (Psikiatri Anak & Bipolar)</option>
                                <option value="3">dr. Hendra Wijaya, Sp.KJ (Psikiatri Adiksi)</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="id_kamar">Alokasi Kamar / Bed Awal</label>
                            <!-- KONEKSI DATABASE: Opsi kamar dari tabel kamar -->
                            <select id="id_kamar" name="id_kamar">
                                <option value="">-- Rawat Jalan (Tidak Menginap) --</option>
                                <option value="1">Ruang Lavender 01 (Isolasi - Terisi)</option>
                                <option value="2">Ruang Lavender 02 (Isolasi - Kosong/Siap)</option>
                                <option value="3">Bangsal Cempaka A (Pria - Terisi 2/6)</option>
                                <option value="4">Bangsal Cempaka B (Wanita - Kosong 0/6)</option>
                            </select>
                        </div>

                        <div class="form-group-full form-full">
                            <label for="tingkat_agitasi">Tingkat Perilaku / Agitasi Saat Tiba <span style="color:red;">*</span></label>
                            <select id="tingkat_agitasi" name="tingkat_agitasi" required>
                                <option value="Tenang">Tenang / Kooperatif</option>
                                <option value="Gelisah Ringan">Gelisah Ringan (Cemas / Mondar-mandir)</option>
                                <option value="Agitasi Berat / Gaduh Gelisah">Agitasi Berat / Gaduh Gelisah (Perlu Pendampingan Khusus)</option>
                            </select>
                        </div>
                    </div>

                    <!-- 3. DATA KELUARGA / WALI (Tabel `keluarga_pasien`) -->
                    <div class="section-header">
                        <i class="fa-solid fa-people-roof text-primary"></i> 3. Data Keluarga / Wali (Informed Consent)
                    </div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nama_wali">Nama Lengkap Wali / Penanggung Jawab <span style="color:red;">*</span></label>
                            <input type="text" id="nama_wali" name="nama_wali" placeholder="Nama wali pasien" required>
                        </div>

                        <div class="form-group">
                            <label for="hubungan">Hubungan dengan Pasien <span style="color:red;">*</span></label>
                            <select id="hubungan" name="hubungan" required>
                                <option value="" disabled selected>-- Pilih Hubungan --</option>
                                <option value="Orang Tua (Ayah/Ibu)">Orang Tua (Ayah / Ibu)</option>
                                <option value="Suami/Istri">Suami / Istri</option>
                                <option value="Anak Kandung">Anak Kandung</option>
                                <option value="Saudara Kandung">Saudara Kandung</option>
                                <option value="Wali Hukum / Dinas Sosial">Wali Hukum / Petugas Dinsos</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="no_telp_wali">Nomor HP / WhatsApp Wali <span style="color:red;">*</span></label>
                            <input type="text" id="no_telp_wali" name="no_telp_wali" placeholder="08xxxxxxxxxx" required>
                        </div>

                        <div class="form-group">
                            <label for="persetujuan_tindakan">Persetujuan Tindakan Darurat & Isolasi <span style="color:red;">*</span></label>
                            <select id="persetujuan_tindakan" name="persetujuan_tindakan" required>
                                <option value="Setuju">Setuju (Informed Consent Lengkap)</option>
                                <option value="Menunggu Persetujuan">Menunggu Persetujuan Keluarga</option>
                                <option value="Menolak">Menolak Tindakan Isolasi/Restraint</option>
                            </select>
                        </div>
                    </div>

                    <div style="display:flex; justify-content:flex-end; gap:12px; margin-top:20px; border-top:1px solid #e2e8f0; padding-top:20px;">
                        <a href="data_pasien.jsp" class="btn btn-secondary">Batal</a>
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> Daftarkan Pasien</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>


