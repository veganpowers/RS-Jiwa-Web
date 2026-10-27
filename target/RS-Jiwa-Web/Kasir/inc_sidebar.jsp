<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- SIDEBAR SEDERHANA ROLE KASIR -->
<div class="sidebar d-flex flex-column p-3 text-white" style="width: 250px; min-height: 100vh; background-color: #343a40;">
    <h5 class="mb-1 text-primary fw-bold"><i class="fa-solid fa-hospital"></i> RS ODGJ</h5>
    <small class="text-secondary mb-4">Panel Kasir & Billing</small>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="dashboard.jsp" class="nav-link ${param.active == 'dashboard' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-gauge me-2"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="tagihan_perawatan.jsp" class="nav-link ${param.active == 'tagihan' ? 'active bg-primary' : 'text-white'} rounded mb-1">
                <i class="fa-solid fa-file-invoice-dollar me-2"></i> Tagihan Pasien
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

