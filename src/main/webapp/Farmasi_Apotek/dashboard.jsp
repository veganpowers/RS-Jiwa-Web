<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || !"farmasi".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    int antreanMenunggu = 0;
    int resepSelesai = 0;
    int stokKritis = 0;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        stmt = conn.createStatement();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM resep_obat WHERE status_tebus IN ('Menunggu', 'Diproses Farmasi')");
        if (rs.next()) antreanMenunggu = rs.getInt(1);
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM resep_obat WHERE status_tebus IN ('Sudah Diambil', 'Sudah Diberikan')");
        if (rs.next()) resepSelesai = rs.getInt(1);
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM obat WHERE stok <= 10");
        if (rs.next()) stokKritis = rs.getInt(1);
        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Farmasi - RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dashboard" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Dashboard Instalasi Farmasi" />
            <jsp:param name="subtitle" value="Manajemen Resep, Obat Masuk, dan Monitoring Stok Psikofarmaka" />
        </jsp:include>

        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-clock-rotate-left fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">ANTREAN RESEP MENUNGGU</small>
                            <h3 class="fw-bold mb-0"><%= antreanMenunggu %> Resep</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-check-double fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">RESEP SELESAI</small>
                            <h3 class="fw-bold mb-0"><%= resepSelesai %> Resep</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-danger bg-opacity-10 text-danger rounded-3 me-3"><i class="fa-solid fa-boxes-stacked fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">STOK OBAT KRITIS (&le; 10)</small>
                            <h3 class="fw-bold mb-0"><%= stokKritis %> Item</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-receipt me-2 text-primary"></i> Resep Masuk Perlu Diracik</h6>
                <a href="antrian_resep.jsp" class="btn btn-sm btn-primary">Lihat Semua Antrean</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. Resep</th>
                                <th>Nama Pasien</th>
                                <th>Dokter</th>
                                <th>Rincian Obat</th>
                                <th>Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int countTable = 0;
                                try {
                                    String sql = "SELECT r.id_resep, p.nama AS nama_pasien, k.nama_kamar, d.nama_dokter, o.nama_obat, r.jumlah, r.status_tebus " +
                                                 "FROM resep_obat r " +
                                                 "JOIN pasien p ON r.id_pasien = p.id_pasien " +
                                                 "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                 "JOIN dokter d ON r.id_dokter = d.id_dokter " +
                                                 "JOIN obat o ON r.id_obat = o.id_obat " +
                                                 "WHERE r.status_tebus IN ('Menunggu', 'Diproses Farmasi') " +
                                                 "ORDER BY r.id_resep DESC LIMIT 5";
                                    rs = stmt.executeQuery(sql);
                                    while (rs.next()) {
                                        countTable++;
                                        int idRes = rs.getInt("id_resep");
                                        String nmP = rs.getString("nama_pasien");
                                        String kmr = rs.getString("nama_kamar");
                                        if (kmr == null) kmr = "Rawat Jalan";
                                        String nmD = rs.getString("nama_dokter");
                                        String nmO = rs.getString("nama_obat");
                                        int jml = rs.getInt("jumlah");
                                        String st = rs.getString("status_tebus");
                            %>
                            <tr>
                                <td><strong>#RX-<%= String.format("%04d", idRes) %></strong></td>
                                <td><%= nmP %> (<%= kmr %>)</td>
                                <td><%= nmD %></td>
                                <td><%= nmO %> - <%= jml %> unit</td>
                                <td>
                                    <% if ("Menunggu".equalsIgnoreCase(st)) { %>
                                        <span class="badge bg-warning text-dark">Menunggu Racik</span>
                                    <% } else { %>
                                        <span class="badge bg-info text-dark"><i class="fa-solid fa-spinner fa-spin me-1"></i> Sedang Diracik</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <a href="antrian_resep.jsp" class="btn btn-sm btn-success">Proses</a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(conn);
                                }

                                if (countTable == 0) {
                            %>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">Tidak ada resep yang perlu diracik saat ini. Semua telah selesai!</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
