<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    String status = request.getParameter("status");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Kamar Perawatan - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="kamar" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Kamar Perawatan" />
            <jsp:param name="subtitle" value="Manajemen Status Ketersediaan Kamar Rawat Inap & Isolasi (CRUD)" />
        </jsp:include>

        <% if ("success".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Data kamar berhasil disimpan/diperbarui ke database!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Data kamar berhasil dihapus!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-door-closed me-2 text-primary"></i> Data Master Kamar & Status Ketersediaan</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahKamar">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Kamar Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 50px;">No</th>
                                <th>Nama Kamar</th>
                                <th>Jenis / Tipe Kamar</th>
                                <th>Kapasitas & Status</th>
                                <th>Pasien yang Menempati</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connK = null;
                                Statement stmtK = null;
                                ResultSet rsK = null;
                                int noK = 0;
                                try {
                                    connK = Koneksi.getConnection();
                                    stmtK = connK.createStatement();
                                    String sqlK = "SELECT k.*, GROUP_CONCAT(CONCAT(p.nama, ' (', p.no_rekam_medis, ')') SEPARATOR ', ') AS daftar_pasien, " +
                                                  "COUNT(p.id_pasien) AS total_penghuni " +
                                                  "FROM kamar k " +
                                                  "LEFT JOIN pasien p ON k.id_kamar = p.id_kamar " +
                                                  "GROUP BY k.id_kamar ORDER BY k.id_kamar ASC";
                                    rsK = stmtK.executeQuery(sqlK);
                                    while (rsK.next()) {
                                        noK++;
                                        int idK = rsK.getInt("id_kamar");
                                        String namaKamar = rsK.getString("nama_kamar");
                                        String jenis = rsK.getString("jenis");
                                        int cap = rsK.getInt("kapasitas");
                                        int terisi = rsK.getInt("total_penghuni");
                                        String pasien = rsK.getString("daftar_pasien");
                            %>
                            <tr>
                                <td><%= noK %></td>
                                <td><strong><%= namaKamar %></strong></td>
                                <td><span class="text-capitalize"><%= jenis %></span></td>
                                <td>
                                    <% if (terisi >= cap) { %>
                                        <span class="badge bg-danger">Penuh (<%= terisi %>/<%= cap %>)</span>
                                    <% } else if (terisi > 0) { %>
                                        <span class="badge bg-warning text-dark">Terisi (<%= terisi %>/<%= cap %>)</span>
                                    <% } else { %>
                                        <span class="badge bg-success">Kosong (<%= terisi %>/<%= cap %>)</span>
                                    <% } %>
                                </td>
                                <td><%= (pasien != null && !pasien.isEmpty()) ? pasien : "<em class='text-muted'>- Belum Terisi -</em>" %></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" 
                                            onclick="editKamar('<%= idK %>', '<%= namaKamar %>', '<%= jenis %>', '<%= cap %>')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="<%= request.getContextPath() %>/KamarDataServlet?action=delete&id=<%= idK %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Hapus kamar <%= namaKamar %>?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsK != null) try { rsK.close(); } catch (SQLException ignored) {}
                                    if (stmtK != null) try { stmtK.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connK);
                                }

                                if (noK == 0) {
                            %>
                            <tr><td colspan="6" class="text-center py-4 text-muted">Belum ada data kamar terdaftar.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH KAMAR -->
<div class="modal fade" id="modalTambahKamar" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Kamar Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/KamarDataServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama / Nomor Kamar *</label>
                        <input type="text" name="nama_kamar" class="form-control" placeholder="Contoh: Isolasi B-01 / Bangsal Mawar" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Jenis / Tipe Kamar *</label>
                        <select name="tipe_kamar" class="form-select" required>
                            <option value="isolasi">Kamar Isolasi Khusus</option>
                            <option value="reguler">Bangsal Reguler</option>
                            <option value="vip_jiwa">VIP Jiwa</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Kapasitas Tempat Tidur (Bed) *</label>
                        <input type="number" name="kapasitas" class="form-control" value="1" min="1" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Kamar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT KAMAR -->
<div class="modal fade" id="modalEditKamar" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Kamar</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/KamarDataServlet?action=update" method="POST">
                <input type="hidden" name="id_kamar" id="edit_id_kamar">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama / Nomor Kamar *</label>
                        <input type="text" name="nama_kamar" id="edit_nama_kamar" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Jenis / Tipe Kamar *</label>
                        <select name="tipe_kamar" id="edit_tipe_kamar" class="form-select" required>
                            <option value="isolasi">Kamar Isolasi Khusus</option>
                            <option value="reguler">Bangsal Reguler</option>
                            <option value="vip_jiwa">VIP Jiwa</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Kapasitas (Bed) *</label>
                        <input type="number" name="kapasitas" id="edit_kapasitas" class="form-control" min="1" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Kamar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editKamar(id, nama, jenis, cap) {
        document.getElementById('edit_id_kamar').value = id;
        document.getElementById('edit_nama_kamar').value = nama;
        document.getElementById('edit_tipe_kamar').value = jenis;
        document.getElementById('edit_kapasitas').value = cap;
        var modal = new bootstrap.Modal(document.getElementById('modalEditKamar'));
        modal.show();
    }
</script>
</body>
</html>
