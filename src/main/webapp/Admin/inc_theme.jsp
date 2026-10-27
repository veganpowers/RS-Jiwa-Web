<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Helper tema dinamis & logo dari session (dapat diubah via Pengaturan Sistem)
    String themePrimary = (session.getAttribute("theme_primary") != null) ? (String) session.getAttribute("theme_primary") : "#0284c7";
    String themeSecondary = (session.getAttribute("theme_secondary") != null) ? (String) session.getAttribute("theme_secondary") : "#38bdf8";
    String themeSidebarBg = (session.getAttribute("theme_sidebar_bg") != null) ? (String) session.getAttribute("theme_sidebar_bg") : "#0f172a";
    String themeSidebarText = (session.getAttribute("theme_sidebar_text") != null) ? (String) session.getAttribute("theme_sidebar_text") : "#cbd5e1";
    String themeLogo = (session.getAttribute("hospital_logo") != null) ? (String) session.getAttribute("hospital_logo") : null;
%>
<style>
    /* CSS Variables Dinamis Berdasarkan Sesi / Pengaturan Admin */
    :root {
        --primary-color: <%= themePrimary %>;
        --secondary-color: <%= themeSecondary %>;
        --sidebar-bg: <%= themeSidebarBg %>;
        --sidebar-text: <%= themeSidebarText %>;
    }

    /* Terapkan variabel warna ke komponen antarmuka */
    .sidebar { background-color: var(--sidebar-bg) !important; }
    .sidebar-header h2 { color: var(--secondary-color) !important; }
    .sidebar-menu li a { color: var(--sidebar-text) !important; }
    .sidebar-menu li a:hover { border-left-color: var(--primary-color) !important; }
    .sidebar-menu li a:hover i { color: var(--secondary-color) !important; }
    .sidebar-menu li a.active { border-left-color: var(--primary-color) !important; }
    .sidebar-menu li a.active i { color: var(--secondary-color) !important; }
    
    .btn-primary { background-color: var(--primary-color) !important; border-color: var(--primary-color) !important; }
    .pagination a.active { background: var(--primary-color) !important; border-color: var(--primary-color) !important; }
    .topbar .brand i { color: var(--primary-color) !important; }
</style>

