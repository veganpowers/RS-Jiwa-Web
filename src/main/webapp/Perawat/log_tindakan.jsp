<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || !"perawat".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pemberian Obat Pasien - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="log" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Log Pemberian Obat Pasien" />
            <jsp:param name="subtitle" value="Checklist Verifikasi Minum Obat Pasien Rawat Inap & Isolasi" />
        </jsp:include>

        <% if ("sukses".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Status pemberian obat berhasil diperbarui!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-pills me-2 text-primary"></i> Jadwal & Daftar Resep Obat Pasien</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Tgl Resep</th>
                                <th>No. RM & Nama Pasien</th>
                                <th>Kamar</th>
                                <th>Nama Obat & Dosis</th>
                                <th>Aturan Pakai</th>
                                <th>Status Minum / Obat</th>
                                <th class="text-center" style="width: 160px;">Aksi Verifikasi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                Statement stmt = null;
                                ResultSet rs = null;
                                int count = 0;
                                try {
                                    conn = Koneksi.getConnection();
                                    stmt = conn.createStatement();
                                    String sql = "SELECT r.id_resep, r.tgl_resep, r.jumlah, r.aturan_pakai, r.status_tebus, " +
                                                 "p.no_rekam_medis, p.nama AS nama_pasien, k.nama_kamar, o.nama_obat " +
                                                 "FROM resep_obat r " +
                                                 "JOIN pasien p ON r.id_pasien = p.id_pasien " +
                                                 "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                 "JOIN obat o ON r.id_obat = o.id_obat " +
                                                 "ORDER BY r.id_resep DESC";
                                    rs = stmt.executeQuery(sql);
                                    while (rs.next()) {
                                        count++;
                                        int idResep = rs.getInt("id_resep");
                                        String tgl = rs.getString("tgl_resep");
                                        String noRm = rs.getString("no_rekam_medis");
                                        String namaPasien = rs.getString("nama_pasien");
                                        String namaKamar = rs.getString("nama_kamar");
                                        if (namaKamar == null || namaKamar.trim().isEmpty()) namaKamar = "Belum Ada Kamar";
                                        String namaObat = rs.getString("nama_obat");
                                        int jml = rs.getInt("jumlah");
                                        String aturan = rs.getString("aturan_pakai");
                                        String status = rs.getString("status_tebus");
                            %>
                            <tr>
                                <td><small class="text-muted"><%= tgl != null ? tgl.substring(0, 16) : "-" %></small></td>
                                <td>
                                    <strong><%= namaPasien %></strong><br>
                                    <small class="text-muted"><%= noRm %></small>
                                </td>
                                <td>
                                    <span class="badge <%= namaKamar.toLowerCase().contains("isolasi") ? "bg-danger" : "bg-info text-dark" %>">
                                        <%= namaKamar %>
                                    </span>
                                </td>
                                <td>
                                    <strong><%= namaObat %></strong><br>
                                    <small class="text-muted"><%= jml %> unit / tablet</small>
                                </td>
                                <td><%= aturan %></td>
                                <td>
                                    <% if ("Sudah Diberikan".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i> Sudah Diminum</span>
                                    <% } else if ("Sudah Diambil".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-primary"><i class="fa-solid fa-box-open me-1"></i> Siap Diberikan</span>
                                    <% } else if ("Diproses Farmasi".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-warning text-dark"><i class="fa-solid fa-spinner me-1"></i> Di Farmasi</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary"><i class="fa-solid fa-clock me-1"></i> Menunggu Resep</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <% if ("Sudah Diberikan".equalsIgnoreCase(status)) { %>
                                        <button class="btn btn-sm btn-outline-secondary" disabled>Selesai</button>
                                    <% } else { %>
                                        <a href="<%= request.getContextPath() %>/PerawatServlet?action=berikan_obat&id=<%= idResep %>" 
                                           class="btn btn-sm btn-success" 
                                           onclick="return confirm('Konfirmasi bahwa pasien <%= namaPasien %> telah menerima dan meminum <%= namaObat %>?')">
                                            <i class="fa-solid fa-check me-1"></i> Berikan
                                        </a>
                                    <% } %>
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

                                if (count == 0) {
                            %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">Belum ada resep obat untuk diverifikasi.</td>
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
