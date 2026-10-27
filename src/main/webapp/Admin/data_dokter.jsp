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
    <title>Kelola Data Dokter - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dokter" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Data Dokter Spesialis" />
            <jsp:param name="subtitle" value="Data Master Tenaga Medis, Psikiater, dan Dokter Penanggung Jawab (CRUD)" />
        </jsp:include>

        <% if ("success".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Data dokter berhasil disimpan/diperbarui ke database!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Data dokter berhasil dihapus!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-user-doctor me-2 text-primary"></i> Data Master Dokter Spesialis</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahDokter">
                    <i class="fa-solid fa-user-plus me-1"></i> Tambah Dokter Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th>
                                <th>Nama Lengkap & Gelar</th>
                                <th>SIP / STR</th>
                                <th>Spesialisasi</th>
                                <th>No. Handphone</th>
                                <th>Email</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                Statement stmt = null;
                                ResultSet rs = null;
                                int no = 0;
                                try {
                                    conn = Koneksi.getConnection();
                                    stmt = conn.createStatement();
                                    rs = stmt.executeQuery("SELECT * FROM dokter ORDER BY id_dokter ASC");
                                    while (rs.next()) {
                                        no++;
                                        int idD = rs.getInt("id_dokter");
                                        String namaD = rs.getString("nama_dokter");
                                        String strD = rs.getString("no_str");
                                        String speD = rs.getString("spesialisasi");
                                        String telpD = rs.getString("no_telp");
                                        String emailD = rs.getString("email");
                            %>
                            <tr>
                                <td><%= no %></td>
                                <td><strong><%= namaD %></strong></td>
                                <td><code><%= strD %></code></td>
                                <td><%= speD %></td>
                                <td><%= telpD %></td>
                                <td><%= (emailD != null) ? emailD : "-" %></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" 
                                            onclick="editDokter('<%= idD %>', '<%= namaD %>', '<%= strD %>', '<%= speD %>', '<%= telpD %>', '<%= emailD %>')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="<%= request.getContextPath() %>/DokterServlet?action=delete&id=<%= idD %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Hapus dokter <%= namaD %>?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
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

                                if (no == 0) {
                            %>
                            <tr><td colspan="7" class="text-center py-4 text-muted">Belum ada data dokter tersimpan.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH DOKTER -->
<div class="modal fade" id="modalTambahDokter" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Dokter Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/DokterServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap & Gelar *</label>
                        <input type="text" name="nama_dokter" class="form-control" placeholder="Contoh: dr. Fajar Nugraha, Sp.KJ" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">No. SIP / STR *</label>
                        <input type="text" name="sip" class="form-control" placeholder="Contoh: SIP.446/102/DSJ/2024" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Spesialisasi / Subspesialisasi *</label>
                        <select name="spesialisasi" class="form-select" required>
                            <option value="Psikiatri Klinis & Dewasa">Psikiatri Klinis & Dewasa</option>
                            <option value="Psikiatri Anak & Remaja">Psikiatri Anak & Remaja</option>
                            <option value="Psikiatri Adiksi & Ketergantungan">Psikiatri Adiksi & Ketergantungan</option>
                            <option value="Psikiatri Forensik">Psikiatri Forensik</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nomor Handphone (WhatsApp) *</label>
                        <input type="text" name="no_hp" class="form-control" placeholder="08123456789" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Alamat Email</label>
                        <input type="email" name="email" class="form-control" placeholder="dokter@rsodgj.com">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Dokter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT DOKTER -->
<div class="modal fade" id="modalEditDokter" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Dokter</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/DokterServlet?action=update" method="POST">
                <input type="hidden" name="id_dokter" id="edit_id_dokter">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap & Gelar *</label>
                        <input type="text" name="nama_dokter" id="edit_nama_dokter" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">No. SIP / STR *</label>
                        <input type="text" name="sip" id="edit_sip" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Spesialisasi *</label>
                        <input type="text" name="spesialisasi" id="edit_spesialisasi" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nomor Handphone *</label>
                        <input type="text" name="no_hp" id="edit_no_hp" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email</label>
                        <input type="email" name="email" id="edit_email" class="form-control">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Dokter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editDokter(id, nama, sip, spesialisasi, noHp, email) {
        document.getElementById('edit_id_dokter').value = id;
        document.getElementById('edit_nama_dokter').value = nama;
        document.getElementById('edit_sip').value = sip;
        document.getElementById('edit_spesialisasi').value = spesialisasi;
        document.getElementById('edit_no_hp').value = noHp;
        document.getElementById('edit_email').value = (email !== 'null') ? email : '';
        var modal = new bootstrap.Modal(document.getElementById('modalEditDokter'));
        modal.show();
    }
</script>
</body>
</html>
