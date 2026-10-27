<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || !"farmasi".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Antrean Resep - Farmasi RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="antrian" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Daftar Antrean Resep Obat" />
            <jsp:param name="subtitle" value="Verifikasi dan Penyiapan Resep Elektronik Pasien" />
        </jsp:include>

        <% if ("sukses".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Status antrean resep dan stok obat berhasil diperbarui!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-list-check me-2 text-primary"></i> Tabel Antrean Resep Pasien</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. Resep</th>
                                <th>Nama Pasien</th>
                                <th>Dokter Peresep</th>
                                <th>Nama Obat & Dosis</th>
                                <th>Aturan Pakai</th>
                                <th>Status</th>
                                <th class="text-center" style="width: 220px;">Aksi Farmasi</th>
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
                                    String sql = "SELECT r.id_resep, r.tgl_resep, r.jumlah, r.aturan_pakai, r.status_tebus, r.catatan_resep, " +
                                                 "p.no_rekam_medis, p.nama AS nama_pasien, k.nama_kamar, " +
                                                 "d.nama_dokter, o.nama_obat, o.stok " +
                                                 "FROM resep_obat r " +
                                                 "JOIN pasien p ON r.id_pasien = p.id_pasien " +
                                                 "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                 "JOIN dokter d ON r.id_dokter = d.id_dokter " +
                                                 "JOIN obat o ON r.id_obat = o.id_obat " +
                                                 "ORDER BY r.id_resep DESC";
                                    rs = stmt.executeQuery(sql);
                                    while (rs.next()) {
                                        count++;
                                        int idResep = rs.getInt("id_resep");
                                        String noResep = "#RX-" + String.format("%04d", idResep);
                                        String namaPasien = rs.getString("nama_pasien");
                                        String kamar = rs.getString("nama_kamar");
                                        if (kamar == null) kamar = "Rawat Jalan";
                                        String namaDokter = rs.getString("nama_dokter");
                                        String namaObat = rs.getString("nama_obat");
                                        int jumlah = rs.getInt("jumlah");
                                        int stokSisa = rs.getInt("stok");
                                        String aturan = rs.getString("aturan_pakai");
                                        String status = rs.getString("status_tebus");
                            %>
                            <tr>
                                <td><strong><%= noResep %></strong></td>
                                <td>
                                    <strong><%= namaPasien %></strong><br>
                                    <small class="badge bg-light text-secondary border"><%= kamar %></small>
                                </td>
                                <td><%= namaDokter %></td>
                                <td>
                                    <strong><%= namaObat %></strong><br>
                                    <small class="text-muted"><%= jumlah %> unit (Stok: <%= stokSisa %>)</small>
                                </td>
                                <td><%= aturan %></td>
                                <td>
                                    <% if ("Menunggu".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-danger">Menunggu Racik</span>
                                    <% } else if ("Diproses Farmasi".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-warning text-dark"><i class="fa-solid fa-spinner fa-spin me-1"></i> Sedang Diracik</span>
                                    <% } else if ("Sudah Diambil".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-primary"><i class="fa-solid fa-box me-1"></i> Diserahkan ke Ners</span>
                                    <% } else if ("Sudah Diberikan".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i> Selesai (Pasien Minum)</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary"><%= status %></span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <% if ("Menunggu".equalsIgnoreCase(status)) { %>
                                        <a href="<%= request.getContextPath() %>/FarmasiServlet?action=racik&id=<%= idResep %>" 
                                           class="btn btn-sm btn-primary">
                                            <i class="fa-solid fa-mortar-pestle me-1"></i> Racik Obat
                                        </a>
                                    <% } else if ("Diproses Farmasi".equalsIgnoreCase(status)) { %>
                                        <a href="<%= request.getContextPath() %>/FarmasiServlet?action=serahkan&id=<%= idResep %>" 
                                           class="btn btn-sm btn-success" 
                                           onclick="return confirm('Serahkan obat ini ke Ners/Perawat ruangan dan kurangi stok obat?')">
                                            <i class="fa-solid fa-hand-holding-medical me-1"></i> Siap & Serahkan
                                        </a>
                                    <% } else { %>
                                        <button class="btn btn-sm btn-outline-secondary" disabled>Telah Diproses</button>
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
                                <td colspan="7" class="text-center py-4 text-muted">Belum ada antrean resep obat.</td>
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
