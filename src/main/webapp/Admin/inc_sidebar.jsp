<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- SIDEBAR UTAMA ADMINISTRATOR (LENGKAP SEMUA FITUR CRUD) -->
<div class="sidebar d-flex flex-column p-3 text-white" style="width: 260px; min-width: 260px; max-width: 260px; min-height: 100vh; flex-shrink: 0;">
    <h5 class="mb-1 text-primary fw-bold"><i class="fa-solid fa-hospital"></i> RS ODGJ</h5>
    <small class="text-secondary mb-3">Panel Administrator</small>
    
    <div class="text-uppercase text-secondary fw-bold" style="font-size: 11px; margin-bottom: 5px;">Data Master</div>
    <ul class="nav nav-pills flex-column mb-2">
        <li class="nav-item">
            <a href="dashboard.jsp" class="nav-link ${param.active == 'dashboard' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-gauge me-2"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="data_dokter.jsp" class="nav-link ${param.active == 'dokter' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-user-doctor me-2"></i> Kelola Dokter
            </a>
        </li>
        <li>
            <a href="data_perawat.jsp" class="nav-link ${param.active == 'perawat' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-user-nurse me-2"></i> Kelola Perawat
            </a>
        </li>
        <li>
            <a href="data_pasien.jsp" class="nav-link ${param.active == 'pasien' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-bed-pulse me-2"></i> Kelola Pasien
            </a>
        </li>
        <li>
            <a href="data_kamar_isolasi.jsp" class="nav-link ${param.active == 'kamar' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-door-closed me-2"></i> Kelola Kamar
            </a>
        </li>
        <li>
            <a href="kelola_obat.jsp" class="nav-link ${param.active == 'obat' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-pills me-2"></i> Kelola Obat
            </a>
        </li>
    </ul>

    <div class="text-uppercase text-secondary fw-bold" style="font-size: 11px; margin-bottom: 5px; margin-top: 5px;">Pelayanan & Medis</div>
    <ul class="nav nav-pills flex-column mb-auto">
        <li>
            <a href="jadwal_dokter.jsp" class="nav-link ${param.active == 'jadwal' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-calendar-days me-2"></i> Jadwal Praktik
            </a>
        </li>
        <li>
            <a href="rekam_medis_master.jsp" class="nav-link ${param.active == 'rekam' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-notes-medical me-2"></i> Rekam Medis
            </a>
        </li>
        <li>
            <a href="kelola_tagihan.jsp" class="nav-link ${param.active == 'tagihan' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-file-invoice-dollar me-2"></i> Kelola Tagihan
            </a>
        </li>
        <li>
            <a href="laporan_bulanan.jsp" class="nav-link ${param.active == 'laporan' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-chart-simple me-2"></i> Laporan
            </a>
        </li>
        <li>
            <a href="kelola_user.jsp" class="nav-link ${param.active == 'user' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-users-gear me-2"></i> Kelola Akun User
            </a>
        </li>
    </ul>

    <hr>
    <div>
        <a href="<%= request.getContextPath() %>/LoginServlet?action=logout" class="btn btn-danger w-100 text-white text-center">
            <i class="fa-solid fa-right-from-bracket me-1"></i> Logout
        </a>
    </div>
</div>

