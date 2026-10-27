<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Kamar Pasien - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="kamar" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Update Status Kamar Pasien" />
            <jsp:param name="subtitle" value="Pemindahan dan Penyesuaian Ruang Rawat Pasien (Isolasi / Bangsal)" />
        </jsp:include>

        <% if ("pindah_sukses".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Kamar pasien berhasil diperbarui dan dialokasikan!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORM PINDAH / UPDATE KAMAR -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-door-open me-2 text-primary"></i> Formulir Pindah Kamar</h6>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/PerawatServlet?action=pindah_kamar" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien --</option>
                                    <%
                                        Connection connPasien = null;
                                        Statement stmtP = null;
                                        ResultSet rsP = null;
                                        try {
                                            connPasien = Koneksi.getConnection();
                                            stmtP = connPasien.createStatement();
                                            String sqlP = "SELECT p.id_pasien, p.no_rekam_medis, p.nama, p.status_perawatan, k.nama_kamar " +
                                                          "FROM pasien p " +
                                                          "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                          "ORDER BY p.id_pasien DESC";
                                            rsP = stmtP.executeQuery(sqlP);
                                            while (rsP.next()) {
                                                int idPasien = rsP.getInt("id_pasien");
                                                String noRm = rsP.getString("no_rekam_medis");
                                                String namaPasien = rsP.getString("nama");
                                                String kmr = rsP.getString("nama_kamar");
                                                String stRawat = rsP.getString("status_perawatan");
                                                String infoKamar = (kmr != null) ? kmr : "Belum Ada Kamar (" + stRawat + ")";
                                    %>
                                    <option value="<%= idPasien %>"><%= namaPasien %> (<%= noRm %>) - Saat ini: <%= infoKamar %></option>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsP != null) try { rsP.close(); } catch (SQLException ignored) {}
                                            if (stmtP != null) try { stmtP.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connPasien);
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pindah ke Kamar Tujuan *</label>
                                <select name="id_kamar_baru" class="form-select" required>
                                    <option value="">-- Pilih Kamar Tujuan --</option>
                                    <%
                                        Connection connKmr = null;
                                        Statement stmtK = null;
                                        ResultSet rsK = null;
                                        try {
                                            connKmr = Koneksi.getConnection();
                                            stmtK = connKmr.createStatement();
                                            rsK = stmtK.executeQuery("SELECT id_kamar, nama_kamar, jenis, kapasitas, terisi FROM kamar ORDER BY id_kamar ASC");
                                            while (rsK.next()) {
                                                int idK = rsK.getInt("id_kamar");
                                                String nm = rsK.getString("nama_kamar");
                                                String jns = rsK.getString("jenis");
                                                int cap = rsK.getInt("kapasitas");
                                                int isi = rsK.getInt("terisi");
                                    %>
                                    <option value="<%= idK %>"><%= nm %> (<%= jns %> - Terisi: <%= isi %>/<%= cap %>)</option>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsK != null) try { rsK.close(); } catch (SQLException ignored) {}
                                            if (stmtK != null) try { stmtK.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connKmr);
                                        }
                                    %>
                                    <option value="-">-- Kosongkan / Rawat Jalan (Tanpa Kamar) --</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Alasan Pemindahan *</label>
                                <select name="alasan" class="form-select" required>
                                    <option value="Kondisi Tenang">Kondisi Tenang / Stabil (Pindah ke Bangsal)</option>
                                    <option value="Gaduh Gelisah">Gaduh Gelisah / Agresif (Pindah ke Isolasi)</option>
                                    <option value="Kebutuhan Khusus">Kebutuhan Medis Khusus</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Catatan Perawat</label>
                                <textarea name="catatan" class="form-control" rows="2" placeholder="Catatan kondisi saat perpindahan fisik pasien..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-warning text-dark w-100 fw-bold"><i class="fa-solid fa-shuffle me-1"></i> Update Kamar Pasien</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL STATUS KETERSEDIAAN KAMAR SAAT INI -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-bed me-2 text-primary"></i> Daftar Kamar & Pasien Penghuni</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Nama Kamar</th>
                                        <th>Tipe</th>
                                        <th>Kapasitas</th>
                                        <th>Daftar Pasien Penghuni</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection connTabel = null;
                                        Statement stmtT = null;
                                        ResultSet rsT = null;
                                        try {
                                            connTabel = Koneksi.getConnection();
                                            stmtT = connTabel.createStatement();
                                            String sqlT = "SELECT k.id_kamar, k.nama_kamar, k.jenis, k.kapasitas, " +
                                                          "GROUP_CONCAT(CONCAT(p.nama, ' (', p.no_rekam_medis, ')') SEPARATOR ', ') AS daftar_pasien, " +
                                                          "COUNT(p.id_pasien) AS total_isi " +
                                                          "FROM kamar k " +
                                                          "LEFT JOIN pasien p ON k.id_kamar = p.id_kamar " +
                                                          "GROUP BY k.id_kamar, k.nama_kamar, k.jenis, k.kapasitas " +
                                                          "ORDER BY k.id_kamar ASC";
                                            rsT = stmtT.executeQuery(sqlT);
                                            while (rsT.next()) {
                                                String nmK = rsT.getString("nama_kamar");
                                                String jns = rsT.getString("jenis");
                                                int cap = rsT.getInt("kapasitas");
                                                int totalIsi = rsT.getInt("total_isi");
                                                String penghuni = rsT.getString("daftar_pasien");
                                    %>
                                    <tr>
                                        <td><strong><%= nmK %></strong></td>
                                        <td><span class="text-capitalize"><%= jns %></span></td>
                                        <td>
                                            <% if (totalIsi >= cap) { %>
                                                <span class="badge bg-danger">Penuh (<%= totalIsi %>/<%= cap %>)</span>
                                            <% } else if (totalIsi > 0) { %>
                                                <span class="badge bg-warning text-dark">Terisi (<%= totalIsi %>/<%= cap %>)</span>
                                            <% } else { %>
                                                <span class="badge bg-success">Kosong (<%= totalIsi %>/<%= cap %>)</span>
                                            <% } %>
                                        </td>
                                        <td><%= (penghuni != null && !penghuni.isEmpty()) ? penghuni : "<em class='text-muted'>- Belum ada pasien -</em>" %></td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='4' class='text-danger p-2'>Error: " + e.getMessage() + "</td></tr>");
                                        } finally {
                                            if (rsT != null) try { rsT.close(); } catch (SQLException ignored) {}
                                            if (stmtT != null) try { stmtT.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connTabel);
                                        }
                                    %>
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
