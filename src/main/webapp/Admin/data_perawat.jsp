<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi, java.util.List, java.util.ArrayList" %>
<%
    String status = request.getParameter("status");
    String msg = request.getParameter("msg");

    // Ambil daftar kamar dari database untuk dropdown ruangan penempatan
    List<String> listKamar = new ArrayList<>();
    Connection connK = null;
    Statement stmtK = null;
    ResultSet rsK = null;
    try {
        connK = Koneksi.getConnection();
        stmtK = connK.createStatement();
        rsK = stmtK.executeQuery("SELECT nama_kamar, jenis FROM kamar ORDER BY id_kamar ASC");
        while (rsK.next()) {
            listKamar.add(rsK.getString("nama_kamar") + " (" + rsK.getString("jenis") + ")");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsK != null) try { rsK.close(); } catch (SQLException ignored) {}
        if (stmtK != null) try { stmtK.close(); } catch (SQLException ignored) {}
        Koneksi.closeConnection(connK);
    }

    // Jika belum ada kamar atau untuk opsi umum IGD/Poli
    if (!listKamar.contains("IGD Jiwa & Krisis")) {
        listKamar.add(0, "IGD Jiwa & Krisis");
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Data Perawat - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="perawat" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Data Tenaga Keperawatan" />
            <jsp:param name="subtitle" value="Data Master Perawat Jiwa, Ners Bangsal, dan Jadwal Shift (CRUD)" />
        </jsp:include>

        <% if ("success".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Data perawat berhasil disimpan/diperbarui ke database!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Data perawat berhasil dihapus!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-user-nurse me-2 text-primary"></i> Data Master Perawat Jiwa</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahPerawat">
                    <i class="fa-solid fa-user-plus me-1"></i> Tambah Perawat Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th>
                                <th>Nama Lengkap</th>
                                <th>NIRA / STR</th>
                                <th>Ruangan Penempatan</th>
                                <th>No. Handphone</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connP = null;
                                Statement stmtP = null;
                                ResultSet rsP = null;
                                int noP = 0;
                                try {
                                    connP = Koneksi.getConnection();
                                    stmtP = connP.createStatement();
                                    rsP = stmtP.executeQuery("SELECT * FROM perawat ORDER BY id_perawat ASC");
                                    while (rsP.next()) {
                                        noP++;
                                        int idP = rsP.getInt("id_perawat");
                                        String namaPerawat = rsP.getString("nama_perawat");
                                        String strPerawat = rsP.getString("no_str");
                                        String ruangPerawat = rsP.getString("ruang_jaga");
                                        String telpPerawat = rsP.getString("no_telp");
                            %>
                            <tr>
                                <td><%= noP %></td>
                                <td><strong><%= namaPerawat %></strong></td>
                                <td><code><%= strPerawat %></code></td>
                                <td><span class="badge bg-light text-dark border"><%= ruangPerawat %></span></td>
                                <td><%= telpPerawat %></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" 
                                            onclick="editPerawat('<%= idP %>', '<%= namaPerawat %>', '<%= strPerawat %>', '<%= ruangPerawat %>', '<%= telpPerawat %>')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="<%= request.getContextPath() %>/PerawatAdminServlet?action=delete&id=<%= idP %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Hapus perawat <%= namaPerawat %>?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsP != null) try { rsP.close(); } catch (SQLException ignored) {}
                                    if (stmtP != null) try { stmtP.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connP);
                                }

                                if (noP == 0) {
                            %>
                            <tr><td colspan="6" class="text-center py-4 text-muted">Belum ada data perawat tersimpan.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH PERAWAT -->
<div class="modal fade" id="modalTambahPerawat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Perawat Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/PerawatAdminServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap & Gelar *</label>
                        <input type="text" name="nama_perawat" class="form-control" placeholder="Contoh: Ns. Siti Rahma, S.Kep" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">NIRA / No. STR *</label>
                        <input type="text" name="nira" class="form-control" placeholder="Contoh: NIRA-3374-00129" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ruangan Penempatan *</label>
                        <select name="ruangan" class="form-select" required>
                            <option value="">-- Pilih Ruangan Penempatan --</option>
                            <% for (String kmr : listKamar) { %>
                                <option value="<%= kmr %>"><%= kmr %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nomor Handphone (WhatsApp) *</label>
                        <input type="text" name="no_hp" class="form-control" placeholder="08123456789" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Perawat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT PERAWAT -->
<div class="modal fade" id="modalEditPerawat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Perawat</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/PerawatAdminServlet?action=update" method="POST">
                <input type="hidden" name="id_perawat" id="edit_id_perawat">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap & Gelar *</label>
                        <input type="text" name="nama_perawat" id="edit_nama_perawat" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">NIRA / No. STR *</label>
                        <input type="text" name="nira" id="edit_nira" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ruangan Penempatan *</label>
                        <select name="ruangan" id="edit_ruangan" class="form-select" required>
                            <option value="">-- Pilih Ruangan Penempatan --</option>
                            <% for (String kmr : listKamar) { %>
                                <option value="<%= kmr %>"><%= kmr %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nomor Handphone *</label>
                        <input type="text" name="no_hp" id="edit_no_hp" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Perawat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editPerawat(id, nama, nira, ruangan, noHp) {
        document.getElementById('edit_id_perawat').value = id;
        document.getElementById('edit_nama_perawat').value = nama;
        document.getElementById('edit_nira').value = nira;
        
        var selectRuangan = document.getElementById('edit_ruangan');
        selectRuangan.value = ruangan;
        // Jika value tidak persis cocok dengan option, tambahkan/set selected
        if (!selectRuangan.value) {
            for (var i = 0; i < selectRuangan.options.length; i++) {
                if (selectRuangan.options[i].text.indexOf(ruangan) !== -1 || ruangan.indexOf(selectRuangan.options[i].value) !== -1) {
                    selectRuangan.selectedIndex = i;
                    break;
                }
            }
        }
        
        document.getElementById('edit_no_hp').value = noHp;
        var modal = new bootstrap.Modal(document.getElementById('modalEditPerawat'));
        modal.show();
    }
</script>
</body>
</html>
