<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- SIDEBAR SEDERHANA ROLE DOKTER -->
<div class="sidebar d-flex flex-column p-3 text-white" style="width: 250px; min-height: 100vh; background-color: #343a40;">
    <h5 class="mb-1 text-primary fw-bold"><i class="fa-solid fa-hospital"></i> RS ODGJ</h5>
    <small class="text-secondary mb-4">Panel Dokter Spesialis</small>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="dashboard.jsp" class="nav-link ${param.active == 'dashboard' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-gauge me-2"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="daftar_pasien_rawat.jsp" class="nav-link ${param.active == 'pasien' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-users me-2"></i> Pasien Rawat
            </a>
        </li>
        <li>
            <a href="input_diagnosa.jsp" class="nav-link ${param.active == 'diagnosa' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-stethoscope me-2"></i> Input Diagnosa
            </a>
        </li>
        <li>
            <a href="resep_obat.jsp" class="nav-link ${param.active == 'resep' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-pills me-2"></i> Resep Obat
            </a>
        </li>
        <li>
            <a href="jadwal_terapi_grup.jsp" class="nav-link ${param.active == 'terapi' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-calendar-days me-2"></i> Jadwal Terapi
            </a>
        </li>
        <li>
            <a href="riwayat_konsultasi.jsp" class="nav-link ${param.active == 'riwayat' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-clock-rotate-left me-2"></i> Riwayat Konsultasi
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
