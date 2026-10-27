<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- SIDEBAR SEDERHANA ROLE PERAWAT -->
<div class="sidebar d-flex flex-column p-3 text-white" style="width: 250px; min-height: 100vh; background-color: #343a40;">
    <h5 class="mb-1 text-primary fw-bold"><i class="fa-solid fa-hospital"></i> RS ODGJ</h5>
    <small class="text-secondary mb-3">Panel Perawat / Ners</small>
    
    <div class="text-uppercase text-secondary fw-bold" style="font-size: 11px; margin-bottom: 5px;">Penerimaan & Pasien</div>
    <ul class="nav nav-pills flex-column mb-2">
        <li class="nav-item">
            <a href="dashboard.jsp" class="nav-link ${param.active == 'dashboard' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-gauge me-2"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="pendaftaran_pasien.jsp" class="nav-link ${param.active == 'pendaftaran' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-user-plus me-2 text-warning"></i> Pendaftaran Pasien
            </a>
        </li>
        <li>
            <a href="jadwal_jaga.jsp" class="nav-link ${param.active == 'kamar' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-door-open me-2"></i> Update Kamar Pasien
            </a>
        </li>
    </ul>

    <div class="text-uppercase text-secondary fw-bold" style="font-size: 11px; margin-bottom: 5px; margin-top: 5px;">Asuhan & Observasi</div>
    <ul class="nav nav-pills flex-column mb-auto">
        <li>
            <a href="pantau_kondisi_harian.jsp" class="nav-link ${param.active == 'pantau' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-heart-pulse me-2"></i> Catatan Harian (TTV)
            </a>
        </li>
        <li>
            <a href="log_tindakan.jsp" class="nav-link ${param.active == 'log' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-pills me-2"></i> Pemberian Obat
            </a>
        </li>
        <li>
            <a href="insiden_darurat.jsp" class="nav-link ${param.active == 'insiden' ? 'active bg-primary' : 'text-white'} rounded mb-1 py-2">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> Laporan Insiden
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
