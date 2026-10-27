<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi, java.text.NumberFormat, java.util.Locale" %>
<%
    Locale indo = new Locale("id", "ID");
    NumberFormat nf = NumberFormat.getCurrencyInstance(indo);
    String status = request.getParameter("status");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Obat Psikiatri - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="obat" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Obat & Psikofarmaka" />
            <jsp:param name="subtitle" value="Data Master Obat Jiwa, Stok Apotek, dan Penyesuaian Harga (CRUD)" />
        </jsp:include>

        <% if ("success".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Data obat berhasil disimpan/diperbarui ke database!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Data obat berhasil dihapus!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-pills me-2 text-primary"></i> Data Master Obat Psikiatri</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahObat">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Obat Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th>
                                <th>Kode & Nama Obat</th>
                                <th>Kategori / Golongan</th>
                                <th>Bentuk Sediaan</th>
                                <th>Sisa Stok</th>
                                <th>Harga Satuan</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connO = null;
                                Statement stmtO = null;
                                ResultSet rsO = null;
                                int noO = 0;
                                try {
                                    connO = Koneksi.getConnection();
                                    stmtO = connO.createStatement();
                                    rsO = stmtO.executeQuery("SELECT * FROM obat ORDER BY id_obat ASC");
                                    while (rsO.next()) {
                                        noO++;
                                        int idO = rsO.getInt("id_obat");
                                        String kodeO = rsO.getString("kode_obat");
                                        String namaO = rsO.getString("nama_obat");
                                        String katO = rsO.getString("kategori");
                                        String btkO = rsO.getString("bentuk_sediaan");
                                        int stokO = rsO.getInt("stok");
                                        double hargaO = rsO.getDouble("harga");
                            %>
                            <tr>
                                <td><%= noO %></td>
                                <td><strong><%= namaO %></strong><br><small class="text-muted"><%= kodeO %></small></td>
                                <td><span class="badge bg-light text-dark border"><%= katO %></span></td>
                                <td><%= btkO %></td>
                                <td>
                                    <% if (stokO < 20) { %>
                                        <span class="badge bg-danger"><%= stokO %> Butir (Menipis)</span>
                                    <% } else { %>
                                        <span class="badge bg-success"><%= stokO %> Butir</span>
                                    <% } %>
                                </td>
                                <td><%= nf.format(hargaO).replace("Rp", "Rp ") %></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" 
                                            onclick="editObat('<%= idO %>', '<%= namaO %>', '<%= katO %>', '<%= btkO %>', '<%= stokO %>', '<%= (long)hargaO %>')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="<%= request.getContextPath() %>/ObatServlet?action=delete&id=<%= idO %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Hapus obat <%= namaO %>?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsO != null) try { rsO.close(); } catch (SQLException ignored) {}
                                    if (stmtO != null) try { stmtO.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connO);
                                }

                                if (noO == 0) {
                            %>
                            <tr><td colspan="7" class="text-center py-4 text-muted">Belum ada obat tersimpan di database.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH OBAT -->
<div class="modal fade" id="modalTambahObat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Obat Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/ObatServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Obat & Dosis *</label>
                        <input type="text" name="nama_obat" class="form-control" placeholder="Contoh: Clozapine 25 mg" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Golongan / Kategori *</label>
                        <select name="kategori" class="form-select" required>
                            <option value="Antipsikotik Atipikal">Antipsikotik Atipikal</option>
                            <option value="Antipsikotik Tipikal">Antipsikotik Tipikal</option>
                            <option value="Antidepresan">Antidepresan</option>
                            <option value="Mood Stabilizer">Mood Stabilizer</option>
                            <option value="Antiansietas / Sedatif">Antiansietas / Sedatif</option>
                            <option value="Injeksi Emergensi">Injeksi Emergensi</option>
                        </select>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold">Bentuk Sediaan *</label>
                            <select name="bentuk_sediaan" class="form-select" required>
                                <option value="Tablet">Tablet</option>
                                <option value="Kapsul">Kapsul</option>
                                <option value="Ampul / Injeksi">Ampul / Injeksi</option>
                                <option value="Sirup / Tetes">Sirup / Tetes</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Stok Awal *</label>
                            <input type="number" name="stok" class="form-control" value="100" min="0" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Harga Satuan (Rp) *</label>
                        <input type="number" name="harga" class="form-control" placeholder="Contoh: 15000" min="0" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Obat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT OBAT -->
<div class="modal fade" id="modalEditObat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Obat</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/ObatServlet?action=update" method="POST">
                <input type="hidden" name="id_obat" id="edit_id_obat">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Obat & Dosis *</label>
                        <input type="text" name="nama_obat" id="edit_nama_obat" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Golongan / Kategori *</label>
                        <select name="kategori" id="edit_kategori" class="form-select" required>
                            <option value="Antipsikotik Atipikal">Antipsikotik Atipikal</option>
                            <option value="Antipsikotik Tipikal">Antipsikotik Tipikal</option>
                            <option value="Antidepresan">Antidepresan</option>
                            <option value="Mood Stabilizer">Mood Stabilizer</option>
                            <option value="Antiansietas / Sedatif">Antiansietas / Sedatif</option>
                            <option value="Injeksi Emergensi">Injeksi Emergensi</option>
                        </select>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold">Bentuk Sediaan *</label>
                            <select name="bentuk_sediaan" id="edit_bentuk_sediaan" class="form-select" required>
                                <option value="Tablet">Tablet</option>
                                <option value="Kapsul">Kapsul</option>
                                <option value="Ampul / Injeksi">Ampul / Injeksi</option>
                                <option value="Sirup / Tetes">Sirup / Tetes</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Jumlah Stok *</label>
                            <input type="number" name="stok" id="edit_stok" class="form-control" min="0" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Harga Satuan (Rp) *</label>
                        <input type="number" name="harga" id="edit_harga" class="form-control" min="0" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Obat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editObat(id, nama, kategori, sediaan, stok, harga) {
        document.getElementById('edit_id_obat').value = id;
        document.getElementById('edit_nama_obat').value = nama;
        document.getElementById('edit_kategori').value = kategori;
        document.getElementById('edit_bentuk_sediaan').value = sediaan;
        document.getElementById('edit_stok').value = stok;
        document.getElementById('edit_harga').value = harga;
        var modal = new bootstrap.Modal(document.getElementById('modalEditObat'));
        modal.show();
    }
</script>
</body>
</html>
