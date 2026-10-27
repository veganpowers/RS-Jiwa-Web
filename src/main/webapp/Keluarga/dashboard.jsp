<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String namaPasien = "Belum Terhubung";
    String noRm = "-";
    String usia = "-";
    String namaKamar = "Belum Ada Kamar";
    String statusPerawatan = "Rawat Inap";
    String namaDokter = "dr. Hendra Pratama, Sp.KJ";
    String tglMasuk = "-";
    String catatanTerakhir = "Pasien dalam pemantauan rutin tim asuhan keperawatan dan dokter penanggung jawab.";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        String sql = "SELECT p.*, k.nama_kamar, d.nama_dokter, kp.hubungan " +
                     "FROM keluarga_pasien kp " +
                     "JOIN pasien p ON kp.id_pasien = p.id_pasien " +
                     "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                     "LEFT JOIN dokter d ON p.id_dokter_dpjp = d.id_dokter " +
                     "WHERE kp.id_user = ? LIMIT 1";
        stmt = conn.prepareStatement(sql);
        if (userId != null) {
            stmt.setInt(1, userId);
        } else {
            stmt.setInt(1, 0);
        }
        rs = stmt.executeQuery();

        if (rs.next()) {
            namaPasien = rs.getString("nama");
            noRm = rs.getString("no_rekam_medis");
            String tglLahir = rs.getString("tgl_lahir");
            usia = (tglLahir != null) ? tglLahir : "-";
            String kmr = rs.getString("nama_kamar");
            if (kmr != null) namaKamar = kmr;
            statusPerawatan = rs.getString("status_perawatan");
            String dtr = rs.getString("nama_dokter");
            if (dtr != null) namaDokter = dtr;
            Timestamp tm = rs.getTimestamp("tgl_masuk");
            if (tm != null) tglMasuk = tm.toString().substring(0, 10);
        } else {
            // Jika login dummy / belum ada id_user, fallback ambil pasien terakhir yang terdaftar
            Statement stmtFallback = conn.createStatement();
            ResultSet rsFb = stmtFallback.executeQuery(
                "SELECT p.*, k.nama_kamar, d.nama_dokter FROM pasien p " +
                "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                "LEFT JOIN dokter d ON p.id_dokter_dpjp = d.id_dokter " +
                "ORDER BY p.id_pasien DESC LIMIT 1");
            if (rsFb.next()) {
                namaPasien = rsFb.getString("nama");
                noRm = rsFb.getString("no_rekam_medis");
                String kmr = rsFb.getString("nama_kamar");
                if (kmr != null) namaKamar = kmr;
                statusPerawatan = rsFb.getString("status_perawatan");
                String dtr = rsFb.getString("nama_dokter");
                if (dtr != null) namaDokter = dtr;
            }
            rsFb.close();
            stmtFallback.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
        Koneksi.closeConnection(conn);
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal Keluarga Pasien - RS Khusus ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dashboard" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Beranda Informasi Pasien" />
            <jsp:param name="subtitle" value="Monitoring Kondisi dan Informasi Perawatan Anggota Keluarga" />
        </jsp:include>

        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body p-4 bg-white">
                <div class="d-flex align-items-center mb-3">
                    <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-circle me-3"><i class="fa-solid fa-user fa-2x"></i></div>
                    <div>
                        <h4 class="fw-bold mb-1"><%= namaPasien %></h4>
                        <p class="text-muted mb-0">No. Rekam Medis: <strong><%= noRm %></strong> &bull; Ruang: <strong><%= namaKamar %></strong></p>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded border">
                            <small class="text-muted d-block">DOKTER PENANGGUNG JAWAB</small>
                            <strong><%= namaDokter %></strong>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded border">
                            <small class="text-muted d-block">STATUS PERAWATAN</small>
                            <% if ("Rawat Inap".equalsIgnoreCase(statusPerawatan) || "Isolasi Khusus".equalsIgnoreCase(statusPerawatan)) { %>
                                <span class="badge bg-danger"><%= statusPerawatan %></span>
                            <% } else { %>
                                <span class="badge bg-success"><%= statusPerawatan %></span>
                            <% } %>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded border">
                            <small class="text-muted d-block">TANGGAL MASUK RAWAT</small>
                            <strong><%= tglMasuk %></strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-notes-medical me-2 text-primary"></i> Catatan Dokter Jiwa Terbaru</h6>
                    </div>
                    <div class="card-body">
                        <p class="mb-2"><strong>Evaluasi Medis:</strong></p>
                        <p class="text-muted"><%= catatanTerakhir %></p>
                        <a href="info_perkembangan.jsp" class="btn btn-sm btn-outline-primary">Lihat Seluruh Catatan</a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-calendar-check me-2 text-primary"></i> Jadwal Besuk Keluarga</h6>
                    </div>
                    <div class="card-body">
                        <p class="text-muted mb-3">Kunjungan tatap muka diperbolehkan pada hari <strong>Selasa & Sabtu</strong> pukul 14:00 - 16:00 WIB.</p>
                        <a href="jadwal_besuk.jsp" class="btn btn-primary"><i class="fa-solid fa-calendar-plus me-1"></i> Ajukan Izin Besuk</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
