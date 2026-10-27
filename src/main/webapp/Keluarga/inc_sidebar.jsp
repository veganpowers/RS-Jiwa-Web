<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- SIDEBAR SEDERHANA ROLE KELUARGA -->
<div class="sidebar d-flex flex-column p-3 text-white" style="width: 260px; min-width: 260px; max-width: 260px; min-height: 100vh; flex-shrink: 0;">
    <h5 class="mb-1 text-primary fw-bold"><i class="fa-solid fa-hospital"></i> RS ODGJ</h5>
    <small class="text-secondary mb-4">Portal Keluarga Pasien</small>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="dashboard.jsp" class="nav-link ${param.active == 'dashboard' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-house me-2"></i> Beranda
            </a>
        </li>
        <li>
            <a href="info_perkembangan.jsp" class="nav-link ${param.active == 'perkembangan' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-chart-line me-2"></i> Perkembangan Pasien
            </a>
        </li>
        <li>
            <a href="jadwal_besuk.jsp" class="nav-link ${param.active == 'besuk' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-calendar-check me-2"></i> Izin Besuk
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

