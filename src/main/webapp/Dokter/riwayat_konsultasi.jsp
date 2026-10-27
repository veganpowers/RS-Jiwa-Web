<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || !"dokter".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Konsultasi & Diagnosa - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="riwayat" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Riwayat Pemeriksaan Pasien" />
            <jsp:param name="subtitle" value="Rekam Medis Historis Hasil Pemeriksaan & Diagnosa Jiwa" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Catatan Konsultasi & Diagnosa Terakhir</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Tanggal</th>
                                <th>No. RM</th>
                                <th>Nama Pasien</th>
                                <th>Keluhan / Kondisi</th>
                                <th>Hasil Diagnosa</th>
                                <th>Dokter Pemeriksa</th>
                                <th>Tindakan / Terapi</th>
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
                                    String sql = "SELECT rm.*, p.nama AS nama_pasien, p.no_rekam_medis, d.nama_dokter " +
                                                 "FROM rekam_medis rm " +
                                                 "JOIN pasien p ON rm.id_pasien = p.id_pasien " +
                                                 "LEFT JOIN dokter d ON rm.id_dokter = d.id_dokter " +
                                                 "ORDER BY rm.id_rm DESC";
                                    rs = stmt.executeQuery(sql);
                                    while (rs.next()) {
                                        count++;
                                        String tgl = rs.getString("tgl_periksa");
                                        String noRm = rs.getString("no_rekam_medis");
                                        String namaPasien = rs.getString("nama_pasien");
                                        String keluhan = rs.getString("keluhan_utama");
                                        String diagnosa = rs.getString("diagnosa_utama");
                                        String dokter = rs.getString("nama_dokter");
                                        String tindakan = rs.getString("rencana_terapi");
                            %>
                            <tr>
                                <td><small class="text-muted"><%= tgl != null ? tgl.substring(0, 10) : "-" %></small></td>
                                <td><strong><%= noRm %></strong></td>
                                <td><%= namaPasien %></td>
                                <td><small><%= keluhan != null ? keluhan : "-" %></small></td>
                                <td><span class="badge bg-primary"><%= diagnosa %></span></td>
                                <td><%= dokter != null ? dokter : "-" %></td>
                                <td><small><%= tindakan != null ? tindakan : "-" %></small></td>
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
                                <td colspan="7" class="text-center py-4 text-muted">Belum ada riwayat konsultasi / rekam medis.</td>
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
