<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Data Pasien - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="pasien" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Data Pasien ODGJ" />
            <jsp:param name="subtitle" value="Data Master Pasien, Pendaftaran Pasien Baru, dan Rekam Identitas (CRUD)" />
        </jsp:include>

        <% 
            String status = request.getParameter("status");
            String msg = request.getParameter("msg");
            if ("success".equals(status)) { 
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Data pasien berhasil disimpan/diperbarui ke database!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Data pasien berhasil dihapus!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-bed-pulse me-2 text-primary"></i> Master Data Pasien</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahPasien">
                    <i class="fa-solid fa-user-plus me-1"></i> Pendaftaran Pasien Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Lengkap</th>
                                <th>NIK</th>
                                <th>JK / Tgl Lahir</th>
                                <th>Status Rawat</th>
                                <th>Kamar</th>
                                <th>Kontak Keluarga</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                PreparedStatement stmt = null;
                                ResultSet rs = null;
                                int count = 0;
                                try {
                                    conn = Koneksi.getConnection();
                                    String sql = "SELECT p.*, k.nama_kamar, kp.no_telp AS kontak_wali, kp.nama_wali " +
                                                 "FROM pasien p " +
                                                 "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                 "LEFT JOIN keluarga_pasien kp ON p.id_pasien = kp.id_pasien " +
                                                 "ORDER BY p.id_pasien DESC";
                                    stmt = conn.prepareStatement(sql);
                                    rs = stmt.executeQuery();
                                    while (rs.next()) {
                                        count++;
                                        int idPasien = rs.getInt("id_pasien");
                                        String noRm = rs.getString("no_rekam_medis");
                                        String nama = rs.getString("nama");
                                        String nik = rs.getString("nik");
                                        String jk = rs.getString("jenis_kelamin");
                                        String tglLahir = rs.getString("tgl_lahir");
                                        String statusRawat = rs.getString("status_perawatan");
                                        String namaKamar = rs.getString("nama_kamar");
                                        int idKamarVal = rs.getInt("id_kamar");
                                        String kontakWali = rs.getString("kontak_wali");
                                        if (kontakWali == null) kontakWali = "-";
                                        String displayKamar = (namaKamar != null) ? namaKamar : "-";
                            %>
                            <tr>
                                <td><strong><%= noRm %></strong></td>
                                <td><%= nama %></td>
                                <td><%= nik %></td>
                                <td><%= ("Laki-laki".equalsIgnoreCase(jk) ? "L" : "P") %> / <%= (tglLahir != null ? tglLahir : "-") %></td>
                                <td>
                                    <% if ("Rawat Inap".equalsIgnoreCase(statusRawat) || "Isolasi Khusus".equalsIgnoreCase(statusRawat)) { %>
                                        <span class="badge bg-danger"><%= statusRawat %></span>
                                    <% } else { %>
                                        <span class="badge bg-success"><%= statusRawat %></span>
                                    <% } %>
                                </td>
                                <td><%= displayKamar %></td>
                                <td><%= kontakWali %></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" 
                                            onclick="editPasien('<%= idPasien %>', '<%= noRm %>', '<%= nama %>', '<%= nik %>', '<%= ("Laki-laki".equalsIgnoreCase(jk) ? "L" : "P") %>', '<%= statusRawat %>', '<%= (idKamarVal > 0 ? idKamarVal : "") %>', '<%= kontakWali %>')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="<%= request.getContextPath() %>/PasienServlet?action=delete&id=<%= idPasien %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Apakah Anda yakin ingin menghapus data pasien <%= nama %>?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='8' class='text-danger p-3'>Error membaca data: " + e.getMessage() + "</td></tr>");
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(conn);
                                }

                                if (count == 0) {
                            %>
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-info-circle me-1"></i> Belum ada data pasien di database. Silakan klik tombol "Pendaftaran Pasien Baru".
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH PASIEN -->
<div class="modal fade" id="modalTambahPasien" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Pendaftaran Pasien Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/PasienServlet?action=insert" method="POST">
                <input type="hidden" name="source" value="admin">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">No. Rekam Medis (RM) *</label>
                            <input type="text" name="no_rm" class="form-control" value="RM-2026-<%= (System.currentTimeMillis() % 9000 + 1000) %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NIK Pasien *</label>
                            <input type="text" name="nik" class="form-control" placeholder="NIK Pasien (KTP)" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Nama Lengkap Pasien *</label>
                            <input type="text" name="nama_pasien" class="form-control" placeholder="Nama lengkap sesuai KTP" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Jenis Kelamin *</label>
                            <select name="jenis_kelamin" class="form-select" required>
                                <option value="L">Laki-laki</option>
                                <option value="P">Perempuan</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Status Rawat *</label>
                            <select name="status_rawat" class="form-select" required>
                                <option value="Rawat Inap">Rawat Inap</option>
                                <option value="Rawat Jalan">Rawat Jalan</option>
                                <option value="Isolasi Khusus">Isolasi Khusus</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Kamar Rawat</label>
                            <select name="nomor_kamar" class="form-select">
                                <option value="">-- Tanpa Kamar / Rawat Jalan --</option>
                                <%
                                    Connection connKamar = null;
                                    Statement stmtK = null;
                                    ResultSet rsK = null;
                                    try {
                                        connKamar = Koneksi.getConnection();
                                        stmtK = connKamar.createStatement();
                                        rsK = stmtK.executeQuery("SELECT id_kamar, nama_kamar, jenis, kapasitas, terisi FROM kamar ORDER BY id_kamar ASC");
                                        while (rsK.next()) {
                                            int idK = rsK.getInt("id_kamar");
                                            String nmKamar = rsK.getString("nama_kamar");
                                            String jnsKamar = rsK.getString("jenis");
                                            int cap = rsK.getInt("kapasitas");
                                            int isi = rsK.getInt("terisi");
                                %>
                                <option value="<%= idK %>"><%= nmKamar %> (<%= jnsKamar %> - <%= isi %>/<%= cap %>)</option>
                                <%
                                        }
                                    } catch (Exception ignored) {
                                    } finally {
                                        if (rsK != null) try { rsK.close(); } catch (SQLException ignored) {}
                                        if (stmtK != null) try { stmtK.close(); } catch (SQLException ignored) {}
                                        Koneksi.closeConnection(connKamar);
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Kontak Wali / Keluarga *</label>
                            <input type="text" name="kontak_wali" class="form-control" placeholder="08123456789 (Nama Wali)" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Pasien</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT PASIEN -->
<div class="modal fade" id="modalEditPasien" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Pasien</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/PasienServlet?action=update" method="POST">
                <input type="hidden" name="source" value="admin">
                <input type="hidden" name="id_pasien" id="edit_id_pasien">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">No. RM</label>
                            <input type="text" name="no_rm" id="edit_no_rm" class="form-control" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NIK Pasien *</label>
                            <input type="text" name="nik" id="edit_nik" class="form-control" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Nama Pasien *</label>
                            <input type="text" name="nama_pasien" id="edit_nama_pasien" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Jenis Kelamin *</label>
                            <select name="jenis_kelamin" id="edit_jenis_kelamin" class="form-select" required>
                                <option value="L">Laki-laki</option>
                                <option value="P">Perempuan</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Status Rawat *</label>
                            <select name="status_rawat" id="edit_status_rawat" class="form-select" required>
                                <option value="Rawat Inap">Rawat Inap</option>
                                <option value="Rawat Jalan">Rawat Jalan</option>
                                <option value="Isolasi Khusus">Isolasi Khusus</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Kamar Rawat</label>
                            <select name="nomor_kamar" id="edit_nomor_kamar" class="form-select">
                                <option value="">-- Tanpa Kamar / Rawat Jalan --</option>
                                <%
                                    Connection connKamarEdit = null;
                                    Statement stmtKE = null;
                                    ResultSet rsKE = null;
                                    try {
                                        connKamarEdit = Koneksi.getConnection();
                                        stmtKE = connKamarEdit.createStatement();
                                        rsKE = stmtKE.executeQuery("SELECT id_kamar, nama_kamar, jenis, kapasitas, terisi FROM kamar ORDER BY id_kamar ASC");
                                        while (rsKE.next()) {
                                            int idK = rsKE.getInt("id_kamar");
                                            String nmKamar = rsKE.getString("nama_kamar");
                                            String jnsKamar = rsKE.getString("jenis");
                                            int cap = rsKE.getInt("kapasitas");
                                            int isi = rsKE.getInt("terisi");
                                %>
                                <option value="<%= idK %>"><%= nmKamar %> (<%= jnsKamar %> - <%= isi %>/<%= cap %>)</option>
                                <%
                                        }
                                    } catch (Exception ignored) {
                                    } finally {
                                        if (rsKE != null) try { rsKE.close(); } catch (SQLException ignored) {}
                                        if (stmtKE != null) try { stmtKE.close(); } catch (SQLException ignored) {}
                                        Koneksi.closeConnection(connKamarEdit);
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Kontak Wali / Keluarga *</label>
                            <input type="text" name="kontak_wali" id="edit_kontak_wali" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Pasien</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editPasien(id, noRm, nama, nik, jk, statusRawat, idKamar, kontakWali) {
        document.getElementById('edit_id_pasien').value = id;
        document.getElementById('edit_no_rm').value = noRm;
        document.getElementById('edit_nama_pasien').value = nama;
        document.getElementById('edit_nik').value = nik;
        document.getElementById('edit_jenis_kelamin').value = jk;
        document.getElementById('edit_status_rawat').value = statusRawat;
        document.getElementById('edit_nomor_kamar').value = idKamar;
        document.getElementById('edit_kontak_wali').value = kontakWali;
        var modal = new bootstrap.Modal(document.getElementById('modalEditPasien'));
        modal.show();
    }
</script>
</body>
</html>
