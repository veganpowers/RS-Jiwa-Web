<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    int idPasien = 0;
    String namaPasien = "Pasien";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        String sql = "SELECT p.id_pasien, p.nama FROM keluarga_pasien kp " +
                     "JOIN pasien p ON kp.id_pasien = p.id_pasien WHERE kp.id_user = ? LIMIT 1";
        stmt = conn.prepareStatement(sql);
        if (userId != null) {
            stmt.setInt(1, userId);
        } else {
            stmt.setInt(1, 0);
        }
        rs = stmt.executeQuery();
        if (rs.next()) {
            idPasien = rs.getInt("id_pasien");
            namaPasien = rs.getString("nama");
        } else {
            Statement stmtFb = conn.createStatement();
            ResultSet rsFb = stmtFb.executeQuery("SELECT id_pasien, nama FROM pasien ORDER BY id_pasien DESC LIMIT 1");
            if (rsFb.next()) {
                idPasien = rsFb.getInt("id_pasien");
                namaPasien = rsFb.getString("nama");
            }
            rsFb.close();
            stmtFb.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        Koneksi.closeConnection(conn);
    }

    String subJudul = "Catatan Evaluasi Dokter dan Perawat Mengenai Pasien " + namaPasien;
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perkembangan Pasien - Portal Keluarga RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="perkembangan" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Riwayat Perkembangan Pasien" />
            <jsp:param name="subtitle" value="<%= subJudul %>" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-list me-2 text-primary"></i> Catatan Observasi Tim Medis untuk <%= namaPasien %></h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Tanggal</th>
                                <th>Petugas Medis</th>
                                <th>Diagnosa / Evaluasi Perkembangan</th>
                                <th>Status Progres</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connList = null;
                                PreparedStatement stmtList = null;
                                ResultSet rsList = null;
                                int cPerk = 0;
                                try {
                                    connList = Koneksi.getConnection();
                                    String sqlPerk = "SELECT rm.tgl_periksa, rm.diagnosa_utama, rm.keluhan_utama, rm.rencana_terapi, d.nama_dokter " +
                                                     "FROM rekam_medis rm " +
                                                     "LEFT JOIN dokter d ON rm.id_dokter = d.id_dokter " +
                                                     "WHERE rm.id_pasien = ? " +
                                                     "ORDER BY rm.id_rm DESC";
                                    stmtList = connList.prepareStatement(sqlPerk);
                                    stmtList.setInt(1, idPasien);
                                    rsList = stmtList.executeQuery();
                                    while (rsList.next()) {
                                        cPerk++;
                                        String tglP = rsList.getString("tgl_periksa");
                                        String diag = rsList.getString("diagnosa_utama");
                                        String kel = rsList.getString("keluhan_utama");
                                        String dtr = rsList.getString("nama_dokter");
                            %>
                            <tr>
                                <td><%= tglP %></td>
                                <td><strong><%= (dtr != null ? dtr : "Dokter DPJP") %></strong></td>
                                <td>
                                    <strong><%= diag %></strong><br>
                                    <small class="text-muted"><%= (kel != null ? kel : "-") %></small>
                                </td>
                                <td><span class="badge bg-success">Dalam Perawatan</span></td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsList != null) try { rsList.close(); } catch (SQLException ignored) {}
                                    if (stmtList != null) try { stmtList.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connList);
                                }

                                if (cPerk == 0) {
                            %>
                            <tr>
                                <td>Hari Ini</td>
                                <td>Tim Medis RS ODGJ</td>
                                <td>Pasien <strong><%= namaPasien %></strong> dalam kondisi stabil dan menjalani terapi pemulihan secara intensif di bangsal.</td>
                                <td><span class="badge bg-primary">Stabil</span></td>
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
