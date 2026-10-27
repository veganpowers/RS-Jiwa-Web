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
    <title>Jadwal Terapi Aktivitas Kelompok (TAK) - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="tak" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Terapi Aktivitas Kelompok (TAK)" />
            <jsp:param name="subtitle" value="Jadwal Rehabilitasi Psikososial dan Evaluasi Dinamika Pasien" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-users-gear me-2 text-primary"></i> Jadwal Sesi TAK & Okupasi Aktif</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Hari & Jam</th>
                                <th>Nama Terapi</th>
                                <th>Jenis TAK</th>
                                <th>Dokter PJ & Fasilitator</th>
                                <th>Ruangan</th>
                                <th>Status</th>
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
                                    String sql = "SELECT tg.*, d.nama_dokter, p.nama_perawat " +
                                                 "FROM jadwal_terapi_grup tg " +
                                                 "LEFT JOIN dokter d ON tg.id_dokter_pj = d.id_dokter " +
                                                 "LEFT JOIN perawat p ON tg.id_perawat_fasilitator = p.id_perawat " +
                                                 "ORDER BY FIELD(tg.hari, 'Senin','Selasa','Rabu','Kamis','Jumat','Sabtu'), tg.jam_mulai ASC";
                                    rs = stmt.executeQuery(sql);
                                    while (rs.next()) {
                                        count++;
                                        String hari = rs.getString("hari");
                                        Time jmMulai = rs.getTime("jam_mulai");
                                        Time jmSelesai = rs.getTime("jam_selesai");
                                        String jamStr = (jmMulai != null ? jmMulai.toString().substring(0, 5) : "") + " - " + 
                                                        (jmSelesai != null ? jmSelesai.toString().substring(0, 5) : "") + " WIB";
                                        String namaT = rs.getString("nama_terapi");
                                        String jenisT = rs.getString("jenis_terapi");
                                        String dokter = rs.getString("nama_dokter");
                                        String ners = rs.getString("nama_perawat");
                                        String ruangan = rs.getString("lokasi_ruangan");
                                        String status = rs.getString("status");
                            %>
                            <tr>
                                <td>
                                    <strong><%= hari %></strong><br>
                                    <small class="badge bg-light text-dark border"><%= jamStr %></small>
                                </td>
                                <td>
                                    <strong><%= namaT %></strong>
                                </td>
                                <td><span class="badge bg-secondary"><%= jenisT %></span></td>
                                <td>
                                    <strong><%= dokter != null ? dokter : "-" %></strong><br>
                                    <small class="text-muted">Fasilitator: <%= ners != null ? ners : "-" %></small>
                                </td>
                                <td><%= ruangan %></td>
                                <td>
                                    <% if ("Berjalan".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-success">Berjalan</span>
                                    <% } else if ("Selesai".equalsIgnoreCase(status)) { %>
                                        <span class="badge bg-secondary">Selesai</span>
                                    <% } else { %>
                                        <span class="badge bg-primary">Terjadwal</span>
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
                                <td colspan="6" class="text-center py-4 text-muted">Belum ada jadwal terapi kelompok.</td>
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
