<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // CONTOH PEMANGGILAN NILAI TEMA DARI SESSION / DATABASE (Bisa diset via Servlet/Filter):
    String primaryColor = (session.getAttribute("theme_primary") != null) ? (String) session.getAttribute("theme_primary") : "#0284c7";
    String secondaryColor = (session.getAttribute("theme_secondary") != null) ? (String) session.getAttribute("theme_secondary") : "#38bdf8";
    String sidebarBgColor = (session.getAttribute("theme_sidebar_bg") != null) ? (String) session.getAttribute("theme_sidebar_bg") : "#0f172a";
    String sidebarTextColor = (session.getAttribute("theme_sidebar_text") != null) ? (String) session.getAttribute("theme_sidebar_text") : "#cbd5e1";
    String logoPath = (session.getAttribute("hospital_logo") != null) ? (String) session.getAttribute("hospital_logo") : null;
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pengaturan Sistem & Kustomisasi Tema - RS Khusus ODGJ</title>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>
        /* ==========================================================================
           1. PENERAPAN CSS VARIABLES (:root)
           Variabel ini mengambil nilai dinamis dari Java Session / Database
           ========================================================================== */
        :root {
            --primary-color: <%= primaryColor %>;
            --secondary-color: <%= secondaryColor %>;
            --sidebar-bg: <%= sidebarBgColor %>;
            --sidebar-text: <%= sidebarTextColor %>;
            --bg-body: #f1f5f9;
            --text-dark: #0f172a;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; min-height: 100vh; background-color: var(--bg-body); color: var(--text-dark); }
        
        /* SIDEBAR STYLES (MENGGUNAKAN CSS VARIABLES) */
        .sidebar { width: 260px; background-color: var(--sidebar-bg); color: #f8fafc; display: flex; flex-direction: column; flex-shrink: 0; transition: background-color 0.3s; }
        .sidebar-header { padding: 22px 20px; background-color: rgba(0,0,0,0.15); border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-brand-wrapper { display: flex; align-items: center; gap: 10px; }
        .sidebar-logo-img { width: 34px; height: 34px; object-fit: contain; border-radius: 6px; }
        .sidebar-header h2 { font-size: 15px; color: var(--secondary-color); font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .sidebar-header p { font-size: 11.5px; color: #94a3b8; margin-top: 3px; }
        
        .sidebar-menu { list-style: none; padding: 15px 0; flex-grow: 1; overflow-y: auto; }
        .sidebar-menu li a { display: flex; align-items: center; gap: 12px; padding: 11px 20px; color: var(--sidebar-text); text-decoration: none; font-size: 13.5px; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { width: 18px; text-align: center; font-size: 14px; color: #94a3b8; }
        .sidebar-menu li a:hover { background-color: rgba(255, 255, 255, 0.05); color: #ffffff; border-left-color: var(--primary-color); }
        .sidebar-menu li a:hover i { color: var(--secondary-color); }
        .sidebar-menu li a.active { background-color: rgba(255, 255, 255, 0.08); color: #ffffff; border-left-color: var(--primary-color); font-weight: 600; }
        .sidebar-menu li a.active i { color: var(--secondary-color); }
        
        .sidebar-footer { padding: 15px 20px; border-top: 1px solid rgba(255,255,255,0.1); }
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
        .page-header h1 { font-size: 22px; color: var(--text-dark); font-weight: 700; }
        .page-header p { font-size: 13px; color: #64748b; margin-top: 2px; }

        /* BUTTONS */
        .btn { display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; border-radius: 6px; font-size: 13.5px; font-weight: 600; cursor: pointer; text-decoration: none; border: none; transition: all 0.2s; }
        .btn-primary { background-color: var(--primary-color); color: white; }
        .btn-primary:hover { opacity: 0.9; }
        .btn-secondary { background-color: #e2e8f0; color: #334155; }
        .btn-secondary:hover { background-color: #cbd5e1; }

        /* TWO COLUMN LAYOUT (FORM & LIVE PREVIEW) */
        .settings-container { display: grid; grid-template-columns: 1.15fr 0.85fr; gap: 24px; }
        @media (max-width: 1024px) {
            .settings-container { grid-template-columns: 1fr; }
        }

        /* CARD */
        .card { background: #ffffff; border-radius: 10px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.04); padding: 24px; margin-bottom: 24px; }
        .card-title { font-size: 15px; font-weight: 700; color: var(--text-dark); margin-bottom: 18px; display: flex; align-items: center; gap: 10px; border-bottom: 1px solid #f1f5f9; padding-bottom: 12px; }
        
        /* COLOR PICKER INPUTS */
        .color-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 18px; }
        .color-item { display: flex; flex-direction: column; gap: 6px; }
        .color-item label { font-size: 12.5px; font-weight: 600; color: #334155; }
        .color-input-wrapper { display: flex; align-items: center; gap: 10px; background: #f8fafc; border: 1px solid #cbd5e1; border-radius: 6px; padding: 6px 10px; }
        .color-input-wrapper input[type="color"] { -webkit-appearance: none; border: none; width: 32px; height: 32px; border-radius: 4px; cursor: pointer; background: none; }
        .color-input-wrapper input[type="color"]::-webkit-color-swatch-wrapper { padding: 0; }
        .color-input-wrapper input[type="color"]::-webkit-color-swatch { border: 1px solid #cbd5e1; border-radius: 4px; }
        .color-hex { font-family: monospace; font-size: 13px; font-weight: 600; color: #334155; }

        /* FILE UPLOAD STYLES */
        .file-upload-box { border: 2px dashed #cbd5e1; border-radius: 8px; padding: 20px; text-align: center; background: #f8fafc; cursor: pointer; transition: all 0.2s; position: relative; }
        .file-upload-box:hover { border-color: var(--primary-color); background: #f0f9ff; }
        .file-upload-box input[type="file"] { position: absolute; top: 0; left: 0; width: 100%; height: 100%; opacity: 0; cursor: pointer; }
        .upload-icon { font-size: 28px; color: #94a3b8; margin-bottom: 6px; }

        /* LIVE PREVIEW COMPONENT */
        .preview-pane { position: sticky; top: 20px; }
        .mockup-wrapper { border: 1px solid #cbd5e1; border-radius: 10px; overflow: hidden; box-shadow: 0 8px 20px rgba(0,0,0,0.06); background: #ffffff; }
        .mockup-header { background: #e2e8f0; padding: 8px 14px; font-size: 11px; font-weight: 600; color: #475569; display: flex; align-items: center; gap: 6px; }
        .mockup-header .circle { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
        
        .mockup-body { display: flex; height: 320px; }
        .mockup-sidebar { width: 110px; padding: 14px 10px; display: flex; flex-direction: column; gap: 12px; transition: background-color 0.2s; }
        .mockup-logo-area { display: flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 700; }
        .mockup-logo-img { width: 22px; height: 22px; object-fit: contain; }
        .mockup-menu { list-style: none; display: flex; flex-direction: column; gap: 6px; margin-top: 10px; }
        .mockup-menu-item { font-size: 10.5px; padding: 6px 8px; border-radius: 4px; display: flex; align-items: center; gap: 6px; }
        
        .mockup-content { flex-grow: 1; background: #f1f5f9; padding: 14px; display: flex; flex-direction: column; gap: 10px; }
        .mockup-topbar { background: #fff; border-radius: 4px; height: 26px; border: 1px solid #e2e8f0; display: flex; align-items: center; justify-content: space-between; padding: 0 10px; font-size: 9px; }
        .mockup-card { background: #fff; border-radius: 6px; padding: 12px; border: 1px solid #e2e8f0; flex-grow: 1; display: flex; flex-direction: column; gap: 8px; }
        .mockup-button { padding: 5px 10px; border-radius: 4px; color: #fff; font-size: 10px; font-weight: 600; border: none; width: fit-content; }
    </style>
</head>
<body>
    <!-- SIDEBAR UTAMA ADMIN -->
    <aside class="sidebar" id="mainSidebar">
        <div class="sidebar-header">
            <div class="sidebar-brand-wrapper">
                <% if (logoPath != null && !logoPath.trim().isEmpty()) { %>
                    <img src="<%= request.getContextPath() %>/<%= logoPath %>" alt="Logo RS" class="sidebar-logo-img" id="sidebarLogoImg">
                <% } else { %>
                    <i class="fa-solid fa-hospital" id="sidebarLogoIcon" style="font-size: 20px; color: var(--secondary-color);"></i>
                <% } %>
                <div>
                    <h2 id="sidebarHospitalTitle">RS Khusus ODGJ</h2>
                    <p>Administrator Portal</p>
                </div>
            </div>
        </div>
        <ul class="sidebar-menu">
            <li><a href='dashboard.jsp'><i class="fa-solid fa-gauge-high"></i> Dashboard Admin</a></li>
            <li><a href='data_dokter.jsp'><i class="fa-solid fa-user-doctor"></i> Data Dokter</a></li>
            <li><a href='data_perawat.jsp'><i class="fa-solid fa-user-nurse"></i> Data Perawat</a></li>
            <li><a href='data_pasien.jsp'><i class="fa-solid fa-users"></i> Data Pasien</a></li>
            <li><a href='data_kamar_isolasi.jsp'><i class="fa-solid fa-bed"></i> Data Kamar Isolasi</a></li>
            <li><a href='jadwal_dokter.jsp'><i class="fa-regular fa-calendar-check"></i> Jadwal Dokter</a></li>
            <li><a href='rekam_medis_master.jsp'><i class="fa-solid fa-notes-medical"></i> Rekam Medis Master</a></li>
            <li><a href='laporan_bulanan.jsp'><i class="fa-solid fa-chart-line"></i> Laporan Bulanan</a></li>
            <li><a href='tambah_pasien.jsp'><i class="fa-solid fa-user-plus"></i> Tambah Pasien</a></li>
            <li><a href='pengaturan_sistem.jsp' class='active'><i class="fa-solid fa-palette"></i> Pengaturan Sistem</a></li>
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
                <i class="fa-solid fa-hospital-user" style="color: var(--primary-color);"></i>
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
                    <h1>Pengaturan Sistem, Tema & Logo Web</h1>
                    <p>Kustomisasi skema warna antarmuka (UI), ganti logo rumah sakit, dan pratinjau perubahan secara real-time.</p>
                </div>
            </div>

            <% if ("theme_saved".equals(request.getParameter("status"))) { %>
                <div style="background:#dcfce7; border:1px solid #86efac; border-left:4px solid #16a34a; padding:12px 18px; border-radius:8px; margin-bottom:20px; font-size:13.5px; color:#166534; display:flex; align-items:center; gap:10px;">
                    <i class="fa-solid fa-circle-check" style="font-size:18px;"></i>
                    <span><strong>Berhasil Disimpan!</strong> Pengaturan tema warna dan logo web telah disimpan ke sesi sistem dan langsung aktif.</span>
                </div>
            <% } %>

            <!-- TWO COLUMN SETTINGS & PREVIEW -->
            <div class="settings-container">
                
                <!-- KOLOM KIRI: FORM PENGATURAN TEMA & LOGO -->
                <div>
                    <!-- FORM KUSTOMISASI TEMA & LOGO MENUJU SERVLET:
                         - Menggunakan enctype="multipart/form-data" untuk upload gambar logo
                         - Action mengarah ke PengaturanServlet (action=save_theme)
                    -->
                    <form action="<%= request.getContextPath() %>/PengaturanServlet?action=save_theme" method="POST" enctype="multipart/form-data">
                        
                        <!-- 1. KUSTOMISASI SKEMA WARNA -->
                        <div class="card">
                            <div class="card-title">
                                <i class="fa-solid fa-palette" style="color: var(--primary-color);"></i>
                                Kustomisasi Tema Warna Web
                            </div>

                            <div class="color-grid">
                                <!-- Warna Utama -->
                                <div class="color-item">
                                    <label for="primaryColorInput">Warna Utama (Primary / Tombol)</label>
                                    <div class="color-input-wrapper">
                                        <input type="color" id="primaryColorInput" name="primary_color" value="<%= primaryColor %>" oninput="updateLivePreview()">
                                        <span class="color-hex" id="hexPrimary"><%= primaryColor %></span>
                                    </div>
                                </div>

                                <!-- Warna Sekunder -->
                                <div class="color-item">
                                    <label for="secondaryColorInput">Warna Sekunder (Aksen / Teks Aktif)</label>
                                    <div class="color-input-wrapper">
                                        <input type="color" id="secondaryColorInput" name="secondary_color" value="<%= secondaryColor %>" oninput="updateLivePreview()">
                                        <span class="color-hex" id="hexSecondary"><%= secondaryColor %></span>
                                    </div>
                                </div>

                                <!-- Warna Background Sidebar -->
                                <div class="color-item">
                                    <label for="sidebarBgInput">Background Sidebar</label>
                                    <div class="color-input-wrapper">
                                        <input type="color" id="sidebarBgInput" name="sidebar_bg" value="<%= sidebarBgColor %>" oninput="updateLivePreview()">
                                        <span class="color-hex" id="hexSidebarBg"><%= sidebarBgColor %></span>
                                    </div>
                                </div>

                                <!-- Warna Teks Sidebar -->
                                <div class="color-item">
                                    <label for="sidebarTextInput">Warna Teks Menu Sidebar</label>
                                    <div class="color-input-wrapper">
                                        <input type="color" id="sidebarTextInput" name="sidebar_text" value="<%= sidebarTextColor %>" oninput="updateLivePreview()">
                                        <span class="color-hex" id="hexSidebarText"><%= sidebarTextColor %></span>
                                    </div>
                                </div>
                            </div>

                            <!-- TOMBOL RESET TEMA DEFAULT -->
                            <div style="display:flex; justify-content:flex-end;">
                                <button type="button" class="btn btn-secondary" onclick="resetThemeDefault()" style="padding:6px 12px; font-size:12px;">
                                    <i class="fa-solid fa-rotate-left"></i> Reset Tema Bawaan
                                </button>
                            </div>
                        </div>

                        <!-- 2. PENGATURAN LOGO RUMAH SAKIT -->
                        <div class="card">
                            <div class="card-title">
                                <i class="fa-solid fa-image" style="color: var(--primary-color);"></i>
                                Unggah Logo Rumah Sakit Baru
                            </div>

                            <p style="font-size:13px; color:#64748b; margin-bottom:12px;">
                                Format yang didukung: <strong>PNG, JPG, SVG, WebP</strong>. Disarankan gambar rasio persegi atau horizontal dengan latar transparan (maks. 2MB).
                            </p>

                            <!-- FILE UPLOAD INPUT -->
                            <div class="file-upload-box">
                                <input type="file" id="logoUploadInput" name="hospital_logo" accept="image/*" onchange="previewUploadedLogo(this)">
                                <div class="upload-icon">
                                    <i class="fa-solid fa-cloud-arrow-up"></i>
                                </div>
                                <div style="font-size:13.5px; font-weight:600; color:#334155;">
                                    Klik atau seret file logo ke area ini
                                </div>
                                <div style="font-size:11.5px; color:#94a3b8; margin-top:4px;" id="uploadFileNameLabel">
                                    Belum ada file baru yang dipilih
                                </div>
                            </div>
                        </div>

                        <!-- TOMBOL SIMPAN KE DATABASE / SERVLET -->
                        <div style="display:flex; gap:12px; align-items:center;">
                            <!-- 
                                LOGIKA PEMROSESAN SERVLET:
                                1. Membaca Part 'hospital_logo' via request.getPart() dan menyimpannya ke folder `/assets/images/logo.png`
                                2. Membaca parameter 'primary_color', 'secondary_color', 'sidebar_bg', 'sidebar_text'
                                3. Menyimpan nilai ke database / table `pengaturan_sistem` atau memperbarui session pengguna.
                            -->
                            <button type="submit" class="btn btn-primary">
                                <i class="fa-solid fa-floppy-disk"></i> Simpan Pengaturan Tema & Logo
                            </button>
                            <span style="font-size:12px; color:#64748b;">
                                <i class="fa-solid fa-circle-check" style="color:#10b981;"></i> Perubahan akan langsung aktif di seluruh sesi.
                            </span>
                        </div>
                    </form>
                </div>

                <!-- KOLOM KANAN: PREVIEW REAL-TIME (SEKETIKA) -->
                <div class="preview-pane">
                    <div class="card" style="padding: 18px;">
                        <div style="font-size:14px; font-weight:700; color:#0f172a; margin-bottom:12px; display:flex; align-items:center; gap:8px;">
                            <i class="fa-solid fa-eye" style="color:var(--primary-color);"></i> Pratinjau Tampilan (Live Preview)
                        </div>

                        <!-- MINIATUR BROWSER MOCKUP -->
                        <div class="mockup-wrapper">
                            <div class="mockup-header">
                                <span class="circle" style="background:#ef4444;"></span>
                                <span class="circle" style="background:#f59e0b;"></span>
                                <span class="circle" style="background:#10b981;"></span>
                                <span style="margin-left:8px;">RS Khusus ODGJ - Antarmuka Pengguna</span>
                            </div>

                            <div class="mockup-body">
                                <!-- MINIATUR SIDEBAR -->
                                <div class="mockup-sidebar" id="previewSidebar" style="background-color: <%= sidebarBgColor %>;">
                                    <div class="mockup-logo-area">
                                        <img src="<%= (logoPath != null) ? request.getContextPath() + "/" + logoPath : "https://cdn-icons-png.flaticon.com/512/3063/3063176.png" %>" 
                                             id="previewLogoImg" 
                                             alt="Logo" 
                                             class="mockup-logo-img">
                                        <span id="previewLogoText" style="color: <%= secondaryColor %>;">RS ODGJ</span>
                                    </div>

                                    <ul class="mockup-menu">
                                        <li class="mockup-menu-item" id="previewActiveMenu" style="background: rgba(255,255,255,0.1); color: #ffffff; border-left: 2px solid <%= primaryColor %>;">
                                            <i class="fa-solid fa-gauge" id="previewActiveIcon" style="color: <%= secondaryColor %>; font-size:9px;"></i> Dashboard
                                        </li>
                                        <li class="mockup-menu-item" id="previewMenuItem" style="color: <%= sidebarTextColor %>;">
                                            <i class="fa-solid fa-users" style="font-size:9px;"></i> Data Pasien
                                        </li>
                                        <li class="mockup-menu-item" id="previewMenuItem2" style="color: <%= sidebarTextColor %>;">
                                            <i class="fa-solid fa-bed" style="font-size:9px;"></i> Kamar Isolasi
                                        </li>
                                    </ul>
                                </div>

                                <!-- MINIATUR CONTENT -->
                                <div class="mockup-content">
                                    <div class="mockup-topbar">
                                        <span style="color:#64748b; font-weight:600;">Sistem Informasi Jiwa</span>
                                        <span style="color:#0f172a; font-weight:700;">Admin</span>
                                    </div>

                                    <div class="mockup-card">
                                        <div style="font-size:11px; font-weight:700; color:#0f172a;">Ringkasan Data</div>
                                        <p style="font-size:9.5px; color:#64748b; line-height:1.4;">
                                            Ini adalah contoh pratinjau komponen tombol dan aksen warna di halaman aplikasi.
                                        </p>
                                        <button type="button" class="mockup-button" id="previewMockupBtn" style="background-color: <%= primaryColor %>;">
                                            Tombol Utama
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div style="margin-top:14px; font-size:11.5px; color:#64748b; text-align:center;">
                            <i class="fa-solid fa-wand-magic-sparkles"></i> Geser pemilih warna di sebelah kiri untuk melihat perubahan warna secara langsung di area ini dan layout utama.
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <!-- JAVASCRIPT: REAL-TIME PREVIEW CONTROLLER -->
    <script>
        // 1. Update Preview Warna Seketika (Real-time Live Preview)
        function updateLivePreview() {
            const primary = document.getElementById('primaryColorInput').value;
            const secondary = document.getElementById('secondaryColorInput').value;
            const sidebarBg = document.getElementById('sidebarBgInput').value;
            const sidebarText = document.getElementById('sidebarTextInput').value;

            // Perbarui label kode HEX di form
            document.getElementById('hexPrimary').innerText = primary;
            document.getElementById('hexSecondary').innerText = secondary;
            document.getElementById('hexSidebarBg').innerText = sidebarBg;
            document.getElementById('hexSidebarText').innerText = sidebarText;

            // 1. Perbarui Elemen di Miniatur Mockup
            document.getElementById('previewSidebar').style.backgroundColor = sidebarBg;
            document.getElementById('previewLogoText').style.color = secondary;
            document.getElementById('previewActiveIcon').style.color = secondary;
            document.getElementById('previewActiveMenu').style.borderLeftColor = primary;
            document.getElementById('previewMenuItem').style.color = sidebarText;
            document.getElementById('previewMenuItem2').style.color = sidebarText;
            document.getElementById('previewMockupBtn').style.backgroundColor = primary;

            // 2. Terapkan langsung ke CSS Variables Halaman Utama untuk pengalaman interaktif
            document.documentElement.style.setProperty('--primary-color', primary);
            document.documentElement.style.setProperty('--secondary-color', secondary);
            document.documentElement.style.setProperty('--sidebar-bg', sidebarBg);
            document.documentElement.style.setProperty('--sidebar-text', sidebarText);
        }

        // 2. Pratinjau Gambar Logo Baru yang Diunggah
        function previewUploadedLogo(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];
                document.getElementById('uploadFileNameLabel').innerText = "File terpilih: " + file.name + " (" + Math.round(file.size / 1024) + " KB)";

                const reader = new FileReader();
                reader.onload = function(e) {
                    // Update logo di miniatur preview
                    const previewImg = document.getElementById('previewLogoImg');
                    previewImg.src = e.target.result;

                    // Update logo di sidebar utama jika elemen gambar ada
                    const sidebarLogo = document.getElementById('sidebarLogoImg');
                    if (sidebarLogo) {
                        sidebarLogo.src = e.target.result;
                    }
                };
                reader.readAsDataURL(file);
            }
        }

        // 3. Reset Tema Bawaan
        function resetThemeDefault() {
            document.getElementById('primaryColorInput').value = "#0284c7";
            document.getElementById('secondaryColorInput').value = "#38bdf8";
            document.getElementById('sidebarBgInput').value = "#0f172a";
            document.getElementById('sidebarTextInput').value = "#cbd5e1";
            updateLivePreview();
        }
    </script>
</body>
</html>

