<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pendaftaran Pasien Baru - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="pendaftaran" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Penerimaan & Pendaftaran Pasien Baru" />
            <jsp:param name="subtitle" value="Registrasi Pasien Masuk IGD / Bangsal Jiwa dan Alokasi Kamar Perawatan" />
        </jsp:include>

        <% 
            String status = request.getParameter("status");
            String msg = request.getParameter("msg");
            if ("success".equals(status)) { 
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Pasien baru berhasil didaftarkan dan data berhasil disimpan ke database!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Data pasien berhasil dihapus!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORMULIR REGISTRASI PASIEN BARU -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-user-plus me-2 text-primary"></i> Formulir Pasien Masuk</h6>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/PasienServlet?action=insert" method="POST">
                            <input type="hidden" name="source" value="perawat">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">No. Rekam Medis (Auto/Manual) *</label>
                                <input type="text" name="no_rm" class="form-control" value="RM-2026-<%= (System.currentTimeMillis() % 9000 + 1000) %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">NIK KTP Pasien (16 Digit) *</label>
                                <input type="text" name="nik" class="form-control" placeholder="Contoh: 3374011205920005" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nama Lengkap Pasien *</label>
                                <input type="text" name="nama_pasien" class="form-control" placeholder="Nama pasien sesuai KTP" required>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Jenis Kelamin *</label>
                                    <select name="jenis_kelamin" class="form-select" required>
                                        <option value="L">Laki-laki</option>
                                        <option value="P">Perempuan</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Status Rawat *</label>
                                    <select name="status_rawat" class="form-select" required>
                                        <option value="Rawat Inap">Rawat Inap</option>
                                        <option value="Rawat Jalan">Rawat Jalan</option>
                                        <option value="Isolasi Khusus">Isolasi Khusus</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tingkat Agitasi / Kondisi Awal *</label>
                                <select name="tingkat_agitasi" class="form-select" required>
                                    <option value="Tenang">Tenang (Kooperatif)</option>
                                    <option value="Gelisah Ringan">Gelisah Ringan</option>
                                    <option value="Agitasi Berat / Gaduh Gelisah">Agitasi Berat / Gaduh Gelisah</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Alokasi Kamar (Jika Rawat Inap)</label>
                                <select name="nomor_kamar" class="form-select">
                                    <option value="">-- Pilih Kamar / Rawat Jalan --</option>
                                    <%
                                        Connection connKamarP = null;
                                        Statement stmtKP = null;
                                        ResultSet rsKP = null;
                                        try {
                                            connKamarP = Koneksi.getConnection();
                                            stmtKP = connKamarP.createStatement();
                                            rsKP = stmtKP.executeQuery("SELECT id_kamar, nama_kamar, jenis, kapasitas, terisi FROM kamar ORDER BY id_kamar ASC");
                                            while (rsKP.next()) {
                                                int idK = rsKP.getInt("id_kamar");
                                                String nmK = rsKP.getString("nama_kamar");
                                                String jnsK = rsKP.getString("jenis");
                                                int cap = rsKP.getInt("kapasitas");
                                                int isi = rsKP.getInt("terisi");
                                    %>
                                    <option value="<%= idK %>"><%= nmK %> (<%= jnsK %> - <%= isi %>/<%= cap %>)</option>
                                    <%
                                            }
                                        } catch (Exception ignored) {
                                        } finally {
                                            if (rsKP != null) try { rsKP.close(); } catch (SQLException ignored) {}
                                            if (stmtKP != null) try { stmtKP.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connKamarP);
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Kontak Wali / Keluarga Penanggung Jawab *</label>
                                <input type="text" name="kontak_wali" class="form-control" placeholder="08123456789 (Nama Wali / Hubungan)" required>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2"><i class="fa-solid fa-save me-1"></i> Daftarkan Pasien Masuk</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL DAFTAR PASIEN YANG TERDAFTAR -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-users me-2 text-primary"></i> Pasien Terdaftar Terakhir</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>No. RM</th>
                                        <th>Nama Pasien</th>
                                        <th>Status Rawat</th>
                                        <th>Kamar</th>
                                        <th>Kontak Wali</th>
                                        <th class="text-center">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection connList = null;
                                        Statement stmtList = null;
                                        ResultSet rsList = null;
                                        int c = 0;
                                        try {
                                            connList = Koneksi.getConnection();
                                            stmtList = connList.createStatement();
                                            String sqlList = "SELECT p.*, k.nama_kamar, kp.no_telp AS kontak_wali " +
                                                             "FROM pasien p " +
                                                             "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                             "LEFT JOIN keluarga_pasien kp ON p.id_pasien = kp.id_pasien " +
                                                             "ORDER BY p.id_pasien DESC LIMIT 8";
                                            rsList = stmtList.executeQuery(sqlList);
                                            while (rsList.next()) {
                                                c++;
                                                int idp = rsList.getInt("id_pasien");
                                                String rm = rsList.getString("no_rekam_medis");
                                                String nm = rsList.getString("nama");
                                                String jk = rsList.getString("jenis_kelamin");
                                                String st = rsList.getString("status_perawatan");
                                                String km = rsList.getString("nama_kamar");
                                                String kw = rsList.getString("kontak_wali");
                                                if (kw == null) kw = "-";
                                    %>
                                    <tr>
                                        <td><strong><%= rm %></strong></td>
                                        <td><%= nm %> <small class="text-muted">(<%= "Laki-laki".equalsIgnoreCase(jk) ? "L" : "P" %>)</small></td>
                                        <td>
                                            <% if ("Rawat Inap".equalsIgnoreCase(st) || "Isolasi Khusus".equalsIgnoreCase(st)) { %>
                                                <span class="badge bg-danger"><%= st %></span>
                                            <% } else { %>
                                                <span class="badge bg-success"><%= st %></span>
                                            <% } %>
                                        </td>
                                        <td><%= (km != null ? km : "-") %></td>
                                        <td><%= kw %></td>
                                        <td class="text-center">
                                            <a href="<%= request.getContextPath() %>/PasienServlet?action=delete&id=<%= idp %>&from=perawat" 
                                               class="btn btn-sm btn-outline-danger" 
                                               onclick="return confirm('Hapus data pasien <%= nm %>?')">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='6' class='text-danger p-2'>Error: " + e.getMessage() + "</td></tr>");
                                            e.printStackTrace();
                                        } finally {
                                            if (rsList != null) try { rsList.close(); } catch (SQLException ignored) {}
                                            if (stmtList != null) try { stmtList.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connList);
                                        }

                                        if (c == 0) {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted">Belum ada data pasien tersimpan di database.</td>
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
