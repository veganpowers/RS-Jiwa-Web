<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    int idPasien = 0;
    String namaPasien = "Pasien";
    String namaWali = "Keluarga Pasien";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        String sql = "SELECT p.id_pasien, p.nama, kp.nama_wali, kp.hubungan " +
                     "FROM keluarga_pasien kp " +
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
            String nw = rs.getString("nama_wali");
            String hb = rs.getString("hubungan");
            if (nw != null) namaWali = nw + " (" + (hb != null ? hb : "Wali") + ")";
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

    String subJudul = "Pengajuan Izin Kunjungan Tatap Muka untuk Pasien " + namaPasien;
    String status = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jadwal Besuk Keluarga - RS Khusus ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="besuk" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Pendaftaran Izin Besuk" />
            <jsp:param name="subtitle" value="<%= subJudul %>" />
        </jsp:include>

        <% if ("sukses".equals(status)) { %>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-clock me-2"></i> Permohonan izin kunjungan berhasil dikirim! Status saat ini <strong>Menunggu Persetujuan Ners</strong> demi keselamatan & stabilitas kondisi pasien.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORM DAFTAR BESUK -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-calendar-plus me-2 text-primary"></i> Formulir Kunjungan untuk <%= namaPasien %></h6>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/KeluargaServlet?action=daftar_besuk" method="POST">
                            <input type="hidden" name="id_pasien" value="<%= idPasien %>">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Tanggal Rencana Besuk *</label>
                                <input type="date" name="tanggal" class="form-control" required value="2026-10-27">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Sesi Waktu Kunjungan *</label>
                                <select name="sesi" class="form-select" required>
                                    <option value="Sesi Siang (10:00 - 11:30 WIB)">Sesi Siang (10:00 - 11:30 WIB)</option>
                                    <option value="Sesi Sore (14:30 - 16:00 WIB)">Sesi Sore (14:30 - 16:00 WIB)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nama Pengunjung & Hubungan *</label>
                                <input type="text" name="nama_pengunjung" class="form-control" value="<%= namaWali %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Jumlah Keluarga Hadir (Maksimal 2) *</label>
                                <select name="jumlah" class="form-select" required>
                                    <option value="1">1 Orang</option>
                                    <option value="2">2 Orang</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-paper-plane me-1"></i> Ajukan Izin Kunjungan</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL RIWAYAT KUNJUNGAN -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-history me-2 text-primary"></i> Riwayat Pengajuan Izin Besuk</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tanggal</th>
                                        <th>Sesi Waktu</th>
                                        <th>Pengunjung</th>
                                        <th>Status Izin</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection connB = null;
                                        PreparedStatement stmtB = null;
                                        ResultSet rsB = null;
                                        int cB = 0;
                                        try {
                                            connB = Koneksi.getConnection();
                                            String sqlB = "SELECT * FROM jadwal_besuk WHERE id_pasien = ? ORDER BY id_besuk DESC";
                                            stmtB = connB.prepareStatement(sqlB);
                                            stmtB.setInt(1, idPasien);
                                            rsB = stmtB.executeQuery();
                                            while (rsB.next()) {
                                                cB++;
                                                String tglBesuk = rsB.getString("tanggal_besuk");
                                                String sesiWaktu = rsB.getString("sesi_waktu");
                                                String pengunjung = rsB.getString("nama_pengunjung");
                                                String statusIzin = rsB.getString("status_izin");
                                    %>
                                    <tr>
                                        <td><%= tglBesuk %></td>
                                        <td><%= sesiWaktu %></td>
                                        <td><%= pengunjung %></td>
                                        <td>
                                            <% if ("Disetujui Ners".equalsIgnoreCase(statusIzin)) { %>
                                                <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i> Disetujui</span>
                                            <% } else if ("Ditolak".equalsIgnoreCase(statusIzin)) { %>
                                                <span class="badge bg-danger"><i class="fa-solid fa-xmark me-1"></i> Ditolak</span>
                                            <% } else { %>
                                                <span class="badge bg-warning text-dark"><i class="fa-solid fa-clock me-1"></i> Menunggu Persetujuan</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsB != null) try { rsB.close(); } catch (SQLException ignored) {}
                                            if (stmtB != null) try { stmtB.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connB);
                                        }

                                        if (cB == 0) {
                                    %>
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">Belum ada riwayat izin kunjungan. Silakan ajukan izin besuk pada formulir di sebelah kiri.</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
